# Recognize speech using Google Speech Recognition
# https://pypi.python.org/pypi/SpeechRecognition/

# This requires PyAudio because it uses the Microphone class
# http://people.csail.mit.edu/hubert/pyaudio/

# Ensure that you have the flac command line tool
# https://xiph.org/flac/download.html

# The Google Speech Recognition API key is specified by key
# If not specified, it uses a generic key that works out of the box
# WARNING: THE GENERIC KEY IS INTENDED FOR TESTING AND PERSONAL PURPOSES ONLY
# IT MAY BE REVOKED BY GOOGLE IN THE FUTURE

##############################################################################

import speech_recognition as speech

reco = speech.Recognizer(language = "fr-FR") # en-US or fr-FR
reco.energy_threshold = 100 # Energy level threshold, typical values are between 150 and 3500
reco.pause_threshold = 0.5 # Minimum length of silence that will register as the end of a phrase

while True:
    with speech.Microphone() as source:
        try:
            print("Listen...")
            audio = reco.listen(source, timeout = 3)
            try:
                print("Recognize...")
                result = reco.recognize(audio, show_all = False)
                print("You said \"%s\"" % result)
            
            except IndexError: print("ERROR: No internet connection")
            except KeyError: print("ERROR: Invalid API key or quota maxed out")
            except LookupError: print("ERROR: Could not understand audio")          
        
        except Exception as err:
            if str(err).find("TimeoutError"):
                print("Timeout 3 seconds")
            else:
                print(err)

##############################################################################
