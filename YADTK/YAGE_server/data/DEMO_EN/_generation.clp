;; =============================================================================
;; Automatically generated generation rules (do not modify this file)
;; =============================================================================

(defrule YAGE::genere-granule-ticket-s70 "tickets from A3 to A4"
	(declare (salience 480))
	(syntaxe (ident s70) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A3 <- (generation (ident ?idA3) (code A3) (idpere ?idgranule) (texte $?txtA3) (traits $?fromA3) (dependances $?depA3) (score ?scoreA3))
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA3 (calcule-score ?fromA3 ?tprop) (calcule-score ?fromA3 ?toA3)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?dependances (create$  ?idA3 ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "tickets" "from" ?txtA3 "to" ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A3 ?f-A4) (regle ticket-s70) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s71 "A2 tickets from A3 to A4"
	(declare (salience 470))
	(syntaxe (ident s71) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	?f-A3 <- (generation (ident ?idA3) (code A3) (idpere ?idgranule) (texte $?txtA3) (traits $?fromA3) (dependances $?depA3) (score ?scoreA3))
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?score (+ ?score ?scoreA3 (calcule-score ?fromA3 ?tprop) (calcule-score ?fromA3 ?toA3)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?dependances (create$  ?idA2 ?idA3 ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA2 "tickets" "from" ?txtA3 "to" ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A2 ?f-A3 ?f-A4) (regle ticket-s71) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s72 "A1 tickets from A3 to A4"
	(declare (salience 470))
	(syntaxe (ident s72) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A3 <- (generation (ident ?idA3) (code A3) (idpere ?idgranule) (texte $?txtA3) (traits $?fromA3) (dependances $?depA3) (score ?scoreA3))
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA3 (calcule-score ?fromA3 ?tprop) (calcule-score ?fromA3 ?toA3)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?dependances (create$  ?idA1 ?idA3 ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 "tickets" "from" ?txtA3 "to" ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A3 ?f-A4) (regle ticket-s72) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s73 "A1 A2 tickets from A3 to A4"
	(declare (salience 460))
	(syntaxe (ident s73) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	?f-A3 <- (generation (ident ?idA3) (code A3) (idpere ?idgranule) (texte $?txtA3) (traits $?fromA3) (dependances $?depA3) (score ?scoreA3))
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?score (+ ?score ?scoreA3 (calcule-score ?fromA3 ?tprop) (calcule-score ?fromA3 ?toA3)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?score (+ ?score (calcule-score ?fromA1 ?fromA2)))
	(bind ?dependances (create$  ?idA1 ?idA2 ?idA3 ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 ?txtA2 "tickets" "from" ?txtA3 "to" ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A2 ?f-A3 ?f-A4) (regle ticket-s73) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s74 "ticket from A3 to A4"
	(declare (salience 480))
	(syntaxe (ident s74) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A3 <- (generation (ident ?idA3) (code A3) (idpere ?idgranule) (texte $?txtA3) (traits $?fromA3) (dependances $?depA3) (score ?scoreA3))
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA3 (calcule-score ?fromA3 ?tprop) (calcule-score ?fromA3 ?toA3)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?dependances (create$  ?idA3 ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "ticket" "from" ?txtA3 "to" ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A3 ?f-A4) (regle ticket-s74) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s75 "A2 ticket from A3 to A4"
	(declare (salience 470))
	(syntaxe (ident s75) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	?f-A3 <- (generation (ident ?idA3) (code A3) (idpere ?idgranule) (texte $?txtA3) (traits $?fromA3) (dependances $?depA3) (score ?scoreA3))
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?score (+ ?score ?scoreA3 (calcule-score ?fromA3 ?tprop) (calcule-score ?fromA3 ?toA3)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?dependances (create$  ?idA2 ?idA3 ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA2 "ticket" "from" ?txtA3 "to" ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A2 ?f-A3 ?f-A4) (regle ticket-s75) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s76 "A1 ticket from A3 to A4"
	(declare (salience 470))
	(syntaxe (ident s76) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A3 <- (generation (ident ?idA3) (code A3) (idpere ?idgranule) (texte $?txtA3) (traits $?fromA3) (dependances $?depA3) (score ?scoreA3))
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA3 (calcule-score ?fromA3 ?tprop) (calcule-score ?fromA3 ?toA3)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?dependances (create$  ?idA1 ?idA3 ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 "ticket" "from" ?txtA3 "to" ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A3 ?f-A4) (regle ticket-s76) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s77 "A1 A2 ticket from A3 to A4"
	(declare (salience 460))
	(syntaxe (ident s77) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	?f-A3 <- (generation (ident ?idA3) (code A3) (idpere ?idgranule) (texte $?txtA3) (traits $?fromA3) (dependances $?depA3) (score ?scoreA3))
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?score (+ ?score ?scoreA3 (calcule-score ?fromA3 ?tprop) (calcule-score ?fromA3 ?toA3)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?score (+ ?score (calcule-score ?fromA1 ?fromA2)))
	(bind ?dependances (create$  ?idA1 ?idA2 ?idA3 ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 ?txtA2 "ticket" "from" ?txtA3 "to" ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A2 ?f-A3 ?f-A4) (regle ticket-s77) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s78 "tickets to A4"
	(declare (salience 490))
	(syntaxe (ident s78) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?dependances (create$  ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "tickets" "to" ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A4) (regle ticket-s78) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s79 "A2 tickets to A4"
	(declare (salience 480))
	(syntaxe (ident s79) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?dependances (create$  ?idA2 ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA2 "tickets" "to" ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A2 ?f-A4) (regle ticket-s79) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s80 "A1 tickets to A4"
	(declare (salience 480))
	(syntaxe (ident s80) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?dependances (create$  ?idA1 ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 "tickets" "to" ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A4) (regle ticket-s80) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s81 "A1 A2 tickets to A4"
	(declare (salience 470))
	(syntaxe (ident s81) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?score (+ ?score (calcule-score ?fromA1 ?fromA2)))
	(bind ?dependances (create$  ?idA1 ?idA2 ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 ?txtA2 "tickets" "to" ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A2 ?f-A4) (regle ticket-s81) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s82 "ticket to A4"
	(declare (salience 490))
	(syntaxe (ident s82) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?dependances (create$  ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "ticket" "to" ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A4) (regle ticket-s82) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s83 "A2 ticket to A4"
	(declare (salience 480))
	(syntaxe (ident s83) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?dependances (create$  ?idA2 ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA2 "ticket" "to" ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A2 ?f-A4) (regle ticket-s83) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s84 "A1 ticket to A4"
	(declare (salience 480))
	(syntaxe (ident s84) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?dependances (create$  ?idA1 ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 "ticket" "to" ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A4) (regle ticket-s84) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s85 "A1 A2 ticket to A4"
	(declare (salience 470))
	(syntaxe (ident s85) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?score (+ ?score (calcule-score ?fromA1 ?fromA2)))
	(bind ?dependances (create$  ?idA1 ?idA2 ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 ?txtA2 "ticket" "to" ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A2 ?f-A4) (regle ticket-s85) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s86 "tickets"
	(declare (salience 500))
	(syntaxe (ident s86) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?dependances (create$ ))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "tickets") (traits ?tprop) (score ?score) (fils ) (regle ticket-s86) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s87 "A2 tickets"
	(declare (salience 490))
	(syntaxe (ident s87) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?dependances (create$  ?idA2))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA2 "tickets") (traits ?tprop) (score ?score) (fils  ?f-A2) (regle ticket-s87) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s88 "A1 tickets"
	(declare (salience 490))
	(syntaxe (ident s88) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?dependances (create$  ?idA1))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 "tickets") (traits ?tprop) (score ?score) (fils  ?f-A1) (regle ticket-s88) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s89 "A1 A2 tickets"
	(declare (salience 480))
	(syntaxe (ident s89) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?score (+ ?score (calcule-score ?fromA1 ?fromA2)))
	(bind ?dependances (create$  ?idA1 ?idA2))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 ?txtA2 "tickets") (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A2) (regle ticket-s89) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s90 "ticket"
	(declare (salience 500))
	(syntaxe (ident s90) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?dependances (create$ ))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "ticket") (traits ?tprop) (score ?score) (fils ) (regle ticket-s90) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s91 "A2 ticket"
	(declare (salience 490))
	(syntaxe (ident s91) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?dependances (create$  ?idA2))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA2 "ticket") (traits ?tprop) (score ?score) (fils  ?f-A2) (regle ticket-s91) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s92 "A1 ticket"
	(declare (salience 490))
	(syntaxe (ident s92) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?dependances (create$  ?idA1))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 "ticket") (traits ?tprop) (score ?score) (fils  ?f-A1) (regle ticket-s92) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-ticket-s93 "A1 A2 ticket"
	(declare (salience 480))
	(syntaxe (ident s93) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept ticket) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?score (+ ?score (calcule-score ?fromA1 ?fromA2)))
	(bind ?dependances (create$  ?idA1 ?idA2))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 ?txtA2 "ticket") (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A2) (regle ticket-s93) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-roundtrip-s96 "round trip"
	(declare (salience 500))
	(syntaxe (ident s96) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept roundtrip) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?dependances (create$ ))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "round" "trip") (traits ?tprop) (score ?score) (fils ) (regle roundtrip-s96) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-paris-s97 "paris"
	(declare (salience 500))
	(syntaxe (ident s97) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept paris) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?dependances (create$ ))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "paris") (traits ?tprop) (score ?score) (fils ) (regle paris-s97) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-paris-s98 "panam"
	(declare (salience 500))
	(syntaxe (ident s98) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept paris) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?dependances (create$ ))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "panam") (traits ?tprop) (score ?score) (fils ) (regle paris-s98) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-london-s99 "london"
	(declare (salience 500))
	(syntaxe (ident s99) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept london) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?dependances (create$ ))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "london") (traits ?tprop) (score ?score) (fils ) (regle london-s99) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-le_mans-s100 "le mans"
	(declare (salience 500))
	(syntaxe (ident s100) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept le_mans) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?dependances (create$ ))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "le" "mans") (traits ?tprop) (score ?score) (fils ) (regle le_mans-s100) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-number:1-s103 "one"
	(declare (salience 500))
	(syntaxe (ident s103) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept number:1) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?dependances (create$ ))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "one") (traits ?tprop) (score ?score) (fils ) (regle number:1-s103) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-number:2-s105 "two"
	(declare (salience 500))
	(syntaxe (ident s105) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept number:2) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?dependances (create$ ))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "two") (traits ?tprop) (score ?score) (fils ) (regle number:2-s105) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-number:5-s107 "five"
	(declare (salience 500))
	(syntaxe (ident s107) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept number:5) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?dependances (create$ ))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "five") (traits ?tprop) (score ?score) (fils ) (regle number:5-s107) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-addition-s116 "A1 and A2"
	(declare (salience 480))
	(syntaxe (ident s116) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept addition) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?dependances (create$  ?idA1 ?idA2))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 "and" ?txtA2) (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A2) (regle addition-s116) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-city:avignon-s131 "avignon"
	(declare (salience 500))
	(syntaxe (ident s131) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept city:avignon) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?dependances (create$ ))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "avignon") (traits ?tprop) (score ?score) (fils ) (regle city:avignon-s131) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-city:marseille-s132 "marseille"
	(declare (salience 500))
	(syntaxe (ident s132) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept city:marseille) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?dependances (create$ ))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "marseille") (traits ?tprop) (score ?score) (fils ) (regle city:marseille-s132) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-date-s133 "A1"
	(declare (salience 490))
	(syntaxe (ident s133) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept date) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?dependances (create$  ?idA1))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1) (traits ?tprop) (score ?score) (fils  ?f-A1) (regle date-s133) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-date-s134 "A2"
	(declare (salience 490))
	(syntaxe (ident s134) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept date) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?dependances (create$  ?idA2))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA2) (traits ?tprop) (score ?score) (fils  ?f-A2) (regle date-s134) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-date-s135 "A2 A3"
	(declare (salience 480))
	(syntaxe (ident s135) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept date) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	?f-A3 <- (generation (ident ?idA3) (code A3) (idpere ?idgranule) (texte $?txtA3) (traits $?fromA3) (dependances $?depA3) (score ?scoreA3))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?score (+ ?score ?scoreA3 (calcule-score ?fromA3 ?tprop) (calcule-score ?fromA3 ?toA3)))
	(bind ?score (+ ?score (calcule-score ?fromA2 ?fromA3)))
	(bind ?dependances (create$  ?idA2 ?idA3))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA2 ?txtA3) (traits ?tprop) (score ?score) (fils  ?f-A2 ?f-A3) (regle date-s135) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-date-s136 "the A2 of A3 A4"
	(declare (salience 470))
	(syntaxe (ident s136) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept date) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	?f-A3 <- (generation (ident ?idA3) (code A3) (idpere ?idgranule) (texte $?txtA3) (traits $?fromA3) (dependances $?depA3) (score ?scoreA3))
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?score (+ ?score ?scoreA3 (calcule-score ?fromA3 ?tprop) (calcule-score ?fromA3 ?toA3)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?score (+ ?score (calcule-score ?fromA3 ?fromA4)))
	(bind ?dependances (create$  ?idA2 ?idA3 ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "the" ?txtA2 "of" ?txtA3 ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A2 ?f-A3 ?f-A4) (regle date-s136) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-date-s137 "A1 the A2 of A3 A4"
	(declare (salience 460))
	(syntaxe (ident s137) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept date) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	?f-A3 <- (generation (ident ?idA3) (code A3) (idpere ?idgranule) (texte $?txtA3) (traits $?fromA3) (dependances $?depA3) (score ?scoreA3))
	?f-A4 <- (generation (ident ?idA4) (code A4) (idpere ?idgranule) (texte $?txtA4) (traits $?fromA4) (dependances $?depA4) (score ?scoreA4))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?score (+ ?score ?scoreA3 (calcule-score ?fromA3 ?tprop) (calcule-score ?fromA3 ?toA3)))
	(bind ?score (+ ?score ?scoreA4 (calcule-score ?fromA4 ?tprop) (calcule-score ?fromA4 ?toA4)))
	(bind ?score (+ ?score (calcule-score ?fromA3 ?fromA4)))
	(bind ?dependances (create$  ?idA1 ?idA2 ?idA3 ?idA4))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 "the" ?txtA2 "of" ?txtA3 ?txtA4) (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A2 ?f-A3 ?f-A4) (regle date-s137) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-date-s138 "the A2 of A3"
	(declare (salience 480))
	(syntaxe (ident s138) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept date) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	?f-A3 <- (generation (ident ?idA3) (code A3) (idpere ?idgranule) (texte $?txtA3) (traits $?fromA3) (dependances $?depA3) (score ?scoreA3))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?score (+ ?score ?scoreA3 (calcule-score ?fromA3 ?tprop) (calcule-score ?fromA3 ?toA3)))
	(bind ?dependances (create$  ?idA2 ?idA3))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "the" ?txtA2 "of" ?txtA3) (traits ?tprop) (score ?score) (fils  ?f-A2 ?f-A3) (regle date-s138) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-date-s139 "A1 the A2 of A3"
	(declare (salience 470))
	(syntaxe (ident s139) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept date) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	?f-A3 <- (generation (ident ?idA3) (code A3) (idpere ?idgranule) (texte $?txtA3) (traits $?fromA3) (dependances $?depA3) (score ?scoreA3))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?score (+ ?score ?scoreA3 (calcule-score ?fromA3 ?tprop) (calcule-score ?fromA3 ?toA3)))
	(bind ?dependances (create$  ?idA1 ?idA2 ?idA3))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 "the" ?txtA2 "of" ?txtA3) (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A2 ?f-A3) (regle date-s139) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-date-s140 "the A2"
	(declare (salience 490))
	(syntaxe (ident s140) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept date) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?dependances (create$  ?idA2))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "the" ?txtA2) (traits ?tprop) (score ?score) (fils  ?f-A2) (regle date-s140) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-date-s141 "A1 the A2"
	(declare (salience 480))
	(syntaxe (ident s141) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept date) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?dependances (create$  ?idA1 ?idA2))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 "the" ?txtA2) (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A2) (regle date-s141) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-time-place-s142 "A1 in A2"
	(declare (salience 480))
	(syntaxe (ident s142) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept time-place) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?dependances (create$  ?idA1 ?idA2))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  ?txtA1 "in" ?txtA2) (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A2) (regle time-place-s142) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-time-unit:night-s143 "night"
	(declare (salience 500))
	(syntaxe (ident s143) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept time-unit:night) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?dependances (create$ ))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "night") (traits ?tprop) (score ?score) (fils ) (regle time-unit:night-s143) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-time-unit:night-s144 "nights"
	(declare (salience 500))
	(syntaxe (ident s144) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept time-unit:night) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?dependances (create$ ))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "nights") (traits ?tprop) (score ?score) (fils ) (regle time-unit:night-s144) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-date-period-s145 "from A1 to A2"
	(declare (salience 480))
	(syntaxe (ident s145) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept date-period) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?dependances (create$  ?idA1 ?idA2))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "from" ?txtA1 "to" ?txtA2) (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A2) (regle date-period-s145) (dependances ?dependances) (prof ?prof)))
)

(defrule YAGE::genere-granule-duration:following-s146 "the next A1 A2"
	(declare (salience 480))
	(syntaxe (ident s146) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))
	(granule (idconcept duration:following) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))
	(_profondeur ?prof)
	?f-A1 <- (generation (ident ?idA1) (code A1) (idpere ?idgranule) (texte $?txtA1) (traits $?fromA1) (dependances $?depA1) (score ?scoreA1))
	?f-A2 <- (generation (ident ?idA2) (code A2) (idpere ?idgranule) (texte $?txtA2) (traits $?fromA2) (dependances $?depA2) (score ?scoreA2))
	=>
	(bind ?ident (sym-cat GEN# (genint*)))
	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))
	(bind ?score (+ ?score ?scoreA1 (calcule-score ?fromA1 ?tprop) (calcule-score ?fromA1 ?toA1)))
	(bind ?score (+ ?score ?scoreA2 (calcule-score ?fromA2 ?tprop) (calcule-score ?fromA2 ?toA2)))
	(bind ?score (+ ?score (calcule-score ?fromA1 ?fromA2)))
	(bind ?dependances (create$  ?idA1 ?idA2))
	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte  "the" "next" ?txtA1 ?txtA2) (traits ?tprop) (score ?score) (fils  ?f-A1 ?f-A2) (regle duration:following-s146) (dependances ?dependances) (prof ?prof)))
)

;; =============================================================================
;; End of file
