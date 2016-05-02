#!/bin/bash
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

cd $(dirname "$0")
export BASE=$(pwd)
source YADTK/COMMON/bash/utils.bash

# http://www.mattburkedev.com/bash-script-to-delete-mac-extended-attribtues/
xattr-2.7 -r -d com.apple.quarantine YADTK

macos_OK || { ERROR "This script works only on MacOS platforms" ; exit ; }
root_OK || { ERROR "Execute as root: sudo install_macos.bash" ; exit ; }
python_OK || { ERROR "YADTK works on Python 2.7 only" ; exit ; }
command_exists gcc || { ERROR "The gcc compiler is not installed on your machine" ; exit ; }

##############################################################################
# Installing the brew command
##############################################################################

# xcode-select --install
# type -P brew &>/dev/null || ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# sudo chown -R root `which brew`

##############################################################################
# Graphviz toolkit
##############################################################################

if ! command_exists dot
then
	# brew install libtool
	# brew install graphviz
	sudo installer -pkg $BASE/SOFTWARE/graphviz/graphviz-2.36.0.pkg -target /
	# ERROR "The Graphviz toolkit is not installed"
	# WARNING "A Graphviz installer was copied to your desktop => please install it manually"
	# cp $BASE/SOFTWARE/graphviz/graphviz-2.36.0.pkg $HOME/Desktop
	# exit
else
	WARNING "The toolkit Graphviz is already installed"
fi

##############################################################################
# Pyclips Python library
##############################################################################

if [ "$((python -c 'import clips') 2>&1)" ]
then
    TITLE "Installing Pyclips"
    cd $BASE/SOFTWARE/pyclips
    tar -zxvf pyclips-1.0.7.tgz
    cd pyclips
    sudo python setup.py build
    sudo python setup.py install
    cd ..
    rm -r pyclips
else
	WARNING "The library Pyclips is already installed"
fi

[ "$((python -c 'import clips') 2>&1)" ] && ERROR "Pyclips installation failed" && exit

##############################################################################
# Termcolor Python library
##############################################################################

if [ "$((python -c 'import termcolor') 2>&1)" ]
then
	TITLE "Installing Termcolor"
	# sudo pip install termcolor
	cd $BASE/SOFTWARE/termcolor
	tar -xvf termcolor.tar
	cd termcolor-1.1.0
	sudo python setup.py install
	cd ..
	rm -r termcolor-1.1.0
else
	WARNING "The library termcolor is already installed"
fi

[ "$((python -c 'import termcolor') 2>&1)" ] && ERROR "Termcolor installation failed" && exit

##############################################################################
# PyPDF2 Python library
##############################################################################

if [ "$((python -c 'import PyPDF2') 2>&1)" ]
then
	TITLE "Installing PyPDF2"
	# sudo pip install PyPDF2
	cd $BASE/SOFTWARE/pypdf
	tar -zxvf PyPDF2-1.24.tgz
	cd PyPDF2-1.24
	sudo python setup.py install
	cd ..
	rm -r PyPDF2-1.24
else
	WARNING "The library PyPDF2 is already installed"
fi

[ "$((python -c 'import PyPDF2') 2>&1)" ] && ERROR "PyPDF2 installation failed" && exit

##############################################################################
# CLIPS binary
##############################################################################

if [ ! -e $BASE/YADTK/COMMON/bin/clips ]
then
	TITLE "Compiling CLIPS"
	cd $BASE/SOFTWARE/clips
	tar -zxvf clips-6.24.tgz
	cd clips-6.24
	make
	cp clips $BASE/YADTK/COMMON/bin
	cd ..
	rm -r clips-6.24
else
	WARNING "The CLIPS binary is already compiled"
fi

##############################################################################
# POS taggers
##############################################################################

if [ ! -e $BASE/YADTK/YASP_server/tagger/lemmatizer ]
then
	TITLE "Compiling the POS tagger"
	cd $BASE/YADTK/YASP_server/tagger
	gcc -o lemmatizer lemmatizer.c
else
	WARNING "The POS tagger is already compiled"
fi

##############################################################################
# ASR Installation question
##############################################################################

read -p "Do you want to install the ASR libraries (yes/no)? " CONT
[ "$CONT" != "yes" ] && WARNING "Installation completed" && exit

##############################################################################
# Pyaudio Python library
##############################################################################

if [ "$((python -c 'import pyaudio') 2>&1)" ]
then
    # brew install portaudio
	# brew link portaudio
	# sudo pip install pyaudio
	sudo installer -pkg $BASE/SOFTWARE/pyaudio/pyaudio-0.2.8.mpkg -target /
	# ERROR "The Pyaudio library is not installed"
	# WARNING "A Pyaudio installer was copied to your desktop => please install it manually"
	# cp $BASE/SOFTWARE/pyaudio/pyaudio-0.2.8.dmg $HOME/Desktop
	# exit
else
	WARNING "The library Pyaudio is already installed"
fi

[ "$((python -c 'import pyaudio') 2>&1)" ] && ERROR "Pyaudio installation failed" && exit

##############################################################################
# SpeechRecognition Python library
##############################################################################

if [ "$((python -c 'import speech_recognition') 2>&1)" ]
then
	TITLE "Installing SpeechRecognition"
	# sudo pip install SpeechRecognition
	cd $BASE/SOFTWARE/speech
	tar -zxvf SpeechRecognition-1.1.4.tgz
	cd SpeechRecognition-1.1.4
	sudo python setup.py install
	cd ..
	rm -r SpeechRecognition-1.1.4
else
	WARNING "The library SpeechRecognition is already installed"
fi

[ "$((python -c 'import speech_recognition') 2>&1)" ] && ERROR "SpeechRecognition installation failed" && exit

##############################################################################
# WebSocket Python library (for the LIUM ASR plugin)
##############################################################################

if [ "$((python -c 'import ws4py') 2>&1)" ]
then
	TITLE "Installing WebSocket library"
	# sudo pip install ws4py==0.3.2
	cd $BASE/SOFTWARE/ws4py
	tar -zxvf ws4py-0.3.2.tgz
	cd ws4py-0.3.2
	sudo python setup.py install
	cd ..
	rm -r ws4py-0.3.2
else
	WARNING "The WebSocket library is already installed"
fi

[ "$((python -c 'import ws4py') 2>&1)" ] && ERROR "WebSocket installation failed" && exit

##############################################################################
WARNING "Installation completed"
##############################################################################
