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

(defrule NOYAU-CARDINAUX::cree-granule-chiffres "Identification des nombres écrits avec des chiffres"
	(declare (salience 500))
	(mot (texte ?texte&:(est-un-nombre ?texte)) (pos ?pos) (fin ?fin))
	=>
	(bind ?concept (sym-cat number: ?texte)) ; Nom du concept => nombre:12 (par exemple)
	(bind ?ident (sym-cat [ ?concept ]# (genint*))) ; Ident du granule => [nombre:12]#53 (par exemple)
	(bind ?traits (if (> (toNumber ?texte) 1) then (create$ morpho:plu) else (create$ morpho:sing)))
	(assert (granule
		(ident ?ident)
		(concept ?concept)
		(offres number quantity)
		(metadata ?traits)
		(texte ?texte)
		(pos ?pos)
		(fin ?fin)
		(liste-pos (create$ ?pos))
		(nbmots 1)
		(score 1.0))))

;; -----------------------------------------------------------------------------
