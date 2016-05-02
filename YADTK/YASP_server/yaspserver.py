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

sys.path.append("../COMMON/python")
from utils import *
from clipsutils import *

YASP_DIR = os.getcwd()
COMMON = YASP_DIR + "/../COMMON"
DEBUG_MODE = os.environ["YASP_DEBUG"]
TAGGER_LANG = os.environ["TAGGER_LANG"]

HOST = socket.gethostbyname(socket.gethostname())
PORT = int(os.environ["YASP_PORT"])
DATA = os.environ["YASP_DATA"]

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
    chaine = normaliser(chaine)
    clips.Reset()
    clips.SendCommand("(focus YASP)")
    clips__Assert('(input (chaine "%s"))' % chaine)
    pos = 0
    for mot in chaine.split():
        pos += 1
        clips__Assert('(mot (texte "%s") (pos %d) (fin %d))' % (mot, pos, pos+1))
    
    if clips__Run():
        if DEBUG_MODE == "TRUE": writeTrace()
        writeFacts(start)
    else:
        writesock("ERROR: A critical problem has occured on the YASP server")
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
        #clips.DebugConfig.ActivationsWatched = True
        clips.SendCommand("(watch focus)")
    
    ##############################################################################    
    
    clips__Load(COMMON + "/clips/utils.clp")
    clips__Load(COMMON + "/clips/lexique.clp")
    clips__Load(COMMON + "/clips/expressions.clp")

    clips__Load(YASP_DIR + "/clips/granules_yasp.clp")
    clips__Load(YASP_DIR + "/clips/module_yasp.clp")
    clips__Load(YASP_DIR + "/clips/module_bdlex.clp")
    clips__Load(YASP_DIR + "/clips/module_entites.clp")

    clips__Load(YASP_DIR + "/clips/module_nombres_%s.clp" % TAGGER_LANG)
    clips__Load(YASP_DIR + "/clips/module_dates_%s.clp" % TAGGER_LANG)

    clips__Load(YASP_DIR + "/data/%s/_lexique.clp" % DATA)
    clips__Load(YASP_DIR + "/data/%s/_entities.clp" % DATA)
    clips__Load(YASP_DIR + "/data/%s/_filtrage.clp" % DATA)

    clips__Load(YASP_DIR + "/tagger/rules_%s.clp" % TAGGER_LANG)

    clips.Reset()
    start = clips.Eval("(nbfacts)")

clips_load_and_init()

##############################################################################
## Démarrage du serveur YASP

setTermTitle("YASP SERVER")
print "Starting YASP server on %s:%s with knowledge %s" % (HOST, PORT, DATA)

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1) # To avoid "address already in use"
sock.bind((HOST, PORT))
sock.listen(5)

while True:
    separation()
    print "Waiting for a connection..."
    connection, client_address = sock.accept()
    print "Connection from", client_address[0]
    data = connection.recv(1024) # Une phrase de 1024 caractères maximum
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
