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
YADTK=$(pwd)
export PATH=.:$PATH
source YADTK/COMMON/bash/utils.bash

[ ! $1 ] && ERROR "Usage: run.bash <config_file> <config_ident>" && exit
[ ! $2 ] && ERROR "Usage: run.bash <config_file> <config_ident>" && exit
[ ! -e $1 ] && ERROR "Error: The configuration file [$1] doesn't exist" && exit

echo "Validating $1..."
xmllint --timing --noout --valid $1
[ $? -gt 0 ] && ERROR "Error: The configuration file [$1] is not valid" && exit 1

##############################################################################
# Getting configuration

CONFIG=$(xmllint --xpath "//config[@id='$2']" $1 2>/dev/null)
if [ ! "$CONFIG" ]
then
	ERROR "Error: No entry [$2] in configuration file $1"
	echo "The available configurations are the following:"
	xmllint --xpath "//config/@id" $1  | tr " " "\n" | sed -e 's/id="\(.*\)"/\1/'
	echo
	exit
fi

DATA=$(echo $CONFIG | xmllint --xpath "string(//config/@knowledge)" -)
[ ! -d "APPLICATIONS/$DATA" ] && ERROR "Error: The knowledge $DATA does not exist" && exit
[ ! -d "YADTK/YASP_server/data/$DATA" ] && ERROR "Error: The knowledge $DATA has not been compiled" && exit

YASP=$(echo $CONFIG | xmllint --xpath "//config/server-yasp" - 2>/dev/null)
YAGE=$(echo $CONFIG | xmllint --xpath "//config/server-yage" - 2>/dev/null)
YADE=$(echo $CONFIG | xmllint --xpath "//config/server-yade" - 2>/dev/null)
YASPCLI=$(echo $CONFIG | xmllint --xpath "//config/client-yasp" - 2>/dev/null)
YAGECLI=$(echo $CONFIG | xmllint --xpath "//config/client-yage" - 2>/dev/null)
YADECLI=$(echo $CONFIG | xmllint --xpath "//config/client-yade" - 2>/dev/null)

echo "Starting $2..."

##############################################################################
# YASP server configuration

if [[ $YASP ]]
then
echo $YASP

YASP_PORT=$(echo $YASP | xmllint --xpath "string(//server-yasp/@port)" -)
YASP_TRACE=$(echo $YASP | xmllint --xpath "string(//server-yasp/@trace)" -)
YASP_DEBUG=$(echo $YASP | xmllint --xpath "string(//server-yasp/@debug)" -)
YASP_LEVEN=$(echo $YASP | xmllint --xpath "string(//server-yasp/@leven)" -)
YASP_TAGGER=$(echo $YASP | xmllint --xpath "string(//server-yasp/@tagger)" -)
YASP_LANG=$(echo $YASP | xmllint --xpath "string(//server-yasp/@lang)" -)

echo "export YASP_DATA=$DATA" > YADTK/YASP_server/yaspserver.config
echo "export YASP_PORT=$YASP_PORT" >> YADTK/YASP_server/yaspserver.config
echo "export YASP_TRACE=$YASP_TRACE" >> YADTK/YASP_server/yaspserver.config
echo "export YASP_DEBUG=$YASP_DEBUG" >> YADTK/YASP_server/yaspserver.config
echo "export TAGGER_FLAG=$YASP_TAGGER" >> YADTK/YASP_server/yaspserver.config
echo "export TAGGER_LANG=$YASP_LANG" >> YADTK/YASP_server/yaspserver.config
echo "export LEV_FLAG=$YASP_LEVEN" >> YADTK/YASP_server/yaspserver.config

POSITION=$(echo $YASP | xmllint --xpath "string(//server-yasp/@position)" -)
[[ $POSITION =~ (.+)\+(.+) ]] && X=${BASH_REMATCH[1]} && Y=${BASH_REMATCH[2]}

term_open $X $Y YADTK/YASP_server/yaspserver.bash
fi

##############################################################################
# YAGE server configuration

if [[ $YAGE ]]
then
echo $YAGE

YAGE_PORT=$(echo $YAGE | xmllint --xpath "string(//server-yage/@port)" -)
YAGE_TRACE=$(echo $YAGE | xmllint --xpath "string(//server-yage/@trace)" -)
YAGE_DEBUG=$(echo $YAGE | xmllint --xpath "string(//server-yage/@debug)" -)

echo "export YAGE_DATA=$DATA" > YADTK/YAGE_server/yageserver.config
echo "export YAGE_PORT=$YAGE_PORT" >> YADTK/YAGE_server/yageserver.config
echo "export YAGE_TRACE=$YAGE_TRACE" >> YADTK/YAGE_server/yageserver.config
echo "export YAGE_DEBUG=$YAGE_DEBUG" >> YADTK/YAGE_server/yageserver.config

POSITION=$(echo $YAGE | xmllint --xpath "string(//server-yage/@position)" -)
[[ $POSITION =~ (.+)\+(.+) ]] && X=${BASH_REMATCH[1]} && Y=${BASH_REMATCH[2]}

term_open $X $Y YADTK/YAGE_server/yageserver.bash
fi

##############################################################################
# YADE server configuration

if [[ $YADE ]]
then
echo $YADE

YADE_PORT=$(echo $YADE | xmllint --xpath "string(//server-yade/@port)" -)
YADE_TRACE=$(echo $YADE | xmllint --xpath "string(//server-yade/@trace)" -)
YADE_DEBUG=$(echo $YADE | xmllint --xpath "string(//server-yade/@debug)" -)
YADE_MIRROR=$(echo $YADE | xmllint --xpath "string(//server-yade/@mirror)" -)

echo "export YADE_DATA=$DATA" > YADTK/YADE_server/yadeserver.config
echo "export YADE_PORT=$YADE_PORT" >> YADTK/YADE_server/yadeserver.config
echo "export YADE_TRACE=$YADE_TRACE" >> YADTK/YADE_server/yadeserver.config
echo "export YADE_DEBUG=$YADE_DEBUG" >> YADTK/YADE_server/yadeserver.config
echo "export MIRROR_FLAG=$YADE_MIRROR" >> YADTK/YADE_server/yadeserver.config
echo "export YASP_SERVER=localhost:$YASP_PORT" >> YADTK/YADE_server/yadeserver.config
echo "export YAGE_SERVER=localhost:$YAGE_PORT" >> YADTK/YADE_server/yadeserver.config

POSITION=$(echo $YADE | xmllint --xpath "string(//server-yade/@position)" -)
[[ $POSITION =~ (.+)\+(.+) ]] && X=${BASH_REMATCH[1]} && Y=${BASH_REMATCH[2]}

term_open $X $Y YADTK/YADE_server/yadeserver.bash
fi

##############################################################################
# YASP client configuration

if [[ $YASPCLI ]]
then
echo $YASPCLI

SCRIPT=$(echo $YASPCLI | xmllint --xpath "string(//client-yasp/@script)" -)
INPUT=$(echo $YASPCLI | xmllint --xpath "string(//client-yasp/@input)" -)
YAVIZ=$(echo $YASPCLI | xmllint --xpath "string(//client-yasp/@visualization)" -)
PDF=$(echo $YASPCLI | xmllint --xpath "string(//client-yasp/@pdf)" -)

echo "export YADTK=$YADTK" > YADTK/YASP_client/yaspclient.config
echo "export YASP_SERVER=localhost:$YASP_PORT" >> YADTK/YASP_client/yaspclient.config
echo "export YASPVIZ_FLAG=$YAVIZ" >> YADTK/YASP_client/yaspclient.config
echo "export SCRIPT=$SCRIPT" >> YADTK/YASP_client/yaspclient.config
echo "export DATA=$DATA" >> YADTK/YASP_client/yaspclient.config
echo "export INPUT=$INPUT" >> YADTK/YASP_client/yaspclient.config
echo "export PDF=$PDF" >> YADTK/YASP_client/yaspclient.config
echo "export CONFIG='$YASPCLI'" >> YADTK/YASP_client/yaspclient.config

POSITION=$(echo $YASPCLI | xmllint --xpath "string(//client-yasp/@position)" -)
[[ $POSITION =~ (.+)\+(.+) ]] && X=${BASH_REMATCH[1]} && Y=${BASH_REMATCH[2]}

term_open $X $Y YADTK/YASP_client/yaspclient.bash
fi

##############################################################################
# YAGE client configuration

if [[ $YAGECLI ]]
then
echo $YAGECLI

SCRIPT=$(echo $YAGECLI | xmllint --xpath "string(//client-yage/@script)" -)

echo "export YAGE_SERVER=localhost:$YAGE_PORT" > YADTK/YAGE_client/yageclient.config
echo "export SCRIPT=$SCRIPT" >> YADTK/YAGE_client/yageclient.config
echo "export DATA=$DATA" >> YADTK/YAGE_client/yageclient.config

POSITION=$(echo $YAGECLI | xmllint --xpath "string(//client-yage/@position)" -)
[[ $POSITION =~ (.+)\+(.+) ]] && X=${BASH_REMATCH[1]} && Y=${BASH_REMATCH[2]}

term_open $X $Y YADTK/YAGE_client/yageclient.bash
fi

##############################################################################
# YADE client configuration

if [[ $YADECLI ]]
then
echo $YADECLI

SCRIPT=$(echo $YADECLI | xmllint --xpath "string(//client-yade/@script)" -)
INPUT=$(echo $YADECLI | xmllint --xpath "string(//client-yade/@input)" -)
YAVIZ=$(echo $YADECLI | xmllint --xpath "string(//client-yade/@visualization)" -)
INPUT_MODULE=$(echo $YADECLI | xmllint --xpath "//input" - 2>/dev/null)
OUTPUT_MODULE=$(echo $YADECLI | xmllint --xpath "//output" - 2>/dev/null)

echo "export YADTK=$YADTK" > YADTK/YADE_client/yadeclient.config
echo "export YADE_SERVER=localhost:$YADE_PORT" >> YADTK/YADE_client/yadeclient.config
echo "export YADEVIZ_FLAG=$YAVIZ" >> YADTK/YADE_client/yadeclient.config
echo "export SCRIPT=$SCRIPT" >> YADTK/YADE_client/yadeclient.config
echo "export DATA=$DATA" >> YADTK/YADE_client/yadeclient.config
echo "export INPUT=$INPUT" >> YADTK/YADE_client/yadeclient.config
echo "export INPUT_MODULE='$INPUT_MODULE'" >> YADTK/YADE_client/yadeclient.config
echo "export OUTPUT_MODULE='$OUTPUT_MODULE'" >> YADTK/YADE_client/yadeclient.config
echo "export CONFIG='$YADECLI'" >> YADTK/YADE_client/yadeclient.config

POSITION=$(echo $YADECLI | xmllint --xpath "string(//client-yade/@position)" -)
[[ $POSITION =~ (.+)\+(.+) ]] && X=${BASH_REMATCH[1]} && Y=${BASH_REMATCH[2]}

term_open $X $Y YADTK/YADE_client/yadeclient.bash
fi

##############################################################################
# term_close "YADTK"
