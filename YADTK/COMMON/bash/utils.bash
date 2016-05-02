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

# http://misc.flogisoft.com/bash/tip_colors_and_formatting
RED="\033[101m" 
CYAN="\033[36m"
NORM="\033[39m"
RESET="\033[0m"
YELLOW="\033[93m" 

function GETTIME {
	echo $(python -c "import time; print int(round(time.time() * 1000))")
}

function TITLE {
	echo -e $CYAN--------------------------------------------------------------------------------
	echo $1
	echo -e --------------------------------------------------------------------------------$NORM
}

function ERROR {
	echo -e $RED$1$RESET
}

function WARNING {
	echo -e $YELLOW$1$RESET
}

function get_desktop {
	if [ "$XDG_CURRENT_DESKTOP" = "" ]
	then
	desktop=$(echo "$XDG_DATA_DIRS" | sed 's/.*\(xfce\|kde\|gnome\).*/\1/')
	else
	desktop=$XDG_CURRENT_DESKTOP
	fi
	desktop=${desktop,,} # convert to lower case
	echo "$desktop"
}

function command_exists {
    [ -x "$(command -v $1)" ] && return $true || return $false
    # command_exists xxxxx || { ERROR "Please install xxxxx" ; exit ; }
}

##############################################################################
# Function to check if running as root

function root_OK {
	[ "$EUID" -eq 0 ] && return $true || return $false
}

##############################################################################
# Function to check the Internet connectivity

function internet_OK {
	ping -q -W 1 -c 1 www.google.com &>/dev/null
	[ $? -eq 0 ] && return $true || return $false
}

##############################################################################
# Function to check the Python version

function python_OK {
    [[ "$(python -V 2>&1)" == "Python 2.7"* ]] && return $true || return $false
}

##############################################################################
# Functions to check the system

function macos_OK {
    [[ "$OSTYPE" == "darwin"* ]] && return $true || return $false
}

function ubuntu_OK {
    [[ "$OSTYPE" == "linux-gnu" ]] && return $true || return $false
}

function term_open () {
##############################################################################
if [[ "$OSTYPE" == "darwin"* ]]; then	
open -a Terminal $3
sleep 0.2
osascript <<EOF
tell application "Terminal"
	set position of window 1 to {$1, $2}
end tell
EOF
fi
##############################################################################
if [[ "$OSTYPE" == "linux-gnu" ]]; then
gnome-terminal --geometry=200x24+$1+$2 -e $3 &
fi
##############################################################################
sleep 0.2
}

function term_close () {
##############################################################################
if [[ "$OSTYPE" == "darwin"* ]]; then	
osascript <<EOF
tell application "Terminal"
	close every window whose name contains "$1"
end tell
tell application "System Events"
	keystroke return
end tell
EOF
fi
##############################################################################
if [[ "$OSTYPE" == "linux-gnu" ]]; then
wmctrl -c "$1"
fi
##############################################################################
}

function term_focus () {
##############################################################################
if [[ "$OSTYPE" == "darwin"* ]]; then
osascript <<EOF
tell application "System Events"
	tell application "Terminal"
		activate
	end tell
	tell application process "Terminal"
		set theWin to first window whose name contains "$1"
		perform action "AXRaise" of theWin
	end tell
end tell
EOF
fi
##############################################################################
if [[ "$OSTYPE" == "linux-gnu" ]]; then
wmctrl -a "$1"
fi
##############################################################################
}

function open_file () {
##############################################################################
if [[ "$OSTYPE" == "darwin"* ]]; then
open "$1"
fi
##############################################################################
if [[ "$OSTYPE" == "linux-gnu" ]]; then
DESK=$(get_desktop)
[[ "$DESK" == "unity" ]] && xdg-open "$1" 2>/dev/null
[[ "$DESK" == "gnome" ]] && gnome-open "$1" 2>/dev/null
[[ "$DESK" == "kde" ]] && kde-open "$1" 2>/dev/null
fi
##############################################################################
}
