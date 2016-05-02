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
;; Module YADEGLOB (variables globales)

(defmodule YADEGLOB (export ?ALL))

;; Réponses type à définir dans le fichier yaderule.xml

(defglobal YADEGLOB ?*timeout* = "undefined")
(defglobal YADEGLOB ?*openning* = "undefined")
(defglobal YADEGLOB ?*nogranule* = "undefined")
(defglobal YADEGLOB ?*noresponse* = "undefined")

;; -----------------------------------------------------------------------------
;; Module YADE (moteur de dialogue)

(defmodule YADE (import MAIN ?ALL) (import LEXIQUE ?ALL) (import YADEGLOB ?ALL) (export ?ALL))

(defglobal YADE ?*mirror* = (sym-cat (getVarEnv "MIRROR_FLAG"))) ; Mode reformulation (TRUE/FALSE)
(defglobal YADE ?*pile-regles* = (create$ base))
(defglobal YADE ?*compteur-contexte* = 0) ; Pour donner un identificateur unique à chaque nouveau contexte

;; -----------------------------------------------------------------------------
;; Module YADERULE (règles de dialogue)

(defmodule YADERULE (import YADE ?ALL))

(defrule YADERULE::initialisation
	(declare (salience 999))
	=>
;	(writeAllFacts)
;	(writeMatches YADERULE::idm155846861072)
	(nop))

(defrule YADERULE::finalisation
	(declare (salience -999))
	=>
;	(writeAllFacts)
;	(writeMatches YADERULE::idm62481473760)
	(nop))

;; -----------------------------------------------------------------------------
;; Gestion des faits YADE

(deftemplate YADE::_fact
	(slot indice (default-dynamic ?*indice*))
	(slot contexte (default-dynamic ?*contexte*))
	(multislot data))

(deffacts YADE::initial-fact "Fait initial utilisable dans les règles de dialogue"
	(_fact (data initial-fact)))

(deffunction YADE::assert-fact ($?liste) "Ajout d'un fait avec production d'une trace"
	(writeLog (format nil "    Asserting the fact (%s)" (concatene$ (mapcar$ toString ?liste))))
	(assert (_fact (data ?liste))))

(deffunction YADE::retract-fact (?adr) "Suppression d'un fait avec production d'une trace"
	(do-for-fact ((?fact _fact))
		(eq ?fact ?adr)
		(writeLog (format nil "    Retracting the fact (%s)" (concatene$ (mapcar$ toString ?fact:data)))))
	(retract ?adr))

(deffunction YADE::retract-all (?rel) "Supprime un ensemble de faits"
	(do-for-all-facts ((?fact _fact))
		(eq ?rel (car$ ?fact:data))
		(retract-fact ?fact)))

;; -----------------------------------------------------------------------------
;; Gestion des compteurs YADE

(deftemplate YADE::_counter
	(slot ident (type SYMBOL) (default ?NONE))
	(slot value (type INTEGER) (default ?NONE)))

(deffunction YADE::reset-counter (?ident) "Réinitialise un compteur existant ou en crée un nouveau"
	(writeLog (format nil "    Reseting the counter [%s] = 0" ?ident))
	(do-for-fact ((?fact _counter))
		(eq ?fact:ident ?ident)
		(modify ?fact (value 0))
		(return))
	(assert (_counter (ident ?ident) (value 0))))

(deffunction YADE::increase-counter (?ident) "Incrémente un compteur existant ou en crée un nouveau"
	(do-for-fact ((?fact _counter))
		(eq ?fact:ident ?ident)
		(modify ?fact (value (+ ?fact:value 1)))
		(writeLog (format nil "    Incrementing the counter [%s] = %d" ?ident (+ ?fact:value 1)))
		(return (+ ?fact:value 1)))
	(assert (_counter (ident ?ident) (value 1)))
	(writeLog (format nil "    Incrementing the counter [%s] = 1" ?ident))
	(return 1))

(deffunction YADE::remove-counter (?ident) "Supprime un compteur existant"
	(writeLog (format nil "    Deleting the counter [%s]" ?ident))
	(do-for-fact ((?fact _counter))
		(eq ?fact:ident ?ident)
		(retract ?fact)
		(return))
	(writeError (format nil "ERROR in remove-counter")))

(deffunction YADE::counter-value (?ident) "Retrouve la valeur d'un compteur"
	(do-for-fact ((?fact _counter))
		(eq ?fact:ident ?ident)
		(return ?fact:value))
	; Il faut retourner une valeur même si le compteur n'existe pas
	; car cette fonction peut être utilisée dans un LHS donc être
	; invoquée par le moteur d'inférence pour vérification
	(return 0))

;; -----------------------------------------------------------------------------
;; Gestion de la structure du dialogue

(deftemplate YADE::contexte "Définition du contexte d'interprétation"
	(slot indice (type INTEGER) (default-dynamic ?*indice*))
	(multislot pile-contextes (type INTEGER) (default-dynamic ?*pile-contextes*))
	(multislot pile-regles (type SYMBOL) (default-dynamic ?*pile-regles*)))
	
(deftemplate YADE::variable "Les variables contextuelles"
	(slot contexte (type SYMBOL) (default ?NONE))
	(slot ident (type SYMBOL) (default ?NONE))
	(slot value))

(deffacts YADE::contexte-initial (contexte))

(deffunction YADE::actualiser-contexte ()
	(do-for-fact ((?fact contexte)) TRUE (retract ?fact))
	(assert (contexte)))

(deffunction YADE::incrementer-indice ()
	(bind ?*ordre* 0)
	(bind ?*indice* (+ ?*indice* 1))
	(actualiser-contexte))
	
(deffunction YADE::empiler-contexte (?regle)
	(bind ?*compteur-contexte* (+ ?*compteur-contexte* 1))
	(bind ?*contexte* ?*compteur-contexte*)
	(bind ?*pile-contextes* (create$ ?*contexte* ?*pile-contextes*))
	(bind ?*pile-regles* (create$ ?regle ?*pile-regles*))
	(writeLog (format nil ">>> Stacking a new context: stack=(%s) rules=(%s)" (implode$ ?*pile-contextes*) (implode$ ?*pile-regles*)))
	(actualiser-contexte))

(deffunction YADE::depiler-contexte ()
	; Supprimer les variables contextuelles
	(bind ?regle (car$ ?*pile-regles*))
	(do-for-all-facts ((?fact variable))
		(eq ?fact:contexte ?regle)
		(retract ?fact))
	; Dépiler un contexte et une règle
	(bind ?*contexte* (cadr$ ?*pile-contextes*))
	(bind ?*pile-contextes* (cdr$ ?*pile-contextes*))
	(bind ?*pile-regles* (cdr$ ?*pile-regles*))
	(writeLog (format nil "<<< Unstacking the current context: stack=(%s) rules=(%s)" (implode$ ?*pile-contextes*) (implode$ ?*pile-regles*)))
	(actualiser-contexte))
	
(deffunction YADE::reset-dialogue-engine ()
	(reset)
	(bind ?*indice* 0)
	(bind ?*contexte* 0)
	(bind ?*compteur-contexte* 0)
	(bind ?*pile-contextes* (create$ 0))
	(bind ?*pile-regles* (create$ base))
	(writeLog (format nil "### Resetting the contexts stack: indice=%d stack=(%s) rules=(%s)" ?*indice* (implode$ ?*pile-contextes*) (implode$ ?*pile-regles*)))
	(actualiser-contexte))

(deffunction YADE::depiler-tout-contextes ()
	(while (> ?*contexte* 0) (depiler-contexte)))

(deffunction YADE::en-attente ()
	(if (> (length$ ?*pile-contextes*) 1)
	then (return TRUE)
	else (return FALSE)))

;; -----------------------------------------------------------------------------
;; Fonctions sur les granules (dont certaines reprises de granule.clp)

(deffunction YADE::retract-granule (?ident) "Supprime un granule"
	(do-for-fact ((?fact granule))
		(eq ?fact:ident ?ident)
		(retract ?fact)))
		
(deffunction YADE::get-granule-adress (?ident)
	(do-for-fact ((?fact granule))
		(eq ?fact:ident ?ident)
		(return ?fact)))

(deffunction YADE::ancestor-or-self (?ancestor ?self) (printout t "->" ?self)
	(if (false ?self) then (return FALSE))
	(or (eq ?self ?ancestor) (ancestor-or-self ?ancestor (get-pere ?self))))

(deffunction YADE::obsolete (?ident)
	(any-factp ((?used used))
		(eq ?used:ident ?ident)))

(deffunction YADE::poids (?ident) "Retourne le nombre de granules dans la structure"
	(bind ?poids 1)
	(bind ?liste (get-fils ?ident))
	(if (nonvide$ ?liste) then
		(progn$ (?fils ?liste)
			(bind ?poids (+ ?poids (poids ?fils)))))
	(return ?poids))

(deffunction YADE::calcule-poids-des-granules () "Actualise les faits poids-granule"
	(do-for-all-facts ((?fact poids-granule)) (retract ?fact))
	(do-for-all-facts ((?granule granule))
		(assert (poids-granule (ident ?granule:ident) (poids (poids ?granule:ident))))))

;; -----------------------------------------------------------------------------
;; Prédicats sur l'ordre des granules

(deffunction YADE::ordered (?granules) "Vérifie que les ident des granules sont donnés dans l'ordre de création"
	(or (< (length$ ?granules) 2)
	    (and (< (getNumber (car$ ?granules)) (getNumber (cadr$ ?granules)))
	         (ordered (cdr$ ?granules)))))

(deffunction YADE::ok-ordre-fact-1 (?gr1 ?gr2) "Vérifie que 2 granules sont dans l'ordre"
	(bind ?id1 (fact-slot-value ?gr1 indice))
	(bind ?id2 (fact-slot-value ?gr2 indice))
	(bind ?pos1 (fact-slot-value ?gr1 pos))
	(bind ?pos2 (fact-slot-value ?gr2 pos))
	(or (< ?id1 ?id2) ; Soit selon leur indice
	    (and (= ?id1 ?id2) (< ?pos1 ?pos2)))) ; Soit selon leur position si même indice

(deffunction YADE::ok-ordre-fact-2 (?gr1 ?gr2) "Vérifie que 2 granules sont dans l'ordre et au plus proche"
	(bind ?concept1 (get-prefix (fact-slot-value ?gr1 concept)))
	(bind ?concept2 (get-prefix (fact-slot-value ?gr2 concept)))
	(and (ok-ordre-fact-1 ?gr1 ?gr2) ; Ils sont ordonnés...
	     (not (any-factp ((?gr3 granule)) ; Et il n'existe pas de troisième granule...
					(and (or (eq (get-prefix ?gr3:concept) ?concept1) ; Ayant le même concept que le granule 1...
					         (eq (get-prefix ?gr3:concept) ?concept2)) ; Ou le même concept que le granule 2...
					     (ok-ordre-fact-1 ?gr1 ?gr3)
					     (ok-ordre-fact-1 ?gr3 ?gr2)))))) ; Et qui soit intercallé entre le granule 1 et le granule 2

(deffunction YADE::ok-ordre-fact-liste-1 (?liste-fact) "Idem 1 pour une liste de granules"
	(or (< (length$ ?liste-fact) 2)
	    (and (ok-ordre-fact-1 (car$ ?liste-fact) (cadr$ ?liste-fact))
	         (ok-ordre-fact-liste-1 (cdr$ ?liste-fact)))))

(deffunction YADE::ok-ordre-fact-liste-2 (?liste-fact) "Idem 2 pour une liste de granules"
	(or (< (length$ ?liste-fact) 2)
	    (and (ok-ordre-fact-2 (car$ ?liste-fact) (cadr$ ?liste-fact))
	         (ok-ordre-fact-liste-2 (cdr$ ?liste-fact)))))

;; -----------------------------------------------------------------------------
;; Pour répondre directement ou envoyer une requête au générateur

(deftemplate YADE::reponse
	(slot ordre (default-dynamic ?*ordre*))
	(slot texte))

(deffunction YADE::ordre> (?fact1 ?fact2) "Relation d'ordre sur les réponses"
	(> (fact-slot-value ?fact1 ordre)
	   (fact-slot-value ?fact2 ordre)))

(deffunction YADE::__granule-to-XML(?idgranule ?code $?modifieurs)
	; On ne génère pas un granule obsolète (used granule)
	(if (obsolete ?idgranule) then (return ""))
	; Construire les fils du granule
	(bind ?xml "")
	(do-for-all-facts ((?liaison liaison) (?fils granule))
		(and (eq ?liaison:idpere ?idgranule)
		     (eq ?liaison:idfils ?fils:ident))
		(bind ?xml (str-cat ?xml (__granule-to-XML ?fils:ident ?liaison:code ?modifieurs))))
	; Intégrer les fils dans le granule courant
	(do-for-fact ((?granule granule))
		(eq ?granule:ident ?idgranule)
		(if (eq ?granule:concept inferred) then (bind ?texte ?granule:texte) else (bind ?texte ""))
		(return (format nil "<granule concept='%s' code='%s' indice='%d' pos='%d' metadata='%s' texte='%s'>%s</granule>"
			?granule:concept ?code ?granule:indice ?granule:pos (implode$ (create$ ?modifieurs)) ?texte ?xml))))

(deffunction YADE::granule-to-XML (?idgranule $?modifieurs)
	(return (__granule-to-XML ?idgranule nil ?modifieurs)))

(deffunction YADE::repondre (?texte)
	(bind ?*ordre* (+ 1 ?*ordre*))
	(assert (reponse (texte ?texte)))
	(writeLog (format nil "    Response part #%d text=\"%s\"" ?*ordre* ?texte)))

(deffunction YADE::rephrase (?idgranule $?modifieurs)
	(writeLog (format nil "    Generating granule %s metadata=(%s)" ?idgranule (implode$ ?modifieurs)))
	(bind ?texte (invoqueYageServer (granule-to-XML ?idgranule $?modifieurs)))
	(return ?texte))

(deffunction YADE::generer-XML (?xml $?modifieurs)
	(bind ?*ordre* (+ 1 ?*ordre*))
	(writeLog (format nil "    Generating expression %s ... </granule> mod=(%s)" (premiereBalise ?xml) (implode$ ?modifieurs)))
	(bind ?texte (invoqueYageServer ?xml))
	(assert (reponse (texte ?texte)))
	(writeLog (format nil "    Response part #%d text=\"%s\"" ?*ordre* ?texte)))

;; -----------------------------------------------------------------------------
;; Fonctions du moteur de dialogue

(deffunction YADE::fin-cycle (?output)
	(write-working-memory ?output)
	(writesock ?output)
	(do-for-all-facts ((?fact input mot reponse)) TRUE (retract ?fact))
	(pop-focus)
	(if (str-index "[stop-dialogue]" ?output) then (reset-dialogue-engine)))

(deffunction YADE::mirror () "Reformulation de toutes les structures de granules"
	(do-for-all-facts ((?granule granule))
		(and (eq ?granule:indice ?*indice*) ; Les derniers granules
		     (eq ?granule:racine TRUE)) ; Que les racines
		(repondre (format nil "Rephrasing %s = %s"
			?granule:ident
			(rephrase ?granule:ident)))))

;; -----------------------------------------------------------------------------
;; Règles du moteur de dialogue

(deffunction YADE::forget-granule ($?args)) ; Fonction définie dans operations.clp
(deffunction YADE::delete-granule ($?args)) ; Fonction définie dans operations.clp

(defrule YADE::initialisation
	(declare (salience 999))
	(input (chaine ?phrase))
	=>
	(write-working-memory-header ?phrase)
	(writeTitle "Applying dialogue rules"))

;; -----------------------------------------------------------------------------
;; Mécanisme d'obsolescence des granules (salience 5xx)

(defglobal YADE ?*age-max* = 3)

;(defrule YADE::obsolescence "Rend obsolète les granules des contextes fermés"
;	(declare (salience 520))
;	(contexte (indice ?indice) (pile-contextes $?pile))
;	?granule <- (granule (ident ?ident) (racine TRUE) (contexte ?c))
;	(test (not (member$ ?c ?pile)))
;	=>
;	(writeLog (format nil "<== Granule %s becomes obsolete" ?ident))
;	(forget-granule ?ident))

(deffunction YADE::__obs(?ident)
    (assert (used (ident ?ident)))
    (writeLog (format nil "<== Granule %s becomes obsolete" ?ident))
    ; Aller voir les fils du granule
	(do-for-all-facts ((?liaison liaison) (?fils granule))
		(and (eq ?liaison:idpere ?ident)
		     (eq ?liaison:idfils ?fils:ident)
             (not (or (member$ MEDIA ?fils:lconcept)
                      (member$ demander ?fils:lconcept))))
        (__obs ?fils:ident)))

(defrule YADE::obsolescence "Rend obsolète les granules non-MEDIA"
	(declare (salience 520))
(STOP)
	(contexte (indice ?indice))
    (granule (indice =(- ?indice 2)) (ident ?ident) (racine TRUE) (lconcept $?liste))
    (test (not (member$ MEDIA ?liste)))
    (test (not (member$ demander ?liste)))
    =>
    (__obs ?ident))

(defrule YADE::supprime-liaison-obsolete "Supprime les liaisons obsolètes"
	(declare (salience 510))
	?liaison <- (liaison (idpere ?idp) (idfils ?idf))
	(or (not (granule (ident ?idp)))
	    (not (granule (ident ?idf))))
	=>
	(retract ?liaison))

(defrule YADE::supprime-granule-obsolete "Supprime les granules obsolètes les plus anciens"
	(declare (salience 500))
	(contexte (indice ?indice))
	?used <- (used (ident ?ident))
	?granule <- (granule (ident ?ident) (indice ?i&:(> (- ?indice ?i) ?*age-max*)))
	=>
	(writeLog (format nil "<== Granule obsolete %s deleted" ?ident))
	(retract ?granule ?used))

;; -----------------------------------------------------------------------------
;; Mécanisme de fusion des granules (salience 4xx)

(defrule YADE::fusion "Mécanisme de fusion pour absorber les redondances"
	(declare (salience 400))
	(contexte (indice ?indice))
	(granule (indice ?indice) (ident ?id1)) ; Structure absorbante
	(granule (indice ?indice) (ident ?id2&~?id1) (racine TRUE) (n ?n)) ; Structure absorbée
    
    ; Le granule 2 ne doit pas être en situation de conflit
    (not (conflit (id1 ?n)))
    (not (conflit (id2 ?n)))
    
    ; Les granules doivent porter le même concept
	(test (identiques ?id1 ?id2))
	=>
	; Pas une précondition car doit être vérifié APRÈS toutes les assertions (granules ET liaisons) !
	(if (fusionnable ?id1 ?id2) then
		(writeLog (format nil "### Merging of %s and %s (the latter is preserved)" ?id2 ?id1))
		(fusionner ?id1 ?id2)
		(delete-granule ?id2)))

;; -----------------------------------------------------------------------------
;; Construction de la réponse du système

(defrule YADE::reset
	(declare (salience 110))
	(input (chaine "_reset"))
	=>
	(reset-dialogue-engine)
	(fin-cycle ?*openning*))

;(defrule YADE::timeout
;	(declare (salience 110))
;	(input (chaine "timeout"))
;	=>
;	(fin-cycle ?*timeout*))

(defrule YADE::mirror
	(declare (salience 100))
	(input)
	(test (true ?*mirror*))
	=>
	(writeTitle "Mirror mode is enabled")
	(mirror))

(defrule YADE::default
	(declare (salience 100))
	(input)
	(test (false ?*mirror*))
	=>
	(calcule-poids-des-granules)
	(focus YADERULE))

(defrule YADE::erreur-nogranule "Pas de granules et pas de réponse"
	(declare (salience 30))
	(input)
	(contexte (indice ?indice))
	(not (granule (indice ?indice)))
	(not (reponse))
	=>
	(fin-cycle ?*nogranule*))

(defrule YADE::erreur-noresponse "Des granules mais pas de réponse"
	(declare (salience 20))
	(input)
	(contexte (indice ?indice))
	(exists (granule (indice ?indice)))
	(not (reponse))
	=>
	(fin-cycle ?*noresponse*))

(defrule YADE::reponse-machine "Reconstitution et envoi de la réponse"
	(declare (salience 10))
	(input)
	(exists (reponse))
	=>
	(bind ?texte "")
	(progn$ (?reponse (sort ordre> (expand$ (find-all-facts ((?r reponse)) TRUE))))
		; Concaténer les réponses successives dans leur ordre d'arrivée
		(bind ?texte (str-cat ?texte (fact-slot-value ?reponse texte) " ")))
	(fin-cycle ?texte))

;; -----------------------------------------------------------------------------
;; Fonction de reformatage des règles de dialogue

;; WARNING !!!!!!!!
;; Under Ubuntu => xsltproc => generate-id() generates "idp0000000"
;; Under MacOS => xsltproc => generate-id() generates "idm0000000"

(deffunction MAIN::sauvegarder-yaderules ()
	(remove "_yaderules.clp")
	(dribble-on "_yaderules.clp")
	(printout t crlf)
	(printout t ";; ========================================================================" crlf)
	(printout t ";; Règles de dialogue générées automatiquement (ne modifiez pas ce fichier)" crlf)
	(printout t ";; ========================================================================" crlf)
	(printout t crlf)
    (ppdeffacts YADEGLOB::initial-facts)
	(printout t crlf)
	(progn$ (?var (get-defglobal-list YADEGLOB)) (focus YADEGLOB) (ppdefglobal ?var))
	; Les saliences des règles de dialogue doivent être accessibles depuis le module YADE :
	(progn$ (?var (get-defglobal-list YADERULE)) (format t "%n(defglobal YADE ?*%s* = 0)" ?var))
	(printout t crlf)
	(dribble-off)
	(progn$ (?rule (get-defrule-list YADERULE))
		(if (str-index "id" ?rule) then
			(printout t ?rule)
			(dribble-on "_yaderules.clp")
			(printout t crlf)
			(focus YADERULE)
			(ppdefrule ?rule)
			(dribble-off)))
	(dribble-on "_yaderules.clp")
	(printout t crlf)
	(printout t ";; =============================================================================" crlf)
	(printout t ";; Fin du fichier" crlf)
	(dribble-off))

;; -----------------------------------------------------------------------------
;; Fin du fichier
