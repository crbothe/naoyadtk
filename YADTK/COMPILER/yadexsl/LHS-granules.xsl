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

<xsl:template match="granule" mode="condition">
<xsl:template match="nogranule" mode="condition">
<xsl:template name="test-concept">
<xsl:template name="build-lconcept">

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!--
	##############################################################################
	# Construction de la structure de granules à rechercher
	# Construit les pattern-CE qui recherchent des granules
	##############################################################################
	-->

	<xsl:template match="granule" mode="condition">
		<xsl:param name="idpere"/>
		<xsl:param name="scpere"/>
		<xsl:variable name="xmlid" select="generate-id()"/>
		<xsl:variable name="rule" select="ancestor::rule[1]"/>
		<xsl:variable name="conditions" select="ancestor::conditions[1]"/>

		<!-- Variable identificateur du granule -->
		<xsl:variable name="ident">
			<xsl:if test="@ident"><xsl:value-of select="@ident"/></xsl:if>
			<xsl:if test="not(@ident)">?<xsl:value-of select="$xmlid"/></xsl:if>
		</xsl:variable>

		<!-- Contrainte sur la place du granule / INDICE par défaut -->
		<xsl:variable name="scope">
			<xsl:choose>
				<xsl:when test="@scope != 'NONE'"><xsl:value-of select="@scope"/></xsl:when>
				<xsl:when test="$scpere != 'NONE'"><xsl:value-of select="$scpere"/></xsl:when>
				<xsl:otherwise>INDICE</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="scope-indice-flag" select="boolean($scope='INDICE')"/>
		<xsl:variable name="scope-context-flag" select="boolean($scope='CONTEXT')"/>
		<xsl:variable name="scope-global-flag" select="boolean($scope='GLOBAL')"/>
		
		<!-- Fact-adress du granule -->
		<xsl:value-of select="concat('?gr-',$xmlid,' &lt;- ')"/>

		(granule
			(ident <xsl:value-of select="$ident"/>)
			(indice ?indice-<xsl:value-of select="$xmlid"/>
			<xsl:if test="$scope-indice-flag">&amp;?indice</xsl:if>)
			<xsl:if test="$scope-context-flag">(contexte ?contexte)</xsl:if>
			<xsl:if test="@concept"><xsl:call-template name="test-concept"/></xsl:if>
			<xsl:if test="@offer or @reject">(offres $?offres-<xsl:value-of select="$xmlid"/>)</xsl:if>
			<xsl:if test="@metadata"><xsl:call-template name="test-metadata"/></xsl:if>
			<xsl:if test="@root">(racine <xsl:value-of select="@root"/>)</xsl:if>
			<xsl:if test="@inferred">(inferred <xsl:value-of select="@inferred"/>)</xsl:if>
		)
		<xsl:if test="@offer">(test (member$ <xsl:value-of select="@offer"/> ?offres-<xsl:value-of select="$xmlid"/>))</xsl:if>
		<xsl:if test="@reject">(test (not (member$ <xsl:value-of select="@reject"/> ?offres-<xsl:value-of select="$xmlid"/>)))</xsl:if>

		<!-- Vérifier la liaison avec le père -->
		<xsl:if test="$idpere">
		(liaison
		(idpere <xsl:value-of select="$idpere"/>)
		(idfils <xsl:value-of select="$ident"/>)
		<xsl:if test="@code">(code <xsl:value-of select="@code"/>)</xsl:if>
		<xsl:if test="@role">(role <xsl:value-of select="@role"/>)</xsl:if>
		)
		</xsl:if>

		<!-- Vérifier si le granule n'est pas obsolète sauf contre-indication -->
		<xsl:if test="$conditions/@accept-used-granules='FALSE'">
			(not (used (ident <xsl:value-of select="$ident"/>)))
		</xsl:if>

		<!-- Aller voir les fils -->
		<xsl:apply-templates select="granule|nogranule" mode="condition">
			<xsl:with-param name="idpere" select="$ident"/>
			<xsl:with-param name="scpere" select="$scope"/>
		</xsl:apply-templates>
	</xsl:template>

	<!--
	##############################################################################
	# Pour vérifier l'absence d'un granule
	# Construit les pattern-CE qui vérifient l'absence d'un granule
	##############################################################################
	-->

	<xsl:template match="nogranule" mode="condition">
		<xsl:param name="idpere"/>
		<xsl:param name="scpere"/>
		<xsl:variable name="xmlid" select="generate-id()"/>
		<xsl:variable name="rule" select="ancestor::rule[1]"/>
		<xsl:variable name="conditions" select="ancestor::conditions[1]"/>

		<!-- Contrainte sur la place du granule / INDICE par défaut -->
		<xsl:variable name="scope">
			<xsl:choose>
				<xsl:when test="@scope != 'NONE'"><xsl:value-of select="@scope"/></xsl:when>
				<xsl:when test="$scpere != 'NONE'"><xsl:value-of select="$scpere"/></xsl:when>
				<xsl:otherwise>INDICE</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="scope-indice-flag" select="boolean($scope='INDICE')"/>
		<xsl:variable name="scope-context-flag" select="boolean($scope='CONTEXT')"/>
		<xsl:variable name="scope-global-flag" select="boolean($scope='GLOBAL')"/>

		<!-- Aller d'abord voir les fils -->
		<xsl:apply-templates select="granule" mode="condition">
			<xsl:with-param name="scpere" select="$scope"/>
		</xsl:apply-templates>

		<!-- Présence d'un granule père -->
		<xsl:if test="$idpere">
			(not (and
			(granule
				(ident ?<xsl:value-of select="$xmlid"/>)
				<xsl:if test="$scope-indice-flag">(indice ?indice)</xsl:if>
				<xsl:if test="$scope-context-flag">(contexte ?contexte)</xsl:if>
				<xsl:if test="@offer">(offres $? <xsl:value-of select="@offer"/> $?)</xsl:if>
				<xsl:if test="@metadata"><xsl:call-template name="test-metadata"/></xsl:if>
				<xsl:if test="@concept"><xsl:call-template name="test-concept"/></xsl:if>
				<xsl:if test="@root">(racine <xsl:value-of select="@root"/>)</xsl:if>
			)
			(liaison
			(idpere <xsl:value-of select="$idpere"/>)
			(idfils ?<xsl:value-of select="$xmlid"/>)
			<xsl:if test="@role">(role <xsl:value-of select="@role"/>)</xsl:if>
			)

			<!-- Présence d'un granule fils -->
			<xsl:if test="granule">
				<!-- Variable identificateur du granule -->
				<xsl:variable name="idfils">
					<xsl:if test="granule/@ident"><xsl:value-of select="granule/@ident"/></xsl:if>
					<xsl:if test="not(granule/@ident)">?<xsl:value-of select="generate-id(granule)"/></xsl:if>
				</xsl:variable>
				(liaison (idpere ?<xsl:value-of select="$xmlid"/>) (idfils <xsl:value-of select="$idfils"/>))
			</xsl:if>

			))
		</xsl:if>

		<!-- Pas de granule père -->	
		<xsl:if test="not($idpere)">
			(not (and
			(granule
			(ident ?<xsl:value-of select="$xmlid"/>)
			<xsl:if test="$scope-indice-flag">(indice ?indice)</xsl:if>
			<xsl:if test="$scope-context-flag">(contexte ?contexte)</xsl:if>
			<xsl:if test="@offer">(offres $? <xsl:value-of select="@offer"/> $?)</xsl:if>
			<xsl:if test="@metadata">(metadata $? <xsl:value-of select="@metadata"/> $?)</xsl:if>
			<xsl:if test="@concept"><xsl:call-template name="test-concept"/></xsl:if>
			)
			
			<!-- Vérification du rôle -->
			<xsl:if test="@role">
				(liaison
				(idfils ?<xsl:value-of select="$xmlid"/>)
				(role <xsl:value-of select="@role"/>))
			</xsl:if>
			
			<!-- Présence d'un granule fils -->
			<xsl:if test="granule">
				<!-- Variable identificateur du granule -->
				<xsl:variable name="idfils">
					<xsl:if test="granule/@ident"><xsl:value-of select="granule/@ident"/></xsl:if>
					<xsl:if test="not(granule/@ident)">?<xsl:value-of select="generate-id(granule)"/></xsl:if>
				</xsl:variable>
				(liaison (idpere ?<xsl:value-of select="$xmlid"/>) (idfils <xsl:value-of select="$idfils"/>))
			</xsl:if>

			))
		</xsl:if>
	</xsl:template>

	<!--
	##############################################################################
	# Construction du filtre conceptuel pour <granule> et <nogranule>
	##############################################################################

	Possibilités d'unification (testé en test01) :

	concept="?x"			=> (concept ?x)
	concept="nombre"		=> (lconcept nombre $?)
	concept="nombre:4"		=> (lconcept nombre 4 $?)
	concept="nombre:?x"		=> (lconcept nombre ?x $?)
	concept="date:06:01"	=> (lconcept date 06 01)
	concept="date:?j:?m"	=> (lconcept date ?j ?m)
	concept="a:b:?x:c:?y"	=> (lconcept c b ?x c ?y $?)
	-->

	<xsl:template name="test-concept">
		<xsl:choose>
			<!-- Variable sur tout le concept -->
			<xsl:when test="substring(@concept,1,1) = '?'">
				(concept <xsl:value-of select="@concept"/>)
			</xsl:when>
			<!-- Autres cas -->
			<xsl:otherwise>
				<xsl:text>(lconcept</xsl:text>
				<xsl:call-template name="build-lconcept">
					<xsl:with-param name="chaine" select="@concept"/>
				</xsl:call-template>)
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Itération sur les termes entre les séparateurs -->

	<xsl:template name="build-lconcept">
		<xsl:param name="chaine"/>
		<xsl:choose>
			<xsl:when test="contains($chaine, ':')">
				<xsl:variable name="terme" select="substring-before($chaine,':')"/>
				<xsl:value-of select="concat(' ',$terme)"/>
				<xsl:call-template name="build-lconcept">
					<xsl:with-param name="chaine" select="substring-after($chaine,':')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat(' ',$chaine,' $?')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!--
	##############################################################################
	# Pour traiter les contraintes de metadata
	##############################################################################	
	-->

	<xsl:template name="test-metadata">
		<xsl:choose>
			<!-- Variable => variable multivaluée -->
			<xsl:when test="substring(@metadata,1,1) = '?'">
				(metadata $<xsl:value-of select="@metadata"/>)
			</xsl:when>
			<!-- Autres cas => une valeur possible -->
			<xsl:otherwise>
				(metadata $? <xsl:value-of select="@metadata"/> $?)
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
