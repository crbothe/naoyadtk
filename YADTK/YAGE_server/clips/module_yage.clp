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
;; Module YAGE
;; -----------------------------------------------------------------------------

(defmodule YAGE (import MAIN ?ALL) (import LEXIQUE ?ALL))

;; -----------------------------------------------------------------------------
;; Les éléments de génération

(deftemplate YAGE::generation
	(slot ident (default ?NONE))
	(slot regle (default ?NONE))
	(slot idgranule)
	(slot idpere)
	(slot code)
	(slot prof)
	(multislot texte)
	(multislot traits)
	(slot score (type INTEGER) (default 0))
	(multislot fils) ; Inutilisé
	(multislot dependances)
	(slot echec (allowed-symbols TRUE FALSE) (default FALSE)))
		
(deffunction YAGE::format-generation (?generation)
	(bind ?regle (fact-slot-value ?generation regle))
	(bind ?ident (fact-slot-value ?generation ident))
	(bind ?texte (concatene$ (fact-slot-value ?generation texte)))
	(bind ?traits (implode$ (fact-slot-value ?generation traits)))
	(bind ?granule (fact-slot-value ?generation idgranule))
	(bind ?dep (implode$ (fact-slot-value ?generation dependances)))
	(bind ?score (fact-slot-value ?generation score))
	(bind ?code (fact-slot-value ?generation code))
	(bind ?pere (fact-slot-value ?generation idpere))
	(if (eq ?granule nil)
	then (format nil "Formulation candidate %s pour %s de %s texte=\"%s\" traits=(%s) dep=(%s) score=%d" ?ident ?code ?pere ?texte ?traits ?dep ?score)
	else (format nil "Formulation candidate %s pour %s texte=\"%s\" traits=(%s) dep=(%s) score=%d" ?ident ?granule ?texte ?traits ?dep ?score)))

;; -----------------------------------------------------------------------------
;; Fonctions de comparaison entre traits de génération

; Critère 1 = nombre de verbalisations (+ 100 par verbalisation)
; Critère 2 = adéquation avec les modifieurs (+/- 10 par modifieur)
; Critère 3 = adéquation de proche en proche (+/- 1 par trait morpho)

(deffunction YAGE::negatif (?trait) (eq (str-car ?trait) "-"))

(deffunction YAGE::positif (?trait) (not (negatif ?trait)))

(deffunction YAGE::est-un-mode (?trait) (str-index "mode" ?trait))

(deffunction YAGE::compatible (?trait1 ?trait2) (eq ?trait1 ?trait2))

(deffunction YAGE::incompatible (?trait1 ?trait2)
	(or (and (positif ?trait1) (negatif ?trait2) (compatible ?trait1 (str-cdr ?trait2)))
		(and (positif ?trait2) (negatif ?trait1) (compatible ?trait2 (str-cdr ?trait1)))))

(deffunction YAGE::comparaison (?trait1 ?trait2) "Compare deux traits"
	(if (compatible ?trait1 ?trait2) then (return 1))
	(if (incompatible ?trait1 ?trait2) then (return -1))
	(return 0))

(deffunction YAGE::calcule-score (?liste1 ?liste2) "Calcule le nombre de traits compatibles entre les deux listes"
	(bind ?score 0)
	(progn$ (?element1 ?liste1)
		(progn$ (?element2 ?liste2)
			(bind ?score (+ ?score (comparaison (str-cat ?element1) (str-cat ?element2))))))
	(return ?score))

(deffunction YAGE::verifie-modes (?liste1 ?liste2) "Les modes doivent impérativement correspondre"
	(progn$ (?e1 ?liste1) (if (and (est-un-mode ?e1) (not (member$ ?e1 ?liste2))) then (return -900)))
	(progn$ (?e2 ?liste2) (if (and (est-un-mode ?e2) (not (member$ ?e2 ?liste1))) then (return -900)))
	(return 0))

(deffunction YAGE::calcule-score-pond (?modifieurs ?traits ?ponderation)
	(bind ?score 0)
	(progn$ (?mod ?modifieurs)
		(if (member$ ?mod ?traits)
		then (bind ?score (+ ?score ?ponderation))
		else (bind ?score (- ?score ?ponderation))))
	(progn$ (?trait ?traits)
		(if (not (str-index "morpho" ?trait)) then ; Pour ne pas prendre en compte les traits morphologiques
			(if (member$ ?trait ?modifieurs)
			then (bind ?score (+ ?score ?ponderation))
			else (bind ?score (- ?score ?ponderation)))))
;	(writeLog (format nil "%s + %s = %d" (implode$ ?modifieurs) (implode$ ?traits) ?score))
	(return ?score))

;; -----------------------------------------------------------------------------
;; Initialisation du processus de génération

(defrule YAGE::initialisation
	(declare (salience 999))
	(exists (granule))
	(stop)
	=>
	(writeAllFacts)
	(halt))

(defrule YAGE::erreur-concept "Un granule comporte un concept inconnu"
	(declare (salience 980))
	(granule (idgranule ?idgranule) (idconcept ?idconcept&~inferred))
	(not (concept (concept ?idconcept)))
	(not (entity (concept ?idconcept)))
	(not (concept (concept =(get-prefix ?idconcept))))
	=>
	(writeError (format nil "ERROR: Unknown granule name [%s] for granule %s%nHave you selected the right application ident in the script run.bash ?" ?idconcept ?idgranule))
	(halt))

;(defrule YAGE::corrige-modifieurs
;	(declare (salience 998))
;	?granule <- (granule (modifieurs $?modifieurs))
;	(test (member$ nil ?modifieurs)) ; Des nil peuvent être placés par le mécanisme de la condition catch (cf. test5)
;	=>
;	(modify ?granule (modifieurs (supprime$ ?modifieurs nil))))

;; -----------------------------------------------------------------------------
;; Retrouver et attribuer les codes des attentes

(defrule YAGE::retrouve-code-1 "Pour retrouver un code manquant à partir du role"
	(declare (salience 950))
	?granule <- (granule (idgranule ?idfils) (idpere ?idpere) (code nil) (role ?role&~nil)) ; Le granule fils sans code mais avec un rôle
	(granule (idgranule ?idpere) (idconcept ?concept-pere)) ; Le concept du granule père
	(attente (concept ?concept-pere) (code ?code) (role ?role)) ; L'attente du granule père qui va bien
	=>
	(writeLog (format nil "  - Attribution du code %s au granule %s (méthode 1)" ?code ?idfils))
	(modify ?granule (code ?code)))
	
(defrule YAGE::retrouve-code-2 "Pour retrouver un code manquant à partir des offres"
	(declare (salience 950))
	?granule <- (granule (idgranule ?idfils) (idconcept ?concept-fils) (idpere ?idpere) (code nil) (role nil)) ; Le granule fils sans code et sans rôle
	(concept (concept ?concept-fils) (offres $?offres)) ; Le concept du granule fils
	(granule (idgranule ?idpere) (idconcept ?concept-pere)) ; Le concept du granule père
	(attente (concept ?concept-pere) (expected $?attentes) (code ?code)) ; Une attente du granule père
	(test (intersectp ?offres ?attentes)) ; Les offres et les attentes correspondent
	=>
	(writeLog (format nil "  - Attribution du code %s au granule %s (méthode 2)" ?code ?idfils))
	(modify ?granule (code ?code)))
	
(defrule YAGE::retrouve-code-3 "Pour retrouver un code manquant"
	(declare (salience 950))
	?granule <- (granule (idgranule ?idfils) (idconcept ?concept-fils) (idpere ?idpere) (code nil))
	(not (concept (concept ?concept-fils))) ; Pas de concept fils (nombre:1 par exemple)
	(granule (idgranule ?idpere) (idconcept ?concept-pere)) ; Le concept du granule père
	(attente (concept ?concept-pere) (expected $?attentes) (code ?code) (role ?role-attente))
	(test (member$ (getConcept ?concept-fils) ?attentes))
	=>
	(writeLog (format nil "  - Attribution du code %s au granule %s (méthode 3)" ?code ?idfils))
	(modify ?granule (code ?code)))

(defrule YAGE::erreur-retrouve-code
	(declare (salience 940))
	(granule (idgranule ?idgranule) (idpere ~nil) (code nil))
	=>
	(writeError (format nil "ERREUR: Impossibilité d'attribuer un code au granule %s" ?idgranule))
	(halt))

;; -----------------------------------------------------------------------------
;; Initialisation du processus de génération + affichage

(defrule YAGE::commence-generation
	(declare (salience 820))
	(granule (prof ?prof))
	(not (granule (prof ?p&:(> ?p ?prof))))
	(not (_profondeur ?))
	=>
	(assert (_profondeur ?prof)))

(defrule YAGE::affiche-profondeur
	(declare (salience 810))
	(_profondeur ?prof)
	=>
	(writeTitle (format nil "Activation du niveau %d" ?prof)))

(defrule YAGE::affiche-generation-candidate
	(declare (salience 800))
	?g <- (generation (echec FALSE))
	=>
	(writeLog (format nil "==> %s" (format-generation ?g))))

;; -----------------------------------------------------------------------------
;; Règles de résolution de conflit (avant les règles de génération sinon explosion combinatoire)

(defrule YAGE::supprime-generation-1 "Score inférieur à -100"
	(declare (salience 720))
	?g <- (generation (ident ?id) (score ?score&:(< ?score -100)))
	=>
	(writeLog (format nil "<== Suppression de %s (score inférieur à -100)" ?id))
	(retract ?g))
	
(defrule YAGE::supprime-generation-2 "Critère de score"
	(declare (salience 710))
	(generation (ident ?id1) (idgranule ?idgranule) (score ?score1))
	?g <- (generation (ident ?id2) (idgranule ?idgranule) (score ?score2&:(< ?score2 ?score1)))
	=>
	(writeLog (format nil "<== Suppression de %s au profit de %s (critère de score)" ?id2 ?id1))
	(retract ?g))

(defrule YAGE::supprime-generation-3 "Critère de couverture"
	(declare (salience 700))
	(generation (ident ?id1) (idgranule ?idgranule) (texte $?texte1))
	?g <- (generation (ident ?id2) (idgranule ?idgranule) (texte $?texte2&:(< (length$ ?texte2) (length$ ?texte1))))
	=>
	(writeLog (format nil "<== Suppression de %s au profit de %s (critère de couverture)" ?id2 ?id1))
	(retract ?g))

;; -----------------------------------------------------------------------------
;; Règles de génération (fichier _generation.clp => salience > 500)

(defrule YAGE::associe-deux-generations "Combinaison de 2 générations pour attente multiple"
	(declare (salience 300))
	(_profondeur ?prof)
	; Deux générations pour deux granules différents mais pour la même attente ?code d'un même granule père ?idgranule
	?g1 <- (generation (idpere ?idgranule) (code ?code) (prof ?prof) (ident ?id1) (idgranule ?idg1) (texte $?txt1) (traits $?from1) (dependances $?dep1) (score ?score1))
	?g2 <- (generation (idpere ?idgranule) (code ?code) (prof ?prof) (ident ?id2) (idgranule ?idg2) (texte $?txt2) (traits $?from2) (dependances $?dep2) (score ?score2))
	(test (neq ?g1 ?g2))
	; Tri sur la position ou l'indice de leur granule
	(granule (idgranule ?idg1) (pos ?pos1) (indice ?i1))
	(granule (idgranule ?idg2) (pos ?pos2) (indice ?i2))
	(test (or (and (eq ?i1 ?i2) (< ?pos1 ?pos2)) (< ?i1 ?i2)))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?texte (create$ ?txt1 ?txt2))
	(bind ?traits (create$ ?from1 ?from2))
	(bind ?dep (create$ ?id1 ?id2))
	(bind ?score (+ ?score1 ?score2))
	(assert (generation (regle combi-2) (ident ?ident) (idgranule nil) (idpere ?idgranule) (code ?code) (prof ?prof) (texte ?texte) (traits ?traits) (dependances ?dep) (score ?score)))
	(writeLog (format nil "    Combinaison des 2 générations %s et %s (attente multiple)" ?id1 ?id2)))

(defrule YAGE::associe-trois-generations "Combinaison de 3 générations pour attente multiple"
	(declare (salience 300))
	(_profondeur ?prof)
	; Trois générations pour trois granules différents mais pour la même attente ?code d'un même granule père ?idgranule
	?g1 <- (generation (idpere ?idgranule) (code ?code) (prof ?prof) (ident ?id1) (idgranule ?idg1) (texte $?txt1) (traits $?from1) (dependances $?dep1) (score ?score1))
	?g2 <- (generation (idpere ?idgranule) (code ?code) (prof ?prof) (ident ?id2) (idgranule ?idg2) (texte $?txt2) (traits $?from2) (dependances $?dep2) (score ?score2))
	?g3 <- (generation (idpere ?idgranule) (code ?code) (prof ?prof) (ident ?id3) (idgranule ?idg3) (texte $?txt3) (traits $?from3) (dependances $?dep3) (score ?score3))
	(test (neq ?g1 ?g2 ?g3))
	; Tri sur la position ou l'indice de leur granule
	(granule (idgranule ?idg1) (pos ?pos1) (indice ?i1))
	(granule (idgranule ?idg2) (pos ?pos2) (indice ?i2))
	(granule (idgranule ?idg3) (pos ?pos3) (indice ?i3))
	(test (or (and (eq ?i1 ?i2) (< ?pos1 ?pos2)) (< ?i1 ?i2)))
	(test (or (and (eq ?i2 ?i3) (< ?pos2 ?pos3)) (< ?i2 ?i3)))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?texte (create$ ?txt1 ?txt2 ?txt3))
	(bind ?traits (create$ ?from1 ?from2 ?from3))
	(bind ?dep (create$ ?id1 ?id2 ?id3))
	(bind ?score (+ ?score1 ?score2 ?score3))
	(assert (generation (regle combi-3) (ident ?ident) (idgranule nil) (idpere ?idgranule) (code ?code) (prof ?prof) (texte ?texte) (traits ?traits) (dependances ?dep) (score ?score)))
	(writeLog (format nil "    Combinaison des 3 générations %s, %s et %s (attente multiple)" ?id1 ?id2 ?id3)))

(defrule YAGE::associe-quatre-generations "Combinaison de 4 générations pour attente multiple"
	(declare (salience 300))
	(_profondeur ?prof)
	; Quatre générations pour quatre granules différents mais pour la même attente ?code d'un même granule père ?idgranule
	?g1 <- (generation (idpere ?idgranule) (code ?code) (prof ?prof) (ident ?id1) (idgranule ?idg1) (texte $?txt1) (traits $?from1) (dependances $?dep1) (score ?score1))
	?g2 <- (generation (idpere ?idgranule) (code ?code) (prof ?prof) (ident ?id2) (idgranule ?idg2) (texte $?txt2) (traits $?from2) (dependances $?dep2) (score ?score2))
	?g3 <- (generation (idpere ?idgranule) (code ?code) (prof ?prof) (ident ?id3) (idgranule ?idg3) (texte $?txt3) (traits $?from3) (dependances $?dep3) (score ?score3))
	?g4 <- (generation (idpere ?idgranule) (code ?code) (prof ?prof) (ident ?id4) (idgranule ?idg4) (texte $?txt4) (traits $?from4) (dependances $?dep4) (score ?score4))
	(test (neq ?g1 ?g2 ?g3 ?g4))
	; Tri sur la position ou l'indice de leur granule
	(granule (idgranule ?idg1) (pos ?pos1) (indice ?i1))
	(granule (idgranule ?idg2) (pos ?pos2) (indice ?i2))
	(granule (idgranule ?idg3) (pos ?pos3) (indice ?i3))
	(granule (idgranule ?idg4) (pos ?pos4) (indice ?i4))
	(test (or (and (eq ?i1 ?i2) (< ?pos1 ?pos2)) (< ?i1 ?i2)))
	(test (or (and (eq ?i2 ?i3) (< ?pos2 ?pos3)) (< ?i2 ?i3)))
	(test (or (and (eq ?i3 ?i4) (< ?pos3 ?pos4)) (< ?i3 ?i4)))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?texte (create$ ?txt1 ?txt2 ?txt3 ?txt4))
	(bind ?traits (create$ ?from1 ?from2 ?from3 ?from4))
	(bind ?dep (create$ ?id1 ?id2 ?id3 ?id4))
	(bind ?score (+ ?score1 ?score2 ?score3 ?score4))
	(assert (generation (regle combi-4) (ident ?ident) (idgranule nil) (idpere ?idgranule) (code ?code) (prof ?prof) (texte ?texte) (traits ?traits) (dependances ?dep) (score ?score)))
	(writeLog (format nil "    Combinaison des 4 générations %s, %s, %s et %s (attente multiple)" ?id1 ?id2 ?id3 ?id4)))

;; -----------------------------------------------------------------------------
;; Passage d'un niveau n à un niveau n-1

(defrule YAGE::affiche-generation "Affichage des formulations retenues du niveau n"
	(declare (salience 30))
	(_profondeur ?prof)
	(generation (prof ?prof) (idgranule ?idgranule) (texte $?texte) (idpere ?idpere) (code ?code))
	=>		
	(if (neq ?idgranule nil)
	then (writeLog (format nil "+++ Formulation retenue pour %s texte=\"%s\"" ?idgranule (concatene$ ?texte)))
	else (writeLog (format nil "+++ Formulation retenue pour %s de %s texte=\"%s\"" ?code ?idpere (concatene$ ?texte)))))

(defrule YAGE::echec-generation "Aucune formulation générée pour un granule de niveau n"
	(declare (salience 20))
	(_profondeur ?prof)
	(granule (idconcept ?idconcept) (idgranule ?idgranule) (idpere ?pere) (code ?code) (prof ?prof))
	(not (generation (idgranule ?idgranule)))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?texte (format nil "[échec de la génération sur le granule %s]" ?idgranule))
	(assert (generation (regle echec-generation) (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?pere) (texte ?texte) (score 0) (echec TRUE)))
	(writeLog (format nil "!!! Echec de la génération sur le granule %s" ?idgranule)))

(defrule YAGE::suppression-granule "Suppression des granules du niveau n"
	(declare (salience 10))
	(_profondeur ?prof)
	?p <- (granule (prof ?prof))
	=>
	(retract ?p))

(defrule YAGE::termine-niveau "Passage du niveau n au niveau n-1"
	(declare (salience 0))
	?p <- (_profondeur ?prof&:(> ?prof 0))
	=>
	(retract ?p)
	(assert (_profondeur (- ?prof 1))))

;; -----------------------------------------------------------------------------
;; Fin du processus de génération

(defrule YAGE::fin-generation
	(declare (salience -900))
	=>
	(writeTitle "Fin de la génération"))

(defrule YAGE::supprime-resultat "Choisir une génération parmi les générations de niveau 0 restantes"
	(declare (salience -910))
	?g1 <- (generation (prof 0) (idgranule ?idgranule) (ident ?id1))
	?g2 <- (generation (prof 0) (idgranule ?idgranule) (ident ?id2&~?id1))
	=>
	(if (evenp (random)) ; Critère aléatoire
		then (bind ?p ?g1) (writeLog (format nil "<== Suppression de %s au profit de %s (critère aléatoire)" ?id1 ?id2))
		else (bind ?p ?g2) (writeLog (format nil "<== Suppression de %s au profit de %s (critère aléatoire)" ?id2 ?id1)))
	(retract ?p))

(defrule YAGE::finalisation
	(declare (salience -999))
	(generation (prof 0) (idgranule ?idgranule) (texte $?texte))
	=>
	(bind ?resultat (concatene$ ?texte))
	(writeLog (format nil "+++ Formulation retenue pour %s texte=\"%s\"" ?idgranule ?resultat))	
	(writesock ?resultat))

;; -----------------------------------------------------------------------------
;; Règles de génération particulières

(defrule YAGE::genere-inferred "Règle de génération des granules hypothétiques"
	(declare (salience 510))
	(granule (idconcept inferred) (idgranule ?idgranule) (idpere ?pere) (code ?code) (prof ?prof) (texte ?texte))
	(_profondeur ?prof)
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score 100)
	(assert (generation (regle gen-inferred) (ident ?ident) (code ?code) (prof ?prof) (idgranule ?idgranule) (idpere ?pere) (texte ?texte) (score ?score))))

(defrule YAGE::genere-entite "Règle de génération des entités nommées"
	(declare (salience 510))
	(entity (concept ?idconcept) (pattern ?texte) (metadata $?tprop) (gen TRUE))
	(granule (idconcept ?idconcept) (idgranule ?idgranule) (idpere ?pere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(assert (generation (regle gen-entites) (ident ?ident) (code ?code) (prof ?prof) (idgranule ?idgranule) (idpere ?pere) (texte ?texte) (score ?score))))

(defrule YAGE::genere-concept-nombre "Règle de génération des nombres (concept nombre ou number)"
	(declare (salience 510))
	(or (granule (idconcept ?idconcept&:(eq nombre (getConcept ?idconcept))) (idgranule ?idgranule) (idpere ?pere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	    (granule (idconcept ?idconcept&:(eq number (getConcept ?idconcept))) (idgranule ?idgranule) (idpere ?pere) (code ?code) (modifieurs $?modifieurs) (prof ?prof)))
	(_profondeur ?prof)
	=>
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs (create$) 10)))
	(bind ?valeur (string-to-field (getValeur ?idconcept)))
	(if (= ?valeur 1)
		then (assert (generation (regle genere-concept-nombre) (ident (sym-cat GEN# (genint*))) (code ?code) (prof ?prof) (idgranule ?idgranule) (idpere ?pere) (texte "un") (traits morpho:masc morpho:sing) (score ?score)))
		     (assert (generation (regle genere-concept-nombre) (ident (sym-cat GEN# (genint*))) (code ?code) (prof ?prof) (idgranule ?idgranule) (idpere ?pere) (texte "une") (traits morpho:fem morpho:sing) (score ?score)))
		else (assert (generation (regle genere-concept-nombre) (ident (sym-cat GEN# (genint*))) (code ?code) (prof ?prof) (idgranule ?idgranule) (idpere ?pere) (texte (str-cat ?valeur)) (traits morpho:plu) (score ?score)))))

(defrule YAGE::genere-concept-addition "Règle de génération du connecteur et"
	(declare (salience 510))
	(granule (idconcept connectAttr:addition) (idgranule ?idgranule) (idpere ?pere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs (create$) 10)))
	(bind ?dependances (create$ ?idA1 ?idA2))
	(assert (generation (regle genere-concept-addition) (ident ?ident) (code ?code) (prof ?prof) (idgranule ?idgranule) (idpere ?pere) (texte ?txtA1 "et" ?txtA2) (score ?score) (fils ?f-A1 ?f-A2) (dependances ?dependances))))

;; -----------------------------------------------------------------------------

(defglobal YAGE ?*dates-fr* = (create$ temps-ordinal temps-annee heure minute))

(defrule YAGE::genere-date-fr "Règle de génération des granules du module dates_fr"
	(declare (salience 510))
	(granule (idconcept ?idconcept&:(member$ (getConcept ?idconcept) ?*dates-fr*)) (idgranule ?idgranule) (idpere ?pere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof) 
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?valeur (string-to-field (getValeur ?idconcept)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs (create$) 10)))
	(assert (generation (regle genere-date-fr) (ident ?ident) (code ?code) (prof ?prof) (idgranule ?idgranule) (idpere ?pere) (texte (str-cat ?valeur)) (score ?score))))

;; -----------------------------------------------------------------------------
;; Fin du fichier
