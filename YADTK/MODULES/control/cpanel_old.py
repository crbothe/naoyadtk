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

import os
import socket

from utils import *
from Tkinter import *

DATA = os.environ["DATA"]
POSITION = os.environ["POSITION"]

try: YADE_SERVER = os.environ["YADE_SERVER"]
except: YADE_SERVER = False

try: YASP_SERVER = os.environ["YASP_SERVER"]
except: YASP_SERVER = False

try: YAGE_SERVER = os.environ["YAGE_SERVER"]
except: YAGE_SERVER = False

if YADE_SERVER: server = YADE_SERVER
elif YASP_SERVER: server = YASP_SERVER
elif YAGE_SERVER: server = YAGE_SERVER
else: ERROR("ERROR: No server configured")

def send(command):
    sock = createSocket(server)
    sock.sendall(command)
    sock.recv(1024)
    sock.close()

def compile():
    os.system("./compiler.bash %s" % DATA)

def reload():
    send("_reload")

def compileReload():
    compile()
    reload()

def reset():
    send("_reset")
    
def exit():
    try: send("_exit")
    except: pass
    with open("_pid", "r") as file: pid = file.read()
    os.system("rm _pid")
    os.system("kill -9 %s" % pid)
    window.destroy()

window = Tk()
window.title("YADTK Control Panel")
window.geometry(POSITION)

buttonCompile = Button(window, text="Compile", command=compile)
buttonCompile.pack(side=LEFT)

buttonReload = Button(window, text="Relolad", command=reload)
buttonReload.pack(side=LEFT)

buttonReload = Button(window, text="Compile+Reload", command=compileReload)
buttonReload.pack(side=LEFT)

buttonReset = Button(window, text="Reset", command=reset)
buttonReset.pack(side=LEFT)

buttonExit = Button(window, text="Exit", command=exit)
buttonExit.pack(side=LEFT)

window.mainloop()
