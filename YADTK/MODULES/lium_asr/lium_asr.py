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
import subprocess
import traceback
import urllib

execfile("../MODULES/lium_asr/wsclient.py")
execfile("../MODULES/lium_asr/parsegst.py")

AUDIOFILE1 = "../MODULES/lium_asr/_audio.flac"
AUDIOFILE2 = "../MODULES/lium_asr/_audio.wav"

##############################################################################
## Checking global variables

try: LIUM_ASR_SERVER
except: LIUM_ASR_SERVER = "localhost:8888"

try: LIUM_ASR_ENERGY
except: LIUM_ASR_ENERGY = 150

try: LIUM_ASR_PAUSE
except: LIUM_ASR_PAUSE = 0.5

try: LIUM_ASR_TIMEOUT
except: LIUM_ASR_TIMEOUT = None

print "   LIUM_ASR_SERVER = %s" % LIUM_ASR_SERVER
print "   LIUM_ASR_ENERGY = %s" % LIUM_ASR_ENERGY
print "   LIUM_ASR_PAUSE = %s" % LIUM_ASR_PAUSE
print "   LIUM_ASR_TIMEOUT = %s" % LIUM_ASR_TIMEOUT

##############################################################################
## LIUM speech recognition service

import speech_recognition as speech

# https://pypi.python.org/pypi/SpeechRecognition/
# recognizer_instance.adjust_for_ambient_noise(source, duration = 1)

MICROPHONE = speech.Recognizer()
MICROPHONE.energy_threshold = LIUM_ASR_ENERGY # Energy level threshold, typical values are between 150 and 3500
MICROPHONE.pause_threshold = LIUM_ASR_PAUSE # Minimum length of silence that will register as the end of a phrase

class LiumInput(InputPlugin):
    
    def input_method(self, queue):
        try:
            print "Listening..."
            with speech.Microphone() as source:
                audio = MICROPHONE.listen(source, timeout=None)
                with open(AUDIOFILE1, 'w') as file: file.write(audio.data)
                subprocess.call("flac -f -d %s 2>/dev/null" % AUDIOFILE1, shell=True)        
                      
            print "Recognizing..."
            ws = MyClient(AUDIOFILE2, "ws://%s/client/ws/speech?%s" % (LIUM_ASR_SERVER, urllib.urlencode([("content-type", '')])), byterate=32000)
            ws.connect()
            result = ws.get_full_hyp()
            #input = parseGstPluginV2(result)
            input = mystring = result.replace('\n', ' ').replace('\r', '').rstrip().lstrip()
            print "Get [%s]" % input
            if input == "": input = "_empty_"
            queue.put(input.encode("utf-8"))
            os.remove(AUDIOFILE1)
            os.remove(AUDIOFILE2)
        
        except Exception as e:
            if str(e).find("TimeoutError"):
                cprint("Timeout (%ss)" % LIUM_ASR_TIMEOUT, "red")
                queue.put("[timeout:%s]" % LIUM_ASR_TIMEOUT)
            else:
                cprint(type(e), "red")
                cprint(e, "red")
                queue.put("[error:unknown]")

##############################################################################

LiumInput()
