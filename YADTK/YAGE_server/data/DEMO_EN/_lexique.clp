
;; =============================================================================
;; Automatically generated lexicon (do not modify this file)
;; =============================================================================

(deffacts LEXIQUE::hello
	(concept (concept hello) (offres politeness hello) (offre-expr ""))
	(syntaxe (concept hello) (ident s57) (pattern "hello") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept hello) (ident s58) (pattern "hi") (traits style:informal) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::please
	(concept (concept please) (offres politeness please) (offre-expr ""))
	(syntaxe (concept please) (ident s59) (pattern "please") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::request
	(concept (concept request) (offres speech-act request) (offre-expr ""))
	(attente (concept request) (code A1) (expected object requestable reference) (required ) (rejected ) (role nil) (flex FALSE) (mult FALSE) (tag NONE))
	(syntaxe (concept request) (ident s60) (pattern "I don' t want") (traits mode:neg) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept request) (ident s61) (pattern "I don' t want A1") (traits mode:neg) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept request) (ident s62) (pattern "can I have/obtain") (traits mode:inter) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept request) (ident s63) (pattern "can I have/obtain A1") (traits mode:inter) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept request) (ident s64) (pattern "I would like") (traits level:2) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept request) (ident s65) (pattern "I would like A1") (traits level:2) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept request) (ident s66) (pattern "I want") (traits level:1) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept request) (ident s67) (pattern "I want A1") (traits level:1) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::ticket
	(concept (concept ticket) (offres object requestable ticket) (offre-expr ""))
	(attente (concept ticket) (code A1) (expected number) (required ) (rejected ) (role quantity) (flex FALSE) (mult FALSE) (tag NONE))
	(attente (concept ticket) (code A2) (expected ticket-property) (required ) (rejected ) (role type) (flex FALSE) (mult FALSE) (tag NONE))
	(attente (concept ticket) (code A3) (expected station) (required ) (rejected ) (role departure) (flex FALSE) (mult FALSE) (tag NONE))
	(attente (concept ticket) (code A4) (expected station) (required ) (rejected ) (role destination) (flex FALSE) (mult FALSE) (tag NONE))
	(syntaxe (concept ticket) (ident s68) (pattern "A1 A3 A4") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s69) (pattern "A1 ticket(s) A3 A4") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s70) (pattern "tickets from A3 to A4") (traits morpho:plu) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s71) (pattern "A2 tickets from A3 to A4") (traits morpho:plu) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s72) (pattern "A1 tickets from A3 to A4") (traits morpho:plu) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s73) (pattern "A1 A2 tickets from A3 to A4") (traits morpho:plu) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s74) (pattern "ticket from A3 to A4") (traits morpho:sing) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s75) (pattern "A2 ticket from A3 to A4") (traits morpho:sing) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s76) (pattern "A1 ticket from A3 to A4") (traits morpho:sing) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s77) (pattern "A1 A2 ticket from A3 to A4") (traits morpho:sing) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s78) (pattern "tickets to A4") (traits morpho:plu) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s79) (pattern "A2 tickets to A4") (traits morpho:plu) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s80) (pattern "A1 tickets to A4") (traits morpho:plu) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s81) (pattern "A1 A2 tickets to A4") (traits morpho:plu) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s82) (pattern "ticket to A4") (traits morpho:sing) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s83) (pattern "A2 ticket to A4") (traits morpho:sing) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s84) (pattern "A1 ticket to A4") (traits morpho:sing) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s85) (pattern "A1 A2 ticket to A4") (traits morpho:sing) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s86) (pattern "tickets") (traits morpho:plu) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s87) (pattern "A2 tickets") (traits morpho:plu) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s88) (pattern "A1 tickets") (traits morpho:plu) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s89) (pattern "A1 A2 tickets") (traits morpho:plu) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s90) (pattern "ticket") (traits morpho:sing) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s91) (pattern "A2 ticket") (traits morpho:sing) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s92) (pattern "A1 ticket") (traits morpho:sing) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept ticket) (ident s93) (pattern "A1 A2 ticket") (traits morpho:sing) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::cheque
	(concept (concept cheque) (offres object requestable cheque) (offre-expr ""))
	(attente (concept cheque) (code A1) (expected number) (required ) (rejected ) (role nil) (flex FALSE) (mult FALSE) (tag NONE))
	(syntaxe (concept cheque) (ident s94) (pattern "cheque") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept cheque) (ident s95) (pattern "A1 cheque") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::roundtrip
	(concept (concept roundtrip) (offres ticket-property roundtrip) (offre-expr ""))
	(syntaxe (concept roundtrip) (ident s96) (pattern "round trip") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::paris
	(concept (concept paris) (offres city station paris) (offre-expr ""))
	(syntaxe (concept paris) (ident s97) (pattern "paris") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept paris) (ident s98) (pattern "panam") (traits style:slangy) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::london
	(concept (concept london) (offres city station london) (offre-expr ""))
	(syntaxe (concept london) (ident s99) (pattern "london") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::le_mans
	(concept (concept le_mans) (offres city station le_mans) (offre-expr ""))
	(syntaxe (concept le_mans) (ident s100) (pattern "le mans") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::number:1
	(concept (concept number:1) (offres number 1) (offre-expr ""))
	(syntaxe (concept number:1) (ident s101) (pattern "a") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept number:1) (ident s102) (pattern "1") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept number:1) (ident s103) (pattern "one") (traits morpho:sing) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::number:2
	(concept (concept number:2) (offres number 2) (offre-expr ""))
	(syntaxe (concept number:2) (ident s104) (pattern "2") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept number:2) (ident s105) (pattern "two") (traits morpho:plu) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::number:5
	(concept (concept number:5) (offres number 5) (offre-expr ""))
	(syntaxe (concept number:5) (ident s106) (pattern "5") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept number:5) (ident s107) (pattern "five") (traits morpho:plu) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::room
	(concept (concept room) (offres requestable room) (offre-expr ""))
	(attente (concept room) (code A1) (expected number) (required ) (rejected ) (role nil) (flex FALSE) (mult FALSE) (tag NONE))
	(attente (concept room) (code A2) (expected room-feature room-constraint time-constraint place-constraint) (required ) (rejected ) (role constraint) (flex FALSE) (mult TRUE) (tag NONE))
	(syntaxe (concept room) (ident s108) (pattern "rooms") (traits morpho:plu) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept room) (ident s109) (pattern "A1 rooms") (traits morpho:plu) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept room) (ident s110) (pattern "room") (traits morpho:sing) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept room) (ident s111) (pattern "A1 room") (traits morpho:sing) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::television
	(concept (concept television) (offres object room-feature television) (offre-expr ""))
	(syntaxe (concept television) (ident s112) (pattern "a/the television") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept television) (ident s113) (pattern "a/the TV") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept television) (ident s114) (pattern "a/the TV set") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::jacuzzi
	(concept (concept jacuzzi) (offres room-feature jacuzzi) (offre-expr ""))
	(syntaxe (concept jacuzzi) (ident s115) (pattern "a/the jacuzzi") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::addition
	(concept (concept addition) (offres addition) (offre-expr "(intersection ?offersA1 ?offersA2)"))
	(attente (concept addition) (code A1) (expected ) (required ) (rejected ) (role nil) (flex FALSE) (mult FALSE) (tag NONE))
	(attente (concept addition) (code A2) (expected ) (required ) (rejected ) (role nil) (flex FALSE) (mult FALSE) (tag NONE))
	(contrainte (concept addition) (test "(intersectp ?offersA1 ?offersA2)"))
	(syntaxe (concept addition) (ident s116) (pattern "A1 and A2") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept addition) (ident s117) (pattern "A1 then A2") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::reference:this
	(concept (concept reference:this) (offres A1 reference this) (offre-expr ""))
	(attente (concept reference:this) (code A1) (expected requestable) (required ) (rejected reference) (role referenced) (flex FALSE) (mult FALSE) (tag NONE))
	(syntaxe (concept reference:this) (ident s118) (pattern "this one") (traits morpho:sing) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept reference:this) (ident s119) (pattern "this A1") (traits morpho:sing) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept reference:this) (ident s120) (pattern "these A1") (traits morpho:plu) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::reference:other
	(concept (concept reference:other) (offres A1 reference other) (offre-expr ""))
	(attente (concept reference:other) (code A1) (expected requestable) (required ) (rejected reference) (role referenced) (flex FALSE) (mult FALSE) (tag NONE))
	(syntaxe (concept reference:other) (ident s121) (pattern "the other one") (traits morpho:definite morpho:sing) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept reference:other) (ident s122) (pattern "the other A1") (traits morpho:definite morpho:sing) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept reference:other) (ident s123) (pattern "another A1") (traits morpho:indefinite morpho:sing) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept reference:other) (ident s124) (pattern "something else") (traits morpho:indefinite morpho:sing) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::color
	(concept (concept color) (offres property color) (offre-expr ""))
	(syntaxe (concept color) (ident s125) (pattern "color") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::table
	(concept (concept table) (offres object table) (offre-expr ""))
	(syntaxe (concept table) (ident s126) (pattern "table") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept table) (ident s127) (pattern "the table") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::attribution
	(concept (concept attribution) (offres attribution) (offre-expr ""))
	(attente (concept attribution) (code A1) (expected property) (required ) (rejected ) (role property) (flex FALSE) (mult FALSE) (tag NONE))
	(attente (concept attribution) (code A2) (expected object) (required ) (rejected ) (role object) (flex FALSE) (mult FALSE) (tag NP))
	(syntaxe (concept attribution) (ident s128) (pattern "the A1 of A2") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::definition
	(concept (concept definition) (offres definition) (offre-expr ""))
	(attente (concept definition) (code A1) (expected attribution) (required ) (rejected ) (role object) (flex FALSE) (mult FALSE) (tag NONE))
	(attente (concept definition) (code A2) (expected definition) (required ) (rejected ) (role definition) (flex FALSE) (mult FALSE) (tag NP))
	(syntaxe (concept definition) (ident s129) (pattern "A1 is A2") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept definition) (ident s130) (pattern "is A1 A2") (traits mode:inter) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::city:avignon
	(concept (concept city:avignon) (offres place-constraint city avignon) (offre-expr ""))
	(syntaxe (concept city:avignon) (ident s131) (pattern "avignon") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::city:marseille
	(concept (concept city:marseille) (offres place-constraint city marseille) (offre-expr ""))
	(syntaxe (concept city:marseille) (ident s132) (pattern "marseille") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::date
	(concept (concept date) (offres time-constraint date) (offre-expr ""))
	(attente (concept date) (code A1) (expected day) (required ) (rejected ) (role nil) (flex FALSE) (mult FALSE) (tag NONE))
	(attente (concept date) (code A2) (expected ordinal) (required ) (rejected ) (role nil) (flex FALSE) (mult FALSE) (tag NONE))
	(attente (concept date) (code A3) (expected month) (required ) (rejected ) (role nil) (flex FALSE) (mult FALSE) (tag NONE))
	(attente (concept date) (code A4) (expected year) (required ) (rejected ) (role nil) (flex FALSE) (mult FALSE) (tag NONE))
	(syntaxe (concept date) (ident s133) (pattern "A1") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept date) (ident s134) (pattern "A2") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept date) (ident s135) (pattern "A2 A3") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept date) (ident s136) (pattern "the A2 of A3 A4") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept date) (ident s137) (pattern "A1 the A2 of A3 A4") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept date) (ident s138) (pattern "the A2 of A3") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept date) (ident s139) (pattern "A1 the A2 of A3") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept date) (ident s140) (pattern "the A2") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept date) (ident s141) (pattern "A1 the A2") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::time-place
	(concept (concept time-place) (offres time-constraint place-constraint time-place) (offre-expr ""))
	(attente (concept time-place) (code A1) (expected time-constraint) (required ) (rejected time-place addition) (role time) (flex FALSE) (mult FALSE) (tag NONE))
	(attente (concept time-place) (code A2) (expected place-constraint) (required ) (rejected time-place addition) (role place) (flex FALSE) (mult FALSE) (tag NONE))
	(syntaxe (concept time-place) (ident s142) (pattern "A1 in A2") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::time-unit:night
	(concept (concept time-unit:night) (offres time-unit night) (offre-expr ""))
	(syntaxe (concept time-unit:night) (ident s143) (pattern "night") (traits morpho:sing) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept time-unit:night) (ident s144) (pattern "nights") (traits morpho:plu) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::date-period
	(concept (concept date-period) (offres time-constraint date-period) (offre-expr ""))
	(attente (concept date-period) (code A1) (expected date) (required ) (rejected ) (role start) (flex FALSE) (mult FALSE) (tag NONE))
	(attente (concept date-period) (code A2) (expected date) (required ) (rejected ) (role end) (flex FALSE) (mult FALSE) (tag NONE))
	(syntaxe (concept date-period) (ident s145) (pattern "from A1 to A2") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::duration:following
	(concept (concept duration:following) (offres time-constraint duration following) (offre-expr ""))
	(attente (concept duration:following) (code A1) (expected number) (required ) (rejected ) (role nil) (flex FALSE) (mult FALSE) (tag NONE))
	(attente (concept duration:following) (code A2) (expected time-unit) (required ) (rejected ) (role nil) (flex FALSE) (mult FALSE) (tag NONE))
	(syntaxe (concept duration:following) (ident s146) (pattern "the next A1 A2") (traits ) (gen TRUE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::person-number
	(concept (concept person-number) (offres room-constraint person-number) (offre-expr ""))
	(attente (concept person-number) (code A1) (expected number) (required ) (rejected ) (role nil) (flex FALSE) (mult FALSE) (tag NONE))
	(syntaxe (concept person-number) (ident s147) (pattern "A1 person(s)/people") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept person-number) (ident s148) (pattern "for A1 person(s)/people") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::couple-number
	(concept (concept couple-number) (offres room-constraint couple-number) (offre-expr ""))
	(attente (concept couple-number) (code A1) (expected number) (required ) (rejected ) (role nil) (flex FALSE) (mult FALSE) (tag NONE))
	(syntaxe (concept couple-number) (ident s149) (pattern "A1 couple(s)") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept couple-number) (ident s150) (pattern "for A1 couple(s)") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

(deffacts LEXIQUE::children-number
	(concept (concept children-number) (offres room-constraint children-number) (offre-expr ""))
	(attente (concept children-number) (code A1) (expected number) (required ) (rejected ) (role nil) (flex FALSE) (mult FALSE) (tag NONE))
	(syntaxe (concept children-number) (ident s151) (pattern "A1 child+") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 ))
	(syntaxe (concept children-number) (ident s152) (pattern "for A1 child+") (traits ) (gen FALSE) (toA1 ) (toA2 ) (toA3 ) (toA4 ) (toA5 ) (toA6 ) (toA7 ) (toA8 ) (toA9 )))

;; =============================================================================
;; Fin du fichier