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
<xsl:output method="text"/>

<xsl:template match="/">
	<xsl:apply-templates select="//granule"/>
</xsl:template>

<xsl:template match="granule">
	
	<!-- Pour donner un identifiant aux concepts anonymes -->
	
	<xsl:variable name="concept">
		<xsl:if test="@concept"><xsl:value-of select="@concept"/></xsl:if>
		<xsl:if test="not(@concept)"><xsl:value-of select="generate-id()"/></xsl:if>
	</xsl:variable>
	
	(deffacts LEXIQUE::concept-<xsl:value-of select="$concept"/>
	(concept
	(concept <xsl:value-of select="$concept"/>)
	
	<!-- Pour compléter la liste des offres par les parties du nom du concepts -->
	
	(offres <xsl:value-of select="@offers"/>
	<xsl:call-template name="tokenizer">
		<xsl:with-param name="string" select="$concept"/>
	</xsl:call-template>)
	
	<xsl:if test="@offerexpr">(offre-expr "<xsl:value-of select="@offerexpr"/>")</xsl:if>
	)
	
	<xsl:for-each select="dependency">
		(attente
		(concept <xsl:value-of select="$concept"/>)
		(code <xsl:value-of select="@id"/>)
		<xsl:if test="@expected">(expected <xsl:value-of select="@expected"/>)</xsl:if>
		<xsl:if test="@required">(required <xsl:value-of select="@required"/>)</xsl:if>
		<xsl:if test="@rejected">(rejected <xsl:value-of select="@rejected"/>)</xsl:if>
		<xsl:if test="@role">(role <xsl:value-of select="@role"/>)</xsl:if>
		<xsl:if test="@flex">(flex <xsl:value-of select="@flex"/>)</xsl:if>
		<xsl:if test="@mult">(mult <xsl:value-of select="@mult"/>)</xsl:if>
		<xsl:if test="@tag">(tag <xsl:value-of select="@tag"/>)</xsl:if>
		)
	</xsl:for-each>
	<xsl:for-each select="constraint">
		(contrainte
		(concept <xsl:value-of select="$concept"/>)
		(test "<xsl:value-of select="@test"/>")
		)
	</xsl:for-each>
	<xsl:for-each select="syntax">
		(syntaxe
		(concept <xsl:value-of select="$concept"/>)
		(pattern "<xsl:value-of select="@pattern"/>")
		(traits <xsl:value-of select="@metadata"/>)
		(gen <xsl:value-of select="@gen"/>)
		(toA1 <xsl:value-of select="@toA1"/>)
		(toA2 <xsl:value-of select="@toA2"/>)
		(toA3 <xsl:value-of select="@toA3"/>)
		(toA4 <xsl:value-of select="@toA4"/>)
		(toA5 <xsl:value-of select="@toA5"/>)
		(toA6 <xsl:value-of select="@toA6"/>)
		(toA7 <xsl:value-of select="@toA7"/>)
		(toA8 <xsl:value-of select="@toA8"/>)
		(toA9 <xsl:value-of select="@toA9"/>)
		(ident <xsl:value-of select="generate-id()"/>)
		)
	</xsl:for-each>
	)
</xsl:template>

<!-- Enumération récursive des parties du concept -->

<xsl:template name="tokenizer">
	<xsl:param name="string"/>
	<xsl:param name="delimiter" select="':'"/>
	<xsl:text> </xsl:text>
	<xsl:choose>
		<xsl:when test="$delimiter and contains($string, $delimiter)">
			<xsl:value-of select="substring-before($string, $delimiter)"/>
			<xsl:call-template name="tokenizer">
				<xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
				<xsl:with-param name="delimiter" select="$delimiter"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$string"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
