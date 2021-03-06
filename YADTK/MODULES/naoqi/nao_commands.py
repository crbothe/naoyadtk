# coding: utf-8
##############################################################################
# This file is part of the YADTK Toolkit (Yet Another Dialogue Toolkit)
# Copyright © Jérôme Lehuen 2010-2015 - Jerome.Lehuen@univ-lemans.fr
#
# The fact that you are presently reading this means that you have had
# knowledge of the CeCILL license and that you accept its terms.
##############################################################################
import time


def talk(text):
	global TTS	
	cprint("==> Nao is saying: %s" % text, "green")
	TTS.say(text)

def relax():
	global POSTURE, MOTION
	cprint("==> Nao is relaxing/loosing stiffness...", "green")
	if str(POSTURE.getPostureFamily()) == "Sitting":
		talk("That is very important to save battery.")
	else:
		POSTURE.post.goToPosture("Sit", 1.0)
		talk("That is very important to save battery.")
		time.sleep(5)
	MOTION.stiffnessInterpolation("Body", 0.0, 1.0)

def standup():
	global POSTURE
	if str(POSTURE.getPostureFamily()) == "Standing":
		talk("but, I am already in standing position")
		return ""
	cprint("==> Nao is standing up...", "green")
	POSTURE.post.goToPosture("StandInit", 1.0)
	talk("I am standing.")

def sitdown():
	global POSTURE
	if str(POSTURE.getPostureFamily()) == "Sitting":
		talk("but, I am already in sitting position")
		return ""
	cprint("==> Nao is sitting down...", "green")
	POSTURE.post.goToPosture("Sit", 1.0)
	talk("I am sitting.")

def turnLeft():
	global MOTION, POSTURE
	cprint("==> Nao is turning left...", "green")
	POSTURE.goToPosture("StandInit", 1.0)
	MOTION.post.setWalkTargetVelocity(0.0, 0.0, 1.0, 1.0)
	talk("I am turning left.")
	time.sleep(1.5)
	MOTION.setWalkTargetVelocity(0.0, 0.0, 0.0, 0.0)

def turnRight():
	global MOTION, POSTURE
	cprint("==> Nao is turning right...", "green")
	POSTURE.goToPosture("StandInit", 1.0)
	MOTION.post.setWalkTargetVelocity(0.0, 0.0, -1.0, 1.0)
	talk("I am turning right.")
	time.sleep(1.5)	
	MOTION.setWalkTargetVelocity(0.0, 0.0, 0.0, 0.0)

def turnAround():
	global MOTION, POSTURE
	cprint("==> Nao is turning around...", "green")
	POSTURE.goToPosture("StandInit", 1.0)
	MOTION.post.setWalkTargetVelocity(0.0, 0.0, -1.0, 1.0)
	talk("I am turning around.")
	time.sleep(4)
	MOTION.setWalkTargetVelocity(0.0, 0.0, 0.0, 0.0)

def walkForward():
	global MOTION, POSTURE, memoryProxy, sonarProxy, queue
	cprint("==> Nao is walking forward...", "green")
	POSTURE.goToPosture("StandInit", 1.0)
	MOTION.post.setWalkTargetVelocity(1.0, 0.0, 0.0, 1.0)
	talk("I will stop if there is obstacle.")
	while True:
		time.sleep(0.1)
		# Subscribe to sonars, this will launch sonars (at hardware level)
		# and start data acquisition.
		sonarProxy.subscribe("myApplication")
		# Now you can retrieve sonar data from ALMemory.
		# Get sonar left and right first echo (distance in meters to the first obstacle).
		l=memoryProxy.getData("Device/SubDeviceList/US/Left/Sensor/Value")
		r=memoryProxy.getData("Device/SubDeviceList/US/Right/Sensor/Value")
		# Unsubscribe from sonars, this will stop sonars (at hardware level)
		sonarProxy.unsubscribe("myApplication")
		minDist = 0.5
		if l < minDist or r < minDist:
			MOTION.setWalkTargetVelocity(0.0, 0.0, 0.0, 0.0)
			talk("Oh! there is obstacle")
			#INPUT_QUEUE.put("right_left_question")
			break
	time.sleep(0.2)
	MOTION.setWalkTargetVelocity(0.0, 0.0, 0.0, 0.0)

def walkBackward():
	global MOTION, POSTURE
	cprint("==> Nao is walking backward...", "green")
	POSTURE.goToPosture("StandInit", 1.0)
	MOTION.post.setWalkTargetVelocity(-1.0, 0.0, 0.0, 1.0)
	talk("I am going back.")
	time.sleep(5)
	MOTION.setWalkTargetVelocity(0.0, 0.0, 0.0, 0.0)

def walkRight():
	global MOTION, POSTURE
	cprint("==> Nao is walking right...", "green")
	POSTURE.goToPosture("StandInit", 1.0)
	MOTION.post.setWalkTargetVelocity(0.0, -1.0, 0.0, 1.0)
	talk("I am moving right.")
	time.sleep(5)
	MOTION.setWalkTargetVelocity(0.0, 0.0, 0.0, 0.0)

def walkLeft():
	global MOTION, POSTURE
	cprint("==> Nao is walking left...", "green")
	POSTURE.goToPosture("StandInit", 1.0)
	MOTION.post.setWalkTargetVelocity(0.0, 1.0, 0.0, 1.0)
	talk("I am moving left.")
	time.sleep(5)
	MOTION.setWalkTargetVelocity(0.0, 0.0, 0.0, 0.0)


def turnLeftWalk():
	global MOTION, POSTURE, sonarProxy, memoryProxy
	cprint("==> Nao is turning left...", "green")
	POSTURE.goToPosture("StandInit", 1.0)
	MOTION.post.setWalkTargetVelocity(0.0, 0.0, 0.7, 1.0)
	time.sleep(2)
	MOTION.setWalkTargetVelocity(1.0, 0.0, 0.0, 1.0)
	while True:
		time.sleep(0.1)
		# Subscribe to sonars, this will launch sonars (at hardware level)
		# and start data acquisition.
		sonarProxy.subscribe("myApplication")
		# Now you can retrieve sonar data from ALMemory.
		# Get sonar left and right first echo (distance in meters to the first obstacle).
		l=memoryProxy.getData("Device/SubDeviceList/US/Left/Sensor/Value")
		r=memoryProxy.getData("Device/SubDeviceList/US/Right/Sensor/Value")
		# Unsubscribe from sonars, this will stop sonars (at hardware level)
		sonarProxy.unsubscribe("myApplication")
		minDist = 0.5
		if l < minDist or r < minDist:
			MOTION.setWalkTargetVelocity(0.0, 0.0, 0.0, 0.0)
			talk("Oh there is again an obstacle")
			break

def turnRightWalk():
	global MOTION, POSTURE, sonarProxy, memoryProxy
	cprint("==> Nao is turning right...", "green")
	POSTURE.goToPosture("StandInit", 1.0)
	MOTION.post.setWalkTargetVelocity(0.0, 0.0, -0.7, 1.0)
	talk("I am turning right.")
	time.sleep(2)	
	MOTION.setWalkTargetVelocity(1.0, 0.0, 0.0, 1.0)
	while True:
		time.sleep(0.1)
		# Subscribe to sonars, this will launch sonars (at hardware level)
		# and start data acquisition.
		sonarProxy.subscribe("myApplication")
		# Now you can retrieve sonar data from ALMemory.
		# Get sonar left and right first echo (distance in meters to the first obstacle).
		l=memoryProxy.getData("Device/SubDeviceList/US/Left/Sensor/Value")
		r=memoryProxy.getData("Device/SubDeviceList/US/Right/Sensor/Value")
		# Unsubscribe from sonars, this will stop sonars (at hardware level)
		sonarProxy.unsubscribe("myApplication")
		minDist = 0.5
		if l < minDist or r < minDist:
			MOTION.setWalkTargetVelocity(0.0, 0.0, 0.0, 0.0)
			talk("Oh there is again an obstacle")
			break

def getNumber():
	#global input 
	pass

import re



def getanology(second, first, third):
	import word2vec
	# Import the word2vec binary file: dataset
	model = word2vec.load('/export/home/sysadmin/text8.bin')

	# We can do simple queries to retreive words related to "word"

	indexes, metrics = model.analogy(pos=[first, third], neg=[second], n=10)

	#model.vocab[indexes]
	related_word = model.vocab[indexes[0]]

	return related_word

def getRelation():
	global input
	#cprint("==> Test okay.", "green")
	import nltk

	sentence = input
	#sentence = 'relation tell me, if man is to king then woman'
	tokens = nltk.word_tokenize(sentence)

	ifIndex   = tokens.index('if')
	toIndex   = tokens.index('to')
	thenIndex = tokens.index('then')

	first  = tokens[ifIndex + 1] 
	second = tokens[toIndex + 1]
	third  = tokens[thenIndex + 1]
	
	resulted = getanology(first, second, third)


	outThis = str('if '+first +' is related to '+ second+ ', then '+ third+ ' probably related to '+  resulted)
	
	talk(outThis)  # relation if man is to king then woman

	cprint(resulted, "green")
	cprint(outThis, "green")
	#print 'if',first, 'is related to', second, 'then', third, 'probably related to',  resulted
