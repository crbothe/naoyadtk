;; #############################################################################
;; This file is part of the YADTK Toolkit (Yet Another Dialogue Toolkit)
;; Copyright © Jérôme Lehuen 2010-2015 - Jerome.Lehuen@univ-lemans.fr
;;
;; This software is governed by the CeCILL license under French law and
;; abiding by the rules of distribution of free software. You can use,
;; modify and/or redistribute the software under the terms of the CeCILL
;; license as circulated by CEA, CNRS and INRIA (http://www.cecill.info).
;;
;; As a counterpart to the access to the source code and rights to copy,
;; modify and redistribute granted by the license, users are provided only
;; with a limited warranty and the software's author, the holder of the
;; economic rights, and the successive licensors have only limited
;; liability.
;;
;; In this respect, the user's attention is drawn to the risks associated
;; with loading, using, modifying and/or developing or reproducing the
;; software by the user in light of its specific status of free software,
;; that may mean that it is complicated to manipulate, and that also
;; therefore means that it is reserved for developers and experienced
;; professionals having in-depth computer knowledge. Users are therefore
;; encouraged to load and test the software's suitability as regards their
;; requirements in conditions enabling the security of their systems and/or
;; data to be ensured and, more generally, to use and operate it in the
;; same conditions as regards security.
;;
;; The fact that you are presently reading this means that you have had
;; knowledge of the CeCILL license and that you accept its terms.
;; #############################################################################

;; This free software is registered at the Agence de Protection des Programmes.
;; For further information or commercial purpose, please contact the author.

;; -----------------------------------------------------------------------------
;; Les mots de l'énoncé

(deftemplate MAIN::mot
	(slot texte (type STRING) (default ""))
	(multislot lemmes (type STRING) (default ?DERIVE))
	(slot pos (type INTEGER) (default ?NONE))
	(slot fin (type INTEGER) (default ?NONE))
	(slot couverture (default 1))
	(slot score (default 1)))

(deffunction MAIN::format-mot-XML (?mot)
	(format nil "<mot pos=\"%d\" texte=\"%s\" lemmes=\"%s\"/>"
		(fact-slot-value ?mot pos)
		(fact-slot-value ?mot texte)
		(concatene$ (fact-slot-value ?mot lemmes))))

;; -----------------------------------------------------------------------------
;; Les groupes de mots

;(deftemplate MAIN::segment "Les segments et groupes syntaxiques"
;	(slot texte (type STRING) (default ?NONE))
;	(slot pos (type INTEGER) (default ?NONE))
;	(slot fin (type INTEGER) (default ?NONE))
;	(slot tag (type SYMBOL) (default ?NONE)))

(deftemplate MAIN::conflit "Conflit non résolu entre deux granules"
	(slot id1 (type SYMBOL) (default ?NONE))
	(slot id2 (type SYMBOL) (default ?NONE)))

;; -----------------------------------------------------------------------------
;; Fonction sur les granules et les segments (de BDLex par exemple)
;; -----------------------------------------------------------------------------

(deffunction MAIN::pos> (?fact1 ?fact2) "Relation d'ordre sur les positions"
	(> (fact-slot-value ?fact1 pos)
	   (fact-slot-value ?fact2 pos)))
	
(deffunction MAIN::plus-grand (?fact1 ?fact2)
	(bind ?pos1 (fact-slot-value ?fact1 pos))
	(bind ?pos2 (fact-slot-value ?fact2 pos))
	(bind ?fin1 (fact-slot-value ?fact1 fin))
	(bind ?fin2 (fact-slot-value ?fact2 fin))
	(> (- ?fin1 ?pos1) (- ?fin2 ?pos2)))

(deffunction MAIN::distincts (?fact1 ?fact2)
	(bind ?pos1 (fact-slot-value ?fact1 pos))
	(bind ?pos2 (fact-slot-value ?fact2 pos))
	(bind ?fin1 (fact-slot-value ?fact1 fin))
	(bind ?fin2 (fact-slot-value ?fact2 fin))
	(or (>= ?pos1 ?fin2) ; Le segment 1 est situé après le segment 2
        (>= ?pos2 ?fin1))) ; Le segment 2 est situé après le segment 1

;; -----------------------------------------------------------------------------

(deffunction MAIN::dependants (?g1 ?g2)
	(bind ?id1 (fact-slot-value ?g1 ident))
	(bind ?id2 (fact-slot-value ?g2 ident))
	(bind ?dep1 (fact-slot-value ?g1 dependances))
	(bind ?dep2 (fact-slot-value ?g2 dependances))
	(or (member$ ?id1 ?dep2) ; Le granule 2 est dépendant du granule 1
        (member$ ?id2 ?dep1))) ; Le granule 1 est dépendant du granule 2

(deffunction MAIN::compatibles (?g1 ?g2)
	(bind ?liste1 (fact-slot-value ?g1 liste-pos))
	(bind ?liste2 (fact-slot-value ?g2 liste-pos))
	(not (intersectp ?liste1 ?liste2))) ; Les deux granules ne partagent aucun mots

(deffunction MAIN::conflictuels (?g1 ?g2) "Les granules ?g1 et ?g2 sont en conflit"
	(and (not (dependants ?g1 ?g2))
	     (not (compatibles ?g1 ?g2))))
	
(deffunction MAIN::granule-adress (?idgranule) "Retourne le fact-adress d'un granule d'après son ident ou FALSE"
	(do-for-fact ((?granule granule))
		(eq ?granule:ident ?idgranule)
		(return ?granule)))

(deffunction MAIN::get-pere (?idgranule) "Retourne l'identificateur du père du granule"
	(do-for-fact ((?liaison liaison) (?pere granule))
		(and (eq ?liaison:idfils ?idgranule)
		     (eq ?liaison:idpere ?pere:ident))
		(return ?pere:ident)))

(deffunction MAIN::get-fils (?idgranule) "Retourne la liste des fils de ?ident"
	(bind ?liste (create$))
	(do-for-all-facts ((?liaison liaison) (?fils granule))
		(and (eq ?liaison:idpere ?idgranule)
		     (eq ?liaison:idfils ?fils:ident))
		(bind ?liste (create$ ?liste ?fils:ident)))
	(return ?liste))

(deffunction MAIN::get-racine (?idgranule) "Retourne l'identificateur de la racine"
	(bind ?pere (get-pere ?idgranule))
	(if (eq ?pere FALSE)
		then (return ?idgranule)
		else (get-racine ?pere)))

(deffunction MAIN::nettoyer (?granule) "Suppression d'une structure de granule"
	(bind ?ident (fact-slot-value ?granule ident))
	(retract ?granule) ; Suppression du granule
	(writeLog (format nil "%n<== %s (utilisé)" ?ident))
	(do-for-all-facts ((?liaison liaison) (?fils granule))
		(and (eq ?liaison:idpere ?ident)
		     (eq ?liaison:idfils ?fils:ident))
		(retract ?liaison) ; Suppression d'une liaison
		(nettoyer ?fils))) ; Suppression récursive du granule-fils

(deffunction MAIN::decode-concept (?symbole) "commentaire TODO"
	(bind ?position (str-index : ?symbole))
	(if (not ?position)
		then (return (create$ (sym-cat ?symbole)))
		else
		(bind ?avant (sub-string 1 (- ?position 1) ?symbole))
		(bind ?apres (sub-string (+ ?position 1) (length$ ?symbole) ?symbole))
		(return	(create$ (sym-cat ?avant) (decode-concept ?apres)))))

(deffunction MAIN::encode-concept (?liste) "commentaire TODO"
	(bind ?resultat (str-cat (car$ ?liste)))
	(progn$ (?element (cdr$ ?liste))
		(bind ?resultat (str-cat ?resultat ":" ?element)))
	(return (sym-cat ?resultat)))

(deffunction MAIN::getNumber (?ident)
	(sub-string (+ (str-index "#" ?ident) 1) (str-length ?ident) ?ident))
	
;; -----------------------------------------------------------------------------
;; Fin du fichier
