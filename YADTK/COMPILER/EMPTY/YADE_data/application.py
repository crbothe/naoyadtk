
# This is a user-function defined in Python:

def bar(str):
	return "Hello %s" % str

clips.RegisterPythonFunction(bar)
clips.BuildFunction("bar", "?str", "(python-call bar ?str)")
