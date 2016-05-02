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

import socket
import hashlib
import base64
import platform
import webbrowser

##############################################################################
## Checking global variables

try: CHROME_ASR_LANG
except: CHROME_ASR_LANG = "en-US"

print "   CHROME_ASR_LANG = %s" % CHROME_ASR_LANG

##############################################################################
## Starting HTTP server

cprint("   Starting HTTP server on localhost:8000...", "green")
os.system("kill -TERM `ps -ef | grep SimpleHTTPServer | grep -v grep | awk '{print $2}'` &>/dev/null")
os.system("cd ../MODULES/chrome_asr; python -m SimpleHTTPServer &>/dev/null &")

##############################################################################
## Launching Chrome Navigator

system = platform.system()
if system == "Linux": chrome_path = "/usr/bin/google-chrome %s"
if system == "Darwin": chrome_path = "open -a /Applications/Google\ Chrome.app %s"
if chrome_path: webbrowser.get(chrome_path).open("http://localhost:8000/chrome.html?lang=%s" % CHROME_ASR_LANG)

##############################################################################
## Web Socket server functions

shake = "HTTP/1.1 101 Switching Protocols\r\n"
shake += "Upgrade: Websocket\r\n"
shake += "Connection: Upgrade\r\n"

def handshake(hs):
    hslist = hs.split("\r\n")
    msg = hs.split("\r\n\r\n")
    key = ""
    cc = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
    for h in hslist:
        if h.startswith('Sec-WebSocket-Key:'): key = h[19:]
        else: continue
    return base64.b64encode(hashlib.sha1(key+cc).digest())

def send(msg):
    global connection
    resp = bytearray([0b10000001, len(msg)])
    for d in bytearray(msg): resp.append(d)
    connection.sendall(resp)

##############################################################################
## Starting Web Socket server

host = "localhost"
port = 9999

cprint("   Starting WS server on %s:%s..." % (host, port), "green")
sock = socket.socket()
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.bind((host,port))
sock.listen(5)

cprint("   Waiting for client connection...", "green")
connection, client = sock.accept()

while True:
    data = connection.recv(4096)
    if (data):
        shake += "Sec-WebSocket-Accept: " + str(handshake(data)) + "\r\n\r\n"
        connection.send(shake)
        break

##############################################################################
## Chrome speech recognition method

class ChromeInput(InputPlugin):

    def start(self):
        super(ChromeInput, self).start()
        send("START")
    
    def stop(self):
        super(ChromeInput, self).stop()
        send("STOP")
    
    def input_method(self, queue):
        print "Waiting for data..."
        data = connection.recv(4096)
        databyte = bytearray(data)
        datalen = (0x7F & databyte[1])
        if(datalen > 0):
            mask_key = databyte[2:6]
            masked_data = databyte[6:(6+datalen)]
            unmasked_data = [masked_data[i] ^ mask_key[i%4] for i in range(len(masked_data))]
            str_data = str(bytearray(unmasked_data))
        
        queue.put(str_data)

##############################################################################

ChromeInput()
