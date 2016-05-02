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
	<!ENTITY % entities SYSTEM "viz-entities.dtd">
	%entities;
]>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>

<!-- Choix de la couleur -->

<xsl:template name="set-color-1">
	<xsl:variable name="id" select="@id"/>
	<xsl:variable name="inferred" select="boolean(@inferred='TRUE')"/>
	<xsl:if test="//output//granule[@id=$id]">[color=blue, fontcolor=blue]</xsl:if>
	<xsl:if test="not(//output//granule[@id=$id])">[color=grey, fontcolor=grey]</xsl:if>
	<xsl:if test="$inferred">[style=dashed]</xsl:if>
</xsl:template>

<xsl:template name="set-color-2">
	<xsl:variable name="indice-courant" select="//working-memory/output/@indice"/>	
	<xsl:variable name="current" select="boolean(@indice=$indice-courant)"/>
	<xsl:variable name="inferred" select="boolean(@inferred='TRUE')"/>
	<xsl:variable name="added" select="boolean(@added='TRUE')"/>
	<xsl:variable name="used" select="boolean(@used='TRUE')"/>
	<xsl:choose>
		<xsl:when test="$used">[color=grey, fontcolor=grey]</xsl:when>
		<xsl:when test="not($used) and $current and $added">[color=red, fontcolor=red]</xsl:when>
		<xsl:when test="not($used) and $current and not($added)">[color=blue, fontcolor=blue]</xsl:when>
	</xsl:choose>
	<xsl:if test="$inferred">[style=dashed]</xsl:if>
</xsl:template>

<!-- Enumération récursive des parties du concept -->

<xsl:template name="tokenizer1">
	<xsl:param name="string"/>
	<xsl:param name="delimiter" select="':'"/>
	<xsl:choose>
		<xsl:when test="$delimiter and contains($string, $delimiter)">
			<xsl:value-of select="substring-before($string, $delimiter)"/>
			<xsl:text>|</xsl:text>
			<xsl:call-template name="tokenizer1">
				<xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
				<xsl:with-param name="delimiter" select="$delimiter"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$string"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Enumération récursive des modifieurs -->

<xsl:template name="tokenizer2">
	<xsl:param name="string"/>
	<xsl:param name="delimiter" select="' '"/>
	<xsl:choose>
		<xsl:when test="$delimiter and contains($string, $delimiter)">
			<!--<xsl:text>|+ </xsl:text>-->
			<xsl:text>+ </xsl:text>
			<xsl:value-of select="substring-before($string, $delimiter)"/>
			<xsl:text>\n</xsl:text>
			<xsl:call-template name="tokenizer2">
				<xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
				<xsl:with-param name="delimiter" select="$delimiter"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<!--<xsl:text>|+ </xsl:text>-->
			<xsl:text>+ </xsl:text>
			<xsl:value-of select="$string"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Remplacement dans une chaîne de caractères -->

<xsl:template name="string-replace-all">
	<xsl:param name="string"/>
	<xsl:param name="replace"/>
	<xsl:param name="by"/>	
	<xsl:choose>
		<xsl:when test="contains($string, $replace)">
			<xsl:value-of select="substring-before($string, $replace)"/>
			<xsl:value-of select="$by"/>
			<xsl:call-template name="string-replace-all">
				<xsl:with-param name="string" select="substring-after($string, $replace)"/>
				<xsl:with-param name="replace" select="$replace"/>
				<xsl:with-param name="by" select="$by"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$string"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Affichage de l'énoncé mot par mot dans un tableau numéroté -->

<xsl:template name="cree-tableau">
	<xsl:param name="string"/>
	<xsl:param name="delimiter" select="' '"/>
	<xsl:param name="compter" select="1"/>
	<xsl:choose>
		<xsl:when test="$delimiter and contains($string, $delimiter)">
			<xsl:text>&TD1;</xsl:text>
			<xsl:value-of select="substring-before($string, $delimiter)"/>
			<xsl:text>&BR;  </xsl:text>
			<xsl:value-of select="$compter"/>
			<xsl:text>  </xsl:text>
			<xsl:text>&TD2;</xsl:text>
			<xsl:call-template name="cree-tableau">
				<xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
				<xsl:with-param name="delimiter" select="$delimiter"/>
				<xsl:with-param name="compter" select="$compter + 1"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:text>&TD1;</xsl:text>
			<xsl:value-of select="$string"/>
			<xsl:text>&BR;</xsl:text>
			<xsl:value-of select="$compter"/>
			<xsl:text>&TD2;</xsl:text>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

