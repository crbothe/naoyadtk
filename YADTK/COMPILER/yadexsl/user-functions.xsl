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
	
	<!-- Retourne la chaine "a : b : c" à partir de la chaine "a:b:c" -->
	
	<exsl:function name="user:explode">
		<xsl:param name="chaine"/>
		<exsl:result>
			<xsl:call-template name="_explode">
				<xsl:with-param name="chaine" select="$chaine"/>
			</xsl:call-template>
		</exsl:result>
	</exsl:function>
	
	<xsl:template name="_explode">
		<xsl:param name="chaine"/>
		<xsl:choose>
			<xsl:when test="contains($chaine,':')">
				<xsl:value-of select="substring-before($chaine,':')"/>
				<xsl:text> : </xsl:text>
				<xsl:call-template name="_explode">
					<xsl:with-param name="chaine" select="substring-after($chaine,':')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$chaine"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- Retourne la chaine 'a " ?x " b' à partir de la chaine 'a ?x b' //// TODO à vérifier -->
	
	<exsl:function name="user:isole-variables">
		<xsl:param name="chaine"/>
		<exsl:result>
			<xsl:call-template name="_isole">
				<xsl:with-param name="chaine" select="$chaine"/>
			</xsl:call-template>
		</exsl:result>
	</exsl:function>
	
	<xsl:template name="_isole">
		<xsl:param name="chaine"/>
		<xsl:choose>
			<xsl:when test="contains($chaine, '?')">
				<xsl:variable name="var" select="substring-before(substring-after($chaine,'?'),' ')"/>
				<xsl:variable name="len" select="number(string-length($var))"/>

				<xsl:if test="$len!=0">
					<!-- un espace après la variable -->
					<xsl:value-of select="substring-before($chaine, '?')"/>
					<xsl:text>" ?</xsl:text><xsl:value-of select="$var"/><xsl:text> "</xsl:text>
					<xsl:call-template name="_isole">
						<xsl:with-param name="chaine" select="substring-after(substring-after($chaine,'?'),' ')"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="$len=0">
					<!-- rien après la variable -->
					<xsl:value-of select="substring-before($chaine, '?')"/>
					<xsl:text>" ?</xsl:text><xsl:value-of select="substring-after($chaine,'?')"/><xsl:text> "</xsl:text>
				</xsl:if>

			</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
				<xsl:value-of select="$chaine"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    
</xsl:stylesheet>
