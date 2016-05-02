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

[ ! $1 ] && ERROR "Usage: compiler.bash <application>" && exit
[ ! -e $BASE/YADTK/COMMON/bin/clips ] && ERROR "Error: YADTK was not correctly installed" && exit

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
CLIPS="${BASE}/YADTK/COMMON/bin/clips"
COMP_PATH="${BASE}/YADTK/COMPILER"
ABORTED="${RED}ABORTED${RESET}"
TIME1=$(GETTIME)

echo
echo Preparing the $APPLICATION knowledge...

##############################################################################
# Validation des fichiers XML
##############################################################################

TITLE "Validating XML files"

echo "Parsing $YASP_DATA_PATH/granules.xml"
$XMLLINT --noent --output $YASP_DATA_PATH/_tmp.xml $YASP_DATA_PATH/granules.xml
$XMLLINT --timing --noout --valid $YASP_DATA_PATH/_tmp.xml
if [ $? -gt 0 ]
then
	echo -e "${RED}DO NOT MODIFY THE FILE _tmp.xml MAKE CHANGES ONLY IN THE APPLICATION FOLDER${RESET}"
	open_file $YASP_DATA_PATH/_tmp.xml
	exit 1
fi

echo "Parsing $YADE_DATA_PATH/yaderules.xml"
$XMLLINT --timing --noout --valid $YADE_DATA_PATH/yaderules.xml
[ $? -gt 0 ] && echo -e $ABORTED && exit 1

##############################################################################
# Transformations XSLT
##############################################################################

TITLE "Statistics on knowledge"

$XSLTPROC $COMP_PATH/statistiques.xsl $YASP_DATA_PATH/granules.xml
[ $? -gt 0 ] && echo -e $ABORTED && exit 1

TITLE "Processing XSLT transformations"

$XSLTPROC --timing -o $YASP_DATA_PATH/_lexique.clp $COMP_PATH/granules.xsl $YASP_DATA_PATH/granules.xml
[ $? -gt 0 ] && echo -e $ABORTED && exit 1

$XSLTPROC --timing -o $YASP_DATA_PATH/_tmp.xml $COMP_PATH/lexicon.xsl $YASP_DATA_PATH/granules.xml
[ $? -gt 0 ] && echo -e $ABORTED && exit 1

$XSLTPROC --timing -o $YADE_DATA_PATH/_yaderules.clp $COMP_PATH/yaderules-v1.xsl $YADE_DATA_PATH/yaderules.xml
[ $? -gt 0 ] && echo -e $ABORTED && exit 1

##############################################################################
# Génération des règles CLIPS
##############################################################################

python $COMP_PATH/comp-yasp.py

##############################################################################
# Reformatage des règles YADE
##############################################################################

TITLE "Generation of YADE rules"

cd $YADE_DATA_PATH

$CLIPS -f2 $COMP_PATH/compyade.bat \
	| tee $COMP_PATH/compyade.log \
	| grep "YADERULE::id" \
	| sed "s/[(]defrule/Defining defrule\:/g"

ERROR=$(grep -n 'ERROR' $COMP_PATH/compyade.log)

if [ -n "$ERROR" ]
then
echo -e $ABORTED
echo -e "${RED}See the file compiler.log${RESET}"
open_file $COMP_PATH/compyade.log
exit 1
fi

##############################################################################
# Copie des fichiers dans les répertoires data
##############################################################################

TITLE "Deploying the application"

rm $BASE/YADTK/YASP_server/data/$APPLICATION/_* 2>/dev/null
rm $BASE/YADTK/YAGE_server/data/$APPLICATION/_* 2>/dev/null
rm $BASE/YADTK/YADE_server/data/$APPLICATION/_* 2>/dev/null

mkdir -p $BASE/YADTK/YASP_server/data/$APPLICATION
mkdir -p $BASE/YADTK/YAGE_server/data/$APPLICATION
mkdir -p $BASE/YADTK/YADE_server/data/$APPLICATION

set -x

cp $YASP_DATA_PATH/_lexique.clp $BASE/YADTK/YASP_server/data/$APPLICATION
cp $YASP_DATA_PATH/_entities.clp $BASE/YADTK/YASP_server/data/$APPLICATION
cp $YASP_DATA_PATH/_filtrage.clp $BASE/YADTK/YASP_server/data/$APPLICATION

cp $YASP_DATA_PATH/_lexique.clp $BASE/YADTK/YAGE_server/data/$APPLICATION
cp $YASP_DATA_PATH/_entities.clp $BASE/YADTK/YAGE_server/data/$APPLICATION
cp $YASP_DATA_PATH/_generation.clp $BASE/YADTK/YAGE_server/data/$APPLICATION

cp $YASP_DATA_PATH/_lexique.clp $BASE/YADTK/YADE_server/data/$APPLICATION
cp $YASP_DATA_PATH/_entities.clp $BASE/YADTK/YADE_server/data/$APPLICATION
cp $YADE_DATA_PATH/_yaderules.clp $BASE/YADTK/YADE_server/data/$APPLICATION
cp $YADE_DATA_PATH/application.clp $BASE/YADTK/YADE_server/data/$APPLICATION
cp $YADE_DATA_PATH/application.py $BASE/YADTK/YADE_server/data/$APPLICATION

set +x

rm $YASP_DATA_PATH/_*
rm $YADE_DATA_PATH/_*

TITLE "Knowledge $APPLICATION compiled"
##############################################################################
TIME2=$(GETTIME)
echo "Elapsed time: $(($TIME2-$TIME1)) ms"
