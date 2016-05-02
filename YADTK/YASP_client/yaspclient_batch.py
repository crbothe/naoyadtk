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

import sys, os
import socket
import codecs
import re

from xml.dom import minidom
from datetime import datetime

# http://www.binpress.com/tutorial/manipulating-pdfs-with-python/167
from PyPDF2 import PdfFileMerger, PdfFileReader

sys.path.append("../COMMON/python")
from utils import *

YADTK = os.environ["YADTK"]
YASP_SERVER = os.environ["YASP_SERVER"]
INPUT = os.environ["INPUT"]
PDF = os.environ["PDF"]
OUTPUT = "%s_results.xml" % os.path.splitext(INPUT)[0]
PDFOUT = "%s.pdf" % os.path.splitext(OUTPUT)[0]
STATS = "%s.stats" % os.path.splitext(OUTPUT)[0]

if not os.path.isabs(INPUT):
	INPUT = "%s/%s" % (YADTK, INPUT)
	OUTPUT = "%s/%s" % (YADTK, OUTPUT)
	PDFOUT = "%s/%s" % (YADTK, PDFOUT)
	STATS = "%s/%s" % (YADTK, STATS)

##############################################################################

setTermTitle("YASP CLIENT")
print "Starting YASP batch client..."
print "Base folder :", YADTK
print "Input file  :", INPUT
print "Output file :", OUTPUT
print "PDF output  :", PDFOUT
print "Stat output :", STATS
raw_input("Type [enter] to start the batch")
T0 = datetime.now()

input = open(INPUT, "r")
output = codecs.open(OUTPUT, "w", "utf-8")
print >>output, '<?xml version="1.0" encoding="UTF-8"?>'
print >>output, "<output>"

if PDF == "TRUE": merger = PdfFileMerger() # For G-structures output

i = 1
e = 0

while True:
    line = input.readline()
    if not line: break
    if line == '\n': continue
    line = line.strip()
    if re.match("^_stop_", line): break
    
    #xmldoc = minidom.parseString(line)
    #text = xmldoc.firstChild.firstChild.nodeValue.encode("utf-8")
    text = line
    
    print "%d: %s" % (i, text)
    i = i + 1
    
    sock = createSocket(YASP_SERVER)
    sock.sendall(text)
    tmp = codecs.open("yaspviz/_tmp.xml", "w", "utf-8") # For G-structures output
    
    resultat = ""
    for line in readlines(sock): resultat += "\n"+line
    
    try: # To avoid strange encoding errors
        resultat = resultat.decode("utf-8")
    except:
        cprint("ENCODING ERROR", "red")
        resultat = ""
        e = e + 1
    finally:
        print >>output, resultat
        print >>tmp, resultat        
    
    sock.close()
    tmp.close() # For G-structures output
        
    ##############################################################################
    # For G-structures output
    if PDF == "TRUE":
        os.system("xsltproc -o yaspviz/_tmp.dot yaspviz/yaspviz.xsl yaspviz/_tmp.xml")
        os.system("dot -Gratio=auto -Tpdf yaspviz/_tmp.dot -o yaspviz/_tmp.pdf")
        merger.append(PdfFileReader(open("yaspviz/_tmp.pdf", "rb")))
    ##############################################################################

print >>output, "\n</output>"
output.close()

if e > 0: cprint("ENCODING ERRORS: %s" % e, "red")

T1 = datetime.now()

if PDF == "TRUE":
    cprint("Generating %s please wait..." % PDFOUT, "green")
    merger.write(PDFOUT) # For G-structures output

T2 = datetime.now()

##############################################################################
# Statistics

cprint("Generating %s please wait..." % STATS, "green")
os.system("xsltproc yaspstats/stats1.xsl %s > _tmp.xml" % OUTPUT)
os.system("xsltproc yaspstats/stats2.xsl _tmp.xml > %s" % STATS)
os.system("xsltproc yaspstats/stats3.xsl %s >> %s" % (OUTPUT, STATS))
cprint("It's OK!", "green")

##############################################################################

T3 = datetime.now()

print "Parsing time    : %s" % str(T1-T0)
print "Generating PDF  : %s" % str(T2-T1)
print "Statistics      : %s" % str(T3-T2)
