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
import clips
import time

from termcolor import colored, cprint

sys.path.append("../COMMON/python")
from utils import *

def python__Load(filename):
    absPath = os.path.abspath(filename)
    print "Loading %s..." % absPath
    try:
        execfile(filename)
    except IOError:
        writeError("\nERROR: Could not open %s" % absPath)
        exit()

def clips__Load(filename):
    absPath = os.path.abspath(filename)
    print "Loading %s..." % absPath
    try:
        clips.Load(filename)
    except IOError:
        writeError("\nERROR: Could not open %s" % absPath)
        exit()
    except clips.ClipsError:
        writeError(clips.ErrorStream.Read())
        exit()

def clips__Call(function, args=""):
    try:
        clips.Call(function, args)
    except clips.ClipsError:
        writeError(clips.ErrorStream.Read())
        exit()

def clips__Focus(module):
    try:
        clips.Eval("(focus %s)" % module)
    except clips.ClipsError:
        writeError(clips.ErrorStream.Read())
        exit()

def clips__Assert(fact):
    try:
        clips.Assert(fact)
    except clips.ClipsError:
        writeError(clips.ErrorStream.Read())
        exit()

def clips__Run():
    clips.Run()
    try:
        errors = clips.ErrorStream.Read()
        errors = "\n%s" % errors.rstrip()
        writeError(errors)
        beep()
        return False
    except:
        return True

##############################################################################
## Some CLIPS user functions
## Think to put their prototypes in file compyade.bat !!
##############################################################################

def registerUserFunction(name):
    exec "clips.RegisterPythonFunction(%s)" % name

def getSystemDate(format):
    # https://docs.python.org/2/library/time.html
    return time.strftime(format, time.gmtime())
clips.RegisterPythonFunction(getSystemDate)
clips.BuildFunction("getSystemDate", "?format", "(return (python-call getSystemDate ?format))")

def getVarEnv(variable):
    return os.environ[variable]
clips.RegisterPythonFunction(getVarEnv)
clips.BuildFunction("getVarEnv", "?var", "(return (python-call getVarEnv ?var))")

def pythonRegexp(expr, chaine):
    p = re.compile(expr)
    res = p.match(chaine)
    if res: return clips.Symbol("TRUE")
    return clips.Symbol("FALSE")
clips.RegisterPythonFunction(pythonRegexp)
clips.BuildFunction("pythonRegexp", "?expr ?chaine", "(return (python-call pythonRegexp ?expr ?chaine))")

def pythonRegexpGroup(expr, chaine, indice):
    p = re.compile(expr)
    res = p.match(chaine)
    return res.group(indice)
clips.RegisterPythonFunction(pythonRegexpGroup)
clips.BuildFunction("pythonRegexpGroup", "?expr ?chaine ?indice", "(return (python-call pythonRegexpGroup ?expr ?chaine ?indice))")

def writeLog(texte):
    def colorize(texte):
        # Pour mettre les granules en vert
        return re.sub(r"(\[[^\]]*\]#[0-9]*)","%s\\1%s" % (LIGHTGREEN,RESET), texte)
    texte = colorize(texte)
    print(texte)
clips.RegisterPythonFunction(writeLog)
clips.BuildFunction("writeLog", "?str", "(python-call writeLog ?str)")

def writeLog2(texte):
    sys.stdout.write(texte)
clips.RegisterPythonFunction(writeLog2)
clips.BuildFunction("writeLog2", "?str", "(python-call writeLog2 ?str)")

def writeTitle(texte):
    title(texte)
clips.RegisterPythonFunction(writeTitle)
clips.BuildFunction("writeTitle", "?str", "(python-call writeTitle ?str)")

def writeError(texte):
    cprint("\n%s\n" % texte, "white", "on_red")
clips.RegisterPythonFunction(writeError)
clips.BuildFunction("writeError", "?str", "(python-call writeError ?str)")
    
def writeAllFacts():
    title("CLIPS facts")
    clips.PrintFacts()
clips.RegisterPythonFunction(writeAllFacts)
clips.BuildFunction("writeAllFacts", "", "(python-call writeAllFacts)")

def writeFacts(start):
    title("CLIPS facts from %s" % start)
    clips.Eval("(facts %s)" % start)
    print clips.DisplayStream.Read()
clips.RegisterPythonFunction(writeFacts)
clips.BuildFunction("writeFacts", "?start", "(python-call writeFacts ?start)")

def writeTrace():
    title("Trace des inférences")
    print clips.TraceStream.Read(),
clips.RegisterPythonFunction(writeTrace)
clips.BuildFunction("writeTrace", "", "(python-call writeTrace)")

def writeMatches(rule):
    clips.Eval("(matches %s)" % rule)
    print clips.DisplayStream.Read()
clips.RegisterPythonFunction(writeMatches)
clips.BuildFunction("writeMatches", "?str", "(python-call writeMatches ?str)")

##############################################################################

def clipsreload():
    
    clips.RegisterPythonFunction(getSystemDate)
    clips.BuildFunction("getSystemDate", "?format", "(return (python-call getSystemDate ?format))")

    clips.RegisterPythonFunction(getVarEnv)
    clips.BuildFunction("getVarEnv", "?var", "(return (python-call getVarEnv ?var))")

    clips.RegisterPythonFunction(pythonRegexp)
    clips.BuildFunction("pythonRegexp", "?expr ?chaine", "(return (python-call pythonRegexp ?expr ?chaine))")

    clips.RegisterPythonFunction(pythonRegexpGroup)
    clips.BuildFunction("pythonRegexpGroup", "?expr ?chaine ?indice", "(return (python-call pythonRegexpGroup ?expr ?chaine ?indice))")

    clips.RegisterPythonFunction(writeLog)
    clips.BuildFunction("writeLog", "?str", "(python-call writeLog ?str)")

    clips.RegisterPythonFunction(writeLog2)
    clips.BuildFunction("writeLog2", "?str", "(python-call writeLog2 ?str)")

    clips.RegisterPythonFunction(writeTitle)
    clips.BuildFunction("writeTitle", "?str", "(python-call writeTitle ?str)")

    clips.RegisterPythonFunction(writeError)
    clips.BuildFunction("writeError", "?str", "(python-call writeError ?str)")
    
    clips.RegisterPythonFunction(writeAllFacts)
    clips.BuildFunction("writeAllFacts", "", "(python-call writeAllFacts)")

    clips.RegisterPythonFunction(writeFacts)
    clips.BuildFunction("writeFacts", "?start", "(python-call writeFacts ?start)")

    clips.RegisterPythonFunction(writeTrace)
    clips.BuildFunction("writeTrace", "", "(python-call writeTrace)")

    clips.RegisterPythonFunction(writeMatches)
    clips.BuildFunction("writeMatches", "?str", "(python-call writeMatches ?str)")

