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
	<!ENTITY % entities SYSTEM "../../COMMON/xml/viz-entities.dtd">
	%entities;
]>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="../../COMMON/xml/viz-utils.xsl"/>	
<xsl:output method="text"/>

<!-- ==================================================================================================== -->
<!-- Structure de granules issue de YASP                                                                  -->
<!-- ==================================================================================================== -->

<xsl:template match="/working-memory">
	
	<xsl:text>digraph G {&#13;</xsl:text>	
	<xsl:text>&#13;graph [fontname = &FONT;];</xsl:text>
	<xsl:text>&#13;node [fontname = &FONT;];</xsl:text>
	<xsl:text>&#13;edge [fontname = &FONT;];</xsl:text>
		
	<xsl:text>&#13;labelloc="top";</xsl:text>
	<xsl:text>&#13;labeljust="center";</xsl:text>
	<xsl:text>&#13;fontsize=18;</xsl:text>
	<xsl:text>&#13;label="YASP input\n\n";</xsl:text>
		
	<!-- Racines (offres des granules-racine)-->
	
	<xsl:for-each select="input/granule">		
		<xsl:text>&#13;root</xsl:text><xsl:value-of select="@id"/>
		<xsl:text> [label="</xsl:text>
		<xsl:call-template name="string-replace-all">
			<xsl:with-param name="string" select="@offres"/>
			<xsl:with-param name="replace" select="' '"/>
			<xsl:with-param name="by" select="'\n'"/>
		</xsl:call-template>
		<xsl:text>"][shape=egg]</xsl:text>
		<xsl:call-template name="set-color-1"/>
	</xsl:for-each>
	<xsl:text>&#13;</xsl:text>
	
	<!-- Relations racines-granule -->
	
	<xsl:for-each select="input/granule">				
		<xsl:text>&#13;root</xsl:text><xsl:value-of select="@id"/>
		<xsl:text> -> </xsl:text><xsl:value-of select="@id"/>
		<!--<xsl:text> [arrowhead=inv]</xsl:text>-->
		<xsl:text> [arrowhead=none]</xsl:text>
		<xsl:call-template name="set-color-1"/>
	</xsl:for-each>
	<xsl:text>&#13;</xsl:text>
	
	<!-- Relations granule-granule triées par le code de dependance -->
	
	<xsl:for-each select="input//granule[granule]">
		
		<!-- Pour ordonner les granules fils -->
		<xsl:text>{rank=same; </xsl:text>
		<xsl:for-each select="granule">
			<xsl:sort select="@code" data-type="text" order="ascending"/>
			<xsl:sort select="@pos" data-type="number" order="ascending"/>
			<xsl:if test="position()=1"><xsl:value-of select="@id"/></xsl:if>
			<xsl:text> -> </xsl:text>
			<xsl:value-of select="@id"/>
		</xsl:for-each>
		<xsl:text> [style=invis]}&#13;&#13;</xsl:text>
		
		<!-- Relations -->
		<xsl:for-each select="granule">
			<xsl:value-of select="../@id"/><xsl:text> -> </xsl:text><xsl:value-of select="@id"/>
			<xsl:text> [label="  </xsl:text><xsl:value-of select="@code"/>
			<xsl:if test="not(@role='nil')"><xsl:value-of select="concat(':',@role)"/></xsl:if>
			<xsl:text>  "]</xsl:text>
			<xsl:if test="@rescued='TRUE'"><xsl:text> [style=dashed]</xsl:text></xsl:if>
			<xsl:call-template name="set-color-1"/>
			<xsl:text>;&#13;</xsl:text>
		</xsl:for-each>
	</xsl:for-each>
	<xsl:text>&#13;</xsl:text>
	
	<!-- Granules -->
	
	<xsl:for-each select="input//granule">
		<xsl:value-of select="@id"/>
		<xsl:text> [shape=Mrecord, label="{</xsl:text>
		<xsl:value-of select="concat('granule #',@id)"/>
		<xsl:if test="@pos!=999">
			<xsl:if test="@pos=@fin"><xsl:value-of select="concat('\nword ',@pos)"/></xsl:if>
			<xsl:if test="@pos!=@fin"><xsl:value-of select="concat('\nwords ',@pos,' to ',@fin)"/></xsl:if>
		</xsl:if>
		<xsl:text>|</xsl:text>
		
		<!-- Nom du concept ou texte si inféré -->
		
		<xsl:if test="@inferred='TRUE'">
			<xsl:value-of select="concat('{',@text,'}')"/>
		</xsl:if>
		
		<xsl:if test="@inferred='FALSE'">
			<xsl:text>{</xsl:text>
			<xsl:call-template name="tokenizer1">
				<xsl:with-param name="string" select="@concept"/>
			</xsl:call-template>
			<xsl:text>}</xsl:text>
		</xsl:if>
		
		<!-- Liste des métadata -->
		
		<xsl:if test="normalize-space(@metadata)">
			<xsl:text>|</xsl:text>
			<xsl:call-template name="tokenizer2">
				<xsl:with-param name="string" select="@metadata"/>
			</xsl:call-template>
		</xsl:if>
				
		<xsl:text>}"</xsl:text>
		<xsl:text>]</xsl:text>
		
		<!-- Pour afficher les scores : <xsl:text>, xlabel="</xsl:text><xsl:value-of select="@score"/><xsl:text>"</xsl:text> -->
		
		<xsl:call-template name="set-color-1"/>
		<xsl:text>;&#13;</xsl:text>
		
	</xsl:for-each>
	<xsl:text>&#13;</xsl:text>
	
	<!-- Pour afficher les conflits -->
	
	<xsl:for-each select="//conflict">
		<xsl:variable name="id1" select="@id1"/>
		<xsl:variable name="id2" select="@id2"/>
		<xsl:if test="//input//granule/@id=$id1 and //input//granule/@id=$id2">
			<xsl:value-of select="@id1"/><xsl:text> -> </xsl:text><xsl:value-of select="@id2"/>
			<xsl:text> [constraint=none, dir=both, arrowhead=diamond, arrowtail=diamond, color=red]</xsl:text>
			<xsl:text> [label="conflict", fontcolor=red]</xsl:text>
		</xsl:if>
	</xsl:for-each>
		
	<xsl:text>&#13;}&#13;</xsl:text>
	
</xsl:template>
</xsl:stylesheet>
