<?xml version="1.0" encoding="UTF-8"?>
<!--
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
-->

<!DOCTYPE xsl:stylesheet [
	<!ENTITY crlf "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>&#10;</xsl:text>">
	<!ENTITY nbsp "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>

<xsl:template match="/">
	<xsl:text>Number of granules: </xsl:text>
	<xsl:value-of select="count(//granule)"/>
	&crlf;
	<xsl:text>Number of features: </xsl:text>
	<xsl:value-of select="count(//declare-feature)"/>
	&crlf;
	<xsl:text>Number of dependencies: </xsl:text>
	<xsl:value-of select="count(//dependency)"/>
	&crlf;
	<xsl:text>Number of patterns: </xsl:text>
	<xsl:value-of select="count(//syntax)"/>
	&crlf;&crlf;
	<xsl:text>Concepts: </xsl:text>
	<xsl:for-each select="//granule"><xsl:value-of select="@concept"/>&nbsp;</xsl:for-each>
	&crlf;&crlf;
	<xsl:text>Features: </xsl:text>
	<xsl:for-each select="//declare-feature"><xsl:value-of select="@id"/>&nbsp;</xsl:for-each>
	&crlf;&crlf;
	<xsl:text>Roles: </xsl:text>
	<xsl:for-each select="//declare-role"><xsl:value-of select="@id"/>&nbsp;</xsl:for-each>
	&crlf;&crlf;
	<xsl:text>Metadata: </xsl:text>
	<xsl:for-each select="//declare-metadata"><xsl:value-of select="@id"/>&nbsp;</xsl:for-each>
	&crlf;
</xsl:template>

</xsl:stylesheet>
