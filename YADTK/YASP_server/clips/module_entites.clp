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

(defmodule NOYAU-ENTITES (import YASP ?ALL))

; TODO = à refaire pour prendre en compte la distance de Levenstein ??

;; -----------------------------------------------------------------------------
;; Identification des entités lexicales
;; -----------------------------------------------------------------------------

(defrule NOYAU-ENTITES::cree-granule-entite-nommee
	(declare (salience 200))
	(input (chaine ?apres))
	(entity (concept ?concept) (pattern ?texte) (offers $?offres) (metadata $?metadata))
	(test (str-index (str-cat " " ?texte " ") (str-cat " " ?apres " ")))
	=>
	(bind ?avant "")
	(bind ?position 0)
	(bind ?couverture (nbmots ?texte))
	(bind ?index (str-index (str-cat " " ?texte " ") (str-cat " " ?apres " ")))
	
	(while ?index
		
		(bind ?index-apres (+ ?index (length$ ?texte) 1))
		(bind ?avant (sub-string 1 (- ?index 2) ?apres))
		(bind ?apres (sub-string ?index-apres (length$ ?apres) ?apres))
		(bind ?position (+ ?position 1 (nbmots ?avant)))
;		(format t "%n[%s] %s [%s] % d" ?avant ?texte ?apres ?position)
		(bind ?ident (sym-cat [ ?concept ]# (genint*)))
		
		(assert (granule
			(ident ?ident)
			(concept ?concept)
			(offres ?offres)
			(texte ?texte)
            (pattern ?texte)
			(pos ?position)
			(fin (+ ?position ?couverture))
			(nbmots ?couverture)
			(metadata ?metadata)
			(score ?couverture)
			(liste-pos (cree-liste ?position (+ ?position ?couverture)))))
			
		(bind ?index (str-index (str-cat " " ?texte " ") (str-cat " " ?apres " ")))))
	
;; -----------------------------------------------------------------------------
;; Fin du fichier
