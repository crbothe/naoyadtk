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
	<!ENTITY FONT "Calibri">
	<!ENTITY CRLF "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>&#10;</xsl:text>">
	<!ENTITY NBSP "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
]>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:user="http://www.univ-lemans.fr/functions"
	extension-element-prefixes="user">

<xsl:import href="user-functions.xsl"/>
<xsl:param name="root" select="''"/>
<xsl:param name="max" select="10"/>
<xsl:output method="text"/>

<xsl:template match="/">	
	<xsl:text>digraph G {</xsl:text>&CRLF;&CRLF;
	<xsl:text>node [fontname=&FONT;][shape=box][style=rounded]</xsl:text>&CRLF;
	<xsl:text>graph [fontname=&FONT;][overlap=false][splines=true]</xsl:text>&CRLF;
	<xsl:text>edge [fontname=&FONT;][arrowhead=open]</xsl:text>&CRLF;&CRLF;
	
	<xsl:if test="$root">
		<!-- Le granule racine est passé en argument -->
		<xsl:apply-templates select="//granule[@concept=$root]" mode="root"/>
	</xsl:if>
	<xsl:if test="not($root)">
		<!-- On cherche tous les granules racines -->
		<xsl:for-each select="//granule">
			<xsl:variable name="id" select="@concept"/>
			<xsl:variable name="offres" select="normalize-space(concat(translate(@concept,':',' '),' ',@offers))"/>
			<xsl:if test="not(//dependency[user:intersection($offres, normalize-space(concat(@expected,' ',@required)))])">
				<xsl:apply-templates select="." mode="root"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:if>
	
	<xsl:text>}</xsl:text>
</xsl:template>

<!-- Traitement des granules racines -->

<xsl:template match="granule[@concept != '']" mode="root">
	<xsl:call-template name="label-granule-root"/>
	&CRLF;
	<xsl:call-template name="appel-recursif">			
		<xsl:with-param name="cpt" select="0"/>
		<xsl:with-param name="pere" select="."/>
	</xsl:call-template>
</xsl:template>




<xsl:template match="group" mode="children">
	<xsl:param name="cpt"/>
	<xsl:param name="pere"/>
	<xsl:param name="attentes"/>
	<xsl:variable name="offres" select="normalize-space(concat(translate(@concept,':',' '),' ',@offers))"/>
	<xsl:if test="user:intersection($offres, $attentes)">
		<xsl:variable name="id1" select="translate($pere,':-','__')"/>
		<xsl:variable name="id2" select="translate(@concept,':-','__')"/>
		
		<xsl:if test="not($id1='') and not($id2='')">
			<xsl:value-of select="concat($id1,' -> ',$id2,';')"/>
			&CRLF;
			<xsl:call-template name="label-group"/>
			&CRLF;
		</xsl:if>

	</xsl:if>
</xsl:template>

<!-- Appel récursif -->

<xsl:template name="appel-recursif">
	<xsl:param name="cpt"/>
	<xsl:param name="pere"/>
	<xsl:for-each select="$pere/dependency">
		<!-- Pour chacune des dépendances du granule -->
		<xsl:variable name="attentes" select="normalize-space(concat(@expected,' ',@required))"/>
		<xsl:for-each select="//granule | //group">
			<xsl:variable name="offres" select="normalize-space(concat(translate(@concept,':',' '),' ',@offers))"/>
			
			<xsl:if test="user:intersection($offres, $attentes)">

				<xsl:variable name="id1" select="translate($pere/@concept,':-','__')"/>
				<xsl:variable name="id2" select="translate(@concept,':-','__')"/>
		
				<xsl:if test="not($id1='') and not($id2='')">
					<xsl:value-of select="concat($id1,' -> ',$id2,';')"/>
					&CRLF;
					<xsl:call-template name="label-granule"/>
					&CRLF;
				</xsl:if>

				<xsl:if test="$cpt &lt; 5">
					<xsl:call-template name="appel-recursif">			
						<xsl:with-param name="cpt" select="$cpt + 1"/>
						<xsl:with-param name="pere" select="."/>
					</xsl:call-template>
				</xsl:if>
				
			</xsl:if>
		</xsl:for-each>
	</xsl:for-each>
</xsl:template>

<!-- Label des granules et des groupes -->

<xsl:template name="label-granule-root">
	<xsl:value-of select="translate(@concept,':-','__')"/>
	<xsl:text> [label="</xsl:text>
	<xsl:value-of select="@concept"/>
	<xsl:text>", color=red, fontcolor=red];</xsl:text>&CRLF;
</xsl:template>

<xsl:template name="label-granule">
	<xsl:value-of select="translate(@concept,':-','__')"/>
	<xsl:text> [label="</xsl:text>
	<xsl:value-of select="@concept"/>
	<xsl:text>"];</xsl:text>&CRLF;
</xsl:template>

<xsl:template name="label-group">
	<xsl:value-of select="translate(@concept,':-','__')"/>
	<xsl:text> [label="</xsl:text>
	<xsl:value-of select="concat(@concept,':xxx')"/>
	<xsl:text>", color=green, fontcolor=green];</xsl:text>&CRLF;
</xsl:template>

</xsl:stylesheet>
