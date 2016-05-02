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

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:user="http://www.univ-lemans.fr/functions"
	xmlns:exsl="http://exslt.org/functions"
	extension-element-prefixes="exsl">
	
	<!-- Fonctions sur les listes représentées par des chaines de caractères -->
	
	<exsl:function name="user:car">
		<xsl:param name="string"/>
		<xsl:choose>
			<xsl:when test="contains($string,' ')">
				<exsl:result select="normalize-space(substring-before($string,' '))"/>
			</xsl:when>
			<xsl:otherwise>
				<exsl:result select="$string"/>
			</xsl:otherwise>
		</xsl:choose>
	</exsl:function>
	
	<exsl:function name="user:cdr">
		<xsl:param name="string"/>
		<xsl:choose>
			<xsl:when test="contains($string,' ')">
				<exsl:result select="normalize-space(substring-after($string,' '))"/>
			</xsl:when>
			<xsl:otherwise>
				<exsl:result select="''"/>
			</xsl:otherwise>
		</xsl:choose>
	</exsl:function>
	
	<exsl:function name="user:nonvide">
		<xsl:param name="string"/>
		<exsl:result select="boolean(number(string-length(normalize-space($string))) > 0)"/>
	</exsl:function>
	
	<exsl:function name="user:member">
		<xsl:param name="string1"/>
		<xsl:param name="string2"/>
		<xsl:variable name="elem" select="concat(' ',$string1,' ')"/>
		<xsl:variable name="liste" select="concat(' ',$string2,' ')"/>
		<exsl:result select="boolean(contains($liste,$elem))"/>
	</exsl:function>
	
	<!-- Teste si deux ensembles représentés par deux chaines ont une intersection non-vide -->
	
	<exsl:function name="user:intersection">
		<xsl:param name="string1"/>
		<xsl:param name="string2"/>
		
		<xsl:variable name="car" select="user:car($string1)"/>
		<xsl:variable name="cdr" select="user:cdr($string1)"/>
		
		<xsl:choose>
			<xsl:when test="user:member($car,$string2)">
				<exsl:result select="true()"/>
			</xsl:when>
			<xsl:when test="user:nonvide($cdr)">
				<exsl:result select="user:intersection($cdr,$string2)"/>
			</xsl:when>
			<xsl:otherwise>
				<exsl:result select="false()"/>
			</xsl:otherwise>
		</xsl:choose>	
	</exsl:function>

</xsl:stylesheet>
