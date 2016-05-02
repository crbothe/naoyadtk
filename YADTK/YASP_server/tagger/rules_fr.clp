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

; NC		nom commun
; NP		nom propre
; V			verbe conjugué
; VINF		verbe à l'infinitif
; AUXAVOIR	auxiliaire avoir
; AUXETRE	auxiliaire être
; DET		déterminant
; NUM		nombre
; ADJ		adjectif
; ADV		adverbe
; PRO		pronom
; PRI		pronom interrogatifs
; PROREL	pronom relatif
; PREP		préposition
; CONJ		conjonction de coordination
; PRES		?

(deffacts BDLEX2::rules
	
	; Règles de renommage
	
	(renommage NUM				donne CHIF)	; chiffre
	(renommage NC NP			donne NOM)	; nom
	(renommage ADJ				donne ADJ)	; adjectif
	(renommage PRO PRI PROREL	donne PRON)	; pronom
	(renommage DET				donne DET)	; déterminant
	(renommage CONJ				donne CONJ)	; conjonction
	(renommage PREP				donne PREP)	; préposition
	(renommage V VINF			donne VERB)	; verbe
	(renommage AUXAVOIR AUXETRE	donne VERB)	; verbe
	(renommage ADV				donne ADV)	; adverbe
	
	; Règles de composition (idem BDLex)
	
	(regle CHIF CHIF		donne CHIF)	; dix huit
	(regle NOM CHIF		    donne NOM)	; henry quatre
	(regle NOM				donne GN)	; chat
	(regle ADJ NOM			donne GN)	; petit chat
	(regle NOM ADJ			donne GN)	; chat noir
	(regle ADJ NOM ADJ		donne GN)	; petit chat noir
	(regle DET GN			donne GN)	; le chat
	(regle CHIF GN			donne GN)	; deux chats
	(regle PRON 	 		donne GN)	; il
	(regle VERB VERB 	 	donne VERB)	; a mangé
	(regle VERB GN 	 		donne GV)	; a mangé la souris
	(regle PRON VERB 	 	donne GV)	; la mange
	(regle VERB ADJ 	 	donne GV)	; est petit
	(regle PREP GN 			donne GP)	; de la france
	(regle GN GP 			donne GN)	; la capitale de la france	
	(regle GN GV 			donne PROP)
)
