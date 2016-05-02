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
from Tkinter import *

CURRENT_DIR = os.path.dirname(__file__)
FILENAME = "%s/_cmd" % CURRENT_DIR

YADTK_FOLDER = os.environ["YADTK"]
POSITION = os.environ["POSITION"]
DATA = os.environ["DATA"]

def ctrl_send(command):
    with open(FILENAME, "w") as file:
        file.write(command)

def ctrl_compile():
    os.system("%s/compiler.bash %s" % (YADTK_FOLDER, DATA))

def ctrl_reload():
    ctrl_send("_reload")

def ctrl_reset():
    ctrl_send("_reset")

def ctrl_compileReload():
    ctrl_compile()
    ctrl_reload()

def ctrl_exit():
    ctrl_send("_exit")
    window.destroy()

window = Tk()
window.wm_attributes("-topmost", 1) # Toujours au-dessus
window.title("YADTK Control Panel")
window.geometry(POSITION)

button1 = Button(window, text="Compile", command=ctrl_compile)
button1.pack(side=LEFT)

button2 = Button(window, text="Relolad", command=ctrl_reload)
button2.pack(side=LEFT)

button3 = Button(window, text="Compile + Reload", command=ctrl_compileReload)
button3.pack(side=LEFT)

button4 = Button(window, text="Reset", command=ctrl_reset)
button4.pack(side=LEFT)

button5 = Button(window, text="Exit", command=ctrl_exit)
button5.pack(side=LEFT)

window.mainloop()
