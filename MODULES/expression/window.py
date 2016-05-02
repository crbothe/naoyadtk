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
FILENAME = "%s/_tmp" % CURRENT_DIR
POSITION = os.environ["POSITION"]

# with open("_pid", "w") as file: file.write(str(os.getpid()))

# Getting the face name
with open(FILENAME, "r") as file:
    FACE = file.read()

def reset_image():
    label.config(image=neutral)

def change_image(img):
    global after_id
    label.config(image=img)
    if after_id is not None:
        window.after_cancel(after_id)
        after_id = None
    after_id = window.after(3000, reset_image)

def check_event():
    global img # Required to keep a reference to the image
    try:            
        with open(FILENAME, "r") as file: name = file.read()
        if name == "kill":
            os.remove(FILENAME)
            window.destroy()
        else:
            os.remove(FILENAME)
            fileName = "%s/%s/%s.gif" % (CURRENT_DIR, FACE, name)
            img = PhotoImage(file=fileName)
            change_image(img)
    except: pass    
    window.after(100, check_event)

window = Tk()
window.title("YADTK — %s" % FACE.upper())
window.geometry(POSITION)

neutral = PhotoImage(file="%s/%s/neutral.gif" % (CURRENT_DIR, FACE))
label = Label(window, image=neutral)
label.pack()

after_id = None
check_event()
window.mainloop()

##############################################################################
