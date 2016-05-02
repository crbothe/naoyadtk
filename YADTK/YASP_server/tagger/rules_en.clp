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

; A             Adjective
; Ad            Adverb
; Comp          Complementizer
; Conj          Conjunction
; Conj1         Conjunction1
; Conj2         Conjunction2
; Det           Determiner
; G             Genitive
; I             Interjective
; N             Noun
; N1            Deverbalized_Noun
; NP            Noun_Phrase
; P             Preposition
; P1            Preposition1
; P2            Preposition2
; PL            Verb_Particle
; Punct         Punctuation
; Punct1        Punctuation1
; Punct2        Punctuation2
; V             Verb
; D1            Determiner1
; D2            Determiner2
; P3            Preposition3
; P4            Preposition4

(deffacts BDLEX2::rules
	
	; Règles de renommage
	
	(renommage NUM				donne CHIF)	; chiffre
	(renommage N N1 G FIRSTNAME	donne NOUN)	; nom
	(renommage A				donne ADJ)	; adjectif
	(renommage P				donne PRON)	; pronom
	(renommage Det				donne DET)	; déterminant
	(renommage Conj Conj1 Conj2	donne CONJ)	; conjonction
	(renommage P P1 P2 P3 P4	donne PREP)	; préposition
	(renommage V				donne VERB)	; verbe
	(renommage Ad				donne ADV)	; adverbe
	
	; Règles de composition
	
	(regle CHIF CHIF		donne CHIF)	; dix huit
	(regle NOUN				donne NP)	; chat
	(regle ADJ NOUN			donne NP)	; petit chat
	(regle NOUN ADJ			donne NP)	; chat noir
	(regle ADJ NOUN ADJ		donne NP)	; petit chat noir
	(regle DET NP			donne NP)	; le chat
	(regle CHIF NP			donne NP)	; deux chats
	(regle PRON 	 		donne NP)	; il
	(regle VERB 	 		donne VP)	; mange
	(regle VERB NP 	 		donne VP)	; mange la souris
	(regle PRON VERB 	 	donne VP)	; la mange
	(regle VERB ADJ 	 	donne VP)	; est petit
	(regle PREP NP 			donne PP)	; ?
	(regle NP VP 			donne PROP)

)
