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
	<!ENTITY NBSP "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
	<!ENTITY CRLF "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>&#10;</xsl:text>">
]>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml"/>

<xsl:template match="/">
	<xsl:element name="stats">
		<xsl:for-each select="//structure[mot]">
			<!--xsl:sort select="count(mot)" order="ascending" data-type="number"/-->
			<!--xsl:sort select="sum(granule/@score)" order="ascending" data-type="number"/-->
			
			<xsl:variable name="words" select="count(mot)"/>
			<xsl:variable name="roots" select="count(granule)"/>
			<xsl:variable name="granules" select="count(descendant::granule)"/>
			<xsl:variable name="leaves" select="count(descendant::granule[not(granule)])"/>
			<xsl:variable name="links" select="count(descendant::granule[parent::granule])"/>
			
			<!-- Coverage Rate = pourcentage de mots pris en compte (couverture lexicale) -->
			<xsl:variable name="coverage" select="sum(granule/@cov)"/>
			<xsl:variable name="cov-rate" select="$coverage div $words * 100"/>
			
			<!-- Consistency = 1 / nombre de racines (cohérence syntaxique) -->
			<xsl:variable name="cons-rate">
				<xsl:if test="$roots = 0">0</xsl:if>
				<xsl:if test="$roots > 0"><xsl:value-of select="1 div $roots * 100"/></xsl:if>
			</xsl:variable>
			
			<!-- Granularity = nombre de granules sur nombre de mots (granularité) -->
			<xsl:variable name="granularity" select="$granules div $words"/>
			
			&CRLF;
			<xsl:element name="parse">
				<xsl:attribute name="words"><xsl:value-of select="$words"/></xsl:attribute>
				<xsl:attribute name="granules"><xsl:value-of select="$granules"/></xsl:attribute>
				<xsl:attribute name="roots"><xsl:value-of select="$roots"/></xsl:attribute>
				<xsl:attribute name="leaves"><xsl:value-of select="$leaves"/></xsl:attribute>
				<xsl:attribute name="links"><xsl:value-of select="$links"/></xsl:attribute>
				
				<xsl:attribute name="cov"><xsl:value-of select="$coverage"/></xsl:attribute>
				<xsl:attribute name="cov-rate"><xsl:value-of select="$cov-rate"/></xsl:attribute>
				<xsl:attribute name="cons-rate"><xsl:value-of select="$cons-rate"/></xsl:attribute>
				<xsl:attribute name="granularity"><xsl:value-of select="$granularity"/></xsl:attribute>
			</xsl:element>
		</xsl:for-each>
		&CRLF;
	</xsl:element>
</xsl:template>

</xsl:stylesheet>
