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

(deftemplate MAIN::input
	(slot chaine (type STRING) (default ?NONE)))

;; -----------------------------------------------------------------------------
;; Les mots et les segments

(deftemplate MAIN::mot
	(slot texte (type STRING) (default ""))
	(multislot lemmes (type STRING) (default ?DERIVE))
	(slot pos (type INTEGER) (default ?NONE))
	(slot fin (type INTEGER) (default ?NONE))
	(slot couverture (default 1))
	(slot score (default 1)))

(deftemplate MAIN::segment "Les segments et groupes syntaxiques"
	(slot texte (type STRING) (default ?NONE))
	(slot pos (type INTEGER) (default ?NONE))
	(slot fin (type INTEGER) (default ?NONE))
	(slot tag (type SYMBOL) (default ?NONE)))

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

(deffunction MAIN::format-mot-XML (?mot)
	(format nil "<mot pos=\"%d\" texte=\"%s\" lemmes=\"%s\"/>"
		(fact-slot-value ?mot pos)
		(fact-slot-value ?mot texte)
		(concatene$ (fact-slot-value ?mot lemmes))))

;; -----------------------------------------------------------------------------
;; Les granules côté analyseur

(deftemplate MAIN::granule
	; -----------------------------------------
	; Partie commune YASP/YADE
	; -----------------------------------------
	(slot ident (type SYMBOL) (default ?NONE)) ; Identifiant du granule
	(slot concept (type SYMBOL) (default nil)) ; Concept du granule (nil si hypothétique)
	(multislot lconcept (type SYMBOL INTEGER)) ; Version liste du concept (vide si hypothétique) TODO TODO TODO TODO TODO TODO
	(multislot offres (type SYMBOL INTEGER)) ; Offres du concept
	(multislot metadata (type SYMBOL)) ; Métadonnées (inter, neg, etc.)
	(slot texte (type STRING) (default "INFERRED")) ; Texte dans l'énoncé
	(slot pos (type INTEGER) (default 999)) ; Position dans l'énoncé (ou 999 si inféré)
	(slot fin (type INTEGER) (default 999)) ; Position suivante dans l'énoncé (ou 999 si inféré)
	(slot score (type FLOAT) (default ?DERIVE)) ; Score pour la résolution des conflits (ou 0.0 si inféré)
	(slot racine (allowed-symbols TRUE FALSE) (default FALSE)) ; Granule racine
	(slot hyp (allowed-symbols TRUE FALSE) (default FALSE)) ; Granule hypothétique
	; -----------------------------------------
	; Partie privée YASP
	; -----------------------------------------
	(slot tag (type SYMBOL) (default nil)) ; La catégorie syntaxique (module BDLex)
	(slot nbmots (type INTEGER) (default ?DERIVE)) ; Nombre de mots pris en compte
	(slot nbins (type INTEGER) (default ?DERIVE)) ; Nombre d'insertions (hésitations, etc.)
	(slot nbhyp (type INTEGER) (default 0)) ; Nombre d'hypothèses (mots inférés)
	(slot pattern (type STRING) (default "NONE")) ; Pattern utilisé
	(slot pattern-id (type SYMBOL) (default nil)) ; Ident du pattern utilisé (nil si pas de pattern)
	(multislot liste-pos (type SYMBOL)) ; Identificateurs des mots pris en compte
	(multislot liste-ins (type SYMBOL)) ; Identificateurs des mots insérés
	(multislot constituants (type SYMBOL)) ; Granules fils uniquement
	(multislot dependances (type SYMBOL))) ; Granules fils et toute la descendance

(deftemplate MAIN::liaison
	; -----------------------------------------
	; Partie commune YASP/YADE
	; -----------------------------------------
	(slot idpere (type SYMBOL) (default ?NONE)) ; Identifiant du granule-père
	(slot idfils (type SYMBOL) (default ?NONE)) ; Identifiant du granule-fils
	(slot code (allowed-symbols A1 A2 A3 A4 A5 A6 A7 A8 A9) (default ?NONE)) ; Code de la liaison
	(slot role (type SYMBOL) (default nil)) ; Rôle du granule-fils
	(slot hyp (allowed-symbols TRUE FALSE) (default FALSE)) ; Liaison hypothétique	
	(multislot types (type SYMBOL))) ; Intersection des offres et des attentes

(deftemplate MAIN::conflit "Conflit non résolu entre deux granules"
	(slot id1 (type SYMBOL) (default ?NONE))
	(slot id2 (type SYMBOL) (default ?NONE)))

;; -----------------------------------------------------------------------------
;; Fonctions sur les granules

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

(deffunction MAIN::getNumber (?idgranule) "commentaire TODO"
	(sub-string
		(+ (str-index "#" ?idgranule) 1)
		(str-length ?idgranule)
		?idgranule))

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

;; -----------------------------------------------------------------------------
;; Affichage d'un granule sur une ligne

(deffunction MAIN::format-granule (?granule) "Affiche un granule sur une ligne"
	(if (fact-slot-value ?granule hyp)
	then
	(format nil "%s (%s) pos=(%s) score=%f"
		(fact-slot-value ?granule ident)
		(fact-slot-value ?granule texte)
		(implode$ (fact-slot-value ?granule liste-pos))
		(fact-slot-value ?granule score))
	else
	(format nil "%s (%s) pattern=\"%s\" offers=(%s) metadata=(%s) granules=(%s) pos=(%s) ins=(%s) score=%f"
		(fact-slot-value ?granule ident)
		(fact-slot-value ?granule texte)
		(fact-slot-value ?granule pattern)
		(implode$ (fact-slot-value ?granule offres))
		(implode$ (fact-slot-value ?granule metadata))
		(implode$ (fact-slot-value ?granule constituants))
		(implode$ (fact-slot-value ?granule liste-pos))
		(implode$ (fact-slot-value ?granule liste-ins))
		(fact-slot-value ?granule score))))

;; -----------------------------------------------------------------------------
;; Affichage simplifié d'une structure de granules

(deffunction MAIN::affiche-granule (?granule ?liaison ?tab)
	(bind ?ident (fact-slot-value ?granule ident))
	(bind ?texte (fact-slot-value ?granule texte))
	(bind ?metadata (fact-slot-value ?granule metadata))
	(bind ?offres (fact-slot-value ?granule offres))
	(bind ?racine (fact-slot-value ?granule racine))
	(bind ?liste-pos (fact-slot-value ?granule liste-pos))
	(bind ?nbins (fact-slot-value ?granule nbins))
	(bind ?nbhyp (fact-slot-value ?granule nbhyp))
	(bind ?score (fact-slot-value ?granule score))
	(bind ?rescued (and (not ?racine) (fact-slot-value ?liaison hyp)))
	(bind ?inferred (fact-slot-value ?granule hyp))
	
	(if (eq ?liaison nil)
	then (bind ?role nil)
	else (bind ?role (fact-slot-value ?liaison role))) ; Le rôle du granule est dans sa liaison

	(if (neq ?liaison nil)
	then (bind ?ligne (format nil "%s%s:%s (%s)" (tabulation ?tab) (fact-slot-value ?liaison code) ?ident ?texte))
	else (bind ?ligne (format nil "%s%s (%s)" (tabulation ?tab) ?ident ?texte)))
	
	(bind ?ligne (format nil "%s offers=(%s)" ?ligne (implode$ ?offres)))
	(if (nonvide$ ?metadata) then (bind ?ligne (format nil "%s metadata=(%s)" ?ligne (implode$ ?metadata))))
	(if (neq ?liaison nil) then (bind ?ligne (format nil "%s retained=(%s)" ?ligne (implode$ (fact-slot-value ?liaison types)))))
	(if (neq ?role nil) then (bind ?ligne (format nil "%s role=%s" ?ligne ?role)))
	(bind ?ligne (format nil "%s pos=(%s) nbins=%d nbhyp=%d score=%f" ?ligne (implode$ ?liste-pos) ?nbins ?nbhyp ?score))
	(if ?rescued then (bind ?ligne (format nil "%s [rescued]" ?ligne)))
	(if ?inferred then (bind ?ligne (format nil "%s [inferred]" ?ligne)))		
	(writeLog ?ligne)
	(do-for-all-facts ((?liaison liaison) (?fils granule))
		(and (eq ?liaison:idpere ?ident)
		     (eq ?liaison:idfils ?fils:ident))
		(affiche-granule ?fils ?liaison (+ ?tab 1))))
	
(deffunction MAIN::affiche-structures ()
	(writeTitle "Resulting structure of granules")
	(do-for-all-facts ((?granule granule))
		(true ?granule:racine)
		(affiche-granule ?granule nil 0)))

;; -----------------------------------------------------------------------------
;; Envoi d'une structure XML de granules vers un socket

(deffunction MAIN::writesock-granule-XML (?granule ?liaison ?tab)
	
	(bind ?id (getNumber (fact-slot-value ?granule ident)))
	(bind ?concept (fact-slot-value ?granule concept))
	(bind ?offres (implode$ (fact-slot-value ?granule offres)))
	(bind ?metadata (implode$ (fact-slot-value ?granule metadata)))
	(bind ?texte (fact-slot-value ?granule texte))	
	(bind ?cov (fact-slot-value ?granule nbmots))
	(bind ?pos (fact-slot-value ?granule pos))
	(bind ?fin (- (fact-slot-value ?granule fin) 1))
	(bind ?racine (fact-slot-value ?granule racine))
	(if ?racine then (bind ?root "TRUE") else (bind ?root "FALSE"))
	(if (fact-slot-value ?granule hyp) then (bind ?inferred "TRUE") else (bind ?inferred "FALSE"))
	(bind ?score (clearLastZero (str-cat (fact-slot-value ?granule score))))
	
	(if (eq ?liaison nil)
	then (bind ?role nil)
	else (bind ?role (fact-slot-value ?liaison role))) ; Le rôle du granule est dans sa liaison
	
	(if (neq ?liaison nil)
	then
		(bind ?code (fact-slot-value ?liaison code))
		(bind ?retained (implode$ (fact-slot-value ?liaison types)))
		(bind ?rescued (if (fact-slot-value ?liaison hyp) then "TRUE" else "FALSE"))
	else
		(bind ?code nil)
		(bind ?retained "")
		(bind ?rescued "FALSE"))
	
	(bind ?attributs (format nil
		"id=\"%s\" concept=\"%s\" code=\"%s\" role=\"%s\" offers=\"%s\" retained=\"%s\" metadata=\"%s\" text=\"%s\" cov=\"%d\" pos=\"%d\" fin=\"%d\" root=\"%s\" inferred=\"%s\" rescued=\"%s\" score=\"%s\""
		?id ?concept ?code ?role ?offres ?retained ?metadata ?texte ?cov ?pos ?fin ?root ?inferred ?rescued ?score))

	;; Est-ce qu'il y a des granules fils ?
	(bind ?ident (fact-slot-value ?granule ident))
	(if (any-factp ((?liaison liaison) (?fils granule))
		(and (eq ?liaison:idpere ?ident)
		     (eq ?liaison:idfils ?fils:ident)))
		then
		(writesock (format nil "%s<granule %s>" (tabulation ?tab) ?attributs))
		;; Affichage des granules fils
		;; TODO faire avec un (progn$ (?granule (sort pos> comme dans afficher-structures-XML
		(do-for-all-facts ((?liaison liaison) (?fils granule))
			(and (eq ?liaison:idpere ?ident)
			     (eq ?liaison:idfils ?fils:ident))
			(writesock-granule-XML ?fils ?liaison (+ ?tab 1)))
		;; Balise fermante </granule>
		(writesock (format nil "%s</granule>" (tabulation ?tab)))
		else
		(writesock (format nil "%s<granule %s/>" (tabulation ?tab) ?attributs))))

(deffunction MAIN::format-conflit-XML (?conflit)
	(format nil "<conflict id1=\"%s\" id2=\"%s\"/>"
		(getNumber (fact-slot-value ?conflit id1))
		(getNumber (fact-slot-value ?conflit id2))))

(deffunction MAIN::writesock-structures-XML (?enonce ?segmentation)
	(writesock (format nil "<structure text=\"%s\">" ?enonce))
;;	(writesock (format nil "%s<segmentation>%s</segmentation>" (tabulation 1) ?segmentation))
	
	(progn$ (?mot (sort pos> (expand$ (find-all-facts ((?mot mot)) TRUE))))
		(writesock (format nil "%s%s" (tabulation 1) (format-mot-XML ?mot))))
	
	(do-for-all-facts ((?conflit conflit)) TRUE
		(writesock (format nil "%s%s" (tabulation 1) (format-conflit-XML ?conflit))))
	
	(progn$ (?granule (sort pos> (expand$ (find-all-facts ((?granule granule)) (true ?granule:racine)))))
		(writesock-granule-XML ?granule nil 1))
	
	(writesock (format nil "</structure>")))
	
;; -----------------------------------------------------------------------------
;; Fin du fichier
