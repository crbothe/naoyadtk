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
;; Commandes et fonctions de la tâche

(deffunction MAIN::get-current-station () (return le_mans))

(deffunction MAIN::get-current-day () (string-to-field (getSystemDate "%d")))
(deffunction MAIN::get-current-month () (string-to-field (getSystemDate "%m")))
(deffunction MAIN::get-current-time () (getSystemDate "%H heures et %M minutes"))

(deffunction MAIN::date-passee (?jour ?mois)
	(bind ?jour (toNumber ?jour))
	(bind ?mois (toNumber ?mois))
	(bind ?jour-now (get-current-day))
	(bind ?mois-now (get-current-month))
	(or
		(and (= ?mois ?mois-now) (< ?jour ?jour-now))
		(< ?mois ?mois-now)))

(deffunction MAIN::date-error (?jour ?mois)
	(bind ?jour (toNumber ?jour))
	(bind ?mois (toNumber ?mois))
	(or
		(and (= ?mois 1) (> ?jour 31))
		(and (= ?mois 2) (> ?jour 28))
		(and (= ?mois 3) (> ?jour 31))
		(and (= ?mois 4) (> ?jour 30))
		(and (= ?mois 5) (> ?jour 31))
		(and (= ?mois 6) (> ?jour 30))
		(and (= ?mois 7) (> ?jour 31))
		(and (= ?mois 8) (> ?jour 31))
		(and (= ?mois 9) (> ?jour 30))
		(and (= ?mois 10) (> ?jour 31))
		(and (= ?mois 11) (> ?jour 30))
		(and (= ?mois 12) (> ?jour 31))))

(deffunction MAIN::correct-day (?jour ?mois)
	(bind ?jour (toNumber ?jour))
	(bind ?mois (toNumber ?mois))
	(if (and (= ?mois 1) (> ?jour 31)) then (return (str-cat (- ?jour 31))))
	(if (and (= ?mois 2) (> ?jour 28)) then (return (str-cat (- ?jour 28))))
	(if (and (= ?mois 3) (> ?jour 31)) then (return (str-cat (- ?jour 31))))
	(if (and (= ?mois 4) (> ?jour 30)) then (return (str-cat (- ?jour 30))))
	(if (and (= ?mois 5) (> ?jour 31)) then (return (str-cat (- ?jour 31))))
	(if (and (= ?mois 6) (> ?jour 30)) then (return (str-cat (- ?jour 30))))
	(if (and (= ?mois 7) (> ?jour 31)) then (return (str-cat (- ?jour 31))))
	(if (and (= ?mois 8) (> ?jour 31)) then (return (str-cat (- ?jour 31))))
	(if (and (= ?mois 9) (> ?jour 30)) then (return (str-cat (- ?jour 30))))
	(if (and (= ?mois 10) (> ?jour 31)) then (return (str-cat (- ?jour 31))))
	(if (and (= ?mois 11) (> ?jour 30)) then (return (str-cat (- ?jour 30))))
	(if (and (= ?mois 12) (> ?jour 31)) then (return (str-cat (- ?jour 31))))
	(return (str-cat ?jour)))

(deffunction MAIN::correct-month (?jour ?mois)
	(bind ?jour (toNumber ?jour))
	(bind ?mois (toNumber ?mois))
	(if (and (= ?mois 1) (> ?jour 31)) then (return "2"))
	(if (and (= ?mois 2) (> ?jour 28)) then (return "3"))
	(if (and (= ?mois 3) (> ?jour 31)) then (return "4"))
	(if (and (= ?mois 4) (> ?jour 30)) then (return "5"))
	(if (and (= ?mois 5) (> ?jour 31)) then (return "6"))
	(if (and (= ?mois 6) (> ?jour 30)) then (return "7"))
	(if (and (= ?mois 7) (> ?jour 31)) then (return "8"))
	(if (and (= ?mois 8) (> ?jour 31)) then (return "9"))
	(if (and (= ?mois 9) (> ?jour 30)) then (return "10"))
	(if (and (= ?mois 10) (> ?jour 31)) then (return "11"))
	(if (and (= ?mois 11) (> ?jour 30)) then (return "12"))
	(if (and (= ?mois 12) (> ?jour 31)) then (return "1"))
	(return (str-cat ?mois)))

;; -----------------------------------------------------------------------------
;; Fin du fichier
