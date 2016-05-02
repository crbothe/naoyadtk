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
;; Suppression définitive d'un granule et de sa descendance

(deffunction YADE::disconnect-granule (?ident) "Détache un granule de sa structure"
	(do-for-fact ((?granule granule)) (eq ?granule:ident ?ident)
		(do-for-fact ((?liaison liaison)) (eq ?liaison:idfils ?ident)
			(bind ?idpere ?liaison:idpere) ; Identifier le père
			(retract ?liaison) ; Suppression définitive de la liaison
			(modify ?granule (racine TRUE))
			; Pour la trace
			(writeLog (format nil "    Unlinking granule %s from %s" ?ident ?idpere))
			(return ?idpere))))

;; -----------------------------------------------------------------------------
;; Suppression définitive d'un granule et de sa descendance

(deffunction YADE::delete-granule (?ident) "Suppression récursive d'une structure de granules"
	(retract-granule ?ident) ; Suppression définitive du granule
	(writeLog (format nil "<== Deleting granule %s" ?ident))
	; Supprimer les granules fils
	(do-for-all-facts ((?liaison liaison)) (eq ?liaison:idpere ?ident) ; Retrouver une liaison
		(retract ?liaison) ; Supprimer la liaison
		(delete-granule ?liaison:idfils))) ; Appel récursif

;; -----------------------------------------------------------------------------
;; Remplacement d'un granule ou d'une structure de granules

(deffunction YADE::remplace-granule (?idold ?idnew) "Remplace un granule par un autre dans une structure"
	(disconnect-granule ?idnew) ; Ne fonctionne pas si on le place juste avant le (modify ?new ... )
	(do-for-fact ((?old granule)) (eq ?old:ident ?idold)
		(do-for-fact ((?new granule)) (eq ?new:ident ?idnew)
			(modify ?new (racine ?old:racine))
			(delete-granule ?idold) ; Suppression récursive de l'ancien granule
			(do-for-fact ((?liaison liaison)) (eq ?liaison:idfils ?idold) ; Nouveau rattachement potentiel
				(modify ?liaison (idfils ?idnew))
				(writeLog (format nil "    Replacing granule %s with %s role=%s" ?idold ?idnew ?liaison:role)))
			(writeLog (format nil "    Replacing granule %s with %s" ?idold ?idnew)))))

;; -----------------------------------------------------------------------------
;; Modification du concept d'un granule => attention slot ident modifié !

(deffunction YADE::change-granule (?ident ?newconcept) "Modifie le concept d'un granule feuille"
	(if (nonvide$ (get-fils ?ident)) then
		(writeError (format nil "ERROR in change-granule: Trying to change the value of the non-terminal granule %s" ?ident))
		(halt))
	(do-for-fact ((?granule granule))
		(eq ?granule:ident ?ident)
		(bind ?number (getNumber ?ident))
		(bind ?newident (sym-cat [ ?newconcept ]# ?number))
		(modify ?granule (ident ?newident) (concept ?newconcept) (lconcept (decode-concept ?newconcept)))
		(writeLog (format nil "    Modifying granule %s value => %s" ?granule:ident ?newident))
		(do-for-fact ((?liaison liaison))
			(eq ?liaison:idfils ?ident)
			(modify ?liaison (idfils ?newident)))))

;; -----------------------------------------------------------------------------
;; Clonage d'un granule ou d'une structure de granules

(deffunction YADE::clone-granule (?ident) "Clone une structure de granule"
	(do-for-fact ((?granule granule))
		(eq ?granule:ident ?ident)
		(bind ?newident (sym-cat [ ?granule:concept ]# (genint*)))
		(duplicate ?granule (ident ?newident) (inferred TRUE))
		(writeLog (format nil "==> Cloning granule %s = %s" ?ident ?newident))
		(do-for-all-facts ((?liaison liaison)) (eq ?liaison:idpere ?ident)
			(bind ?idfils (clone-granule ?liaison:idfils))
			(duplicate ?liaison (idpere ?newident) (idfils ?idfils)))
		(return ?newident)))

;; -----------------------------------------------------------------------------
;; Obsolescence récursive d'une structure de granules => faits (used ... )

(deffunction YADE::__forget-granule (?ident)
	(assert (used (ident ?ident)))
	(progn$ (?fils (get-fils ?ident))
			(__forget-granule ?fils)))

(deffunction YADE::forget-granule (?ident) "Obsolescence récursive d'une structure de granules"
;	(bind ?idpere (disconnect-granule ?ident)) ; Récupère un éventuel père ou FALSE
	(__forget-granule ?ident)) ; Marque toute la structure
;	(return ?idpere)) ; Retourne le père ou FALSE

;; -----------------------------------------------------------------------------
;; Rattachement d'un granule à un autre = nouvelle liaison

(deffunction YADE::__connect-granule-connectAttr (?idpere ?idfils) "Rattache un granule à un connecteur"
	(do-for-fact ((?pere granule)) (eq ?pere:ident ?idpere)
		(do-for-fact ((?fils granule)) (eq ?fils:ident ?idfils)
		
			(if (not (attente-satisfaite ?idpere A1))
			then (assert (liaison (idpere ?idpere) (idfils ?idfils) (code A1)))
			     (modify ?pere (types ?fils:types))
			     (modify ?fils (racine FALSE))
			     (return))
			
			(if (not (attente-satisfaite ?idpere A2))
			then (assert (liaison (idpere ?idpere) (idfils ?idfils) (code A2)))
			     (modify ?pere (types (intersection$ ?pere:types ?fils:types)))
			     (modify ?fils (racine FALSE))
			     (return))))
	
	(writeError (format nil "ERROR in connect-granule-connectAttr: impossible connection between %s and %s" ?idpere ?idfils))
	(halt))

(deffunction YADE::connect-granule (?idpere ?idfils ?role) "Rattache un granule à un autre"
	(bind ?offres (get-offres ?idfils)) ; Les offres du fils
	(do-for-fact ((?pere granule)) (eq ?pere:ident ?idpere) ; Le granule père
		(do-for-fact ((?fils granule)) (eq ?fils:ident ?idfils) ; Le granule fils
			(if (eq connectAttr (car$ ?pere:lconcept))
			then
				(__connect-granule-connectAttr ?idpere ?idfils) ; Traitement différent si connectAttr
			else
				(do-for-fact ((?attente attente))
					(and (eq ?attente:concept ?pere:concept) ; Les attentes du père
					     (or (and (neq ?role nil) (eq ?attente:role ?role)) ; L'attente qui le bon rôle ou bien...
					         (and (eq ?role nil) (or (intersectp ?attente:expected ?offres) ; L'attente qui va avec les offres
					                                 (intersectp ?attente:required ?offres)))))
					(assert (liaison (idpere ?idpere) (idfils ?idfils) (code ?attente:code) (role ?attente:role)))
					(modify ?fils (racine FALSE))
					(writeLog (format nil "    Linking granule %s to %s role=%s" ?idfils ?idpere ?attente:role))
					(return))
						
				(writeError (format nil "ERROR in connect-granule: impossible connection between %s and %s" ?idpere ?idfils))
				(halt)))))

;; -----------------------------------------------------------------------------
;; Instanciation d'un nouveau granule + rattachement éventuel

(deffunction YADE::__find-offers (?cname) "Retrouver les offres d'un concept donné"
	(do-for-fact ((?concept concept))
		(eq ?concept:concept ?cname) ; Concept défini dans la grammaire => offres connues
		(return ?concept:offres))
	(return (decode-concept ?cname))) ; Concept non défini dans la grammaire (modules externes)

(deffunction YADE::create-granule-1 (?cname) "Instancier un nouveau granule et retourner son ident"
	(bind ?ident (sym-cat [ ?cname ]# (+ 1000 (genint*))))
	(bind ?offers (__find-offers ?cname))
	(bind ?lconcept (decode-concept ?cname))
	(assert (granule (ident ?ident) (concept ?cname) (lconcept ?lconcept) (offres ?offers) (racine TRUE) (added TRUE)))
	(writeLog (format nil "==> Creating granule %s" ?ident))
	(return ?ident))

(deffunction YADE::create-granule-2 (?cname ?idpere ?role) "Instancier un nouveau granule fils et retourner son ident"
	(bind ?idfils (sym-cat [ ?cname ]# (+ 1000 (genint*))))
	(bind ?offers (__find-offers ?cname))
	(bind ?lconcept (decode-concept ?cname))
	(assert (granule (ident ?idfils) (concept ?cname) (lconcept ?lconcept) (offres ?offers) (added TRUE)))
	(writeLog (format nil "==> Creating granule %s under %s role=%s" ?idfils ?idpere ?role))
	(connect-granule ?idpere ?idfils ?role)
	(return ?idfils))

;; -----------------------------------------------------------------------------
;; Fin du fichier
