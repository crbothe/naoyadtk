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

(defmodule YASP (import MAIN ?ALL) (import LEXIQUE ?ALL) (export ?ALL))

(defglobal YASP ?*yasp-dir* = (getVarEnv "YASP_DIR")) ; Répertoire du serveur
(defglobal YASP ?*tagger* = (sym-cat (getVarEnv "TAGGER_FLAG"))) ; Etiquetage Morphosyntaxique (TRUE/FALSE)
(defglobal YASP ?*levenshtein* = (sym-cat (getVarEnv "LEV_FLAG"))) ; Distance de Levenshtein (TRUE/FALSE)

(defmodule ETAPE1 (import YASP ?ALL)) ; Lemmatisation et segmentation
(defmodule ETAPE2 (import YASP ?ALL)) ; Construction de la structure de granules
(defmodule ETAPE3 (import YASP ?ALL)) ; Résolution des conflits
(defmodule ETAPE4 (import YASP ?ALL)) ; Génération des hypothèses de rattachement (flex=TRUE)
(defmodule ETAPE5 (import YASP ?ALL)) ; Finalisation des structures

;; -----------------------------------------------------------------------------
;; Règles du module YASP

(defrule YASP::initialisation
	(declare (salience 999))
	(input)
	=>
	(focus ETAPE5)  ; Finalisation
	(focus ETAPE4)  ; Rattachements hypothétiques
	(focus ETAPE3)  ; Résolution des conflits résiduels
	(focus ETAPE2)  ; Construction de la structure de granules
	(focus ETAPE1)) ; Lemmatisation et segmentation

(defrule YASP::fin-traitement
	(declare (salience -999))
	(input (chaine ?chaine))
	=>
	(affiche-structures)
	(writesock-structures-XML ?chaine "---"))

;; -----------------------------------------------------------------------------
;; ETAPE1 - Segmentation morphosyntaxique (voir module_bdlex.clp)
;; -----------------------------------------------------------------------------

(defrule ETAPE1::initialisation
	(declare (salience 999))
	(input)
	=>
	(writeTitle "STEP 1 - Non deterministic POS tagging")
	(if ?*tagger*
		then (focus BDLEX)
		else (writeLog "Disabled")))

;; -----------------------------------------------------------------------------
;; ETAPE2 - Construction du chart (voir _filtrage.clp)
;; -----------------------------------------------------------------------------

(deffunction ETAPE2::score (?nbmots ?nbins) "Calcul le score d'un granule"
;	(- ?nbmots ?nbins))
	(- ?nbmots (* ?nbins 1.5)))

(deffunction ETAPE2::__cons (?deb ?fin) "Fabrique une liste d'entiers entre ?deb et ?fin"
	(bind ?resultat (create$))
	(loop-for-count (?var (+ ?deb 1) (- ?fin 1))
		(bind ?resultat (create$ ?resultat ?var)))
	(return ?resultat))

(deffunction ETAPE2::complement (?liste) "Construit la liste complémentaire (insertions)"
	(if (vide$ (cdr$ ?liste))
		then (return (create$))
		else (return (create$ (__cons (car$ ?liste) (cadr$ ?liste))
		                      (complement (cdr$ ?liste))))))

(defrule ETAPE2::initialisation
	(declare (salience 999))
	(input (chaine ?chaine))
	=>
	(writeTitle "STEP 2 - Granule instantiation")
	(focus NOYAU-DATES)
	(focus NOYAU-ENTITES)
	(focus NOYAU-CARDINAUX))

(defrule ETAPE2::affiche-granule
	(declare (salience 910))
	?granule <- (granule (hyp FALSE))
	=>
	(writeLog (format nil "==> %s" (format-granule ?granule))))

(defrule ETAPE2::affiche-granule-guest "Affichage d'un granule hypothétique lié"
	(declare (salience 900))
	?granule <- (granule (hyp TRUE) (ident ?id))
	(liaison (idfils ?id))
	=>
	(writeLog (format nil "==> %s" (format-granule ?granule))))

(defrule ETAPE2::supprime-liaison "Suppression d'une liaison obsolète"
	(declare (salience 900))
	?liaison <- (liaison (idpere ?idp))
	(not (granule (ident ?idp)))
	=>
	(retract ?liaison))

;; LA RÈGLE SUIVANTE EST TRES IMPORTANTE POUR EVITER L'EXPLOSION COMBINATOIRE !!!

(defrule ETAPE2::supprime-granule-faible "Même concept mais scores différents"
	(declare (salience 800))
	?g1 <- (granule (hyp FALSE) (concept ?concept) (ident ?id1) (score ?sc1) (texte ?texte1))
;;;;(not (liaison (idfils ?id1))) ; Le granule 1 doit être une racine => NON
	?g2 <- (granule (hyp FALSE) (concept ?concept) (ident ?id2&~?id1) (score ?sc2&:(< ?sc1 ?sc2)) (texte ?texte2))
;;;;(not (liaison (idfils ?id2))) ; Le granule 2 doit être une racine => NON
	(test (conflictuels ?g1 ?g2)) ; Il y a recouvrement
	=>
	(retract ?g1)
	(writeLog (format nil "<== %s (%s) for the benefit of %s (%s) / score" ?id1 ?texte1 ?id2 ?texte2)))

;; -----------------------------------------------------------------------------
;; Rustine pour supprimer quelques granules problématiques TODO = corriger

(defrule ETAPE2::supprime-granule-type "TODO"
	(declare (salience -100))
	?gr <- (granule (offres $?offres) (ident ?id) (texte ?txt))
	(not (liaison (idfils ?id))) ; Granule racine
    (test (or
        (member$ heure ?offres)
        (member$ minute ?offres)
        (member$ date ?offres)
        (member$ temps-ordinal ?offres)))
    =>
    (retract ?gr)
	(writeLog (format nil "<== %s (%s) / orphan" ?id ?txt)))

;; -----------------------------------------------------------------------------
;; ETAPE3 - Résolution des conflits résiduels entre granules
;; -----------------------------------------------------------------------------

(defrule ETAPE3::initialisation
	(declare (salience 999))
	=>
	(writeTitle "STEP 3 - Conflict resolution"))

(defrule ETAPE3::supprime-liaison-1 "Suppression d'une liaison obsolète"
	(declare (salience 900))
	?liaison <- (liaison (idpere ?idp))
	(not (granule (ident ?idp)))
	=>
	(retract ?liaison))

(defrule ETAPE3::supprime-liaison-2 "Suppression d'une liaison obsolète"
	(declare (salience 900))
	?liaison <- (liaison (idfils ?idf))
	(not (granule (ident ?idf)))
	=>
	(retract ?liaison))

(deftemplate ETAPE3::_conflit
	(slot id1 (type SYMBOL) (default ?NONE))
	(slot id2 (type SYMBOL) (default ?NONE))
	(slot sc1 (type FLOAT) (default ?NONE))
	(slot sc2 (type FLOAT) (default ?NONE)))

(defrule ETAPE3::supprime-conflit "Suppression d'un conflit obsolète"
	(declare (salience 900))
	?conflit <- (_conflit (id1 ?id1) (id2 ?id2))
	(or (not (granule (ident ?id1)))
	    (not (granule (ident ?id2))))
	=>
	(retract ?conflit))

(defrule ETAPE3::cree-conflit "Ne concerne que les racines"
	(declare (salience 100))
	?g1 <- (granule (hyp FALSE) (texte ?texte1) (ident ?id1) (score ?sc1))
	(not (liaison (idfils ?id1))) ; Le granule 1 doit être une racine
	?g2 <- (granule (hyp FALSE) (texte ?texte2) (ident ?id2&~?id1) (score ?sc2))
	(not (liaison (idfils ?id2))) ; Le granule 2 doit être une racine
	(test (conflictuels ?g1 ?g2)) ; Il y a recouvrement
	=>
	(assert (_conflit (id1 ?id1) (id2 ?id2) (sc1 ?sc1) (sc2 ?sc2))))

(defrule ETAPE3::supprime-granule-conflictuel-score "Supprimer les scores les plus importants d'abord"
	(declare (salience 30))
	?conflit <- (_conflit (id1 ?id1) (id2 ?id2) (sc1 ?sc1) (sc2 ?sc2&:(> ?sc1 ?sc2)))
	(not (_conflit (sc1 ?sc3) (sc2 ?sc4&:(> ?sc3 ?sc4)&:(> ?sc3 ?sc1)))) ; Pas de conflit plus important
	?g1 <- (granule (ident ?id1) (texte ?texte1))
	?g2 <- (granule (ident ?id2) (texte ?texte2))
	=>
	(retract ?conflit)
	(retract ?g2)
	(writeLog (format nil "<== %s (%s) for the benefit of %s (%s) / score" ?id2 ?texte2 ?id1 ?texte1)))

(defrule ETAPE3::supprime-granule-conflictuel-hypo "Minimiser le nombre de mots hypothétiques"
	(declare (salience 20))
	?conflit <- (_conflit (id1 ?id1) (id2 ?id2))
	?g1 <- (granule (ident ?id1) (texte ?texte1) (nbhyp ?hyp1))
	?g2 <- (granule (ident ?id2) (texte ?texte2) (nbhyp ?hyp2&:(> ?hyp2 ?hyp1)))
	=>
	(retract ?conflit)
	(retract ?g2)
	(writeLog (format nil "<== %s (%s) for the benefit of %s (%s) / number of inferred words" ?id2 ?texte2 ?id1 ?texte1)))

(defrule ETAPE3::supprime-granule-conflictuel-similitude "Même concept et même score"
	(declare (salience 10))
    ;;; TODO = Supprime à tord le conflit dans "je voudrais un avocat"
	?conflit <- (_conflit (id1 ?id1) (id2 ?id2) (sc1 ?sc) (sc2 ?sc))
	?g1 <- (granule (ident ?id1) (concept ?concept) (texte ?texte1))
	?g2 <- (granule (ident ?id2) (concept ?concept) (texte ?texte2))
	=>
	(retract ?conflit)
	(retract ?g2)
	(writeLog (format nil "<== %s (%s) for the benefit of %s (%s) / sameness" ?id2 ?texte2 ?id1 ?texte1)))

(defrule ETAPE3::conflit-non-resolu
	(declare (salience -999))
	(_conflit (id1 ?id1) (id2 ?id2&:(string> ?id2 ?id1)))
	;?g1 <- (granule (ident ?id1))
	;?g2 <- (granule (ident ?id2))
	=>
	(assert (conflit (id1 ?id1) (id2 ?id2)))
	(writeLog (format nil "### Unresolved conflict between %s and %s" ?id2 ?id1)))

;; -----------------------------------------------------------------------------
;; ETAPE4 - Rattachement hypothétique des granules libres
;; -----------------------------------------------------------------------------

(deftemplate ETAPE4::_candidature
	(slot idpere (type SYMBOL) (default ?NONE))
	(slot idfils (type SYMBOL) (default ?NONE))
	(multislot types (type SYMBOL) (default ?NONE))
	(slot role (type SYMBOL) (default ?NONE))
	(slot code (allowed-symbols A1 A2 A3 A4 A5 A6 A7 A8 A9) (default ?NONE))
	(slot mult (allowed-symbols TRUE FALSE) (default FALSE))
	(slot score (type FLOAT) (default ?NONE)))

(defrule ETAPE4::initialisation
	(declare (salience 999))
	=>
	(writeTitle "STEP 4 - Free granules rescuing"))

(defrule ETAPE4::cree-candidature
	(declare (salience 900))
	?gp <- (granule (hyp FALSE) (concept ?concept) (ident ?idp) (pos ?pos1))
	(attente (concept ?concept) (flex ?flex) (mult ?mult) (code ?code) (expected $?attentes) (role ?role))
	(or (test (eq ?mult TRUE)) ; Attente multiple ou
	    (and (test (eq ?flex TRUE)) ; Attente flexible et
		     (not (liaison (idpere ?idp) (code ?code))))) ; Attente non satisfaite
	?gf <- (granule (hyp FALSE) (ident ?idf&~?idp) (pos ?pos2) (offres $?offres))
	(not (liaison (idfils ?idf))) ; Granule libre
	(not (conflit (id1 ?idf))) ; Pas en conflit / TODO = vraiment ?
	(not (conflit (id2 ?idf))) ; Pas en conflit / TODO = vraiment ?
	(not (_candidature (idpere ?idp) (idfils ?idf) (code ?code))) ; Pas encore fait
	(test (correspondance ?attentes ?offres))
	=>
	(bind ?types (intersection$ ?attentes ?offres))
	(bind ?score (+ (length$ ?types) (/ 1 (abs (- ?pos1 ?pos2))))) ; Score = nombre de types + 1 / distance entre les positions
	(assert (_candidature (idpere ?idp) (idfils ?idf) (code ?code) (types ?types) (role ?role) (mult ?mult) (score ?score)))
	(writeLog (format nil "Candidacy of %s --> %s offers=(%s) role=%s mult=%s score=%f" ?idf ?idp (implode$ ?types) ?role ?mult ?score)))

(defrule ETAPE4::supprime-candidature "Suppression d'une candidature obsolète"
	(declare (salience 900))
	?candidature <- (_candidature (idpere ?idp) (idfils ?idf) (code ?code) (mult FALSE))
	(or (liaison (idpere ?idp) (code ?code)) ; L'attente du père est satisfaite
	    (liaison (idfils ?idf))) ; Le fils n'est plus disponible
	=>
	(retract ?candidature))
	
(defrule ETAPE4::cree-liaison
	(declare (salience 10))
	(_candidature (idpere ?idp) (idfils ?idf) (code ?code) (mult ?mult) (types $?types) (role ?role) (score ?score))
	(not (_candidature (idfils ?idf) (score ?s&:(> ?s ?score))))
	(or (test (eq ?mult TRUE)) ; Attente multiple ou
	    (and (test (eq ?mult FALSE)) ; Attente simple
		     (not (_candidature (idpere ?idp) (idfils ~?idf) (score ?s&:(> ?s ?score)))))) ; Meilleure candidature
	?gp <- (granule (ident ?idp))
	?gf <- (granule (ident ?idf))
	=>
	(assert (liaison (hyp TRUE) (idpere ?idp) (idfils ?idf) (code ?code) (types ?types) (role ?role)))
	(writeLog (format nil "Rescuing of %s --> %s role=%s" ?idf ?idp ?role)))

;; -----------------------------------------------------------------------------
;; ETAPE5 - Finalisation des structures de granules
;; -----------------------------------------------------------------------------
	
(defrule ETAPE5::trouve-racine
	(declare (salience 100))
	?granule <- (granule (racine FALSE) (ident ?idf) (offres $?offres))
	(not (liaison (idfils ?idf)))
	=>
	(modify ?granule (racine TRUE)))

(defrule ETAPE5::supprime-granule-hypothetique "Supprimer un granule hypothétique non utilisé"
	(declare (salience 20))
	?gr <- (granule (racine TRUE) (hyp TRUE))
	=>
	(retract ?gr))

(defrule ETAPE5::offres-granule-hypothetique "Affecter des offres à un granule hypothétique"
	(declare (salience 10))
	?gr <- (granule (hyp TRUE) (ident ?idf) (offres))
	(liaison (idfils ?idf) (idpere ?idp) (code ?code))
	(granule (ident ?idp) (concept ?concept))
	(attente (concept ?concept) (code ?code) (expected $?expected))
	=>
	(modify ?gr (offres ?expected)))

;; -----------------------------------------------------------------------------
;; Fin du fichier

	