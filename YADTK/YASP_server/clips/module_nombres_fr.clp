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

(defmodule NOYAU-CARDINAUX (import YASP ?ALL))

;; -----------------------------------------------------------------------------
;; Identification des nombres cardinaux
;; -----------------------------------------------------------------------------

(deftemplate NOYAU-CARDINAUX::nbr "Les faits intermédiaires pour la construction des nombres"
	(slot texte (type STRING) (default ?NONE))
	(slot valeur (type INTEGER) (default ?NONE))
	(slot pos (type INTEGER) (default ?NONE))
	(slot fin (type INTEGER) (default ?NONE)))

(deffunction NOYAU-CARDINAUX::unite (?valeur) (and (> ?valeur 1) (< ?valeur 10)))

(deffunction NOYAU-CARDINAUX::unite1000 (?valeur) (and (> ?valeur 1) (< ?valeur 1000)))

(deffunction NOYAU-CARDINAUX::inf100 (?valeur) (< ?valeur 100))

(deffunction NOYAU-CARDINAUX::inf1000 (?valeur) (< ?valeur 1000))

(deffunction NOYAU-CARDINAUX::dizaine (?valeur)
	(or (= ?valeur 20)
	    (= ?valeur 30)
	    (= ?valeur 40)
	    (= ?valeur 50)
	    (= ?valeur 60)
	    (= ?valeur 80)))

(defrule NOYAU-CARDINAUX::cree-granule "Identification des nombres écrits avec des mots"
	(declare (salience -999))
	?nbr <- (nbr (texte ?texte) (valeur ?valeur) (pos ?pos) (fin ?fin))
	=>
	(retract ?nbr)
	(bind ?concept (sym-cat nombre: ?valeur)) ; Nom du concept => nombre:12 (par exemple)
	(bind ?ident (sym-cat [ ?concept ]# (genint*))) ; Ident du granule => [nombre:12]#53 (par exemple)
	(bind ?traits (if (eq ?texte "un") then (create$ morpho:masc morpho:sing) else
	              (if (eq ?texte "une") then (create$ morpho:fem morpho:sing)
	                                    else (create$ morpho:plu))))
	(assert (granule
		(ident ?ident)
		(concept ?concept)
		(offres nombre quantite)
		(metadata ?traits)
		(texte ?texte)
		(pos ?pos)
		(fin ?fin)
		(liste-pos (cree-liste ?pos ?fin))
		(nbmots (nbmots ?texte))
		(score (nbmots ?texte)))))

(defrule NOYAU-CARDINAUX::cree-granule-chiffres "Identification des nombres écrits avec des chiffres"
	(declare (salience 500))
	(mot (texte ?texte&:(est-un-nombre ?texte)) (pos ?pos) (fin ?fin))
	=>
	(bind ?concept (sym-cat nombre: ?texte)) ; Nom du concept => nombre:12 (par exemple)
	(bind ?ident (sym-cat [ ?concept ]# (genint*))) ; Ident du granule => [nombre:12]#53 (par exemple)
	(bind ?traits (if (> (toNumber ?texte) 1) then (create$ morpho:plu) else (create$ morpho:sing)))
	(assert (granule
		(ident ?ident)
		(concept ?concept)
		(offres nombre quantite)
		(metadata ?traits)
		(texte ?texte)
		(pos ?pos)
		(fin ?fin)
		(liste-pos (create$ ?pos))
		(nbmots 1)
		(score 1.0))))
		
;; -----------------------------------------------------------------------------
;; Reconnaissance des nombres "atomiques"

(deffacts NOYAU-CARDINAUX::nombres
	
	(nombre 0 "zéro")
	(nombre 1 "un")
	(nombre 1 "une")
	(nombre 2 "deux")
	(nombre 3 "trois")
	(nombre 4 "quatre")
	(nombre 5 "cinq")
	(nombre 6 "six")
	(nombre 7 "sept")
	(nombre 8 "huit")
	(nombre 9 "neuf")
	(nombre 10 "dix")
	(nombre 11 "onze")
	(nombre 12 "douze")
	(nombre 13 "treize")
	(nombre 14 "quatorze")
	(nombre 15 "quinze")
	(nombre 16 "seize")
	(nombre 20 "vingt")
	(nombre 30 "trente")
	(nombre 40 "quarante")
	(nombre 50 "cinquante")
	(nombre 60 "soixante")
	(nombre 100 "cent")
	(nombre 100 "cents")
	(nombre 1000 "mille")
	(nombre 1000 "milles"))

(defrule NOYAU-CARDINAUX::nombres "Nombres inférieurs à 100"
	(declare (salience 400))
	(nombre ?valeur ?texte)
	?mot <- (mot (texte ?texte) (pos ?pos) (fin ?fin))
	=>
	(assert (nbr (texte ?texte) (valeur ?valeur) (pos ?pos) (fin ?fin))))
	
;; -----------------------------------------------------------------------------
;; Reconstruction des dizaines

(defrule NOYAU-CARDINAUX::dizaines1 "Nombres inférieurs à 100 comportant un et"
	(declare (salience 300))
	?nbr1 <- (nbr (texte ?txt1) (valeur ?v1&:(dizaine ?v1)) (pos ?pos1) (fin ?fin1))
	(mot (texte "et") (pos ?fin1) (fin ?fin2))
	?nbr3 <- (nbr (texte ?txt3) (valeur 1) (pos ?fin2) (fin ?fin3))
	=>
	(retract ?nbr1 ?nbr3)
	(bind ?texte (concatene$ ?txt1 "et" ?txt3))
	(bind ?valeur (+ ?v1 1))
	(assert (nbr (texte ?texte) (valeur ?valeur) (pos ?pos1) (fin ?fin3))))

(defrule NOYAU-CARDINAUX::dizaines2 "Autres nombres inférieurs à 100"
	(declare (salience 300))
	?nbr1 <- (nbr (texte ?txt1) (valeur ?v1&:(dizaine ?v1)) (pos ?pos1) (fin ?fin1))
	?nbr2 <- (nbr (texte ?txt2) (valeur ?v2&:(unite ?v2)) (pos ?fin1) (fin ?fin2))
	=>
	(retract ?nbr1 ?nbr2)
	(bind ?texte (concatene$ ?txt1 ?txt2))
	(bind ?valeur (+ ?v1 ?v2))
	(assert (nbr (texte ?texte) (valeur ?valeur) (pos ?pos1) (fin ?fin2))))

;; -----------------------------------------------------------------------------
;; Cas particuliers entre 17 et 99

(defrule NOYAU-CARDINAUX::17-19 "Nombres de 17 à 19"
	(declare (salience 300))
	?nbr1 <- (nbr (texte ?txt1) (valeur 10) (pos ?pos1) (fin ?fin1))
	?nbr2 <- (nbr (texte ?txt2) (valeur ?v2&:(>= ?v2 7)&:(<= ?v2 9)) (pos ?fin1) (fin ?fin2))
	=>
	(retract ?nbr1 ?nbr2)
	(bind ?texte (concatene$ ?txt1 ?txt2))
	(bind ?valeur (+ 10 ?v2))
	(assert (nbr (texte ?texte) (valeur ?valeur) (pos ?pos1) (fin ?fin2))))

(defrule NOYAU-CARDINAUX::70-76 "Nombres de 70 à 76"
	(declare (salience 300))
	?nbr1 <- (nbr (texte ?txt1) (valeur 60) (pos ?pos1) (fin ?fin1))
	?nbr2 <- (nbr (texte ?txt2) (valeur ?v2&:(>= ?v2 10)&:(<= ?v2 16)) (pos ?fin1) (fin ?fin2))
	=>
	(retract ?nbr1 ?nbr2)
	(bind ?texte (concatene$ ?txt1 ?txt2))
	(bind ?valeur (+ 60 ?v2))
	(assert (nbr (texte ?texte) (valeur ?valeur) (pos ?pos1) (fin ?fin2))))

(defrule NOYAU-CARDINAUX::71 "Cas particulier de 71"
	(declare (salience 300))
	?nbr1 <- (nbr (valeur 60) (pos ?pos1) (fin ?fin1))
	(mot (texte "et") (pos ?fin1) (fin ?fin2))
	?nbr3 <- (nbr (valeur 11) (pos ?fin2) (fin ?fin3))
	=>
	(retract ?nbr1 ?nbr3)
	(assert (nbr (texte "soixante et onze") (valeur 71) (pos ?pos1) (fin ?fin3))))

(defrule NOYAU-CARDINAUX::77-79 "Nombres de 77 à 79"
	(declare (salience 310))
	?nbr1 <- (nbr (texte ?txt1) (valeur 60) (pos ?pos1) (fin ?fin1))
	?nbr2 <- (nbr (texte ?txt2) (valeur 10) (pos ?fin1) (fin ?fin2))
	?nbr3 <- (nbr (texte ?txt3) (valeur ?v3&:(>= ?v3 7)&:(<= ?v3 9)) (pos ?fin2) (fin ?fin3))
	=>
	(retract ?nbr1 ?nbr2 ?nbr3)
	(bind ?texte (concatene$ ?txt1 ?txt2 ?txt3))
	(bind ?valeur (+ 70 ?v3))
	(assert (nbr (texte ?texte) (valeur ?valeur) (pos ?pos1) (fin ?fin3))))
	
(defrule NOYAU-CARDINAUX::80 "Cas particulier de 80"
	(declare (salience 300))
	?nbr1 <- (nbr (valeur 4) (pos ?pos1) (fin ?fin1))
	?nbr2 <- (nbr (valeur 20) (pos ?fin1) (fin ?fin2))
	=>
	(retract ?nbr1 ?nbr2)
	(assert (nbr (texte "quatre vingt") (valeur 80) (pos ?pos1) (fin ?fin2))))

(defrule NOYAU-CARDINAUX::81-96 "Nombres de 81 à 96"
	(declare (salience 310))
	?nbr1 <- (nbr (texte ?txt1) (valeur 4) (pos ?pos1) (fin ?fin1))
	?nbr2 <- (nbr (texte ?txt2) (valeur 20) (pos ?fin1) (fin ?fin2))
	?nbr3 <- (nbr (texte ?txt3) (valeur ?v3&:(>= ?v3 1)&:(<= ?v3 16)) (pos ?fin2) (fin ?fin3))
	=>
	(retract ?nbr1 ?nbr2 ?nbr3)
	(bind ?texte (concatene$ ?txt1 ?txt2 ?txt3))
	(bind ?valeur (+ 80 ?v3))
	(assert (nbr (texte ?texte) (valeur ?valeur) (pos ?pos1) (fin ?fin3))))

(defrule NOYAU-CARDINAUX::97-99 "Nombres de 97 à 99"
	(declare (salience 320))
	?nbr1 <- (nbr (texte ?txt1) (valeur 4) (pos ?pos1) (fin ?fin1))
	?nbr2 <- (nbr (texte ?txt2) (valeur 20) (pos ?fin1) (fin ?fin2))
	?nbr3 <- (nbr (texte ?txt3) (valeur 10) (pos ?fin2) (fin ?fin3))
	?nbr4 <- (nbr (texte ?txt4) (valeur ?v4&:(>= ?v4 7)&:(<= ?v4 9)) (pos ?fin3) (fin ?fin4))
	=>
	(retract ?nbr1 ?nbr2 ?nbr3 ?nbr4)
	(bind ?texte (concatene$ ?txt1 ?txt2 ?txt3 ?txt4))
	(bind ?valeur (+ 90 ?v4))
	(assert (nbr (texte ?texte) (valeur ?valeur) (pos ?pos1) (fin ?fin4))))
	
;; -----------------------------------------------------------------------------
;; Reconstruction des centaines

(defrule NOYAU-CARDINAUX::centaines1 "Nombres inférieurs à 200"
	(declare (salience 200))
	?nbr1 <- (nbr (texte ?txt1) (valeur 100) (pos ?pos1) (fin ?fin1))
	?nbr2 <- (nbr (texte ?txt2) (valeur ?v2&:(inf100 ?v2)) (pos ?fin1) (fin ?fin2))
	=>
	(retract ?nbr1 ?nbr2)
	(bind ?texte (concatene$ ?txt1 ?txt2))
	(bind ?valeur (+ 100 ?v2))
	(assert (nbr (texte ?texte) (valeur ?valeur) (pos ?pos1) (fin ?fin2))))

(defrule NOYAU-CARDINAUX::centaines2 "Multiples de 100 supérieurs à 200"
	(declare (salience 200))
	?nbr1 <- (nbr (texte ?txt1) (valeur ?v1&:(unite ?v1)) (pos ?pos1) (fin ?fin1))
	?nbr2 <- (nbr (texte ?txt2) (valeur 100) (pos ?fin1) (fin ?fin2))
	=>
	(retract ?nbr1 ?nbr2)
	(bind ?texte (concatene$ ?txt1 ?txt2))
	(bind ?valeur (* ?v1 100))
	(assert (nbr (texte ?texte) (valeur ?valeur) (pos ?pos1) (fin ?fin2))))
	
(defrule NOYAU-CARDINAUX::centaines3 "Autres nombres supérieurs à 200"
	(declare (salience 210))
	?nbr1 <- (nbr (texte ?txt1) (valeur ?v1&:(unite ?v1)) (pos ?pos1) (fin ?fin1))
	?nbr2 <- (nbr (texte ?txt2) (valeur 100) (pos ?fin1) (fin ?fin2))
	?nbr3 <- (nbr (texte ?txt3) (valeur ?v3&:(inf100 ?v3)) (pos ?fin2) (fin ?fin3))
	=>
	(retract ?nbr1 ?nbr2 ?nbr3)
	(bind ?texte (concatene$ ?txt1 ?txt2 ?txt3))
	(bind ?valeur (+ (* ?v1 100) ?v3))
	(assert (nbr (texte ?texte) (valeur ?valeur) (pos ?pos1) (fin ?fin3))))
	
;; -----------------------------------------------------------------------------
;; Reconstruction des milliers

(defrule NOYAU-CARDINAUX::milliers1 "Nombres inférieurs à 2000"
	(declare (salience 100))
	?nbr1 <- (nbr (texte ?txt1) (valeur 1000) (pos ?pos1) (fin ?fin1))
	?nbr2 <- (nbr (texte ?txt2) (valeur ?v2&:(inf1000 ?v2)) (pos ?fin1) (fin ?fin2))
	=>
	(retract ?nbr1 ?nbr2)
	(bind ?texte (concatene$ ?txt1 ?txt2))
	(bind ?valeur (+ 1000 ?v2))
	(assert (nbr (texte ?texte) (valeur ?valeur) (pos ?pos1) (fin ?fin2))))
	
(defrule NOYAU-CARDINAUX::milliers2 "Multiples de 1000 supérieurs à 2000"
	(declare (salience 100))
	?nbr1 <- (nbr (texte ?txt1) (valeur ?v1&:(unite1000 ?v1)) (pos ?pos1) (fin ?fin1))
	?nbr2 <- (nbr (texte ?txt2) (valeur 1000) (pos ?fin1) (fin ?fin2))
	=>
	(retract ?nbr1 ?nbr2)
	(bind ?texte (concatene$ ?txt1 ?txt2))
	(bind ?valeur (* ?v1 1000))
	(assert (nbr (texte ?texte) (valeur ?valeur) (pos ?pos1) (fin ?fin2))))
	
(defrule NOYAU-CARDINAUX::milliers3 "Autres nombres supérieurs à 2000"
	(declare (salience 110))
	?nbr1 <- (nbr (texte ?txt1) (valeur ?v1&:(unite1000 ?v1)) (pos ?pos1) (fin ?fin1))
	?nbr2 <- (nbr (texte ?txt2) (valeur 1000) (pos ?fin1) (fin ?fin2))
	?nbr3 <- (nbr (texte ?txt3) (valeur ?v3&:(inf1000 ?v3)) (pos ?fin2) (fin ?fin3))
	=>
	(retract ?nbr1 ?nbr2 ?nbr3)
	(bind ?texte (concatene$ ?txt1 ?txt2 ?txt3))
	(bind ?valeur (+ (* ?v1 1000) ?v3))
	(assert (nbr (texte ?texte) (valeur ?valeur) (pos ?pos1) (fin ?fin3))))

;; -----------------------------------------------------------------------------
;; Fin du fichier
