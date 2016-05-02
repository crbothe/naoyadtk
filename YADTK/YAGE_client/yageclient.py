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

BASE = os.getcwd()
OUTPUT = BASE + "/_output.xml"  
RAISE = BASE + "/raise.bash > /dev/null"

##############################################################################
## Récupérer l'adresse et le port du serveur YASP

YAGE_SERVER = os.environ["YAGE_SERVER"]
(YAGE_HOST, YAGE_PORT) = adresseDecode(YAGE_SERVER)

##############################################################################

setTermTitle("YAGE CLIENT")
print "Starting YAGE client..."

print
print '  <granule concept="acte:demander"><granule concept="billet"><granule concept="nombre:1"/><granule concept="ville:paris" role="destination"/></granule></granule>'
print '  <granule concept="acte:demander"><granule concept="billet"><granule concept="nombre:2"/><granule concept="ville:paris" role="destination"/></granule></granule>'
print '  <granule concept="ticket"><granule concept="number:1"/><granule concept="roundtrip"/><granule concept="ville:paris" role="destination"/></granule>'
print '  <granule concept="ticket"><granule concept="number:2"/><granule concept="roundtrip"/><granule concept="ville:paris" role="destination" metadata="style:slangy"/></granule>'
print '  <granule concept="acte:demander"><granule concept="inferred" code="A1" texte="some black snow"/></granule>'
print
print '  <granule concept="temps-jour:lundi"/>'
print '  <granule concept="temps-ordinal:2"/>'
print '  <granule concept="temps-mois:2"/>'
print '  <granule concept="temps-annee:2015"/>'
print

while True:
    chaine = raw_input('Enter a litteral G-structure or type "exit" > ')
    print "Connecting to %s..." % YAGE_SERVER
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.connect((YAGE_HOST, YAGE_PORT))
    sock.sendall(chaine)
    
    for line in readlines(sock):
        # Le serveur YASP retourne "EXIT" lorsqu'il reçoit "exit":
        if line == "EXIT": exit()
        if line.find("ERROR") > -1:
            cprint(line, "red") # Les lignes contenant ERROR en rouge
            exit()
        else:
            cprint(line, "blue") # Les autres lignes en bleu
    sock.close()
    # Réactiver le terminal client
    os.system(RAISE)

##############################################################################
