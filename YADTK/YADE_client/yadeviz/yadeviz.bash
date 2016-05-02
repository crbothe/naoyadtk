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

cd `dirname "$0"`
source ./../../COMMON/bash/utils.bash

xsltproc -o _output1.dot yadeviz1.xsl _input.xml
xsltproc -o _output2.dot yadeviz2.xsl _input.xml

dot -Gratio=auto -Tpdf _output1.dot -o _output1.pdf
dot -Gratio=auto -Tpdf _output2.dot -o _output2.pdf

open_file _output1.pdf
open_file _output2.pdf

if [[ "$OSTYPE" == "darwin"* ]]; then
##############################################################################
osascript <<EOF
tell application "Preview"
	activate
	tell application "System Events"
		keystroke "2" using { command down } -- Page unique
		keystroke "9" using { command down } -- Adapter à la fenêtre
	end tell
end tell
EOF
##############################################################################
fi