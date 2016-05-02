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
import codecs
import time
import multiprocessing

##############################################################################
## Checking global variables

try: GOOGLE_ASR_LANG
except: GOOGLE_ASR_LANG = "fr"

try: GOOGLE_ASR_ENERGY
except: GOOGLE_ASR_ENERGY = 150

try: GOOGLE_ASR_PAUSE
except: GOOGLE_ASR_PAUSE = 0.5

try: GOOGLE_ASR_TIMEOUT
except: GOOGLE_ASR_TIMEOUT = None

print "   GOOGLE_ASR_LANG = %s" % GOOGLE_ASR_LANG
print "   GOOGLE_ASR_ENERGY = %s" % GOOGLE_ASR_ENERGY
print "   GOOGLE_ASR_PAUSE = %s" % GOOGLE_ASR_PAUSE
print "   GOOGLE_ASR_TIMEOUT = %s" % GOOGLE_ASR_TIMEOUT

##############################################################################
## Google speech recognition API

import speech_recognition as speech

# https://pypi.python.org/pypi/SpeechRecognition/
# recognizer_instance.adjust_for_ambient_noise(source, duration = 1)

GOOGLE_ASR = speech.Recognizer(language = GOOGLE_ASR_LANG.encode("utf-8")) # Language code for google voice recognition API
GOOGLE_ASR.energy_threshold = GOOGLE_ASR_ENERGY # Energy level threshold, typical values are between 150 and 3500
GOOGLE_ASR.pause_threshold = GOOGLE_ASR_PAUSE # Minimum length of silence that will register as the end of a phrase

class GoogleInput(InputPlugin):
    
    def input_method(self, queue):
        try:
            print "Listening..."
            with speech.Microphone() as source:
                audio = GOOGLE_ASR.listen(source, timeout=GOOGLE_ASR_TIMEOUT)
        
            try:
                print "Recognizing..."
                input = GOOGLE_ASR.recognize(audio)
                print "Get [%s]" % input
                if input == "": input = "_empty_"
                queue.put(input.encode("utf-8"))
            
            except IndexError:
                cprint("No internet connection", "red")
                queue.put("[error:internet]")
                            
            except KeyError:
                cprint("Invalid API key or quota maxed out", "red")
                queue.put("[error:apikey]")
            
            except LookupError:
                cprint("Could not understand audio", "red")
                queue.put("[error:audio]")
        
        except Exception as err:
            if str(err).find("TimeoutError"):
                cprint("Timeout (%ss)" % GOOGLE_ASR_TIMEOUT, "red")
                queue.put("[timeout:%s]" % GOOGLE_ASR_TIMEOUT)
            else:
                cprint(type(err), "red")
                cprint(err, "red")
                queue.put("[error:unknown]")

##############################################################################

GoogleInput()
