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
;; Fonctions d'ordre sur les mots de l'énoncé

(deffunction MAIN::succ1 (?pos ?fin) (= ?pos ?fin)) ; Succession stricte
(deffunction MAIN::succ2 (?pos ?fin) (or (= ?pos ?fin) (= ?pos (+ ?fin 1)))) ; Une insertion
(deffunction MAIN::succ3 (?pos ?fin) (>= ?pos ?fin)) ; Succession laxiste (génère des bug)
(deffunction MAIN::succ4 (?pos ?fin)
	(bind ?disp (- ?pos ?fin))
	(or (= ?disp 0) (= ?disp 1) (= ?disp 2))) ; Jusqu'à 2 insertions
	
(deffunction MAIN::succ (?pos ?fin) "Contrainte de succession"
 	(and (numberp ?pos)
	     (numberp ?fin) ; Attention : les granules hypothétiques n'ont pas de position
	     (succ2 ?pos ?fin))) ; On peut choisir sa fonction ici

;; -----------------------------------------------------------------------------
; Prédicat de comparaison d'une chaine avec une "expression Yasp"

; Alternative => le/la/les
; Partie optionnelle => chambre(s)
; Terminaison ouverte => climatisé+
; Forme canonique => [demander]

;(deffunction MAIN::score-levenshtein (?mot ?reference)
;	(return (- 100 (* (/ (levenshtein ?mot ?reference) (length ?reference)) 100))))

;(deffunction MAIN::_acceptable (?mot ?reference) "Basé sur la distance de Levenshtein (cf. main_yasp.c)"
;	(or (eq ?mot ?reference)
;	    (and ?*levenshtein*
;		     (> (str-length ?mot) 3)
;	         (> (score-levenshtein ?mot ?reference) 75))))

(deffunction MAIN::_acceptable (?mot ?reference) (eq ?mot ?reference))

(deffunction MAIN::_comp (?mot ?reference ?lemmes) "Partie terminale"
	;(writeLog (format nil "%s %s (%s)" ?mot ?reference (implode$ ?lemmes)))
	(bind ?index1 (str-index "(" ?reference))
	(bind ?index3 (str-index "+" ?reference))
	(bind ?index4 (str-index "[" ?reference))
	
	(if ?index4 then ; Forme canonique
		(bind ?lemme (deparentheser ?reference))
		(return (member$ ?lemme ?lemmes)) else
	
	(if ?index3 then ; Terminaison ouverte
		(bind ?ref (sub-string 1 (- ?index3 1) ?reference))
		(return (str-index ?ref ?mot)) else

	(if ?index1 then ; Partie optionnelle
		(bind ?index2 (str-index ")" ?reference))
		(bind ?deb (sub-string 1 (- ?index1 1) ?reference))
		(bind ?mid (sub-string (+ ?index1 1) (- ?index2 1) ?reference))
		(bind ?fin (sub-string (+ ?index2 1) (length ?reference) ?reference))
		(return (or
			(_acceptable ?mot (str-cat ?deb ?mid ?fin))
			(_acceptable ?mot (str-cat ?deb ?fin))))

	else (return (_acceptable ?mot ?reference))))))

(deffunction MAIN::_comp_rec (?mot ?reference ?lemmes) "Partie récursive"
	(bind ?index (str-index "/" ?reference))
	
	(if ?index then ; Alternative
			
		(bind ?ref (sub-string 1 (- ?index 1) ?reference))
		(bind ?reste (sub-string (+ ?index 1) (length ?reference) ?reference))
		(return (or (_comp ?mot ?ref ?lemmes)
			        (_comp_rec ?mot ?reste ?lemmes)))
	else
		(return (_comp ?mot ?reference ?lemmes))))

(deffunction MAIN::comp (?mot ?reference ?lemmes) "Prédicat de comparaison d'une chaine avec une expression"
	(bind ?mot (lowcase ?mot))
	(bind ?reference (lowcase ?reference))
	(return (_comp_rec ?mot ?reference ?lemmes)))

;; -----------------------------------------------------------------------------
;; Distance de Levenshtein intégrée aux expressions YASP => calcul des scores

;(deffunction MAIN::_leven (?mot ?reference)
;	(bind ?index1 (str-index "(" ?reference))
;	(bind ?index3 (str-index "+" ?reference))
;	(bind ?index4 (str-index "[" ?reference))
;	
;	(if ?index4 then ; Lemmatiseur
;		(return 0) else
;	
;	(if ?index3 then ; Terminaison ouverte
;		(bind ?ref (sub-string 1 (- ?index3 1) ?reference))
;		(if (str-index ?ref ?mot) then (return 0)) else
;	
;	(if ?index1 then ; Partie optionnelle
;		(bind ?index2 (str-index ")" ?reference))
;		(bind ?deb (sub-string 1 (- ?index1 1) ?reference))
;		(bind ?mid (sub-string (+ ?index1 1) (- ?index2 1) ?reference))
;		(bind ?fin (sub-string (+ ?index2 1) (length ?reference) ?reference))
;		(bind ?r1 (levenshtein ?mot (str-cat ?deb ?mid ?fin)))
;		(bind ?r2 (levenshtein ?mot (str-cat ?deb ?fin)))
;		(return (min ?r1 ?r2))
;
;	else (return (levenshtein ?mot ?reference))))))

;; -----------------------------------------------------------------------------
;; Fin du fichier
