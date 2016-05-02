
;; ========================================================================
;; Règles de dialogue générées automatiquement (ne modifiez pas ce fichier)
;; ========================================================================

(deffacts YADEGLOB::initial-facts
   (tache0))

(defglobal YADEGLOB ?*timeout* = "Hey, are you sleeping ?")
(defglobal YADEGLOB ?*openning* = "Hi, what can I do for you ?")
(defglobal YADEGLOB ?*nogranule* = "Sorry, I didn't understand. Can you reformulate please ?")
(defglobal YADEGLOB ?*noresponse* = "Sorry, but I don't know what to say. I do not have enough dialogue rules...")
(defglobal YADEGLOB ?*type-langage* = lang:standard)
(defglobal YADEGLOB ?*bavard* = TRUE)

(defglobal YADE ?*salience-idm46398532930496* = 0)
(defglobal YADE ?*salience-idm46398532814928* = 0)
(defglobal YADE ?*salience-idm46398532810000* = 0)
(defglobal YADE ?*salience-idm46398532803968* = 0)
(defglobal YADE ?*salience-idm46398532797264* = 0)
(defglobal YADE ?*salience-idm46398532789696* = 0)

(defrule YADERULE::idm46398532930496 "add departure station to a ticket"
   (declare (salience ?*salience-idm46398532930496*))
   (contexte (indice ?indice) (pile-contextes ?contexte $?))
   ?gr-idm46398532911760 <- (granule (ident ?id) (indice ?indice-idm46398532911760&?indice) (lconcept ticket $?))
   (not (used (ident ?id)))
   ?gr-idm46398532944176 <- (granule (ident ?idm46398532944176) (indice ?indice-idm46398532944176&?indice))
   (liaison (idpere ?id) (idfils ?idm46398532944176) (role destination))
   (not (used (ident ?idm46398532944176)))
   (not (and (granule (ident ?idm46398532943376) (indice ?indice))
             (liaison (idpere ?id) (idfils ?idm46398532943376) (role departure))))
   (test (differents$ (create$ ?gr-idm46398532911760 ?gr-idm46398532944176)))
   (not (fired ?indice idm46398532930496 =(string-to-field (getNumber ?id)) =(string-to-field (getNumber ?idm46398532944176))))
   (poids-granule (ident ?id) (poids ?id-poids))
   (test (bind ?*salience-idm46398532930496* (+ 500 3 ?id-poids)))
   =>
   (assert (fired ?indice idm46398532930496 (string-to-field (getNumber ?id)) (string-to-field (getNumber ?idm46398532944176))))
   (bind ?liste-id (create$ (string-to-field (getNumber ?id)) (string-to-field (getNumber ?idm46398532944176))))
   (writeLog (format nil "### Inference rule (add departure station to a ticket) granules=(%s) salience=%d id=%s" (implode$ ?liste-id) ?*salience-idm46398532930496* idm46398532930496))
   (bind ?idm46398532941296 (create-granule-2 (sym-cat (get-current-station)) ?id departure))
   (calcule-poids-des-granules))

(defrule YADERULE::idm46398532814928 "openning"
   (declare (salience ?*salience-idm46398532814928*))
   (contexte (indice ?indice) (pile-contextes ?contexte $?))
   ?gr-idm46398532812368 <- (granule (ident ?idm46398532812368) (indice ?indice-idm46398532812368&?indice) (lconcept hello $?))
   (not (used (ident ?idm46398532812368)))
   (not (fired ?indice idm46398532814928 =(string-to-field (getNumber ?idm46398532812368))))
   (poids-granule (ident ?idm46398532812368) (poids ?idm46398532812368-poids))
   (test (bind ?*salience-idm46398532814928* (+ 400 1 ?idm46398532812368-poids)))
   =>
   (assert (fired ?indice idm46398532814928 (string-to-field (getNumber ?idm46398532812368))))
   (bind ?liste-id (create$ (string-to-field (getNumber ?idm46398532812368))))
   (writeLog (format nil "### Standalone rule (openning) granules=(%s) salience=%d id=%s" (implode$ ?liste-id) ?*salience-idm46398532814928* idm46398532814928))
   (repondre "Hi, what can I do for you ?")
   (repondre (sym-cat [ expression : asking ]))
   (calcule-poids-des-granules))

(defrule YADERULE::idm46398532810000 "request without requestable"
   (declare (salience ?*salience-idm46398532810000*))
   (contexte (indice ?indice) (pile-contextes ?contexte $?) (pile-regles ~idm46398532810000 $?))
   ?gr-idm46398532807328 <- (granule (ident ?id1) (indice ?indice-idm46398532807328&?indice) (lconcept request $?))
   (not (used (ident ?id1)))
   (not (and (granule (ident ?idm46398532806352) (indice ?indice))
             (liaison (idpere ?id1) (idfils ?idm46398532806352))))
   (not (fired ?indice idm46398532810000 =(string-to-field (getNumber ?id1))))
   (poids-granule (ident ?id1) (poids ?id1-poids))
   (test (bind ?*salience-idm46398532810000* (+ 300 2 ?id1-poids)))
   =>
   (assert (fired ?indice idm46398532810000 (string-to-field (getNumber ?id1))))
   (bind ?liste-id (create$ (string-to-field (getNumber ?id1))))
   (writeLog (format nil "### Initiative rule (request without requestable) granules=(%s) salience=%d id=%s" (implode$ ?liste-id) ?*salience-idm46398532810000* idm46398532810000))
   (empiler-contexte idm46398532810000)
   (assert (variable (contexte idm46398532810000) (ident id1) (value ?id1)))
   (pop-focus)
   (repondre "I did not understand well what you ask me.")
   (repondre "What are you looking for exactly? [timeout:5]")
   (calcule-poids-des-granules))

(defrule YADERULE::idm46398532803968 "identifies a requestable"
   (declare (salience ?*salience-idm46398532803968*))
   (contexte (indice ?indice) (pile-contextes ?contexte $?) (pile-regles idm46398532810000 $?))
   ?gr-idm46398532801296 <- (granule (ident ?id2) (indice ?indice-idm46398532801296&?indice) (offres $?offres-idm46398532801296))
   (test (member$ requestable ?offres-idm46398532801296))
   (not (used (ident ?id2)))
   (variable (contexte idm46398532810000) (ident id1) (value ?id1))
   (not (fired ?indice idm46398532803968 =(string-to-field (getNumber ?id2))))
   (poids-granule (ident ?id2) (poids ?id2-poids))
   (test (bind ?*salience-idm46398532803968* (+ 200 1 ?id2-poids)))
   =>
   (assert (fired ?indice idm46398532803968 (string-to-field (getNumber ?id2))))
   (bind ?liste-id (create$ (string-to-field (getNumber ?id2))))
   (writeLog (format nil "### Nested terminal rule (identifies a requestable) granules=(%s) salience=%d id=%s" (implode$ ?liste-id) ?*salience-idm46398532803968* idm46398532803968))
   (repondre (rephrase ?id2))
   (repondre ", Ok.")
   (disconnect-granule ?id2)
   (connect-granule ?id1 ?id2 nil)
   (depiler-contexte)
   (calcule-poids-des-granules))

(defrule YADERULE::idm46398532797264 "not a requestable then reiterates"
   (declare (salience ?*salience-idm46398532797264*))
   (contexte (indice ?indice) (pile-contextes ?contexte $?) (pile-regles idm46398532810000 $?))
   (not (and (granule (ident ?idm46398532794592) (indice ?indice) (offres $? requestable $?))))
   (test (< (counter-value reiteration) 2))
   (variable (contexte idm46398532810000) (ident id1) (value ?id1))
   (not (fired ?indice idm46398532797264))
   (test (bind ?*salience-idm46398532797264* (+ 400 2)))
   =>
   (assert (fired ?indice idm46398532797264))
   (bind ?liste-id (create$))
   (writeLog (format nil "### Nested non terminal rule (not a requestable then reiterates) granules=(%s) salience=%d id=%s" (implode$ ?liste-id) ?*salience-idm46398532797264* idm46398532797264))
   (increase-counter reiteration)
   (if (= (counter-value reiteration) 1)
      then
      (repondre "Excuse me but you asked me something?"))
   (if (= (counter-value reiteration) 2)
      then
      (repondre "What do you want? Please answer me..."))
   (calcule-poids-des-granules))

(defrule YADERULE::idm46398532789696 "too much reiteration"
   (declare (salience ?*salience-idm46398532789696*))
   (contexte (indice ?indice) (pile-contextes ?contexte $?) (pile-regles idm46398532810000 $?))
   (not (and (granule (ident ?idm46398532787008) (indice ?indice) (offres $? requestable $?))))
   (test (= (counter-value reiteration) 2))
   (variable (contexte idm46398532810000) (ident id1) (value ?id1))
   (not (fired ?indice idm46398532789696))
   (test (bind ?*salience-idm46398532789696* (+ 200 2)))
   =>
   (assert (fired ?indice idm46398532789696))
   (bind ?liste-id (create$))
   (writeLog (format nil "### Nested terminal rule (too much reiteration) granules=(%s) salience=%d id=%s" (implode$ ?liste-id) ?*salience-idm46398532789696* idm46398532789696))
   (repondre "Sorry but we definitively do not understand ourselves")
   (remove-counter reiteration)
   (depiler-contexte)
   (calcule-poids-des-granules))

;; =============================================================================
;; Fin du fichier
