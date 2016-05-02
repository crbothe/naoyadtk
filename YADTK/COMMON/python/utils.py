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

import sys, os, re
import socket
import unicodedata

from termcolor import colored, cprint

LIGHTGREEN = "\033[92m"
LIGHTYELLOW = "\033[93m"
RESET = "\033[0m"

def exit():
    os._exit(1)

def ERROR(msg):
    cprint (msg, "red")
    os._exit(1)

def beep():
    sys.stdout.write("\a")
    sys.stdout.flush()
    
def title(texte):
    color = "cyan"
    cprint ("--------------------------------------------------------------------------------", color)
    cprint (texte, color)
    cprint ("--------------------------------------------------------------------------------", color)

def separation():
    color = "cyan"
    cprint ("================================================================================", color)

def printcwd():
    print "[[%s]]" % os.getcwd()

def setTermTitle(title):
    print("\x1B]0;%s\x07" % title)

def adresseDecode(adresse):
    (host, port) = re.match("(.*):(.*)", adresse).groups()
    if host == "localhost":
        host = socket.gethostbyname(socket.gethostname())
    return (host, int(port))

def createSocket(adresse):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect(adresseDecode(adresse))
    return sock

def readlines(sock, bytes=1024):
    buffer = ""
    delim = "\n"
    data = True
    while data:
        data = sock.recv(bytes)
        buffer += data
        while buffer.find(delim) != -1:
            line, buffer = buffer.split(delim, 1)
            yield line
    return

def normaliser(chaine):
    chaine = chaine.lower() # Convertir en minuscules
    chaine = chaine.strip() # Enlever les espaces au début et à la fin
    chaine = re.sub(r"-"," ", chaine) # Remplacer les traits par des espaces
    chaine = re.sub(r"\."," ", chaine) # Remplacer les points par des espaces
    chaine = re.sub(r"\,"," ", chaine) # Remplacer les virgules par des espaces
    chaine = re.sub(r"\;"," ", chaine) # Remplacer les point-virgules par des espaces
    chaine = re.sub(r"\""," ", chaine) # Remplacer les guillemets par des espaces
    chaine = re.sub(r"\?"," ?", chaine) # Ajouter un espace avant chaque point d'interrogation
    chaine = re.sub(r"'","' ", chaine) # Ajouter un espace après chaque apostrophe
    chaine = re.sub(r" +"," ", chaine) # Supprimer les espaces multiples
    chaine = chaine.strip() # Enlever les espaces au début et à la fin
    return chaine

def toascii(chaine):
    return ''.join((c for c in unicodedata.normalize('NFD', chaine) if unicodedata.category(c) != 'Mn'))

##############################################################################
