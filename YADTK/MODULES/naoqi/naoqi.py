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

# http://doc.aldebaran.com/2-1/dev/python/install_guide.html"
# http://doc.aldebaran.com/2-1/getting_started/helloworld_python.html

##############################################################################
## Checking global variables

try: NAOQI_ROBOT
except: ERROR("ERROR: You must specify an address for the Nao robot")

try: NAOQI_LANG
except: NAOQI_LANG = "English"

try: NAOQI_VOLUME
except: NAOQI_VOLUME = 0.5

print "   NAOQI_ROBOT = %s" % NAOQI_ROBOT
print "   NAOQI_LANG = %s" % NAOQI_LANG
print "   NAOQI_VOLUME = %s" % NAOQI_VOLUME

(_host_,_port_) = re.match("(.*):(.*)", NAOQI_ROBOT).groups()
robotIP = str(_host_)
robotPORT = int(_port_)

##############################################################################
## Creating some Python proxies

try:
    from naoqi import ALProxy
except Exception, e:
    cprint("Error when importing naoqi Python module", "white", "on_red")
    print str(e)
    os._exit(1)

try:
    TTS = ALProxy("ALTextToSpeech", robotIP, robotPORT)
    TTS.setLanguage(NAOQI_LANG)
    TTS.setVolume(NAOQI_VOLUME)
except Exception, e:
    cprint("Error when creating ALTextToSpeech proxy", "white", "on_red")
    print str(e)
    os._exit(1)

try:
    MOTION = ALProxy("ALMotion", robotIP, robotPORT)
    MOTION.stiffnessInterpolation("Body", 1.0, 1.0)
except Exception, e:
    cprint("Error when creating ALMotion proxy", "white", "on_red")
    print str(e)
    os._exit(1)

try:
    POSTURE = ALProxy("ALRobotPosture", robotIP, robotPORT)
except Exception, e:
    cprint("Error when creating ALRobotPosture proxy", "white", "on_red")
    print str(e)
    os._exit(1)

try:
    memoryProxy = ALProxy("ALMemory", robotIP, robotPORT)
except Exception, e:
    cprint("Error when creating ALMemory proxy", "white", "on_red")
    print str(e)
    os._exit(1)

try:
    sonarProxy = ALProxy("ALSonar", robotIP, robotPORT)
except Exception, e:
    cprint("Error when creating ALSonar proxy", "white", "on_red")
    print str(e)
    os._exit(1)

try:
    camProxy = ALProxy("ALVideoDevice", robotIP, robotPORT)
except Exception, e:
    cprint("Error when creating ALVideoDevice proxy", "white", "on_red")
    print str(e)
    os._exit(1)

##############################################################################
## Importing the module's definitions

execfile("/export/home/sysadmin/crb/yadtk/YADTK/MODULES/naoqi/nao_commands.py")
#execfile("/export/home/sysadmin/crb/yadtk/YADTK/MODULES/naoqi/nao_intelectual.py")
#execfile("/export/home/sysadmin/crb/yadtk/YADTK/MODULES/naoqi/findingWall.py")
#execfile("modules/naoqi/nao_loops.py")

##############################################################################
