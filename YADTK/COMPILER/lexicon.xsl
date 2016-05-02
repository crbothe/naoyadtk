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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="UTF-8"/>

<xsl:template match="/">
	<xsl:element name="lexicon">
		<xsl:apply-templates select="//entity"/>
	</xsl:element>
</xsl:template>

<xsl:template match="entity">
	<xsl:text>
</xsl:text>
	<xsl:element name="entity">
		<xsl:attribute name="concept"><xsl:value-of select="../@concept"/></xsl:attribute>
		<xsl:attribute name="pattern"><xsl:value-of select="@pattern"/></xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
		<xsl:attribute name="offers"><xsl:value-of select="../@offers"/></xsl:attribute>
		<xsl:attribute name="metadata"><xsl:value-of select="@metadata"/></xsl:attribute>
		<xsl:attribute name="gen"><xsl:value-of select="@gen"/></xsl:attribute>
	</xsl:element>
</xsl:template>

</xsl:stylesheet>