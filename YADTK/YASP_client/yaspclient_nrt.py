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

import sys, os
import socket
import codecs
import re

from xml.dom import minidom

sys.path.append("../COMMON/python")
from utils import *

YASP_SERVER = os.environ["YASP_SERVER"]
YADTK = os.environ["YADTK"]
INPUT = os.environ["INPUT"]

if not os.path.isabs(INPUT):
	INPUT = "%s/%s" % (YADTK, INPUT)

##############################################################################
## Vérification d'une analyse YASP

def verifier(analyse):
    xmldoc1 = minidom.parseString(analyse)
    root1 = xmldoc1.firstChild
    text = root1.getAttribute("text").encode("utf-8")
    print "%s..." % text,
    
    sock = createSocket(YASP_SERVER)
    sock.sendall(text)
    
    result = ""
    for line in readlines(sock):
        if re.search("structure", line) or re.search("granule", line):
            result += line.strip()
    sock.close()
    
    xmldoc2 = minidom.parseString(result)
    root2 = xmldoc2.firstChild
    
    # Supprimer les attributs id qui peuvent être différents
    for node in xmldoc1.getElementsByTagName("granule"): node.removeAttribute("id")
    for node in xmldoc2.getElementsByTagName("granule"): node.removeAttribute("id")
    
    isEqualGranule(root1, root2)
    print "OK"

##############################################################################
#  Comparaison récursive de deux minidoms (version générique)

def isEqualElement(node1, node2):
    if node1.tagName != node2.tagName: return False
    if sorted(node1.attributes.items()) != sorted(node2.attributes.items()): return False
    if len(node1.childNodes) != len(node2.childNodes): return False
    
    for child1, child2 in zip(node1.childNodes, node2.childNodes):
        if child1.nodeType != child2.nodeType: return False
        if child1.nodeType == child1.TEXT_NODE and child1.data != child2.data: return False
        if child1.nodeType == child1.ELEMENT_NODE: return isEqualElement(child1, child2)
    
    return True

##############################################################################
# Version améliorée pour l'affichage de l'erreur

def isEqualGranule(node1, node2):
    
    # Vérification des attributs du granule
    list1 = sorted(node1.attributes.items())
    list2 = sorted(node2.attributes.items())
    if list1 != list2:
        cprint("GRANULE ERROR", "white", "on_red")
        for attr1, attr2 in zip(list1, list2):
            if attr1 != attr2:
                print
                cprint("Expected: %s=\"%s\"" % attr1, "cyan")
                cprint("Obtained: %s=\"%s\"" % attr2, "red")
                print
                cprint(node2.toprettyxml(), "red")
                exit()
    
    # Vérification du nombre de granules fils
    if len(node1.childNodes) != len(node2.childNodes):
        cprint("STRUCTURE ERROR", "white", "on_red")
        print
        cprint(node2.toprettyxml(), "cyan")
        cprint(node1.toprettyxml(), "red")
        exit()
    
    # Appel récursif
    for child1, child2 in zip(node1.childNodes, node2.childNodes):
        isEqualGranule(child1, child2)

##############################################################################
## Programme principal

setTermTitle("YASP CLIENT")
print "Starting YASP NRT client..."
print "Base folder :", YADTK
print "Input file  :", INPUT

raw_input("Type [enter] to start the test")

file = open(INPUT, "r")
while True:
    line = file.readline()
    if not line: break
    if re.match("^stop", line): break
    if re.search("granule", line): xml += line.strip()
    if re.search("<structure", line): xml = line.strip()
    if re.search("</structure", line):
        xml += line.strip()
        verifier(xml)

file.close()
cprint("Good! That's All Folks!", "cyan")

##############################################################################
