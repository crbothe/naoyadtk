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

(defmodule MAIN (export ?ALL))

;; -----------------------------------------------------------------------------
;; Fonctions diverses
;; -----------------------------------------------------------------------------

(deffunction MAIN::nop ())

(deffunction MAIN::error (?message)
	(printout t crlf)
	(format t "%n************************************************************************************************")
	(format t "%nERROR: %s" ?message)
	(format t "%n************************************************************************************************"))

(deffunction MAIN::true (?var) (eq ?var TRUE))
(deffunction MAIN::false (?var) (eq ?var FALSE))

(deffunction MAIN::nbfacts () (+ (fact-index (assert (nothing))) 1))

(deffunction MAIN::print-type-of (?object) (printout t crlf "### [" ?object "] is a " (type ?object)))

(deffunction MAIN::toNumber (?object)
	(if (numberp ?object)
	then (return ?object)
	else (return (string-to-field ?object))))

(deffunction MAIN::toString (?object)
	(switch (type ?object)
		(case FACT-ADDRESS then (return (format nil "&lt;fact-%d&gt;" (fact-index ?object))))
		(default (return ?object))))

(deffunction MAIN::genint* () "Pour générer un entier"
	(bind ?sym (gensym*))
	(string-to-field (sub-string 4 (str-length ?sym) ?sym)))

(deffunction MAIN::index> (?fact1 ?fact2)
	(> (fact-index ?fact1)
	   (fact-index ?fact1)))

(deffunction MAIN::pos> (?fact1 ?fact2) "Relation d'ordre sur les positions"
	(> (fact-slot-value ?fact1 pos)
	   (fact-slot-value ?fact2 pos)))

(deffunction MAIN::print-fact (?fact)
	(facts * (fact-index ?fact) (fact-index ?fact)))

(deffunction MAIN::tabulation (?n) "Fabrique une tabulation de taille 3xn"
	(if (eq ?n 0)
		then (return "")
		else (return (str-cat "   " (tabulation (- ?n 1))))))

(deffunction MAIN::fileExists (?filename) (return (rename ?filename ?filename)))

(deffunction MAIN::waitfor (?filename ?timeout) "Attente d'un fichier avec timeout en secondes"
	(bind ?compteur 0)
	(while (not (fileExists ?filename)) do
		(printout t ".")
		(system "sleep 1") ; Pause d'une seconde
		(bind ?compteur (+ ?compteur 1))
		(if (> ?compteur ?timeout) then
			(printout t "### TIMEOUT (" ?timeout "s) waitfor " ?filename crlf)
			(return FALSE)))
	(return TRUE))

(deffunction MAIN:debug ()
	(remove "trace-debug.txt")
	(dribble-on "trace-debug.txt")
	(watch activations)
	(watch rules)
	(watch facts)
	(watch focus))

;; -----------------------------------------------------------------------------
;; Fonctions sur les chaînes
;; -----------------------------------------------------------------------------

(deffunction MAIN::spec (?chaine) "La chaîne commence par un caractère accentué"
	(bind ?car (sub-string 1 1 ?chaine))
	(or (eq ?car (sub-string 1 1 "é"))
		(eq ?car (sub-string 1 1 "è"))
		(eq ?car (sub-string 1 1 "ê"))
		(eq ?car (sub-string 1 1 "ë"))
		(eq ?car (sub-string 1 1 "à"))
		(eq ?car (sub-string 1 1 "â"))
		(eq ?car (sub-string 1 1 "ô"))
		(eq ?car (sub-string 1 1 "ù"))
		(eq ?car (sub-string 1 1 "ç"))))
		
(deffunction MAIN::str-car (?chaine) "Fonction CAR sur les chaînes de caractères"
	(if (spec ?chaine)
		then (return (sub-string 1 2 ?chaine))
		else (return (sub-string 1 1 ?chaine))))

(deffunction MAIN::str-cdr (?chaine) "Fonction CDR sur les chaînes de caractères"
	(if (spec ?chaine)
		then (return (sub-string 3 (str-length ?chaine) ?chaine))
		else (return (sub-string 2 (str-length ?chaine) ?chaine))))

(deffunction MAIN::str-cddr (?chaine) (str-cdr (str-cdr ?chaine)))

(deffunction MAIN::nonvide (?chaine) (> (str-length ?chaine) 0))

(deffunction MAIN::est-un-nombre (?chaine) (numberp (string-to-field ?chaine)))

(deffunction MAIN::string> (?str1 ?str2) (> (str-compare ?str1 ?str2) 0))

(deffunction MAIN::str-explose (?chaine) "Pour exploser une chaîne de caractères en une liste de char"
	(bind ?car (str-car ?chaine))
	(bind ?cdr (str-cdr ?chaine))
	(if (eq ?car "")
		then (return (create$))
		else (return (create$ ?car (str-explose ?cdr)))))
		
(deffunction MAIN::nbchar (?char ?chaine) "Pour compter le nombre de caractère ?char dans une chaîne"
	(if (eq ?chaine "") then (return 0))
	(if (eq (str-car ?chaine) ?char)
		then (return (+ 1 (nbchar ?char (str-cdr ?chaine))))
		else (return (nbchar ?char (str-cdr ?chaine)))))

(deffunction MAIN::nbmots (?chaine) "Pour compter le nombre de mots dans une chaîne"
	(if (eq ?chaine "")
		then (return 0)
		else (+ 1 (nbchar " " ?chaine))))
		
(deffunction MAIN::_tokenise (?chaine ?mot) "Fabrique une liste de chaînes"
	(bind ?car (sub-string 1 1 ?chaine))
	(bind ?cdr (sub-string 2 (length ?chaine) ?chaine))
	(switch ?car
		(case "" then (if (eq ?mot "")
			then (create$)
			else (create$ ?mot)))
		(case " " then (if (eq ?mot "")
			then (create$ (_tokenise ?cdr ""))
			else (create$ ?mot (_tokenise ?cdr ""))))
		(default (_tokenise ?cdr (str-cat ?mot ?car)))))

(deffunction MAIN::tokenise (?chaine) (_tokenise ?chaine ""))
	
(deffunction MAIN::str-replace-all (?source ?str1 ?str2) "Pour remplacer les occurences de ?str1 par ?str2 dans ?source"
	(bind ?position (str-index ?str1 ?source))
	(if (not ?position)
		then (return ?source)
		else
		(bind ?avant (sub-string 1 (- ?position 1) ?source))
		(bind ?apres (sub-string (+ ?position (length$ ?str1)) (length$ ?source) ?source))
		(return (str-cat ?avant ?str2 (str-replace-all ?apres ?str1 ?str2)))))

(deffunction MAIN::clearSpaces (?chaine) "Pour supprimer tous les blancs d'une chaîne de caractères"
	(bind ?car (str-car ?chaine))
	(bind ?cdr (str-cdr ?chaine))
	(if (eq ?car "")
		then (return "")
		else (if (eq ?car " ")
			then (return (clearSpaces ?cdr))
			else (return (str-cat ?car (clearSpaces ?cdr))))))

(deffunction MAIN::sansaccents (?chaine) "Pour supprimer tous les accents d'une chaîne de caractères"
	(bind ?car (str-car ?chaine))
	(bind ?cdr (str-cdr ?chaine))
	(switch ?car
		(case "" then (return ""))
		(case "é" then (return (str-cat "e" (sansaccents ?cdr))))
		(case "è" then (return (str-cat "e" (sansaccents ?cdr))))
		(case "ê" then (return (str-cat "e" (sansaccents ?cdr))))
		(case "ë" then (return (str-cat "e" (sansaccents ?cdr))))
		(case "à" then (return (str-cat "a" (sansaccents ?cdr))))
		(case "â" then (return (str-cat "a" (sansaccents ?cdr))))
		(case "ù" then (return (str-cat "u" (sansaccents ?cdr))))
		(case "ô" then (return (str-cat "o" (sansaccents ?cdr))))
		(case "ç" then (return (str-cat "c" (sansaccents ?cdr))))
		(default (return (str-cat ?car (sansaccents ?cdr))))))
		
(deffunction MAIN::token (?chaine) "Pour remplacer tous les espaces par des underscores"
	(sym-cat (lowcase (str-replace-all ?chaine " " "_"))))

(deffunction MAIN::deparentheser (?chaine)
	(sub-string 2 (- (str-length ?chaine) 1) ?chaine))

(deffunction MAIN::clearFirstSpaces (?chaine) "Pour supprimer les premiers blancs d'une chaîne de caractères"
	(bind ?len (length ?chaine))
	(if (eq " " (sub-string 1 1 ?chaine))
	then (return (clearFirstSpaces (sub-string 2 ?len ?chaine)))
	else (return ?chaine)))

(deffunction MAIN::clearLastSpaces (?chaine) "Pour supprimer les derniers blancs d'une chaîne de caractères"
	(bind ?len (length ?chaine))
	(if (eq " " (sub-string ?len ?len ?chaine))
	then (return (clearLastSpaces (sub-string 1 (- ?len 1) ?chaine)))
	else (return ?chaine)))

(deffunction MAIN::clearLastZero (?chaine) "Pour supprimer les derniers 0 d'une chaîne de caractères"
	(bind ?len (length ?chaine))
	(bind ?last (sub-string ?len ?len ?chaine))
	(if (or (eq ?last "0") (eq ?last "."))
	then (return (clearLastZero (sub-string 1 (- ?len 1) ?chaine)))
	else (return ?chaine)))

(deffunction MAIN::premiereBalise (?chaine) "Retourne la première balise d'une chaîne XML"
	(bind ?pos (str-index ">" ?chaine))
	(return (sub-string 1 ?pos ?chaine)))
	
;; -----------------------------------------------------------------------------
;; Additions entre des symboles et des nombres

(defmethod MAIN::+ ((?x INTEGER) (?y SYMBOL))
	(if (est-un-nombre ?y)
	then (return (str-cat (+ ?x (string-to-field ?y))))
	else (error (format nil "ERROR: Can't perform operation (+ %d %s)" ?x ?y))))
	
(defmethod MAIN::+ ((?x SYMBOL) ($?rest INTEGER))
	(if (est-un-nombre ?x)
	then (return (str-cat (+ (string-to-field ?x) (expand$ ?rest))))
	else (error (format nil "ERROR: Can't perform operation (+ %s %s)" ?x (implode$ ?rest)))))

(defmethod MAIN::+ ((?x SYMBOL) (?y SYMBOL) ($?rest INTEGER))
	(if (and (est-un-nombre ?x) (est-un-nombre ?y))
	then (return (str-cat (+ (string-to-field ?x) (string-to-field ?y) (expand$ ?rest))))
	else (error (format nil "ERROR: Can't perform operation (+ %s %s %s)" ?x ?y (implode$ ?rest)))))

(defmethod MAIN::+ ((?x SYMBOL) (?y SYMBOL) (?z SYMBOL) ($?rest INTEGER))
	(if (and (est-un-nombre ?x) (est-un-nombre ?y) (est-un-nombre ?z))
	then (return (str-cat (+ (string-to-field ?x) (string-to-field ?y) (string-to-field ?z) (expand$ ?rest))))
	else (error (format nil "ERROR: Can't perform operation (+ %s %s %s %s)" ?x ?y ?z (implode$ ?rest)))))

;; -----------------------------------------------------------------------------
;; Fonctions sur les multivalués
;; -----------------------------------------------------------------------------

(defglobal MAIN ?*vide* = (create$))

(deffunction MAIN::car$ ($?liste) (nth$ 1 ?liste)) ; Retourne le premier élément ou nil si liste vide

(deffunction MAIN::cdr$ ($?liste) (rest$ ?liste)) ; Retourne la liste privée de sont premier élément

(deffunction MAIN::cadr$ ($?liste) (car$ (cdr$ ?liste)))

(deffunction MAIN::vide$ ($?liste) (= (length$ ?liste) 0))

(deffunction MAIN::nonvide$ ($?liste) (> (length$ ?liste) 0))

(deffunction MAIN::dernier$ ($?liste) (nth$ (length$ ?liste) ?liste))

(deffunction MAIN::equal$ (?test ?set1 ?set2) "Egalité ensembliste"
	(eq (sort ?test ?set1)
	    (sort ?test ?set2)))

(deffunction MAIN::intersection$ (?liste1 ?liste2) "Intersection ensembliste"
	(bind ?resultat (create$))
	(progn$ (?element ?liste1)
		(if (member$ ?element ?liste2) then
			(bind ?resultat (create$ ?resultat ?element))))
	(return ?resultat))

(deffunction MAIN::intersection (?liste1 ?liste2) (intersection$ ?liste1 ?liste2))

(deffunction MAIN::intersectp (?liste1 ?liste2) "Prédicat d'intersection ensembliste"
	(progn$ (?element ?liste1)
		(if (member$ ?element ?liste2) then
			(return TRUE))))
			
(deffunction MAIN::union$ (?liste1 ?liste2) "Union ensembliste"
	(bind ?resultat (create$ ?liste1))
	(progn$ (?element ?liste2)
		(if (not (member$ ?element ?resultat)) then
			(bind ?resultat (insert$ ?resultat 1 ?element))))
	(return ?resultat))

(deffunction MAIN::differents$ (?liste) "Vérifie la présence de doublons"
	(if (vide$ ?liste)
	then (return TRUE) else
		(bind ?car (car$ ?liste))
		(bind ?cdr (cdr$ ?liste))
		(if (member$ ?car ?cdr)
		then (return FALSE) else
			(return (differents$ ?cdr)))))

(deffunction MAIN::supprime-doublons$ (?liste) "Supprime les doublons"
	(if (vide$ ?liste)
	then (return ?liste) else
		(bind ?car (car$ ?liste))
		(bind ?cdr (cdr$ ?liste))
		(if (member$ ?car ?cdr)
		then (return (supprime-doublons$ ?cdr)) else
			(return (create$ ?car (supprime-doublons$ ?cdr))))))

(deffunction MAIN::mapcar$ (?fonction $?liste) "La fonction mapcar de Lisp"
	(bind ?resultat (create$))
	(progn$ (?element ?liste)
		(bind ?resultat (create$ ?resultat (funcall ?fonction ?element))))
	(return ?resultat))

(deffunction MAIN::concatene$ ($?liste) "Concatène une liste de chaînes"
	(bind ?chaine "")
	(progn$ (?mot ?liste) (bind ?chaine (str-cat ?chaine " " ?mot)))
	(return (sub-string 2 (str-length ?chaine) ?chaine)))

(deffunction MAIN::concatene2$ ($?liste) "Concatène une liste de symboles"
	(bind ?resultat (nth$ 1 ?liste))
	(progn$ (?element (rest$ ?liste))
		(bind ?resultat (sym-cat ?resultat ?element)))
	(return ?resultat))

(deffunction MAIN::supprime$ (?liste $?termes) "Supprime toutes les occurences de plusieurs termes"
	(bind ?resultat (create$))
	(progn$ (?element ?liste)
		(if (not (member$ ?element ?termes)) then
			(bind ?resultat (create$ ?resultat ?element))))
	(return ?resultat))
	
(deffunction MAIN::nb-occurence$ (?element ?liste) "Retourne le nombre d'occurence de l'élément"
	(bind ?res 0)
	(progn$ (?e ?liste)
		(if (eq ?e ?element) then (bind ?res (+ 1 ?res))))
	(return ?res))

;; -----------------------------------------------------------------------------


;; -----------------------------------------------------------------------------
;; Fin du fichier

; Pour enlever les espaces inutiles dans une chaine
(deffunction MAIN::clean (?chaine) (concatene$ (tokenise ?chaine)))

(deffunction MAIN::cree-liste (?pos ?fin)
	(if (= ?pos ?fin) then (return (create$)))
	(return (create$ ?pos (cree-liste (+ ?pos 1) ?fin))))
