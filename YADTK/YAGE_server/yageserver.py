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
import re
from xml.dom import minidom

sys.path.append("../COMMON/python")
from utils import *
from clipsutils import *

YAGE_DIR = os.getcwd()
COMMON = YAGE_DIR + "/../COMMON"
DEBUG_MODE = os.environ["YAGE_DEBUG"]

HOST = socket.gethostname()
PORT = int(os.environ["YAGE_PORT"])
DATA = os.environ["YAGE_DATA"]

##############################################################################
## Reconstruction d'une structure de granules

def __idpere(node):
    if node.parentNode == xmldoc: return "nil"
    else: return node.parentNode.getAttribute("idgranule")

def __prof(node):
    if node.parentNode == xmldoc: return 0
    else: return __prof(node.parentNode) + 1

def creeGranule(node):
    global cmpt
    cmpt += 1
    idgranule = "gr" + str(cmpt)
    node.setAttribute("idgranule", idgranule)
    
    idconcept = node.getAttribute("concept")
    code = node.getAttribute("code")
    role = node.getAttribute("role")
    indice = node.getAttribute("indice")
    pos = node.getAttribute("pos")
    modifieurs = node.getAttribute("metadata")
    texte = node.getAttribute("texte")

    idpere = __idpere(node)
    prof = __prof(node)

    if not(code): code = "nil"
    if not(role): role = "nil"
    if not(indice): indice = "0"
    if not(pos): pos = "0"
    
    fact = '(granule (idgranule %s) (idconcept %s) (idpere %s) (code %s) (role %s) (indice %s) (pos %s) (prof %d) (modifieurs %s) (texte "%s"))' % (idgranule, idconcept, idpere, code, role, indice, pos, prof, modifieurs, texte)
    print "==> %s" % fact
    clips__Assert(fact.encode("utf-8"))

def xmlparse(chaine):
    global xmldoc
    global cmpt
    cmpt = 0
    xmldoc = minidom.parseString(chaine)
    for node in xmldoc.getElementsByTagName("granule"):
        creeGranule(node)

##############################################################################
## Fonctions du serveur

def writesock(texte):
    texte += "\n"
    connection.sendall(texte)

def stopserver():
    print "Server stopped"
    writesock("EXIT")
    exit()

def dostuff(chaine):
    if chaine == "_exit": stopserver()
    clips.Reset()
    clips.SendCommand("(focus YAGE)")
    title("Instanciation des granules")
    xmlparse(chaine)
    
    if clips__Run():
        if DEBUG_MODE == "TRUE": writeTrace()
        clips.SendCommand("(focus YAGE)")
        writeFacts(start)
    else:
        writesock("ERROR: A critical problem has occured on the YAGE server")
        exit()

##############################################################################
## Chargements des fichiers

def clips_load_and_init():
    global start
    
    clips.RegisterPythonFunction(writesock)
    clips.BuildFunction("writesock", "?chaine", "(python-call writesock ?chaine)")
    
    ##############################################################################
    ## Configuration du moteur CLIPS
    
    clips.SetExternalTraceback(True)

    if DEBUG_MODE == "TRUE":
        clips.DebugConfig.FactsWatched = True
        clips.DebugConfig.RulesWatched = True
    #   clips.DebugConfig.ActivationsWatched = True
        clips.SendCommand("(watch focus)")
    
    ##############################################################################

    clips__Load(COMMON + "/clips/utils.clp")
    clips__Load(COMMON + "/clips/lexique.clp")

    clips__Load(YAGE_DIR + "/clips/granules_yage.clp")
    clips__Load(YAGE_DIR + "/clips/module_yage.clp")

    clips__Load(YAGE_DIR + "/data/%s/_lexique.clp" % DATA)
    clips__Load(YAGE_DIR + "/data/%s/_entities.clp" % DATA)
    clips__Load(YAGE_DIR + "/data/%s/_generation.clp" % DATA)

    clips.Reset()
    start = clips.Eval("(nbfacts)")

clips_load_and_init()

##############################################################################
## Démarrage du serveur YAGE

setTermTitle("YAGE SERVER")
print "Starting YAGE server on %s:%s with knowledge %s" % (HOST, PORT, DATA)

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1) # To avoid "address already in use"
sock.bind((HOST, PORT))
sock.listen(5)

while True:
    separation()
    print "Waiting for a connection..."
    connection, client_address = sock.accept()
    print "Connection from", client_address[0]
    data = connection.recv(8000) # Une structure XML de 8000 caractères maximum
    print "Received [%s]" % data
    
    if data == "_exit":
        stopserver()
    
    elif data == "_reload":
        print("Reloading knowledge %s and restart server..." % DATA)
        clips.Clear()
        from clipsutils import * # ???????
        clipsreload()
        clips_load_and_init()
        print("Knowledge %s reloaded" % DATA)
    
    else: dostuff(data)
    connection.close()

##############################################################################
