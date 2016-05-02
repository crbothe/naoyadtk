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
import time
import socket
import codecs
import multiprocessing

from xml.dom import minidom

sys.path.append("../COMMON/python")
from utils import *
from clipsutils import *

BASE = os.getcwd()
RAISE = BASE + "/raise.bash > /dev/null"
YADEVIZ = BASE + "/yadeviz/yadeviz.bash"
YADEVIZ_FLAG = os.environ["YADEVIZ_FLAG"]
YADE_SERVER = os.environ["YADE_SERVER"]
YADTK_FOLDER = os.environ["YADTK"]
DATA = os.environ["DATA"]

INPUT_QUEUE = multiprocessing.Queue(10)
INPUT_MODULES = [] # Input plugins list
OUTPUT_MODULES = [] # Output plugins list

##############################################################################
## I/O plugin super classes (do not instanciate)

class Plugin(object):

    # Can be redefined in subclasses
    def kill(self): pass

class InputPlugin(Plugin):
    
    def __init__(self):
        INPUT_MODULES.append(self)
    
    def start(self):
        self.thread = multiprocessing.Process(target=self.input_method, args=(INPUT_QUEUE,))
        self.thread.start()

    def stop(self):
        self.thread.terminate()

class OutputPlugin(Plugin):
    
    def __init__(self):
        OUTPUT_MODULES.append(self)
        
    def put(self, data):
        self.output_method(data)

class TaskPlugin(Plugin):
    
    def __init__(self):
        OUTPUT_MODULES.append(self)
        
    def put(self, data):
        self.thread = multiprocessing.Process(target=self.output_method, args=(INPUT_QUEUE, data))
        self.thread.start()

##############################################################################
## Importing the modules

CONFIG = os.environ["CONFIG"]
xmldoc = minidom.parseString(CONFIG)
for element in xmldoc.getElementsByTagName("import"):
    module = element.getAttribute("module")
    print "Importing module %s..." % module.upper()
    # Converting attributes to variables
    for attr in element.attributes.items():
        attrName, attrValue = attr[0], attr[1]
        varName = "%s_%s" % (module, attrName)
        locals()[varName.upper()] = attrValue # Example: APPLE_TTS_VOICE

    path1 = "../MODULES/%s/%s.py" % (module,module) # If system module
    path2 = "../../MODULES/%s/%s.py" % (module,module) # If user module
    if os.path.isfile(path1): execfile(path1)
    elif os.path.isfile(path2): execfile(path2)
    else: ERROR("ERROR: Module %s does not exist" % module)
    
##############################################################################
## Main loop

setTermTitle("YADE CLIENT")
print "Starting YADE client..."

date = time.strftime('%d/%m/%y %H:%M',time.localtime())
with open("dialogue.log", "a") as file:
	file.write("-------------------------------------- %s --------------------------------------\n" % date)

while True:

    # Starting all the input modules
    for module in INPUT_MODULES: module.start()
    
    # Waiting for something in the queue
    while INPUT_QUEUE.empty(): time.sleep(0.1)
    input = INPUT_QUEUE.get()
    cprint("INPUT: %s" % input, "cyan")
    with open("dialogue.log", "a") as file: file.write("<-- %s\n" % input)
    
    # Stopping all the input modules
    for module in INPUT_MODULES: module.stop()
    
    # Sending the input to the YADE server
    print "Connecting to %s..." % YADE_SERVER
    sock = createSocket(YADE_SERVER)
    sock.sendall(input)
    
    # Getting the server response
    output = sock.recv(1024).rstrip()
    cprint("OUTPUT: %s" % output, "cyan")
    with open("dialogue.log", "a") as file: file.write("--> %s\n" % output)
    sock.close()
    
    # Catching some exceptions
    if output == "EXIT": break # The server returns "EXIT"
    if output == "PASS": continue # The server returns "PASS"
    if output.find("ERROR") > -1: ERROR(output) # The response contains "ERROR"
    
    # Sending the response to all the output modules
    for module in OUTPUT_MODULES: module.put(output)
    
    # The input must not come from the system (ex: [noresult] from the database module)
    if YADEVIZ_FLAG == "TRUE" and not re.search("\[.*\]", input):
        os.system(YADEVIZ)
        os.system(RAISE)

##############################################################################

for module in INPUT_MODULES: module.kill()
for module in OUTPUT_MODULES: module.kill()

##############################################################################
