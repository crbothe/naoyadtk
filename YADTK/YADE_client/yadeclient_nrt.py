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

sys.path.append("../COMMON/python")
from utils import *
from clipsutils import *

YADE_SERVER = os.environ["YADE_SERVER"]
YADTK = os.environ["YADTK"]
INPUT = os.environ["INPUT"]

if not os.path.isabs(INPUT):
	INPUT = "%s/%s" % (YADTK, INPUT)

##############################################################################
## Programme principal

setTermTitle("YADE CLIENT")
print "Starting YADE NRT client..."
print "Base folder :", YADTK
print "Input file  :", INPUT

raw_input("Type [enter] to start the test")

file = open(INPUT, "r")
while True:
    line = file.readline()
    print line,
    if not line: break
    if re.match("^stop", line): break
    if re.match("^USER", line):
        input = re.match("^USER: (.*)", line).group(1)
        line = file.readline()
        print line,
        if not(re.match("^YADE:", line)):
            cprint("ERREUR: File autotests.txt is not well-formed", "white", "on_red")
            exit()
        else:
            cible = re.match("^YADE: (.*)", line).group(1)
            sock = createSocket(YADE_SERVER)
            sock.sendall(input)
            output = sock.recv(256)
            if normaliser(output) != normaliser(cible):
                cprint("ERROR " + output, "white", "on_red")
                exit()

file.close()
cprint("Good! That's All Folks!", "cyan")

##############################################################################
