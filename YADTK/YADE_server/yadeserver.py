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
import socket
import sys, os
from xml.dom import minidom

sys.path.append("../COMMON/python")
from clipsutils import *
from utils import *

YADE_DIR = os.getcwd()
COMMON = YADE_DIR + "/../COMMON"
DEBUG_MODE = os.environ["YADE_DEBUG"]
YASP_SERVER = os.environ["YASP_SERVER"]
YAGE_SERVER = os.environ["YAGE_SERVER"]

HOST = socket.gethostname()
PORT = int(os.environ["YADE_PORT"])
DATA = os.environ["YADE_DATA"]

##############################################################################
## Reconstruction d'une structure de granules

def __lemmes(node):
    result = ""
    for mot in node.getAttribute("lemmes").split():
        result += " \"%s\"" % mot
    return result

def __lconcept(node):
    result = ""
    for mot in node.getAttribute("concept").split(":"):
        result += " %s" % mot
    return result

def __ident(node):
    id = node.getAttribute("id")
    concept = node.getAttribute("concept")
    return "[%s]#%s" % (concept, id)

def creeMot(node):
    pos = node.getAttribute("pos")
    fin = int(pos) + 1
    texte = node.getAttribute("texte")
    lemmes = __lemmes(node)
    fact = '(mot (pos %s) (fin %d) (texte "%s") (lemmes %s))' % (pos, fin, texte, lemmes)
    clips__Assert(fact.encode("utf-8")) # Parceque Minidom semble convertir les chaines <str> en <unicode> !!!
    fact = '(mot (pos %s) (fin %s))' % (pos, pos) # Pour les termes optionnels des conditions de type Elisa
    clips__Assert(fact.encode("utf-8"))

def creeConflit(node):
    id1 = node.getAttribute("id1")
    id2 = node.getAttribute("id2")
    fact = '(conflit (id1 %s) (id2 %s))' % (id1, id2)
    clips__Assert(fact.encode("utf-8"))

def creeGranule(node):
    ident = __ident(node)
    n = node.getAttribute("id")
    concept = node.getAttribute("concept")
    lconcept = __lconcept(node)
    text = node.getAttribute("text")
    offers = node.getAttribute("offers")
    metadata = node.getAttribute("metadata")
    pos = node.getAttribute("pos")
    fin = int(node.getAttribute("fin")) + 1 # Dans le XML l'attribut fin correspond au dernier mot
    root = node.getAttribute("root")
    inferred = node.getAttribute("inferred")
    code = node.getAttribute("code") # Attribut de liaison => code
    role = node.getAttribute("role") # Attribut de liaison => role
    fact = '(granule (n %s) (ident %s) (concept %s) (lconcept %s) (offres %s) (metadata %s) (pos %s) (fin %d) (texte "%s") (racine %s) (hyp %s))' % (n, ident, concept, lconcept, offers, metadata, pos, fin, text, root, inferred)
    clips__Assert(fact.encode("utf-8"))

def creeLiaison(pere, fils):
    idpere = __ident(pere)
    idfils = __ident(fils)
    role = fils.getAttribute("role")
    code = fils.getAttribute("code")
    rescued = fils.getAttribute("rescued")
    fact = "(liaison (idpere %s) (idfils %s) (code %s) (role %s) (hyp %s))" % (idpere, idfils, code, role, rescued)
    clips__Assert(fact.encode("utf-8"))

def xmlparse(chaine):
    liste = [] # Id des granules déjà instanciés
    xmldoc = minidom.parseString(chaine)
    for node in xmldoc.getElementsByTagName("mot"):
        creeMot(node)
    for node in xmldoc.getElementsByTagName("conflict"):
        creeConflit(node)
    for node in xmldoc.getElementsByTagName("granule"):
        id = int(node.getAttribute("id"))
        if id not in liste:
            liste.append(id)
            creeGranule(node)
        if node.parentNode.tagName == "granule":
            creeLiaison(node.parentNode, node)

##############################################################################
## Fonctions du serveur

def writesock(texte):
    texte += "\n"
    connection.sendall(texte)

def invoqueYageServer(chaine):
    print "    Connecting to %s..." % YAGE_SERVER
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect(adresseDecode(YAGE_SERVER)) # Connection au serveur YAGE
    sock.sendall(chaine)
    result = ""
    for line in readlines(sock):
        result += line.strip()
    sock.close()
    return result

def stopYaspServer():
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect(adresseDecode(YASP_SERVER))
    sock.sendall("_exit")

def reloadYaspServer():
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect(adresseDecode(YASP_SERVER))
    sock.sendall("_reload")

def stopYageServer():
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect(adresseDecode(YAGE_SERVER))
    sock.sendall("_exit")

def reloadYageServer():
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect(adresseDecode(YAGE_SERVER))
    sock.sendall("_reload")

def stopserver():
    print "Server stopped"
    writesock("EXIT")
    exit()

def dostuff(chaine):
    clips.SendCommand("(focus YADE)")
    clips__Assert('(input (chaine "%s"))' % chaine)
    
    # Vérifier si la chaine est une réponse interne (ex: module base de données)
    if re.search("\[.*\]", chaine):
        print "It is an internal response => YASP is not invoked"
    else:
        # Sinon alors envoi de la chaine à YASP
        print "Connecting to %s..." % YASP_SERVER
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect(adresseDecode(YASP_SERVER)) # Connection au serveur YASP
        sock.sendall(chaine)
        # Récupération et affichage du résultat en XML
        writeTitle("Resulting structure of granules")
        result = ""
        for line in readlines(sock):
            writeLog(line)
            result += line.strip()
        sock.close()
        # Instanciation de la structure de granules correspondante  
        clips.SendCommand("(incrementer-indice)")
        xmlparse(result)
    
    # Lancement du moteur d'inférences de YADE
    if clips__Run():
        if DEBUG_MODE == "TRUE": writeTrace()
        clips.SendCommand("(focus YADE)")
        writeFacts(start)
    else:
        writesock("ERROR: A critical problem has occured on the YADE server")
        exit()

##############################################################################
## Chargements des fichiers

def clips_load_and_init():
    global start
    
    clips.RegisterPythonFunction(writesock)
    clips.BuildFunction("writesock", "?chaine", "(python-call writesock ?chaine)")

    clips.BuildFunction("invoqueYageServer", "?chaine", "(python-call invoqueYageServer ?chaine)")
    clips.RegisterPythonFunction(invoqueYageServer)
    
    ##############################################################################
    ## Configuration du moteur CLIPS
    
    clips.SetExternalTraceback(True)
    ## IMPORTANT => To active dynamic salience for dialog rules:
    clips.EngineConfig.SalienceEvaluation = clips.WHEN_ACTIVATED    
    
    if DEBUG_MODE == "TRUE":
        clips.DebugConfig.FactsWatched = True
        clips.DebugConfig.RulesWatched = True
        #clips.DebugConfig.ActivationsWatched = True
        clips.SendCommand("(watch focus)")
    
    ##############################################################################
    
    clips__Load(COMMON + "/clips/utils.clp")
    clips__Load(COMMON + "/clips/lexique.clp")
    clips__Load(COMMON + "/clips/expressions.clp")

    clips__Load(YADE_DIR + "/clips/granules_yade.clp")
    clips__Load(YADE_DIR + "/clips/module_yade.clp")
    clips__Load(YADE_DIR + "/clips/operations.clp")

    clips__Load(YADE_DIR + "/data/%s/application.clp" % DATA)
    python__Load(YADE_DIR + "/data/%s/application.py" % DATA)

    clips__Load(YADE_DIR + "/data/%s/_lexique.clp" % DATA)
    clips__Load(YADE_DIR + "/data/%s/_entities.clp" % DATA)
    clips__Load(YADE_DIR + "/data/%s/_yaderules.clp" % DATA)

    clips.Reset()
    start = clips.Eval("(nbfacts)")

clips_load_and_init()

##############################################################################
## Démarrage du serveur YASP

setTermTitle("YADE SERVER")
print "Starting YADE server on %s:%s with knowledge %s" % (HOST, PORT, DATA)
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
        stopYaspServer()
        stopYageServer()
        stopserver()
    
    elif data == "_reload":
        reloadYaspServer()
        reloadYageServer()
        print("Reloading knowledge %s and restart server..." % DATA)
        clips.Clear()
        from clipsutils import * # ???????
        clipsreload()
        clips_load_and_init()
        print("Knowledge %s reloaded" % DATA)
        writesock("Knowledge %s reloaded" % DATA)
        
    else: dostuff(data)
    connection.close()

##############################################################################
