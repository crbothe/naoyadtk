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

[ ! $1 ] && ERROR "Usage: graphmaker.bash <application> [<concept>]" && exit

if [ ! -d "APPLICATIONS/$1" ]
then
	ERROR "Error: The application $1 doesn't exist"
	echo "The available applications are the following:"
    ls -d ./APPLICATIONS/* | sed "s/APPLICATIONS//g" | tr ".\/" " "
	echo
	exit
fi

export APPLICATION=$1
export YASP_DATA_PATH=$BASE/APPLICATIONS/$APPLICATION/YASP_data
export YADE_DATA_PATH=$BASE/APPLICATIONS/$APPLICATION/YADE_data

XMLLINT="xmllint"
XSLTPROC="xsltproc"
XSL_PATH="${BASE}/YADTK/COMMON/xml"
ABORTED="${RED}ABORTED${RESET}"

##############################################################################
# Validation des fichiers XML
##############################################################################

TITLE "Validating XML files"

echo "Parsing $YASP_DATA_PATH/granules.xml"
$XMLLINT --noent --output $YASP_DATA_PATH/_tmp.xml $YASP_DATA_PATH/granules.xml
$XMLLINT --timing --noout --valid $YASP_DATA_PATH/_tmp.xml
rm $YASP_DATA_PATH/_tmp.xml

##############################################################################
# Transformations XSLT vers terminal
##############################################################################

TITLE "Processing XSLT transformation"

$XSLTPROC -stringparam root "$2" -stringparam max "$3" $XSL_PATH/graphmaker1.xsl $YASP_DATA_PATH/granules.xml
[ $? -gt 0 ] && echo -e $ABORTED && exit 1

##############################################################################
# Transformations XSLT vers Graphviz
##############################################################################

$XSLTPROC --timing -o $YASP_DATA_PATH/graphe-$APPLICATION.dot -stringparam root "$2" -stringparam max "$3" $XSL_PATH/graphmaker2.xsl $YASP_DATA_PATH/granules.xml
neato -Tjpg $YASP_DATA_PATH/graphe-$APPLICATION.dot -o $YASP_DATA_PATH/graphe-$APPLICATION.jpg
#neato -Tpng $YASP_DATA_PATH/graphe-$APPLICATION.dot -o $YASP_DATA_PATH/graphe-$APPLICATION.png
[ $? -gt 0 ] && echo -e $ABORTED && exit 1

open_file $YASP_DATA_PATH/graphe-$APPLICATION.jpg
echo "Output files:"
echo "   $YASP_DATA_PATH/graphe-$APPLICATION.dot"
echo "   $YASP_DATA_PATH/graphe-$APPLICATION.jpg"

##############################################################################
