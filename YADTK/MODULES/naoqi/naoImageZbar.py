# -*- encoding: UTF-8 -*-
# Get an image from NAO. Display it and save it using PIL.

from sys import argv
from naoqi import ALProxy
import zbar
import Image
import sys
import time

IP = "192.168.0.14"  # Replace here with your NaoQi's IP address.
PORT = 9559

"""
First get an image from Nao, then show it on the screen with PIL.
"""
motionProxy = ALProxy("ALMotion", IP, PORT)
camProxy = ALProxy("ALVideoDevice", IP, PORT)
posture = ALProxy("ALRobotPosture", IP, PORT) # Allows the robot to speak
memoryProxy = ALProxy("ALMemory", IP, PORT)
sonarProxy = ALProxy("ALSonar", IP, PORT)

def getImage():
	global camProxy
	resolution = 2    # VGA
	colorSpace = 11   # RGB
	videoClient = camProxy.subscribe("python_client", resolution, colorSpace, 5)
	#t0 = time.time()
	# Get a camera image.
	# image[6] contains the image data passed as an array of ASCII chars.
	naoImage = camProxy.getImageRemote(videoClient)
	#t1 = time.time()
	# Time the image transfer.
	#print "acquisition delay ", t1 - t0
	camProxy.unsubscribe(videoClient)

	# Get the image size and pixel array.
	imageWidth = naoImage[0]
	imageHeight = naoImage[1]
	array = naoImage[6]

	# Create a PIL Image from our pixel array.
	im = Image.fromstring("RGB", (imageWidth, imageHeight), array)

	# Save the image.
	im.save("camImage.png", "PNG")
	#im.show()
	
def scanqr():
	####################################
	# Scanning image for reading QR code
	#if len(argv) < 2: exit(1)
	# create a reader
	scanner = zbar.ImageScanner()

	# configure the reader
	scanner.parse_config('enable')

	# obtain image data
	pil = Image.open("camImage.png").convert('L')
	width, height = pil.size
	raw = pil.tostring()

	# wrap image data
	image = zbar.Image(width, height, 'Y800', raw)

	# scan the image for barcodes
	scanner.scan(image)
	# extract results
	for symbol in image:
	# do something useful with results
		sym = symbol.data
		#print 'decoded', symbol.type, 'symbol', '"%s"' % symbol.data
		#print sym
		return sym
	# clean up
	del(image)

# Function to detect the obstacle minimum distance is minDist
def detectObsStop(minDist):
	while True:
		# Subscribe to sonars, this will launch sonars (at hardware level)
		# and start data acquisition.
		sonarProxy.subscribe("myApplication")
		# Now you can retrieve sonar data from ALMemory.
		# Get sonar left and right first echo (distance in meters to the first obstacle).
		l=memoryProxy.getData("Device/SubDeviceList/US/Left/Sensor/Value")
		r=memoryProxy.getData("Device/SubDeviceList/US/Right/Sensor/Value")
		# Unsubscribe from sonars, this will stop sonars (at hardware level)
		sonarProxy.unsubscribe("myApplication")
		#minDist = 0.4
		#print "getting data"
		if l < minDist or r < minDist:
			#enable = False
			#return True
			motionProxy.setWalkTargetVelocity(0.0, 0.0, 0.0, 0.0)
			#talk("Oh there is obstacle")
			#queue.put("right_left_question")
			break
		time.sleep(0.05)	
		
				
def frange(start, stop, step):
        i = start
        while i < stop:
            yield i
            i += step
            
def showNaoImage(findWall, direction):
	
	if direction == "right":
		right = 1.6
		left  = 0.0
	elif direction == "left":
		right = 0.0
		left  = 1.6
	elif direction == "front":
		right = 1.6
		left  = 1.6
	elif direction == "straight":
		right = 0.4
		left  = 0.4
	
	global camProxy, motionProxy, posture, memoryProxy, sonarProxy
	motionProxy.stiffnessInterpolation("Body", 1.0, 1.0)
	motionProxy.setAngles("HeadPitch", 0.0, 1.0)
	motionProxy.setAngles("RHand", 0.0, 0.5)
	motionProxy.setAngles("RShoulderPitch", 0.4, 0.2)

	for xx in frange(-right, left, 0.2):
#	print xx
		motionProxy.setAngles("HeadYaw", xx, 0.9)
		
		# Get image from nao camera
		getImage()
		
		# Scan image for reading QR code
		sym = scanqr()
		print sym
		if sym == findWall:
			print "Found required wall"
			if xx <= 0.0:
				motionProxy.setAngles("RShoulderPitch", 0.2, 0.4)
				motionProxy.setAngles("RShoulderRoll", xx, 0.4)
				motionProxy.setAngles("RHand", 0.7, 0.2)
			elif xx > 0.0:
				motionProxy.setAngles("LShoulderPitch", 0.2, 0.7)
				motionProxy.setAngles("LShoulderRoll", xx, 0.7)
				motionProxy.setAngles("LHand", 0.7, 0.7)
			motionProxy.setAngles("HeadYaw", 0.0, 0.9)
			if posture.getPostureFamily() != "Standing":
				posture.goToPosture("StandInit", 0.7)
				time.sleep(2)
			motionProxy.moveTo(0.0, 0.0, xx)
			#time.sleep(1*abs(xx))

			motionProxy.setWalkTargetVelocity(1.0, 0.0, 0.0, 1.0)
			
			# Detect obstacle with sonar sensor and stop if it is 0.4m far
			detectObsStop(0.4)
			# put dialog in queue and exit through RETURN statement
			#queue.put("dialogs")
			return 0

	if (xx-left < 0.01) and (sym == None):
		print sym
		print xx
		return "Nothing", xx
	##########################################

	motionProxy.setAngles("HeadYaw", 0.0, 0.4)
	motionProxy.setAngles("RShoulderPitch", 1.1, 1.0)
	time.sleep(0.05)
		
#naoImage = showNaoImage("ThirdWall", "left")
#naoImage = showNaoImage("SecondWall", "left")
naoImage = showNaoImage("FirstWall", "left")
print naoImage

def detectWall(direction):	

	if direction == "right":
		right = 1.6
		left  = 0.2
	elif direction == "left":
		right = 0.2
		left  = 1.6
	elif direction == "front":
		right = 1.6
		left  = 1.6
	elif direction == "straight":
		right = 0.4
		left  = 0.4
		
	global camProxy, motionProxy, posture, memoryProxy, sonarProxy
	motionProxy.stiffnessInterpolation("Body", 1.0, 1.0)
	motionProxy.setAngles("HeadPitch", 0.0, 1.0)
	#motionProxy.setAngles("RHand", 0.0, 0.5)
	#motionProxy.setAngles("RShoulderPitch", 0.4, 0.2)

	for xx in frange(-right, left, 0.2):
		#print "first", xx
		motionProxy.setAngles("HeadYaw", xx, 0.9)
		
		# Get image from nao camera
		getImage()
		
		# Scan image for reading QR code
		sym = scanqr()
		#print "second", xx
		if sym == "FirstWall":
			print sym
			print xx
			return sym, xx
		elif sym == "SecondWall":
			print sym
			print xx
			return sym, xx
		elif sym == "ThirdWall":
			print sym
			print xx
			return sym, xx
	if (xx-left < 0.01) and (sym == None):
		print sym
		print xx
		return "Nothing", xx
		
		
#wallDir = detectWall("straight")
#print wallDir
#print wallDir[0]
#print wallDir[1]

#xx = wallDir[1]

def moveToWall(xx):
	global  camProxy, motionProxy, posture, memoryProxy, sonarProxy
	print xx
	motionProxy.setAngles("HeadYaw", 0.0, 0.9)
	if posture.getPostureFamily() != "Standing":
		posture.goToPosture("StandInit", 0.7)
		time.sleep(2)
	motionProxy.moveTo(0.0, 0.0, xx)

	motionProxy.setWalkTargetVelocity(1.0, 0.0, 0.0, 1.0)
	
	# Detect obstacle with sonar sensor and stop if it is 0.4m far
	detectObsStop(0.4)
	
	return 0
	
#moveToWall(xx)


def test(direction):

	if direction == "right":
		right = 1.6
		left  = 0.2
	elif direction == "left":
		right = 0.2
		left  = 1.6
	elif direction == "front":
		right = 1.6
		left  = 1.6
	elif direction == "straight":
		right = 0.4
		left  = 0.4
		
	for xx in frange(-right, left, 0.2):
		print xx, left	

	print xx-left
	if (xx-left) < 0.01:
		print "exit"
		
#test("left")
