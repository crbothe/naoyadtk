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

(defglobal MAIN ?*ordre* = 0) ; Ordre des parties pour la réponse du système
(defglobal MAIN ?*indice* = 0) ; Indice courant (intervention de l'usager)
(defglobal MAIN ?*contexte* = 0) ; Contexte courant (délimite des attentes du système)

(defglobal MAIN ?*pile-contextes* = (create$ 0))

(defglobal MAIN ?*outputFileName* = "../YADE_client/yadeviz/_input.xml") ; Sortie XML pour la visualisation
(defglobal MAIN ?*liste-actions* = (create$)) ; Liste des actions pour la visualisation

(deftemplate MAIN::input
	(slot indice (default-dynamic ?*indice*))
	(slot contexte (default-dynamic ?*contexte*))
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

;; -----------------------------------------------------------------------------
;; Les granules côté dialogueur

(deftemplate MAIN::granule
	; -----------------------------------------
	; Partie commune YASP/YADE
	; -----------------------------------------
	(slot ident (type SYMBOL) (default ?NONE)) ; Identifiant du granule
	(slot concept (type SYMBOL) (default nil)) ; Concept du granule (nil si hypothétique)
	(multislot lconcept (type SYMBOL INTEGER)) ; Version liste du concept (vide si hypothétique)
	(multislot offres (type SYMBOL INTEGER)) ; Offres du concept
	(multislot metadata (type SYMBOL)) ; Métadonnées (inter, neg, etc.)
	(slot texte (type STRING) (default "INFERRED")) ; Texte dans l'énoncé
	(slot pos (type INTEGER) (default 999)) ; Position dans l'énoncé (ou 999 si inféré)
	(slot fin (type INTEGER) (default 999)) ; Position suivante dans l'énoncé (ou 999 si inféré)
	(slot score (type FLOAT) (default ?DERIVE)) ; Score pour la résolution des conflits (ou 0.0 si inféré)
	(slot racine (allowed-symbols TRUE FALSE) (default FALSE)) ; Granule racine
	(slot hyp (allowed-symbols TRUE FALSE) (default FALSE)) ; Granule hypothétique (inféré dans YASP)
	; -----------------------------------------
	; Partie privée YADE
	; -----------------------------------------
	(slot n (type INTEGER)) ; Pour la règle YADE::fusion du fichier module_yade.clp
	(slot added (allowed-symbols TRUE FALSE) (default FALSE)) ; Granule ajouté (inféré dans YADE)
	(slot indice (default-dynamic ?*indice*))
	(slot contexte (default-dynamic ?*contexte*)))

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

(deftemplate MAIN::used
	(slot ident (type SYMBOL) (default ?NONE)))

(deftemplate MAIN::poids-granule
	(slot ident (type SYMBOL) (default ?NONE))
	(slot poids (type INTEGER) (default ?NONE)))

(deftemplate MAIN::conflit "Conflit non résolu entre deux granules"
	(slot id1 (type INTEGER) (default ?NONE))
	(slot id2 (type INTEGER) (default ?NONE)))

;; -----------------------------------------------------------------------------
;; Fonctions sur les granules

(deffunction MAIN::getNumber (?idgranule) "commentaire TODO"
	(sub-string
		(+ (str-index "#" ?idgranule) 1)
		(str-length ?idgranule)
		?idgranule))

(deffunction MAIN::date> (?g1 ?g2) "Relation d'ordre sur la création"
	(> (string-to-field (getNumber (fact-slot-value ?g1 ident)))
	   (string-to-field (getNumber (fact-slot-value ?g2 ident)))))

(deffunction MAIN::number> (?id1 ?id2) "Relation d'ordre sur la création"
	(> (string-to-field (getNumber ?id1))
	   (string-to-field (getNumber ?id2))))

(deffunction MAIN::get-pere (?idgranule) "Retourne l'identificateur du père du granule"
	(do-for-fact ((?liaison liaison) (?pere granule))
		(and (eq ?liaison:idfils ?idgranule)
		     (eq ?liaison:idpere ?pere:ident))
		(return ?pere:ident)))

(deffunction MAIN::get-fils (?idgranule) "Retourne la liste des fils de ?idgranule"
	(bind ?liste (create$))
	(do-for-all-facts ((?liaison liaison) (?fils granule))
		(and (eq ?liaison:idpere ?idgranule)
		     (eq ?liaison:idfils ?fils:ident))
		(bind ?liste (create$ ?liste ?fils:ident)))
	(return ?liste))

;(deffunction YADE::get-concept (?ident) "Retourne le concept de ?ident"
;	(do-for-fact ((?granule granule))
;		(eq ?granule:ident ?ident)
;		(return (encode-concept ?granule:concept))))

(deffunction MAIN::get-concept (?idgranule) "Retourne le concept du granule"
	(do-for-fact ((?granule granule))
		(eq ?granule:ident ?idgranule)
		(return ?granule:concept)))

(deffunction MAIN::get-code (?idgranule) "Retourne le code de la liaison du granule (ou nil)"
	(do-for-fact ((?liaison liaison))
		(eq ?liaison:idfils ?idgranule)
		(return ?liaison:code))
	(return nil))

(deffunction MAIN::get-role (?idgranule) "Retourne le rôle de la liaison du granule (ou nil)"
	(do-for-fact ((?liaison liaison))
		(eq ?liaison:idfils ?idgranule)
		(return ?liaison:role))
	(return nil))

(deffunction MAIN::get-offres (?idgranule) "Retourne les offres de ?idgranule"
	(do-for-fact ((?granule granule))
		(eq ?granule:ident ?idgranule)
		(return ?granule:offres)))

(deffunction MAIN::attente-satisfaite (?idpere ?code) "Vérifie si une attente d'un granule est satisfaite"
	(any-factp ((?liaison liaison))
		(and (eq ?liaison:idpere ?idpere)
		     (eq ?liaison:code ?code))))

(deffunction MAIN::get-fils-by-code (?idpere ?code) "Retourne l'ident d'un fils à partir du code de la dépendance"
	(do-for-fact ((?liaison liaison))
		(and (eq ?liaison:idpere ?idpere)
		     (eq ?liaison:code ?code))
		(return ?liaison:idfils))
	(return nil))

(deffunction MAIN::get-liaison-by-code (?idpere ?code) "Retourne une liaison à partir de son code"
	(do-for-fact ((?liaison liaison))
		(and (eq ?liaison:idpere ?idpere)
		     (eq ?liaison:code ?code))
		(return ?liaison))
	(writeError (format nil "ERROR in get-liaison-by-code: %s don't have any %s dependency" ?idpere ?code))
	(halt))

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

;(deffunction MAIN::format-granule (?granule) "Affiche un granule sur une ligne"
;	(format nil "%s role=%s offres=(%s) metadata=(%s)"
;		(fact-slot-value ?granule ident)
;		(fact-slot-value ?granule role)
;		(implode$ (fact-slot-value ?granule types))
;		(implode$ (fact-slot-value ?granule metadata))))

(deffunction MAIN::identiques (?id1 ?id2)
 	(and (eq (get-concept ?id1) (get-concept ?id2))
	     (eq (get-role ?id1) (get-role ?id2))))

(deffunction MAIN::fusionnable (?id1 ?id2) "Vérifie la fusionnabilité de deux G-structures"
	(if (or (eq nil ?id1) (eq nil ?id2)) then (return TRUE))	
	(if (not (identiques ?id1 ?id2)) then (return FALSE))
	(progn$ (?code (create$ A1 A2 A3 A4 A5 A6 A7 A8 A9))
		(bind ?fils1 (get-fils-by-code ?id1 ?code))
		(bind ?fils2 (get-fils-by-code ?id2 ?code))
		(if (not (fusionnable ?fils1 ?fils2)) then (return FALSE)))
	(return TRUE))
	
(deffunction MAIN::fusionner (?id1 ?id2) "Réalise la fusion de deux G-structures fusionnables"
	(progn$ (?code (create$ A1 A2 A3 A4 A5 A6 A7 A8 A9))
		(bind ?fils1 (get-fils-by-code ?id1 ?code))
		(bind ?fils2 (get-fils-by-code ?id2 ?code))
		(if (and (eq nil ?fils1) (neq nil ?fils2)) then
			(bind ?liaison (get-liaison-by-code ?id2 ?code))
			(modify ?liaison (idpere ?id1)))
		(if (and (neq nil ?fils1) (neq nil ?fils2)) then
			(fusionner ?fils1 ?fils2))))

;; -----------------------------------------------------------------------------
;; Envoi de la mémoire de travail dans un fichier

(deffunction MAIN::write-granule-XML (?granule ?liaison ?output ?tab)
	(bind ?ident (fact-slot-value ?granule ident))
	(bind ?indice (fact-slot-value ?granule indice))
	(bind ?contexte (fact-slot-value ?granule contexte))
	(bind ?racine (fact-slot-value ?granule racine))
	(bind ?concept (fact-slot-value ?granule concept))
	(bind ?texte (fact-slot-value ?granule texte))
	(bind ?code (get-code ?ident))
	(bind ?role (get-role ?ident))
	(bind ?pos (fact-slot-value ?granule pos))
	(bind ?fin (fact-slot-value ?granule fin))
	(bind ?hyp (fact-slot-value ?granule hyp))
	(bind ?rescued (if (eq ?liaison nil) then "FALSE" else (fact-slot-value ?liaison hyp)))
	(bind ?offres (fact-slot-value ?granule offres))
	(bind ?metadata (fact-slot-value ?granule metadata))
	(bind ?added (fact-slot-value ?granule added))
	
	(bind ?poids 0)
	(do-for-fact ((?p poids-granule))
		(eq ?p:ident ?ident)
		(bind ?poids ?p:poids))
	
	(if (any-factp ((?fact used)) (eq ?fact:ident ?ident))
	then (bind ?used "TRUE")
	else (bind ?used "FALSE"))
	
	(format ?output "%n%s<granule id=\"%s\" indice=\"%d\" context=\"%d\" pos=\"%d\" fin=\"%d\" poids=\"%d\" concept=\"%s\" code=\"%s\" role=\"%s\" offres=\"%s\" metadata=\"%s\" text=\"%s\" inferred=\"%s\" rescued=\"%s\" added=\"%s\" used=\"%s\""
		(tabulation ?tab) (getNumber ?ident) ?indice ?contexte ?pos (- ?fin 1) ?poids (encode-concept ?concept) ?code ?role (implode$ ?offres) (implode$ ?metadata) ?texte ?hyp ?rescued ?added ?used)
	(if (any-factp ((?liaison liaison) (?fils granule))
			(and (eq ?liaison:idpere ?ident)
			     (eq ?liaison:idfils ?fils:ident)))
	then
		(format ?output ">")
		(do-for-all-facts ((?liaison liaison) (?fils granule))
			(and (eq ?liaison:idpere ?ident)
			     (eq ?liaison:idfils ?fils:ident))
			(write-granule-XML ?fils ?liaison ?output (+ ?tab 1)))
		(format ?output "%n%s</granule>" (tabulation ?tab))
	else
		(format ?output "/>")))

(deffunction MAIN::write-working-memory-header (?input)
	(remove ?*outputFileName*)
	(open ?*outputFileName* outputfile "w")
	(format outputfile "<working-memory>")
	(format outputfile "%n%s<input text=\"%s\">" (tabulation 1) ?input)
	(progn$ (?granule (sort date> (expand$ (find-all-facts ((?gr granule)) (and (true ?gr:racine) (eq ?gr:indice ?*indice*))))))
		(write-granule-XML ?granule nil outputfile 2))
	(do-for-all-facts ((?c conflit)) TRUE
		(format outputfile "%n%s<conflict id1=\"%d\" id2=\"%d\"/>" (tabulation 2) ?c:id1 ?c:id2))
	(format outputfile "%n%s</input>" (tabulation 1))
	(close outputfile))
	
(deffunction MAIN::write-working-memory (?output)
	(open ?*outputFileName* outputfile "a")
	(format outputfile "%n%s<output text=\"%s\" indice=\"%d\" stack=\"%s\">" (tabulation 1) ?output ?*indice* (implode$ ?*pile-contextes*))
	(progn$ (?granule (sort date> (expand$ (find-all-facts ((?gr granule)) (true ?gr:racine)))))
		(write-granule-XML ?granule nil outputfile 2))
	(format outputfile "%n%s</output>" (tabulation 1))
	
	; TODO = génère un segmentation fault de temps en temps !!!
	;(do-for-all-facts ((?fact _fact)) TRUE (format outputfile "%n%s<fact context=\"%d\" indice=\"%d\" value=\"%s\"/>" (tabulation 1) ?fact:contexte ?fact:indice (implode$ ?fact:data)))
	;(do-for-all-facts ((?fact _counter)) TRUE (format outputfile "%n%s<counter ident=\"%s\" value=\"%d\"/>" (tabulation 1) ?fact:ident ?fact:value))
	
	(format outputfile "%n</working-memory>")
	(close outputfile))
	
;; -----------------------------------------------------------------------------
;; Fin du fichier
