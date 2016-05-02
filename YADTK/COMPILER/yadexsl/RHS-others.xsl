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

<xsl:template match="speak" mode="action">
<xsl:template match="assert" mode="action">
<xsl:template match="retract" mode="action">
<xsl:template match="reset" mode="action">
<xsl:template match="increase" mode="action">
<xsl:template match="set-string" mode="action">
<xsl:template match="set-symbol" mode="action">
<xsl:template match="bind" mode="action">
<xsl:template match="ctrl" mode="action">

-->

<xsl:stylesheet version="1.0"	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns:user="http://www.univ-lemans.fr/functions"
								extension-element-prefixes="user">
	<!--
	##############################################################################
	# 
	##############################################################################
	-->
	
	<xsl:template match="speak" mode="action">
		<xsl:if test="@text">
			<xsl:call-template name="decoupage-speak">
				<xsl:with-param name="chaine" select="@text"/>
			</xsl:call-template>
		</xsl:if>
		
		<!-- Génération de structures littérales -->
		<xsl:for-each select="granule">
			(generer-XML (str-cat "<xsl:apply-templates select="." mode="generation"/>") <xsl:value-of select="@modifiers"/>)
		</xsl:for-each>
	</xsl:template>
	
	<!-- Découpage de la partie réponse -->
	
	<xsl:template name="decoupage-speak">
		<xsl:param name="chaine"/>
		<xsl:choose>
			
			<!-- Présence d'une expression -->
			<xsl:when test="contains($chaine,'(')">
				<xsl:variable name="texte" select="normalize-space(substring-before($chaine,'('))"/>
				<xsl:variable name="expression" select="normalize-space(substring-before(substring-after($chaine,'('),')'))"/>
				<xsl:variable name="reste" select="normalize-space(substring-after($chaine,')'))"/>

				<xsl:if test="not($texte='')">(repondre "<xsl:value-of select="$texte"/>")</xsl:if>
                
                <xsl:if test="not(contains($expression,'group'))">(repondre (<xsl:value-of select="$expression"/>))</xsl:if>
                <xsl:if test="contains($expression,'group')">
                    <!-- Pour retrouver la valeur d'un groupe d'une expression régulière -->
                    (repondre (pythonRegexpGroup ?expr ?texte <xsl:value-of select="normalize-space(substring-after($expression,' '))"/>))
                </xsl:if>
                
				<xsl:if test="$reste">
					<xsl:call-template name="decoupage-speak">
						<xsl:with-param name="chaine" select="$reste"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			
			<!-- Pas ou plus d'expression -->
			<xsl:otherwise>
				(repondre "<xsl:value-of select="$chaine"/>")
			</xsl:otherwise>
			
		</xsl:choose>
	</xsl:template>
    
	<!--
	##############################################################################
	# 
	##############################################################################
	-->
    
	<!-- ============================================ -->
	<!-- Pour la génération d'une structure littérale -->
	<!-- ============================================ -->

	<xsl:template match="granule" mode="generation">
		<xsl:param name="idpere" select="'nil'"/>
		<xsl:param name="prof" select="0"/>
		<xsl:param name="mod"/>
		<!-- modifieurs = modifieurs hérités + nouveaux modifieurs -->
		<xsl:variable name="modifiers" select="normalize-space(concat($mod,' ',@modifiers))"/>

		<xsl:text>&lt;granule</xsl:text>
		<xsl:text> concept='</xsl:text><xsl:value-of select="@concept"/><xsl:text>'</xsl:text>
		
		<xsl:if test="@code"><xsl:text> code='</xsl:text><xsl:value-of select="@code"/><xsl:text>'</xsl:text></xsl:if>
		<xsl:if test="@role"><xsl:text> role='</xsl:text><xsl:value-of select="@role"/><xsl:text>'</xsl:text></xsl:if>
		
		<xsl:if test="$modifiers">
			<xsl:text> modifieurs='</xsl:text>
			<!-- La liste des modifieurs peut comprendre des variables -->
			<xsl:value-of select="user:isole-variables($modifiers)"/>
			<xsl:text>'</xsl:text>
		</xsl:if>
		
		<xsl:text>&gt;</xsl:text>	
		<xsl:apply-templates select="granule|reuse-granule" mode="generation">
			<xsl:with-param name="idpere" select="generate-id()"/>
			<xsl:with-param name="prof" select="$prof + 1"/>
			<xsl:with-param name="mod" select="$modifiers"/>
		</xsl:apply-templates>
		<xsl:text>&lt;/granule&gt;</xsl:text>
	</xsl:template>

	<xsl:template match="reuse-granule" mode="generation">
		<xsl:param name="mod"/>
		<!-- modifieurs = modifieurs hérités + nouveaux modifieurs -->
		<xsl:variable name="modifiers" select="normalize-space(concat($mod,' ',@modifiers))"/>
		<xsl:text>" (granule-to-XML </xsl:text>
		<xsl:value-of select="@ident"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$modifiers"/>
		<xsl:text>) "</xsl:text>
	</xsl:template>
	
	<!--
	##############################################################################
	# 
	##############################################################################
	-->
	
	<xsl:template match="assert" mode="action">
		(assert-fact <xsl:value-of select="translate(@fact,'()','  ')"/>)
	</xsl:template>
	
	<!--
	##############################################################################
	# 
	##############################################################################
	-->
	
	<xsl:template match="retract" mode="action">
		<xsl:if test="@ref">(retract-fact <xsl:value-of select="@ref"/>)</xsl:if>
		<xsl:if test="@all">(retract-all <xsl:value-of select="@all"/>)</xsl:if>
	</xsl:template>
	
	<!--
	##############################################################################
	# 
	##############################################################################
	-->
	
	<xsl:template match="increase[@counter]" mode="action">
		(increase-counter <xsl:value-of select="@counter"/>)
	</xsl:template>
	
	<xsl:template match="reset[@counter]" mode="action">
		(reset-counter <xsl:value-of select="@counter"/>)
	</xsl:template>
	
	<xsl:template match="remove[@counter]" mode="action">
		(remove-counter <xsl:value-of select="@counter"/>)
	</xsl:template>
	
	<!--
	##############################################################################
	# 
	##############################################################################
	-->
	
	<xsl:template match="set-string" mode="action">
		(bind ?*<xsl:value-of select="@name"/>* "<xsl:value-of select="@value"/>")
		(ajoute-action (format nil "    Modification de la variable globale ?*%s* = '%s'"
			<xsl:text> "</xsl:text><xsl:value-of select="@name"/><xsl:text>" </xsl:text>
			<xsl:text> "</xsl:text><xsl:value-of select="@value"/><xsl:text>"</xsl:text>))
	</xsl:template>
	
	<!--
	##############################################################################
	# 
	##############################################################################
	-->
	
	<xsl:template match="set-symbol" mode="action">
		(bind ?*<xsl:value-of select="@name"/>* <xsl:value-of select="@value"/>)
		(ajoute-action "<xsl:value-of select="concat('    Modification de la variable globale ?*',@name,'* = ',@value)"/>")
	</xsl:template>
	
	<!--
	##############################################################################
	# 
	##############################################################################
	-->
	
	<xsl:template match="bind" mode="action">
		(bind <xsl:value-of select="@var"/> <xsl:value-of select="@value"/>)
		<!-- Mémoriser la variable dans le cas d'une règle incidente -->
		<xsl:if test="ancestor::rule[1]/rule">
			(assert (variable
			(contexte <xsl:value-of select="generate-id(ancestor::rule[1])"/>)
			(ident <xsl:value-of select="substring-after(@var,'?')"/>)
			(value <xsl:value-of select="@var"/>)))
		</xsl:if>
	</xsl:template>
	
	<!--
	##############################################################################
	# 
	##############################################################################
	-->
	
	<xsl:template match="ctrl" mode="action">
		(ctrl-<xsl:value-of select="@command"/>)
	</xsl:template>
    
	<!--
	##############################################################################
	# 
	##############################################################################
	-->
        
	<xsl:template match="command" mode="action">
		<xsl:variable name="xxx">(sym-cat [ <xsl:value-of select="user:explode(@expr)"/> ])</xsl:variable>
		(repondre <xsl:value-of select="$xxx"/>)        
	</xsl:template>    

</xsl:stylesheet>
