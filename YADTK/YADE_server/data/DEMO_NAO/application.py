
def getcolor():
	return "black"

clips.RegisterPythonFunction(getcolor)
clips.BuildFunction("get-color", "", "(python-call getcolor)")

def getRelatedWord():
	return "boy"

clips.RegisterPythonFunction(getcolor)
clips.BuildFunction("get-relatedWord", "", "(python-call getRelatedWord)")





