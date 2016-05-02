# coding: utf-8

import re

# Access the nao functions connecting files
execfile("/export/home/sysadmin/crb/yadtk/YADTK/MODULES/naoqi/naoqi.py")
execfile("/export/home/sysadmin/crb/yadtk/YADTK/MODULES/naoqi/nao_commands.py")
#execfile("/export/home/sysadmin/crb/yadtk/YADTK/MODULES/naoqi/nao_intelectual.py")
#execfile("/export/home/sysadmin/crb/yadtk/YADTK/MODULES/naoqi/nao_loops.py")

##############################################################################
## Nao output plugin

class NaoOutput(OutputPlugin):
    
    def output_method(self, data):
        # For example the YADE action is <speak text="Ok man, I can do that [nao:walk]"/>
        # Suppressing the command tags in the text
        tosay = re.sub(r"\[[^\]]*\]","", data)
        #cprint(tosay, "red")
        #from naoqi import ALProxy
        #global robotIP, PORT
        #tts = ALProxy("ALTextToSpeech", robotIP, PORT)
        # Sending the text to the Nao's TTS (cf. nao_commands.py)
        talk(tosay)
        #tts.setVolume(0.3)
        #tts.say(tosay)
        # Searching for a Nao command tag in text
        result = re.search("\[nao:([A-Za-z_]*)\]", data)

        if result:
            # Executing the action if there is one
            command = result.group(1)
            if   command == "standup":        standup()        #1 
            elif command == "sitdown":        sitdown()        #2
            elif command == "turnLeft":       turnLeft()       #3
            elif command == "turnRight":      turnRight()      #4
            elif command == "turnAround":     turnAround()     #5
            elif command == "walkForward":    walkForward()    #6
            elif command == "walkBackward":   walkBackward()   #7
            elif command == "walkRight":      walkRight()      #8
            elif command == "walkLeft":       walkLeft()       #9
            elif command == "getNumber":      getNumber()      #10
            elif command == "relax":          relax()          #11
            elif command == "turnLeftWalk":   turnLeftWalk()   #12
            elif command == "turnRightWalk":  turnRightWalk()  #13

	    # get relation
            elif command == "getRelation":    getRelation()    #13


	    elif command == "findwall":
		x = detectWall("left")
		print x 					   #14
	    elif command == "movetowall":       moveToWall(x)      #15
	    elif command == "findfirstwall":  x = findReqWall("FirstWall", "front")      #16
	    elif command == "findsecondwall":  x = findReqWall("SecondWall", "front")    #17
	    elif command == "findthirdwall":  x = findReqWall("ThirdWall", "front")      #18
	
            global x
##############################################################################

NaoOutput()
