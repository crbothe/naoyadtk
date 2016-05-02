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

(defmodule LEXIQUE (import MAIN ?ALL) (export ?ALL))
(defmodule PRECOMP (import LEXIQUE ?ALL))

(deffunction LEXIQUE::writelog ($?args))

;; -----------------------------------------------------------------------------
;; Module LEXIQUE
;; -----------------------------------------------------------------------------
;; ATTENTION : Penser à adapter la fonction PRECOMP::sauvegarder-lexique

(deftemplate LEXIQUE::concept
	(slot concept (type SYMBOL) (default ?NONE))
	(multislot offres (type SYMBOL INTEGER) (default ?DERIVE)) ; Pas d'offre => concept vide
	(slot offre-expr (type STRING) (default ?DERIVE))) ; Offre calculée pour les connecteurs

(deftemplate LEXIQUE::attente
	(slot concept (type SYMBOL) (default ?NONE))
	(multislot expected (type SYMBOL) (default ?DERIVE)) ; (cardinality 1 ?VARIABLE))
	(multislot required (type SYMBOL) (default ?DERIVE))
	(multislot rejected (type SYMBOL) (default ?DERIVE))
	(slot code (allowed-symbols A1 A2 A3 A4 A5 A6 A7 A8 A9) (default ?NONE))
	(slot role (type SYMBOL) (default nil))
	(slot flex (allowed-symbols TRUE FALSE) (default FALSE))
	(slot mult (allowed-symbols TRUE FALSE) (default FALSE))
	(slot tag (allowed-symbols NOM GN GV PROP NOUN NP VP NONE) (default NONE))) ; Doit être cohérent avec granules.dtd

(deftemplate LEXIQUE::contrainte
	(slot concept (type SYMBOL) (default ?NONE))
	(slot test (type STRING) (default ?NONE)))
	
(deftemplate LEXIQUE::syntaxe
	(slot concept (type SYMBOL) (default ?NONE))
	(slot pattern (type STRING) (default ?NONE))
	(multislot traits (type SYMBOL) (default ?NONE))
	(slot ident (type SYMBOL) (default ?NONE))
	; Attributs pour la génération
	(slot gen (allowed-symbols TRUE FALSE) (default FALSE))
	(multislot toA1) ; Modifieurs vers le granule fils A1
	(multislot toA2) ; Modifieurs vers le granule fils A2
	(multislot toA3) ; Modifieurs vers le granule fils A3
	(multislot toA4) ; Etc.
	(multislot toA5)
	(multislot toA6)
	(multislot toA7)
	(multislot toA8)
	(multislot toA9))
		
(deftemplate LEXIQUE::entity
	(slot concept (type SYMBOL) (default ?NONE))
	(slot pattern (type STRING) (default ?NONE))
	(multislot offers (type SYMBOL) (default ?NONE))
	(multislot metadata (type SYMBOL) (default ?NONE))
	(slot gen (allowed-symbols TRUE FALSE) (default ?NONE)))
	
;; -----------------------------------------------------------------------------
;; Quelques fonctions sur les formes d'usage

(deffunction LEXIQUE::est-un-code (?terme)
	(member$ (sym-cat ?terme) (create$ A1 A2 A3 A4 A5 A6 A7 A8 A9)))

(deffunction LEXIQUE::est-un-jocker (?terme)
	(eq "*" ?terme))
				
(deffunction LEXIQUE::est-optionnel (?terme)
	(eq "(" (str-car ?terme)))

(deffunction LEXIQUE::est-lemmatise (?terme)
	(eq "[" (str-car ?terme)))

(deffunction LEXIQUE::supprime-termes-optionnels (?liste)
	(bind ?resultat (create$))
	(progn$ (?terme ?liste)
		(if (est-optionnel ?terme)
			then (bind ?resultat (create$ ?resultat (deparentheser ?terme)))
			else (bind ?resultat (create$ ?resultat ?terme))))
	(return ?resultat))

(deffunction LEXIQUE::contient-terme-optionnel (?pattern)
	(or (eq 1 (str-index "(" (clearFirstSpaces ?pattern)))
	    (str-index " (" ?pattern)))

;; -----------------------------------------------------------------------------
;; Quelques fonctions utilitaires

(deffunction LEXIQUE::correspondance (?attentes ?offres)
	(intersectp ?attentes ?offres)) ; Intersection non vide

(deffunction LEXIQUE::get-prefix (?idconcept) "Pour vérifier les concepts dynamiques (ex: nombre:2)"
	(bind ?pos (str-index : ?idconcept))
	(if (integerp ?pos)
	then (return (sym-cat (sub-string 1 (- ?pos 1) ?idconcept)))
	else (return nil)))

;; -----------------------------------------------------------------------------
;; Module PRECOMP (combinatoire des termes optionnels et sauvegarde)
;; -----------------------------------------------------------------------------

(deftemplate PRECOMP::syntaxe-temp
	(slot ident (type SYMBOL) (default ?NONE))
	(multislot pattern (type STRING) (default ?NONE)))

(defrule PRECOMP::cree-syntaxe-temp
	?syntaxe <- (syntaxe (pattern ?pattern&:(contient-terme-optionnel ?pattern)) (ident ?ident))
	=>
	(assert (syntaxe-temp (pattern (tokenise ?pattern)) (ident ?ident)))
	(assert (__retract ?syntaxe)))

(defrule PRECOMP::derive-syntaxe-temp
	(syntaxe-temp (pattern $?avant ?terme&:(est-optionnel ?terme) $?apres) (ident ?ident))
	(not (syntaxe-temp (pattern $?pattern&:(eq ?pattern (create$ ?avant ?apres))) (ident ?ident)))
	=>
	(assert (syntaxe-temp (pattern (create$ ?avant ?apres)) (ident ?ident))))

(defrule PRECOMP::cree-syntaxe
	(syntaxe-temp (pattern $?pattern) (ident ?ident))
	?syntaxe <- (syntaxe (ident ?ident))
	=>
	(bind ?newident (sym-cat ?ident "-" (gensym*)))
	(bind ?pattern (concatene$ (supprime-termes-optionnels ?pattern)))
	(duplicate ?syntaxe (pattern ?pattern) (ident ?newident))
	(writeLog2 "."))
		
(defrule PRECOMP::supprime-syntaxe
	(declare (salience -999))
	(__retract ?syntaxe)
	=>
	(retract ?syntaxe))

;; -----------------------------------------------------------------------------
;; Pour reformater et sauvegarder le lexique

(deffunction PRECOMP::sauvegarder-lexique (?clpfile ?xmlfile)
	(open ?clpfile TOCLP "w")
	(open ?xmlfile TOXML "w")
	
	(format TOCLP "%n;; =============================================================================")
	(format TOCLP "%n;; Automatically generated lexicon (do not modify this file)")
	(format TOCLP "%n;; =============================================================================")
	
	(format TOXML "%n<!-- ============================================================================= -->")
	(format TOXML "%n<!-- Automatically generated lexicon (do not modify this file)                     -->")
	(format TOXML "%n<!-- ============================================================================= -->")
	
	(format TOXML "%n%n<granules>")
	
;; -----------------------------------------------------------------------------
;; Sauvegarde des concepts

	(do-for-all-facts ((?concept concept)) TRUE
		;; Sauvegarde CLP
		(format TOCLP "%n%n(deffacts LEXIQUE::%s" ?concept:concept)
		(format TOCLP "%n	(concept (concept %s) (offres %s) (offre-expr \"%s\"))"
			?concept:concept (implode$ ?concept:offres) ?concept:offre-expr)
		;; Sauvegarde XML
		(format TOXML "%n	<granule concept=\"%s\" offers=\"%s\" offerexpr=\"%s\">"
			?concept:concept (implode$ ?concept:offres) ?concept:offre-expr)

;; -----------------------------------------------------------------------------
;; Sauvegarde des attentes

		(do-for-all-facts ((?attente attente))
			(eq ?attente:concept ?concept:concept)
			;; Sauvegarde CLP
			(format TOCLP "%n	(attente (concept %s) (code %s) (expected %s) (required %s) (rejected %s) (role %s) (flex %s) (mult %s) (tag %s))"
				?attente:concept ?attente:code (implode$ ?attente:expected) (implode$ ?attente:required) (implode$ ?attente:rejected) ?attente:role ?attente:flex ?attente:mult ?attente:tag)
			;; Sauvegarde XML
			(format TOXML "%n		<dependency id=\"%s\" expected=\"%s\" role=\"%s\" flex=\"%s\" tag=\"%s\"/>"
				?attente:code (implode$ ?attente:expected) ?attente:role ?attente:flex ?attente:tag))

;; -----------------------------------------------------------------------------
;; Sauvegarde des contraintes
		
		(do-for-all-facts ((?contrainte contrainte))
			(eq ?contrainte:concept ?concept:concept)
			;; Sauvegarde CLP
			(format TOCLP "%n	(contrainte (concept %s) (test \"%s\"))" ?contrainte:concept ?contrainte:test)
			;; Sauvegarde XML
			(format TOXML "%n		<constraint test=\"%s\"/>" ?contrainte:test))

;; -----------------------------------------------------------------------------
;; Sauvegarde des syntaxes

		(do-for-all-facts ((?syntaxe syntaxe))
			(eq ?syntaxe:concept ?concept:concept)
			(bind ?ident (sym-cat "s" (genint*)))
			;; Sauvegarde CLP
			(format TOCLP "%n	(syntaxe (concept %s) (ident %s) (pattern \"%s\") (traits %s) (gen %s) (toA1 %s) (toA2 %s) (toA3 %s) (toA4 %s) (toA5 %s) (toA6 %s) (toA7 %s) (toA8 %s) (toA9 %s))"
				?syntaxe:concept ?ident ?syntaxe:pattern (implode$ ?syntaxe:traits) ?syntaxe:gen
				(implode$ ?syntaxe:toA1) (implode$ ?syntaxe:toA2) (implode$ ?syntaxe:toA3) (implode$ ?syntaxe:toA4) (implode$ ?syntaxe:toA5) (implode$ ?syntaxe:toA6) (implode$ ?syntaxe:toA7) (implode$ ?syntaxe:toA8) (implode$ ?syntaxe:toA9))				
			;; Sauvegarde XML
			(format TOXML "%n		<syntax ident=\"%s\" pattern=\"%s\" metadata=\"%s\" gen=\"%s\"/>"
				?ident ?syntaxe:pattern (implode$ ?syntaxe:traits) ?syntaxe:gen))

;; -----------------------------------------------------------------------------
;; Fin de la sauvegarde

		(format TOCLP ")")
		(format TOXML "%n	</granule>"))
	(format TOXML "%n</granules>")
	
	(format TOCLP "%n%n;; =============================================================================")
	(format TOCLP "%n;; Fin du fichier")
	
	(close TOCLP)
	(close TOXML))

;; -----------------------------------------------------------------------------
;; Fin du fichier
