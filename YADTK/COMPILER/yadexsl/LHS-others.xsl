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

<xsl:template match="exists" mode="condition">
<xsl:template match="notexists" mode="condition">
<xsl:template match="verify" mode="condition">
<xsl:template match="input[@contains]" mode="condition">
<xsl:template match="input[@pattern]" mode="condition">

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!--
	##############################################################################
	# Présence d'un fait CLIPS
	##############################################################################	
	-->
	
	<xsl:template match="exists" mode="condition">
		<xsl:if test="@ref"><xsl:value-of select="concat(@ref,' &lt;- ')"/></xsl:if>
		(_fact (indice ?indice-<xsl:value-of select="generate-id()"/>)
		       (data <xsl:value-of select="translate(@fact,'()','  ')"/>))
	</xsl:template>

	<!--
	##############################################################################
	# Absence d'un fait CLIPS
	##############################################################################
	-->
	
	<xsl:template match="notexists" mode="condition">
		(not (_fact (data <xsl:value-of select="translate(@fact,'()','  ')"/>)))
	</xsl:template>
	
	<!--
	##############################################################################
	# Condition booléenne
	##############################################################################
	-->
	
	<xsl:template match="verify" mode="condition">
		(test <xsl:value-of select="normalize-space(@test)"/>)
	</xsl:template>

	<!--
	##############################################################################
	# Unsolved conflict
	##############################################################################
	-->
	
	<xsl:template match="conflict" mode="condition">
		(conflit (id1 ?tmp1&amp;:(= ?tmp1 (string-to-field (getNumber <xsl:value-of select="@id1"/>))))
		         (id2 ?tmp2&amp;:(= ?tmp2 (string-to-field (getNumber <xsl:value-of select="@id2"/>)))))		
	</xsl:template>

	<!--
	##############################################################################
	# Détection d'une sous-chaine en entrée
	##############################################################################
	-->

	<xsl:template match="input[@contains]" mode="condition">
		<xsl:param name="scpere"/>
		(input (chaine ?texte)
		<xsl:if test="$scpere='NONE'">(indice ?indice)</xsl:if>
		<xsl:if test="$scpere='INDICE'">(indice ?indice)</xsl:if>
		<xsl:if test="$scpere='CONTEXT'">(contexte ?contexte)</xsl:if>
		)
		(test (str-index (lowcase "<xsl:value-of select="normalize-space(@contains)"/>") ?texte))
	</xsl:template>

	<!--
	##############################################################################
	# Détection d'une expression régulière
	##############################################################################
	-->

	<xsl:template match="input[@regexp]" mode="condition">
		<xsl:param name="scpere"/>
		(input (chaine ?texte)
		<xsl:if test="$scpere='NONE'">(indice ?indice)</xsl:if>
		<xsl:if test="$scpere='INDICE'">(indice ?indice)</xsl:if>
		<xsl:if test="$scpere='CONTEXT'">(contexte ?contexte)</xsl:if>
		)
		(test (pythonRegexp "<xsl:value-of select="@regexp"/>" ?texte))
	</xsl:template>
    
	<!--
	##############################################################################
	# Recherche d'un pattern en entrée
	##############################################################################	
	-->
	
	<xsl:template match="input[@pattern]" mode="condition">
		<xsl:call-template name="build-pattern">
			<xsl:with-param name="chaine" select="normalize-space(@pattern)"/>
		</xsl:call-template>
	</xsl:template>
	
	<!-- Construction du filtre pour les préconditions du type pattern -->
	
	<xsl:template name="build-pattern">
		<xsl:param name="chaine"/>
		<xsl:param name="i" select="1"/>
		<xsl:param name="jocker-before" select="false()"/>

		<xsl:variable name="tmp">
            <!-- pas le dernier mot -->
			<xsl:if test="contains($chaine,' ')"><xsl:value-of select="substring-before($chaine,' ')"/></xsl:if>
            <!-- dernier mot -->
			<xsl:if test="not(contains($chaine,' '))"><xsl:value-of select="$chaine"/></xsl:if>
		</xsl:variable>

		<xsl:variable name="optionnel" select="boolean(contains($tmp,'('))"/>
		<xsl:variable name="jocker" select="boolean($tmp = '*')"/>
        
        <xsl:if test="$jocker">
			<xsl:call-template name="build-pattern">
				<xsl:with-param name="chaine" select="substring-after($chaine,' ')"/>
				<xsl:with-param name="i" select="$i"/>
				<xsl:with-param name="jocker-before" select="true()"/>                
			</xsl:call-template>
		</xsl:if>
        
        <xsl:if test="not($jocker)">
    		<xsl:variable name="mot">
    			<xsl:if test="$optionnel"><xsl:value-of select="substring-before(substring-after($tmp,'('),')')"/></xsl:if>
    			<xsl:if test="not($optionnel)"><xsl:value-of select="$tmp"/></xsl:if>
    		</xsl:variable>

    		<xsl:if test="$optionnel">(or </xsl:if>
            
    		(mot (lemmes $?lemmes<xsl:value-of select="$i"/>)
                 (texte ?texte<xsl:value-of select="$i"/>&amp;:(comp ?texte<xsl:value-of select="$i"/> "<xsl:value-of select="$mot"/>" ?lemmes<xsl:value-of select="$i"/>))
                 
    		<xsl:if test="$i = 1">
                (pos ?pos<xsl:value-of select="$i"/>)
                (fin ?fin<xsl:value-of select="$i"/>))
            </xsl:if>
            
    		<xsl:if test="$i > 1">
                (pos ?pos<xsl:value-of select="$i"/>
                <!-- contrainte de succession après un jocker -->
                <xsl:if test="$jocker-before">&amp;:(>= ?pos<xsl:value-of select="$i"/> ?fin<xsl:value-of select="$i - 1"/>)</xsl:if>
                <!-- contrainte de succession sans jocker -->
                <xsl:if test="not($jocker-before)">&amp;:(succ ?pos<xsl:value-of select="$i"/> ?fin<xsl:value-of select="$i - 1"/>)</xsl:if>
                )
                (fin ?fin<xsl:value-of select="$i"/>))
            </xsl:if>
            
    		<xsl:if test="$optionnel">
                (mot (texte "") (pos ?fin<xsl:value-of select="$i - 1"/>) (fin ?fin<xsl:value-of select="$i"/>)))
            </xsl:if>

    		<xsl:if test="contains($chaine,' ')">
    			<xsl:call-template name="build-pattern">
    				<xsl:with-param name="chaine" select="substring-after($chaine,' ')"/>
    				<xsl:with-param name="i" select="$i + 1"/>
    			</xsl:call-template>
    		</xsl:if>
    	</xsl:if>
    </xsl:template>
	
</xsl:stylesheet>
