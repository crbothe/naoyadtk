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

# Google Speech API supports only 100 characters
# http://hayageek.com/text-to-speech-google-api-php/
# http://cydanil.net/wiki/index.php?title=PyAudio

import os
import re
import urllib2
import pyglet

AUDIOFILE = "../MODULES/google_tts/_audio.mp3"

##############################################################################
## Checking global variables

try: GOOGLE_TTS_LANG
except: GOOGLE_TTS_LANG = "en"

print "   GOOGLE_TTS_LANG = %s" % GOOGLE_TTS_LANG

##############################################################################
## Google TTS plugin

class GoogleOutput(OutputPlugin):
    
    def output_method(self, data):
        
        # Searching a lang command tag
        res = re.search("\[lang:([A-Za-z]*)\]", text)
        if res: lang = res.group(1)
        else: lang = GOOGLE_TTS_LANG

        text = re.sub(r"\[.*\]","", text) # Supprimer les balises de commande
        text = text.rstrip().replace(" ", "+") # Remplacer les espaces par des +
    
        url = "http://translate.google.com/translate_tts?ie=utf-8&tl=%s&q=%s" % (lang, text)
        hdr = {'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11' }
        req = urllib2.Request(url, headers=hdr)
        flux = urllib2.urlopen(req)
    
        with open(AUDIOFILE, 'wb') as fp:
            while True:
                chunk = flux.read(1024)
                if not chunk: break
                fp.write(chunk)
    
        #os.system("play -q %" % FILENAME)
        song = pyglet.media.load(FILENAME, streaming=False)
        song.play()
        #pyglet.app.run()

##############################################################################

GoogleOutput()
