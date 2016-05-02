# coding: utf-8
##############################################################################
# This file is part of the YADTK Toolkit (Yet Another Dialogue Toolkit)
# Copyright © Jérôme Lehuen 2010-2015 - Jerome.Lehuen@univ-lemans.fr
#
# This software is governed by the CeCILL license under French law and
# abiding by the rules of distribution of free software. You can use,
# modify and/or redistribute the software under the terms of the CeCILL
# license as circulated by CEA, CNRS and INRIA (http://www.cecill.info).
#
# As a counterpart to the access to the source code and rights to copy,
# modify and redistribute granted by the license, users are provided only
# with a limited warranty and the software's author, the holder of the
# economic rights, and the successive licensors have only limited
# liability.
#
# In this respect, the user's attention is drawn to the risks associated
# with loading, using, modifying and/or developing or reproducing the
# software by the user in light of its specific status of free software,
# that may mean that it is complicated to manipulate, and that also
# therefore means that it is reserved for developers and experienced
# professionals having in-depth computer knowledge. Users are therefore
# encouraged to load and test the software's suitability as regards their
# requirements in conditions enabling the security of their systems and/or
# data to be ensured and, more generally, to use and operate it in the
# same conditions as regards security.
#
# The fact that you are presently reading this means that you have had
# knowledge of the CeCILL license and that you accept its terms.
##############################################################################

# This free software is registered at the Agence de Protection des Programmes.
# For further information or commercial purpose, please contact the author.

import re
import sys
import codecs

from xml.dom import minidom

sys.path.append("YADTK/COMMON/python")
from clipsutils import *
from utils import *

##############################################################################

def code(terme):
    return re.match("A[1-9]", terme)

def taille(pattern):
    return len(pattern.split())

def valence(pattern):
    valence = 0
    for terme in pattern.split():
        if code(terme):
            valence += 1
    return valence

def tokenize(pattern):
    pattern = pattern.lower() # Convertir en minuscules
    pattern = pattern.strip() # Enlever les espaces au début et à la fin
    pattern = toascii(pattern) # Convertir les caractères non-ascii
    pattern = re.sub(r"\(.*\)","", pattern) # supprimer les parties parenthésées
    pattern = re.sub(r"/[^ ]*","", pattern) # supprimer les parties alternatives
    pattern = re.sub(r" ","_", pattern) # Remplacer les espaces par des underscores
    pattern = re.sub(r"'","_", pattern) # Remplacer les apostrophes par des underscores
    pattern = re.sub(r"_+","_", pattern) # Supprimer les underscores multiples
    pattern = re.sub(r"^_","", pattern) # Supprimer les underscores en début
    return pattern

##############################################################################
# Fonction de génération des entités lexicales YASP
##############################################################################

def opt(term):
    return(term[0] == '(')

def deopt(term):
    return term[1:len(term)-1]    

def generer_entites_yasp(inputfile, outputfile):
    xmldoc = minidom.parse(inputfile)
    lexicon = codecs.open(outputfile, "w", "utf-8")
    
    print >>lexicon, ";; ============================================================================="
    print >>lexicon, ";; Automatically generated lexical entities (do not modify this file)"
    print >>lexicon, ";; ============================================================================="
    print >>lexicon    
    print >>lexicon, "(deffacts LEXIQUE::entities"
    print >>lexicon
    
    for entity in xmldoc.getElementsByTagName("entity"):
    
        concept = entity.getAttribute("concept")
        pattern = entity.getAttribute("pattern")
        value = entity.getAttribute("value")
        offers = entity.getAttribute("offers")
        metadata = entity.getAttribute("metadata")
        gen = entity.getAttribute("gen")
        
        if value: conceptName = "%s:%s" % (concept, value)
        else: conceptName = "%s:%s" % (concept, tokenize(pattern))
        
        def traiter(pattern):
            print >>lexicon, "(entity (concept %s) (pattern \"%s\") (offers %s %s) (metadata %s) (gen %s))" % (conceptName, pattern, concept, offers, metadata, gen)
        
        # Pout générer la combinatoire des patterns au niveau de la compilation (trop lent pendant l'exécution)
        
        def combiner(liste, resultat):
            if not liste: traiter(" ".join(resultat))
            elif opt(liste[0]):
                combiner(liste[1:], resultat+[deopt(liste[0])])
                combiner(liste[1:], resultat)
            else: combiner(liste[1:], resultat+[liste[0]])
        
        combiner(pattern.split(), [])
        
    print >>lexicon, ")"
    print >>lexicon, ";; ============================================================================="
    print >>lexicon, ";; End of file"
    lexicon.close()

'''
def traiter(pattern):
    print "-%s-" % pattern

def combiner(liste, resultat):
    if not liste: traiter(" ".join(resultat))
    elif opt(liste[0]):
        combiner(liste[1:], resultat+[deopt(liste[0])])
        combiner(liste[1:], resultat)
    else: combiner(liste[1:], resultat+[liste[0]])

combiner("a (b) c (d)".split(), [])
'''

##############################################################################
# Fonction de génération des règles de compréhension YASP
##############################################################################

def compiler_regles_yasp(inputfile, outputfile):
    xmldoc = minidom.parse(inputfile)
    rules = codecs.open(outputfile, "w", "utf-8")
    
    print >>rules, ";; ============================================================================="
    print >>rules, ";; Automatically generated parsing rules (do not modify this file)"
    print >>rules, ";; ============================================================================="
    print >>rules
    
    pattern_cmpt = 0
    for syntaxNode in xmldoc.getElementsByTagName("syntax"):
    
        pattern_cmpt += 1
        pattern = syntaxNode.getAttribute("pattern") # Le pattern syntaxique
        metadata = syntaxNode.getAttribute("metadata") # Les métadonnées du pattern
        concept = syntaxNode.parentNode.getAttribute("concept") # Le concept du granule
        offres = syntaxNode.parentNode.getAttribute("offers") # Les offres du granule
        offres_expr = syntaxNode.parentNode.getAttribute("offerexpr") # Les offres calculées
        
        if not(concept): concept = "unnamed"
        
        nom_regle = "ETAPE2::cree-granule-%s-%d" % (concept, pattern_cmpt)
        salience = taille(pattern) - 10 * valence(pattern) # Calcul de la priorité
        
        texte = "" # Initialisation de la liste des mots
        cons = "" # Initialisation de la liste des constituants
        dep = "" # Initialisation de la liste des dépendances
        liste_pos = "" # Initialisation de la liste des positions des mots pris en compte
        liste_hyp = "" # Initialisation de la liste des hypothèses
        liste_sco = "" # Initialisation de la liste des scores	
        reports = "" # Initialisation de la liste des reports
        
        print "Defining defrule: %s (%s)" % (nom_regle, pattern),
        print >>rules, "(defrule %s \"%s\"" % (nom_regle, pattern)
        print >>rules, "	(declare (salience %d))" % salience
        
        # ----------------------------------------------------------------------------
        # Left Hand Side
        # ----------------------------------------------------------------------------

        i = 0
        for terme in pattern.split():
            i += 1
            texte += " ?texte%d" % i
            
            if code(terme):
                print >>rules, "	(or",
                
                print >>rules, "(and (attente (concept %s) (code %s) (role ?role%s) (mult ?mult%s) (expected $?expected%s) (required $?required%s) (rejected $?rejected%s))" % (concept, terme, terme, terme, terme, terme, terme)
                
                print >>rules, "	         (granule (ident ?id%d) (texte ?texte%d)" % (i, i),
                if i == 1: print >>rules, "(pos ?pos1) (fin ?fin1)",
                else: print >>rules, "(pos ?pos%d&:(succ ?pos%d ?fin%d)) (fin ?fin%d) " % (i, i, i-1, i),
                print >>rules, "(liste-pos $?liste%d) (offres $?offers%s) (dependances $?dep%d) (metadata $?metadata%d) (nbhyp ?nbhyp%d) (score ?score%d))" % (i, terme, i, i, i, i)
                
                print >>rules, "	         (test (and (or (vide$ ?expected%s) (correspondance ?expected%s (create$ ?offers%s ?metadata%d)))" % (terme, terme, terme, i)
                print >>rules, "	                    (or (vide$ ?required%s) (subsetp ?required%s (create$ ?offers%s ?metadata%d)))" % (terme, terme, terme, i)
                print >>rules, "	                    (or (vide$ ?rejected%s) (not (intersectp ?rejected%s (create$ ?offers%s ?metadata%d)))))))" % (terme, terme, terme, i)
                
                ## The Granule Guesser precond (tag ~ NONE)
                
                print >>rules, "	    (and (attente (concept %s) (code %s) (tag ?tag%s&~NONE) (role ?role%s) (expected $?expected%s))" % (concept, terme, terme, terme, terme)
                
                print >>rules, "	         (granule (ident ?id%d) (texte ?texte%d)" % (i, i),
                if i == 1:
                    print >>rules, "(pos ?pos1) (fin ?fin1)",
                else:
                    print >>rules, "(pos ?pos%d&:(succ ?pos%d ?fin%d)) (fin ?fin%d)" % (i, i, i-1, i),
                print >>rules, "(liste-pos $?liste%d) (dependances $?dep%d) (metadata $?metadata%d) (nbhyp ?nbhyp%d) (score ?score%d) (offres $?offers%s) (tag ?tag%s))))" % (i, i, i, i, i, terme, terme)

                cons += " ?id%d" % i
                dep += " ?dep%d" % i
                liste_pos += " ?liste%d" % i
                liste_hyp += " ?nbhyp%d" % i
                liste_sco += " ?score%d" % i
                
                # Report éventuel des offres du granule fils (si le code est contenu dans les offres)
                if offres.find(terme) > -1:
                    reports += " ?offers%s" % terme
                    
            else: # Ce n'est pas une dépendance donc c'est un mot
            
                print >>rules, "	(mot (lemmes $?lemmes%d) (texte ?texte%d&:(comp ?texte%d \"%s\" ?lemmes%d))" % (i, i, i, terme, i),
                if i == 1:
                    print >>rules, "(pos ?pos1) (fin ?fin1)",
                else:
                    print >>rules, "(pos ?pos%d&:(succ ?pos%d ?fin%d)) (fin ?fin%d)" % (i, i, i-1, i),
                print >>rules, "(score ?score%d))" % i
                    		
                liste_pos += " ?pos%d" % i
                liste_sco += " ?score%d" % i
                
        # Suppression des éventuels reports d'offres de la liste des offres
        for terme in offres.split():
            if code(terme):
                offres = offres.replace(terme, "") # Supprimer le terme de la liste
        
        # Ajout des contraintes supplémentaires (contraintes coisées)
        for node in syntaxNode.parentNode.getElementsByTagName("constraint"):
            print >>rules, "	(test %s)" % node.getAttribute("test")
    
        # ----------------------------------------------------------------------------
        # Right Hand Side
        # ----------------------------------------------------------------------------

        print >>rules, "	=>"
        print >>rules, "	(bind ?concept %s)" % concept
        print >>rules, "	(bind ?ident (sym-cat [%s]# (genint*)))" % concept
        print >>rules, "	(bind ?texte (clean (concatene$ %s)))" % texte
        print >>rules, "	(bind ?pattern \"%s\")" % pattern
        print >>rules, "	(bind ?metadata (create$ %s))" % metadata
        print >>rules, "	(bind ?liste-pos (supprime$ (create$ %s) nil))"  % liste_pos
        print >>rules, "	(bind ?liste-ins (complement ?liste-pos))"
        print >>rules, "	(bind ?pos (car$ ?liste-pos))"
        print >>rules, "	(bind ?fin (+ 1 (dernier$ ?liste-pos)))"
        print >>rules, "	(bind ?nbhyp (+ 0 0%s))" % liste_hyp
        print >>rules, "	(bind ?nbins (length$ ?liste-ins))"
        print >>rules, "	(bind ?nbmots (length$ ?liste-pos))"
        print >>rules, "	(bind ?score (score ?nbmots ?nbins))"
        print >>rules, "	(bind ?constituants (supprime$ (create$ %s) nil))" % cons
        print >>rules, "	(bind ?dependances (supprime$ (create$ %s %s) nil))" % (cons, dep)
        print >>rules, "	(bind ?offres (create$ %s %s %s))" % (offres, reports, offres_expr)
            
        print >>rules, "	(assert (granule (ident ?ident) (concept ?concept) (texte ?texte) (pattern ?pattern)",
        print >>rules, "(pos ?pos) (fin ?fin) (nbmots ?nbmots) (nbins ?nbins) (nbhyp ?nbhyp) (liste-pos ?liste-pos) (liste-ins ?liste-ins)",
        print >>rules, "(constituants ?constituants) (dependances ?dependances) (score ?score)",
        print >>rules, "(offres ?offres) (metadata ?metadata)))",
            
        i = 0
        for terme in pattern.split():
            i += 1
            if code(terme):
                print >>rules, "\n	(assert (liaison (code %s)" % terme,
                print >>rules, "(idpere ?ident) (idfils ?id%d) (role ?role%s)" % (i, terme),
                print >>rules, "(types (intersection$ ?expected%s (create$ ?offers%s ?metadata%d)))))" % (terme, terme, i),
            
        print >>rules, "\n)\n"
        print

    print >>rules, ";; ============================================================================="
    print >>rules, ";; End of file"
    rules.close()

##############################################################################
# Fonction de génération des règles de génération YAGE
##############################################################################

def compiler_regles_yage(inputfile, outputfile):
    xmldoc = minidom.parse(inputfile)
    rules = codecs.open(outputfile, "w", "utf-8")
    
    print >>rules, ";; ============================================================================="
    print >>rules, ";; Automatically generated generation rules (do not modify this file)"
    print >>rules, ";; ============================================================================="
    print >>rules
    
    pattern_cmpt = 0
    for syntaxNode in xmldoc.getElementsByTagName("syntax"):
        if syntaxNode.getAttribute("gen") == "TRUE":
            pattern_cmpt += 1
            
            idconcept = syntaxNode.parentNode.getAttribute("concept")
            idsyntaxe = syntaxNode.getAttribute("ident")
            pattern = syntaxNode.getAttribute("pattern") # Le pattern syntaxique
            tprop = syntaxNode.getAttribute("metadata") # Les métadonnées du pattern
            
            nom_regle = "YAGE::genere-granule-%s-%s" % (idconcept, idsyntaxe)
            code_regle = "%s-%s" % (idconcept, idsyntaxe)
            salience = 500 - 10 * valence(pattern) # Les formulations les plus simples sont prioritaires
            
            print "Defining defrule: %s (%s)" % (nom_regle, pattern),
            print >>rules, "(defrule %s \"%s\"" % (nom_regle, pattern)
            print >>rules, "	(declare (salience %d))" % salience
            print >>rules, "	(syntaxe (ident %s) (traits $?tprop) (toA1 $?toA1) (toA2 $?toA2) (toA3 $?toA3) (toA4 $?toA4) (toA5 $?toA5) (toA6 $?toA6) (toA7 $?toA7) (toA8 $?toA8) (toA9 $?toA9))" % idsyntaxe

            # ----------------------------------------------------------------------------
            # Left Hand Side
            # ----------------------------------------------------------------------------
            
            print >>rules, "	(granule (idconcept %s) (idgranule ?idgranule) (idpere ?idpere) (code ?code) (modifieurs $?modifieurs) (prof ?prof))" % idconcept
            print >>rules, "	(_profondeur ?prof)"
            
            for terme in pattern.split():
                if code(terme):
                    print >>rules, "	?f-%s <- (generation (ident ?id%s) (code %s) (idpere ?idgranule) (texte $?txt%s) (traits $?from%s) (dependances $?dep%s) (score ?score%s))" % (terme, terme, terme, terme, terme, terme, terme)
                
            # ----------------------------------------------------------------------------
            # Right Hand Side
            # ----------------------------------------------------------------------------

            print >>rules, "	=>"
            print >>rules, "	(bind ?ident (sym-cat GEN# (genint*)))"
            print >>rules, "	(bind ?score (+ 100 (calcule-score-pond ?modifieurs ?tprop 10)))"
            
            # Calcul des scores verticaux
            
            for terme in pattern.split():
                if code(terme):
                    print >>rules, "	(bind ?score (+ ?score ?score%s (calcule-score ?from%s ?tprop) (calcule-score ?from%s ?to%s)))" % (terme, terme, terme, terme)
            
            # Calcul des scores horizontaux (codes successifs)
            
            liste = pattern.split()
            for i in range(0, len(liste)-1):
                mot1 = liste[i]
                mot2 = liste[i+1]
                if code(mot1) and code(mot2):
                    print >>rules, "	(bind ?score (+ ?score (calcule-score ?from%s ?from%s)))" % (mot1, mot2)
            
            # Construction des dépendances et du texte
            
            dep = ""
            txt = ""
            grn = ""
            for terme in pattern.split():
                if code(terme):
                    dep += " ?id%s" % terme
                    txt += " ?txt%s" % terme
                    grn += " ?f-%s" % terme
                else:
                    txt += " \"%s\"" % terme
            
            print >>rules, "	(bind ?dependances (create$ %s))" % dep
            print >>rules, "	(assert (generation (ident ?ident) (code ?code) (idgranule ?idgranule) (idpere ?idpere) (texte %s) (traits ?tprop) (score ?score) (fils %s) (regle %s) (dependances ?dependances) (prof ?prof)))" % (txt, grn, code_regle)
            
            print >>rules, ")\n"
            print

    print >>rules, ";; ============================================================================="
    print >>rules, ";; End of file"
    rules.close()

##############################################################################
## Combinatoire sur les patterns puis génération des règles et du lexique
## The variable $YASP_DATA_PATH is exported from the script compiler.bash
## _lexique.clp -> _concepts.xml -> _lexique.clp
##                               -> _filtrage.clp

YASP_DATA_PATH = os.environ["YASP_DATA_PATH"] + "/"

# Réalisation de la combinatoire sur les patterns YASP
title("Optional terms combination")
clips__Load("YADTK/COMMON/clips/utils.clp")
clips__Load("YADTK/COMMON/clips/lexique.clp")
clips__Load(YASP_DATA_PATH + "_lexique.clp")
clips.Reset()
clips__Focus("PRECOMP")
clips__Run()
print

# Sauvegarde de la nouvelle grammaire en CLIPS et en XML
clips__Focus("PRECOMP")
clips__Call("sauvegarder-lexique", YASP_DATA_PATH + "_lexique.clp " + YASP_DATA_PATH + "_concepts.xml")

# Génération de base des entités à partir du fichier _tmp.xml
generer_entites_yasp(YASP_DATA_PATH + "_tmp.xml", YASP_DATA_PATH + "_entities.clp")

# Génération et sauvegarde des règles de compréhension YASP
title("Generation of YASP rules")
compiler_regles_yasp(YASP_DATA_PATH + "_concepts.xml", YASP_DATA_PATH + "_filtrage.clp")

# Génération et sauvegarde des règles de génération YAGE
title("Generation of YAGE rules")
compiler_regles_yage(YASP_DATA_PATH + "_concepts.xml", YASP_DATA_PATH + "_generation.clp")

##############################################################################
