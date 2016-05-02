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

<xsl:template match="connect-granule" mode="action">
<xsl:template match="disconnect-granule" mode="action">
<xsl:template match="delete-granule" mode="action">
<xsl:template match="forget-granule" mode="action">
<xsl:template match="change-granule" mode="action">
<xsl:template match="create-granule" mode="action">
<xsl:template match="reuse-granule" mode="action">
<xsl:template match="clone-granule" mode="action">
<xsl:template match="remplace-granule" mode="action">

-->

<xsl:stylesheet version="1.0"	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns:user="http://www.univ-lemans.fr/functions"
								extension-element-prefixes="user">
	<!--
	##############################################################################
	# Connecter un granule fils à un granule père
	##############################################################################	
	-->
	
	<xsl:template match="connect-granule" mode="action">
		(connect-granule <xsl:value-of select="concat(@parent,' ',@child,' ',@role)"/>)
	</xsl:template>

	<!--
	##############################################################################
	# Déconnecter un granule fils d'un granule père
	##############################################################################	
	-->
	
	<xsl:template match="disconnect-granule" mode="action">
		(disconnect-granule <xsl:value-of select="@ident"/>)
	</xsl:template>

	<!--
	##############################################################################
	# Supprimer définitivement un granule et sa descendance
	##############################################################################	
	-->
	
	<xsl:template match="delete-granule" mode="action">
		(delete-granule <xsl:value-of select="@ident"/>)
	</xsl:template>

	<!--
	##############################################################################
	# Oublier un granule et sa descendance (obsolescence)
	##############################################################################	
	-->
	
	<xsl:template match="forget-granule" mode="action">
		(forget-granule <xsl:value-of select="@ident"/>)
	</xsl:template>

	<!--
	##############################################################################
	# Changer le concept d'un granule (slot ident également modifié)
	##############################################################################	
	-->
	
	<xsl:template match="change-granule" mode="action">
		(change-granule <xsl:value-of select="@ident"/> (sym-cat <xsl:value-of select="user:explode(@concept)"/>))
	</xsl:template>

	<!--
	##############################################################################
	# Créer un nouveau granule ou une structure de granules
	##############################################################################	
	-->
	
	<xsl:template match="create-granule" mode="action">
		<xsl:param name="idpere"/>
		
		<xsl:variable name="id">
			<xsl:if test="@ident"><xsl:value-of select="@ident"/></xsl:if>
			<xsl:if test="not(@ident)"><xsl:value-of select="concat('?',generate-id())"/></xsl:if>
		</xsl:variable>

		<xsl:variable name="concept">(sym-cat <xsl:value-of select="user:explode(@concept)"/>)</xsl:variable>

		<xsl:if test="not($idpere)">
			<!-- Pas de père => créer un granule racine -->
			(bind <xsl:value-of select="concat($id,' (create-granule-1 ',$concept,')')"/>)
		</xsl:if>

		<xsl:if test="$idpere">
			<!-- Un père => créer un granule fils et le rattacher -->	
			(bind <xsl:value-of select="concat($id,' (create-granule-2 ',$concept,' ',$idpere,' ',@role,')')"/>)
		</xsl:if>

		<!-- Aller voir les fils  -->
		<xsl:apply-templates select="create-granule | reuse-granule | clone-granule" mode="action">
			<xsl:with-param name="idpere" select="$id"/>
		</xsl:apply-templates>
	</xsl:template>

	<!--
	##############################################################################
	# Réutiliser un granule ou une structure de granules
	##############################################################################	
	-->
	
	<xsl:template match="reuse-granule" mode="action">
		<xsl:param name="idpere"/>
		<!--<xsl:variable name="id" select="substring-after(@ident,'?')"/>-->

		<xsl:variable name="role">
			<xsl:if test="@role"><xsl:value-of select="@role"/></xsl:if>
			<xsl:if test="not(@role)">nil</xsl:if>
		</xsl:variable>

		<xsl:if test="$idpere">
			(disconnect-granule <xsl:value-of select="@ident"/>)
			(connect-granule <xsl:value-of select="concat($idpere,' ',@ident,' ',@role,')')"/>
		</xsl:if>

		<!-- Aller voir les fils  -->
		<xsl:apply-templates select="create-granule | reuse-granule | clone-granule" mode="action">
			<xsl:with-param name="idpere" select="@ident"/>
		</xsl:apply-templates>
	</xsl:template>

	<!--
	##############################################################################
	# Cloner un granule ou une structure de granules
	##############################################################################	
	-->
	
	<xsl:template match="clone-granule" mode="action">
		<xsl:param name="idpere"/>
		<xsl:variable name="id" select="concat('?',generate-id())"/>

		<xsl:variable name="role">
			<xsl:if test="@role"><xsl:value-of select="@role"/></xsl:if>
			<xsl:if test="not(@role)">nil</xsl:if>
		</xsl:variable>

		(bind <xsl:value-of select="concat($id,' (clone-granule ',@ident,')')"/>)

		<xsl:if test="$idpere">
			(connect-granule <xsl:value-of select="concat($idpere,' ',$id,' ',@role,')')"/>
		</xsl:if>

		<!-- Aller voir les fils  -->
		<xsl:apply-templates select="create-granule | reuse-granule | clone-granule" mode="action">
			<xsl:with-param name="idpere" select="$id"/>
		</xsl:apply-templates>
	</xsl:template>

	<!--
	##############################################################################
	# Remplacer un granule ou une structure de granules
	##############################################################################	
	-->
	
	<xsl:template match="remplace-granule" mode="action">
		<xsl:if test="create-granule">
			<xsl:apply-templates select="create-granule" mode="action"/>
			(remplace-granule <xsl:value-of select="concat(@ident,' ?',generate-id(create-granule))"/>)
		</xsl:if>
		<xsl:if test="reuse-granule">
			<xsl:apply-templates select="reuse-granule" mode="action"/>
			(remplace-granule <xsl:value-of select="concat(@ident,' ',child::reuse-granule[1]/@ident)"/>)
		</xsl:if>
		<xsl:if test="clone-granule">
			<xsl:apply-templates select="clone-granule" mode="action"/>
			(remplace-granule <xsl:value-of select="concat(@ident,' ',child::clone-granule[1]/@ident)"/>)
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
