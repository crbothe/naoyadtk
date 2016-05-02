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
;; Module BDLEX
;; -----------------------------------------------------------------------------

(defmodule BDLEX (import YASP ?ALL) (export ?ALL))
(defmodule BDLEX2 (import BDLEX ?ALL))

(defglobal BDLEX ?*lang* = (getVarEnv "TAGGER_LANG"))
(defglobal BDLEX ?*inputFile* = "tagger/_inputFile")
(defglobal BDLEX ?*outputFile* = "tagger/_outputFile")
(defglobal BDLEX ?*bdlexCommand* = (format nil "tagger/run.bash %s" ?*lang*))

(deftemplate BDLEX::lexeme "Les faits produits par BDLex"
	(slot pos (type INTEGER) (default ?NONE))
	(slot fin (type INTEGER) (default ?NONE))
	(slot graphie (type STRING) (default ?NONE))
	(slot canonique (type STRING) (default "?"))
	(multislot categorie (type SYMBOL NUMBER)))

(deftemplate BDLEX::bdlexsegment
	(slot pos (type INTEGER) (default ?NONE))
	(slot fin (type INTEGER) (default ?NONE))
	(slot len (type INTEGER) (default ?NONE))
	(slot tag (type SYMBOL) (default ?NONE))
	(slot texte (type STRING) (default ?NONE))
	(multislot dependances (type FACT-ADDRESS) (default ?DERIVE)))

(deffunction BDLEX::dependance (?s1 ?s2)
	(bind ?dep1 (fact-slot-value ?s1 dependances))
	(bind ?dep2 (fact-slot-value ?s2 dependances))
	(or (member$ ?s1 ?dep2) ; Le segment 2 est dépendant du segment 1
        (member$ ?s2 ?dep1))) ; Le segment 1 est dépendant du segment 2

(deffunction BDLEX::racine (?s)
	; Ne pas utiliser dans les LHS des règles => risque de non prise en compte
	(not (any-factp ((?segment bdlexsegment)) (member$ ?s ?segment:dependances))))

(deffunction BDLEX::runTagger (?texte) "Etiquetage morpho-syntaxique"
	(remove ?*inputFile*)
	(remove ?*outputFile*)
	; Créer le fichier d'entrée pour BDLex
	(open ?*inputFile* inputFile "w")
	(printout inputFile ?texte crlf)
	(close inputFile)
	; Exécuter BDLex et charger le résultat
	(system ?*bdlexCommand*)
	(if (not (waitfor ?*outputFile* 5)) then (halt)) ; Timeout de 5 secondes
	(load-facts ?*outputFile*))
	;(remove ?*inputFile*)
	;(remove ?*outputFile*)

;; -----------------------------------------------------------------------------
;; Règles du module BDLEX
;; -----------------------------------------------------------------------------

(defrule BDLEX::initialisation
	(declare (salience 999))
	(input (chaine ?chaine))
	=>
	(runTagger ?chaine) ; Etiquetage morphologique
	(focus BDLEX2)) ; Segmentation morphosyntaxique

(defrule BDLEX::ajoute-lemme "Complète les faits MAIN::mots avec les formes canoniques"
	(declare (salience 10))
	(lexeme (pos ?pos) (canonique ?forme))
	?mot <- (mot (pos ?pos) (lemmes $?formes))
	(test (not (member$ ?forme ?formes)))
	=>
	(modify ?mot (lemmes ?formes ?forme)))

(defrule BDLEX::finalisation "Affiche les lexemes et les segments triés selon leur position"
	(declare (salience -999))
	(exists (lexeme))
	=>
;	(writeAllFacts)
	
	(progn$ (?lexeme (sort pos> (expand$ (find-all-facts ((?lexeme lexeme)) TRUE))))
		(writeLog (format nil "%d [%s] %s (%s)"
			(fact-slot-value ?lexeme pos)
			(fact-slot-value ?lexeme graphie)
			(fact-slot-value ?lexeme canonique)
			(implode$ (fact-slot-value ?lexeme categorie)))))
			
	(writeLog "------")
	
	(progn$ (?segment (sort pos> (expand$ (find-all-facts ((?segment bdlexsegment)) TRUE))))
		(writeLog (format nil "%d [%s] %s %s"
			(fact-slot-value ?segment pos)
			(fact-slot-value ?segment texte)
			(fact-slot-value ?segment tag)
			(if (racine ?segment) then "*" else ""))))
	
	(do-for-all-facts ((?segment bdlexsegment)) TRUE
		(assert (granule
			(ident (sym-cat [inferred]# (genint*)))
			(concept inferred)
			(texte ?segment:texte)
			(pos ?segment:pos)
			(fin ?segment:fin)
			(nbmots ?segment:len)
			(nbhyp ?segment:len)
			(liste-pos (cree-liste ?segment:pos ?segment:fin))
			(tag ?segment:tag)
			(hyp TRUE)))))

;; -----------------------------------------------------------------------------
;; BDLEX2 - Segmentation morphosyntaxique
;; -----------------------------------------------------------------------------

(defrule BDLEX2::renommage
	(declare (salience 500))
	(renommage $?liste donne ?tag)
	(lexeme (pos ?pos) (fin ?fin) (categorie $? ?cat $?) (graphie ?texte))
	(test (member$ ?cat ?liste))
	(not (bdlexsegment (pos ?pos) (fin ?fin) (tag ?tag)))
	=>
	(assert (bdlexsegment (pos ?pos) (fin ?fin) (len (- ?fin ?pos)) (tag ?tag) (texte ?texte))))

(defrule BDLEX2::regle-1
	(declare (salience 510))
	(regle ?tag1 donne ?tag)
	?s1 <- (bdlexsegment (pos ?pos1) (fin ?fin1) (tag ?tag1) (texte ?texte1) (dependances $?dep1))
	(not (bdlexsegment (pos ?pos1) (fin ?fin1) (tag ?tag)))
	=>
	(assert (bdlexsegment (pos ?pos1) (fin ?fin1) (len (- ?fin1 ?pos1)) (tag ?tag) (texte (str-cat ?texte1)) (dependances ?s1 ?dep1))))

(defrule BDLEX2::regle-2
	(declare (salience 520))
	(regle ?tag1 ?tag2 donne ?tag)
	?s1 <- (bdlexsegment (pos ?pos1) (fin ?fin1) (tag ?tag1) (texte ?texte1) (dependances $?dep1))
	?s2 <- (bdlexsegment (pos ?fin1) (fin ?fin2) (tag ?tag2) (texte ?texte2) (dependances $?dep2))
	(not (bdlexsegment (pos ?pos1) (fin ?fin2) (tag ?tag)))
	=>
	(assert (bdlexsegment (pos ?pos1) (fin ?fin2) (len (- ?fin2 ?pos1)) (tag ?tag) (texte (str-cat ?texte1 " " ?texte2)) (dependances ?s1 ?s2 ?dep1 ?dep2))))

(defrule BDLEX2::regle-3
	(declare (salience 530))
	(regle ?tag1 ?tag2 ?tag3 donne ?tag)
	?s1 <- (bdlexsegment (pos ?pos1) (fin ?fin1) (tag ?tag1) (texte ?texte1) (dependances $?dep1))
	?s2 <- (bdlexsegment (pos ?fin1) (fin ?fin2) (tag ?tag2) (texte ?texte2) (dependances $?dep2))
	?s3 <- (bdlexsegment (pos ?fin2) (fin ?fin3) (tag ?tag3) (texte ?texte3) (dependances $?dep3))
	(not (bdlexsegment (pos ?pos1) (fin ?fin3) (tag ?tag)))
	=>
	(assert (bdlexsegment (pos ?pos1) (fin ?fin3) (len (- ?fin3 ?pos1)) (tag ?tag) (texte (str-cat ?texte1 " " ?texte2 " " ?texte3)) (dependances ?s1 ?s2 ?s3 ?dep1 ?dep2 ?dep3))))

;; -----------------------------------------------------------------------------
;; Inférences sur les mots inconus => TODO

;(defrule BDLEX2::cree-hypothese
;	(declare (salience 100))
;	?lex1 <- (bdlexsegment (pos ?pos1) (fin ?fin1) (tag GN) (texte ?texte1) (dependances $?dep1))
;	?lex2 <- (lexeme (pos ?fin1) (fin ?fin2)  (canonique "?") (graphie ?texte2))
;	(not (bdlexsegment (pos ?pos1) (fin ?fin2) (tag GN)))
;	=>
;	(assert (bdlexsegment (pos ?pos1) (fin ?fin2) (tag GN) (texte (str-cat ?texte1 " " ?texte2)) (dependances ?lex1 ?lex2 ?dep1))))

;; -----------------------------------------------------------------------------
;; Nettoyage (dans BDLEX sinon bouclage infini dans BDLEX2)

;(defrule BDLEX::supprime-segment-1 "Suppression d'un segment absorbé (tags identiques)"
;	(declare (salience 110))
;	?s1 <- (bdlexsegment (tag ?tag) (dependances $?dep1))
;	?s2 <- (bdlexsegment (tag ?tag) (dependances $?dep2))
;	(test (neq ?s1 ?s2))
;	(test (not (distincts ?s1 ?s2))) ; Ils se recouvrent
;	(test (intersectp ?dep1 ?dep2)) ; Ils sont dépendants
;	(test (plus-grand ?s1 ?s2)) ; On garde le plus prand
;	=>
;	(retract ?s2))

;(defrule BDLEX::supprime-segment-2 "Suppression d'une racine plus petite"
;	(declare (salience 110))
;	?s1 <- (bdlexsegment)
;	?s2 <- (bdlexsegment)
;	(test (neq ?s1 ?s2))
;	(not (bdlexsegment (dependances $? ?s1 $?))) ; s1 est un segment racine
;	(not (bdlexsegment (dependances $? ?s2 $?))) ; s2 est un segment racine
;	(test (not (distincts ?s1 ?s2))) ; Ils se recouvrent
;	(test (plus-grand ?s1 ?s2)) ; On garde le plus prand
;	=>
;	(retract ?s2))

;(defrule BDLEX::supprime-doublon
;	(declare (salience 100))
;	?s1 <- (bdlexsegment (pos ?pos) (fin ?fin))
;	?s2 <- (bdlexsegment (pos ?pos) (fin ?fin))
;	(test (neq ?s1 ?s2))
;	=>
;	(retract ?s2))
	
;; -----------------------------------------------------------------------------
;; Fin du fichier
