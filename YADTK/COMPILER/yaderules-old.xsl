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
	<!--
	(deffacts YADEGLOB::initial-facts
	<xsl:for-each select="yaderules/initial">
		<xsl:value-of select="@fact"/>
	</xsl:for-each>)
	-->
	<xsl:apply-templates select="yaderules/set-string" mode="defglobal"/>
	<xsl:apply-templates select="yaderules/set-symbol" mode="defglobal"/>
	<xsl:apply-templates select="yaderules//rule" mode="defglobal"/>
	<xsl:apply-templates select="yaderules/rule" mode="defrule"/>
	<!--xsl:apply-templates select="yaderules/rule" mode="agenda"/-->
</xsl:template>

<!-- Les variables globales -->

<xsl:template match="set-string" mode="defglobal">
	(defglobal YADEGLOB ?*<xsl:value-of select="@name"/>* = "<xsl:value-of select="@value"/>")
</xsl:template>

<xsl:template match="set-symbol" mode="defglobal">
		(defglobal YADEGLOB ?*<xsl:value-of select="@name"/>* = <xsl:value-of select="@value"/>)
</xsl:template>

<xsl:template match="rule" mode="defglobal">
	(defglobal YADERULE ?*salience-<xsl:value-of select="generate-id()"/>* = 0)
</xsl:template>

<!-- ======================================= -->
<!-- Modèle générale d'une règle de dialogue -->
<!-- ======================================= -->

<xsl:template match="rule" mode="defrule">
	
	<xsl:param name="regle-mere"/>
	<xsl:variable name="idrule" select="generate-id()"/>
	
	<!-- Typologie des règles et autres attributs (détermine une stratégie de dialogue) -->
	
	<xsl:variable name="inference" select="boolean(@type='inference')"/>
	<xsl:variable name="dialogue" select="boolean(@type='dialogue')"/>
	<xsl:variable name="immediate" select="boolean(@priority='HIGH')"/>
	<xsl:variable name="terminale" select="boolean(@terminal='TRUE')"/>
	<xsl:variable name="incidente" select="boolean(rule)"/>
	<xsl:variable name="contextuelle" select="boolean(parent::rule)"/>
	<xsl:variable name="regissante" select="boolean(not($incidente) and not($contextuelle) and not($immediate))"/>
	<xsl:variable name="opportuniste" select="boolean(not($incidente) and not($contextuelle) and $immediate)"/>
	<xsl:variable name="contextuelle-term" select="boolean(not($incidente) and $contextuelle and $terminale)"/>
	<xsl:variable name="contextuelle-nterm" select="boolean(not($incidente) and $contextuelle and not($terminale))"/>
	
	<xsl:variable name="type-regle">
		<xsl:choose>
			<xsl:when test="$inference">INF</xsl:when>
			<xsl:when test="$incidente">INC</xsl:when>
			<xsl:when test="$regissante">REG</xsl:when>
			<xsl:when test="$opportuniste">ROP</xsl:when>
			<xsl:when test="$contextuelle-term">RCT</xsl:when>
			<xsl:when test="$contextuelle-nterm">RCNT</xsl:when>
			<xsl:otherwise>ERROR</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Construction de la règle -->
	
	(defrule YADERULE::<xsl:value-of select="$idrule"/>
	<xsl:if test="@descr">"<xsl:value-of select="@descr"/>"</xsl:if>
	(declare (salience ?*salience-<xsl:value-of select="$idrule"/>*))
	
	<xsl:if test="$dialogue">
		<!-- Pour ne pas déclencher la règle deux fois de suite -->
		?liste &lt;- (liste $?liste-regles)
		(test (not (member$ <xsl:value-of select="$idrule"/> ?liste-regles)))
	</xsl:if>
	
	(contexte (indice ?indice)
	<xsl:choose>
		<xsl:when test="$dialogue and ($regissante or ($incidente and not($contextuelle)))">(pile-contextes ?contexte&amp;0)</xsl:when>
		<xsl:otherwise>(pile-contextes ?contexte $?)</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="$incidente and not($contextuelle)">(pile-regles ~<xsl:value-of select="$idrule"/> $?)</xsl:if>
	<xsl:if test="$contextuelle and not($incidente)">(pile-regles <xsl:value-of select="$regle-mere"/> $?)</xsl:if>
	<xsl:if test="$contextuelle and $incidente">(pile-regles <xsl:value-of select="$regle-mere"/>&amp;~<xsl:value-of select="$idrule"/> $?)</xsl:if>
	)
	
	<!-- Pour récupérer les variables dans le cas d'une règle contextuelle -->
	<xsl:if test="$contextuelle">
		<xsl:apply-templates select="ancestor::rule/conditions/descendant::granule[contains(@ident,'?')]" mode="get-variable-id"/>
		<xsl:apply-templates select="ancestor::rule/conditions/descendant::granule[contains(@concept,':?')]" mode="get-variable-co"/>
		<xsl:apply-templates select="ancestor::rule/conditions/exists[@ref]" mode="get-variable-1"/>
		<xsl:apply-templates select="ancestor::rule/conditions/exists[contains(@fact,'?')]" mode="get-variable-2"/>
		<xsl:apply-templates select="ancestor::rule/actions/bind" mode="get-variable"/>
	</xsl:if>
	
	<!-- Motifs de granules et autres conditions -->
	<xsl:apply-templates select="conditions/*" mode="condition">
		<xsl:with-param name="scpere" select="conditions/@scope"/>
	</xsl:apply-templates>
	
	<!-- Pour ajouter la condition granules différents -->
	<xsl:call-template name="neq-granules">
		<xsl:with-param name="granules" select="conditions//granule"/>
    </xsl:call-template>
	
	<!-- Pour ajouter la condition granules-racines ordonnés (version 1 = ordonnés seulement) -->
	<xsl:if test="conditions/@ordered='TRUE'">
		<xsl:call-template name="ord-granules-1">
			<xsl:with-param name="granules" select="conditions/granule"/>
    	</xsl:call-template>
	</xsl:if>
	
	<!-- Pour ajouter la condition granules-racines ordonnés (version 2 = ordonnés + au plus proche) -->
	<xsl:if test="conditions/@nearest='TRUE'">
		<xsl:call-template name="ord-granules-2">
			<xsl:with-param name="granules" select="conditions/granule"/>
    	</xsl:call-template>
	</xsl:if>
	
	<xsl:if test="$dialogue">
		<!-- Pour vérifier qu'un granule ou un fait au moins est nouveau (indice courant) SAUF S'IL Y A UN NOT GRANULE !!! -->
		<xsl:if test="conditions//granule and not(conditions//nogranule)">
			(test (member$ ?indice (create$
			<xsl:for-each select="conditions//granule"> ?indice-<xsl:value-of select="generate-id()"/></xsl:for-each>
			<xsl:for-each select="conditions//exists"> ?indice-<xsl:value-of select="generate-id()"/></xsl:for-each>
			)))
		</xsl:if>
	</xsl:if>
	
	<xsl:if test="$inference">(test (bind ?*salience-<xsl:value-of select="$idrule"/>* ?*salience-INF*))</xsl:if>
	<xsl:if test="$dialogue">
	<!-- Calcul de la priorité dynamique -->
		<xsl:apply-templates select="conditions//granule[not(parent::granule)]" mode="get-poids"/>
		(test (bind ?*salience-<xsl:value-of select="$idrule"/>* (+
			<!-- Partir du poids de base de la règle -->
			?*salience-<xsl:value-of select="$type-regle"/>*
			<!-- Ajouter le nombre total de granules -->
			<xsl:value-of select="count(conditions/descendant::*)"/>
			<!-- Ajouter les poids des granules racine -->
			<xsl:for-each select="conditions//granule[not(parent::granule)]">
				<xsl:variable name="ident">
					<xsl:if test="@ident"><xsl:value-of select="@ident"/></xsl:if>
					<xsl:if test="not(@ident)">?<xsl:value-of select="generate-id()"/></xsl:if>
				</xsl:variable>
				<xsl:value-of select="concat(' ',$ident,'-poids')"/>
			</xsl:for-each>
			<!-- Ajouter un petit plus -->
			<xsl:if test="@salience"><xsl:value-of select="concat(' ',@salience)"/></xsl:if>
		)))
	</xsl:if>
	
	=>
	
	<!-- Construction de la description de la règle -->
	<xsl:call-template name="description-rule"/>
	
	<xsl:if test="$incidente">
		<!-- Empiler un nouveau contexte -->
		(empiler-contexte <xsl:value-of select="$idrule"/>)
		<!-- Passer des variables aux règles contextuelles -->
		<xsl:apply-templates select="conditions/descendant::granule[contains(@ident,'?')]" mode="set-variable-id"/>
		<xsl:apply-templates select="conditions/descendant::granule[contains(@concept,':?')]" mode="set-variable-co"/>
		
		<xsl:apply-templates select="conditions/exists[@ref]" mode="set-variable-1"/>
		<xsl:apply-templates select="conditions/exists[contains(@fact,'?')]" mode="set-variable-2"/>
		<!-- Empêcher le déclenchement d'une autre règle -->
		(pop-focus)
	</xsl:if>
	
	<!-- Actions -->
	<xsl:for-each select="actions/*">
		<xsl:if test="not(@test)"><xsl:apply-templates select="." mode="action"/></xsl:if>
		<xsl:if test="@test">
			(if <xsl:value-of select="@test"/> then <xsl:apply-templates select="." mode="action"/>)
		</xsl:if>
	</xsl:for-each>
	
	<xsl:if test="$dialogue">
		<xsl:if test="$terminale">(depiler-contexte)</xsl:if>
		(retract ?liste)
		(assert (liste ?liste-regles <xsl:value-of select="$idrule"/>))
	</xsl:if>
	
	<!-- Pointer les granules racine utilisés
	<xsl:apply-templates select="conditions/granule" mode="used"/>
	-->
	
	(calcule-poids-des-granules))
	
	<!-- Pour construire les règles contextuelles -->
	<xsl:apply-templates select="rule" mode="defrule">
		<xsl:with-param name="regle-mere" select="$idrule"/>
	</xsl:apply-templates>
	
</xsl:template>

<!-- ===================================================== -->
<!-- Construction de la structure de granules à rechercher -->
<!-- ===================================================== -->

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
	
	<!-- Type de la règle en construction (repris sur le modèle générale d'une règle) -->
	<xsl:variable name="immediate" select="boolean($rule/@immediate='TRUE')"/>
	<xsl:variable name="terminale" select="boolean($rule/@terminal='TRUE')"/>
	<xsl:variable name="incidente" select="boolean($rule/rule)"/>
	<xsl:variable name="contextuelle" select="boolean($rule/parent::rule)"/>
	<xsl:variable name="regissante" select="boolean(not($incidente) and not($contextuelle) and not($immediate))"/>
	<xsl:variable name="opportuniste" select="boolean(not($incidente) and not($contextuelle) and $immediate)"/>
	<xsl:variable name="contextuelle-term" select="boolean($contextuelle and $terminale)"/>
	<xsl:variable name="contextuelle-nterm" select="boolean($contextuelle and not($terminale))"/>
	
	<!-- Fact-adress du granule -->
	<xsl:value-of select="concat('?gr-',$xmlid,' &lt;- ')"/>
	
	(granule
		(ident <xsl:value-of select="$ident"/>)
		(indice ?indice-<xsl:value-of select="$xmlid"/>
		<xsl:if test="$scope-indice-flag">&amp;?indice</xsl:if>)
		<xsl:if test="$scope-context-flag">(contexte ?contexte)</xsl:if>
		<xsl:if test="@concept"><xsl:call-template name="test-concept"/></xsl:if>
		<!--<xsl:if test="@offer">(types $? <xsl:value-of select="@offer"/> $?)</xsl:if>-->
		<xsl:if test="@offer or @reject">(types $?types-<xsl:value-of select="$xmlid"/>)</xsl:if>
		<xsl:if test="@metadata">(metadata $? <xsl:value-of select="@metadata"/> $?)</xsl:if>
		<xsl:if test="@role">(role <xsl:value-of select="@role"/>)</xsl:if>
		<xsl:if test="@code">(code <xsl:value-of select="@code"/>)</xsl:if>
		<xsl:if test="@root">(racine <xsl:value-of select="@root"/>)</xsl:if>
		<xsl:if test="@inferred">(inferred <xsl:value-of select="@inferred"/>)</xsl:if>
	)
	<xsl:if test="@offer">(test (member$ <xsl:value-of select="@offer"/> ?types-<xsl:value-of select="$xmlid"/>))</xsl:if>
	<xsl:if test="@reject">(test (not (member$ <xsl:value-of select="@reject"/> ?types-<xsl:value-of select="$xmlid"/>)))</xsl:if>

	<!-- Vérifier la liaison avec le père -->
	<xsl:if test="$idpere">
	(liaison
	<xsl:if test="@code">(code <xsl:value-of select="@code"/>)</xsl:if>
	(idpere <xsl:value-of select="$idpere"/>)
	(idfils <xsl:value-of select="$ident"/>)
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

<!-- Vérifier l'absence d'un granule  -->

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
			<xsl:if test="@role">(role <xsl:value-of select="@role"/>)</xsl:if>
			<xsl:if test="@offer">(types $? <xsl:value-of select="@offer"/> $?)</xsl:if>
			<xsl:if test="@metadata">(metadata $? <xsl:value-of select="@metadata"/> $?)</xsl:if>
			<xsl:if test="@concept"><xsl:call-template name="test-concept"/></xsl:if>
			<xsl:if test="@root">(racine <xsl:value-of select="@root"/>)</xsl:if>
		)
		(liaison (idpere <xsl:value-of select="$idpere"/>) (idfils ?<xsl:value-of select="$xmlid"/>))
		
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
		<xsl:if test="@role">(role <xsl:value-of select="@role"/>)</xsl:if>
		<xsl:if test="@offer">(types $? <xsl:value-of select="@offer"/> $?)</xsl:if>
		<xsl:if test="@metadata">(metadata $? <xsl:value-of select="@metadata"/> $?)</xsl:if>
		<xsl:if test="@concept"><xsl:call-template name="test-concept"/></xsl:if>
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
</xsl:template>

<!-- Pointer les granules utilisés -->

<xsl:template match="granule" mode="used">
	<xsl:variable name="ident">
		<xsl:if test="@ident"><xsl:value-of select="@ident"/></xsl:if>
		<xsl:if test="not(@ident)">?<xsl:value-of select="generate-id()"/></xsl:if>
	</xsl:variable>
	(propage-used <xsl:value-of select="$ident"/>)
</xsl:template>

<!-- Créer les faits variable (dans RHS des règles incidentes)-->

<xsl:template match="granule" mode="set-variable-id">
	(assert (variable
	(contexte <xsl:value-of select="generate-id(ancestor::rule[1])"/>)
	(ident <xsl:value-of select="substring-after(@ident,'?')"/>)
	(value <xsl:value-of select="@ident"/>)))
</xsl:template>

<xsl:template match="granule" mode="set-variable-co">
	(assert (variable
	(contexte <xsl:value-of select="generate-id(ancestor::rule[1])"/>)
	(ident <xsl:value-of select="substring-after(@concept,':?')"/>)
	(value <xsl:value-of select="substring-after(@concept,':')"/>)))
</xsl:template>

<xsl:template match="exists" mode="set-variable-1">
	(assert (variable
	(contexte <xsl:value-of select="generate-id(ancestor::rule[1])"/>)
	(ident <xsl:value-of select="substring-after(@ref,'?')"/>)
	(value <xsl:value-of select="@ref"/>)))
</xsl:template>

<xsl:template match="exists" mode="set-variable-2">
	<xsl:call-template name="assert-variables-exists">
		<xsl:with-param name="chaine" select="normalize-space(@fact)"/>
		<xsl:with-param name="contexte" select="generate-id(ancestor::rule[1])"/>
	</xsl:call-template>
</xsl:template>

<!-- Récupérer les faits variable (dans LHS des règles contextuelles) -->

<xsl:template match="granule" mode="get-variable-id">
	(variable
	(contexte <xsl:value-of select="generate-id(ancestor::rule[1])"/>)
	(ident <xsl:value-of select="substring-after(@ident,'?')"/>)
	(value <xsl:value-of select="@ident"/>))
</xsl:template>

<xsl:template match="granule" mode="get-variable-co">
	(variable
	(contexte <xsl:value-of select="generate-id(ancestor::rule[1])"/>)
	(ident <xsl:value-of select="substring-after(@concept,':?')"/>)
	(value <xsl:value-of select="substring-after(@concept,':')"/>))
</xsl:template>

<xsl:template match="exists" mode="get-variable-1">
	(variable
	(contexte <xsl:value-of select="generate-id(ancestor::rule[1])"/>)
	(ident <xsl:value-of select="substring-after(@ref,'?')"/>)
	(value <xsl:value-of select="@ref"/>))
</xsl:template>

<xsl:template match="exists" mode="get-variable-2">
	<xsl:call-template name="get-variables-exists">
		<xsl:with-param name="chaine" select="normalize-space(@fact)"/>
		<xsl:with-param name="contexte" select="generate-id(ancestor::rule[1])"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="bind" mode="get-variable">
	(variable
	(contexte <xsl:value-of select="generate-id(ancestor::rule[1])"/>)
	(ident <xsl:value-of select="substring-after(@var,'?')"/>)
	(value <xsl:value-of select="@var"/>))
</xsl:template>

<!-- Les autres préconditions -->

<xsl:template match="stop" mode="condition">
	(stop)
</xsl:template>

<xsl:template match="exists" mode="condition">
	<xsl:if test="@ref"><xsl:value-of select="concat(@ref,' &lt;- ')"/></xsl:if>
	(_fact (indice ?indice-<xsl:value-of select="generate-id()"/>)
	       (data <xsl:value-of select="translate(@fact,'()','  ')"/>))
</xsl:template>

<xsl:template match="notexists" mode="condition">
	(not (_fact (data <xsl:value-of select="translate(@fact,'()','  ')"/>)))
</xsl:template>

<xsl:template match="catch" mode="condition">
	<xsl:variable name="internal" select="translate(@fact,'()','  ')"/>
	(or (_fact (data <xsl:value-of select="$internal"/>))
	    (_default
	<xsl:call-template name="scan-variables-catch">
		<xsl:with-param name="chaine" select="$internal"/>
	</xsl:call-template> $?))
</xsl:template>

<xsl:template match="verify" mode="condition">
	(test <xsl:value-of select="normalize-space(@test)"/>)
</xsl:template>

<xsl:template match="input[@contains]" mode="condition">
	(input (chaine ?texte))
	(test (str-index (lowcase "<xsl:value-of select="normalize-space(@contains)"/>") ?texte))
</xsl:template>

<xsl:template match="input[@pattern]" mode="condition">
	<xsl:call-template name="build-pattern">
		<xsl:with-param name="chaine" select="normalize-space(@pattern)"/>
	</xsl:call-template>
</xsl:template>

<xsl:template match="detect" mode="condition">
	(_indic (ident <xsl:value-of select="@indicator"/>)
	<xsl:if test="@value">(value <xsl:value-of select="@value"/>)</xsl:if>)
</xsl:template>

<!-- Pour le calcul de la salience dynamique -->

<xsl:template match="granule" mode="get-poids">
	<xsl:variable name="idrule" select="generate-id(ancestor::rule[1])"/>
	<xsl:variable name="ident">
		<xsl:if test="@ident"><xsl:value-of select="@ident"/></xsl:if>
		<xsl:if test="not(@ident)">?<xsl:value-of select="generate-id()"/></xsl:if>
	</xsl:variable>
	(poids-granule (ident <xsl:value-of select="$ident"/>) (poids <xsl:value-of select="$ident"/>-poids))
</xsl:template>

<!-- =============================================================================================================================== -->
<!-- Actions Actions Actions Actions Actions Actions Actions Actions Actions Actions Actions Actions Actions Actions Actions Actions -->
<!-- =============================================================================================================================== -->

<xsl:template match="speak" mode="action">
	<xsl:if test="@text">
		<xsl:call-template name="transforme-speak">
			<xsl:with-param name="chaine" select="@text"/>
		</xsl:call-template>
	</xsl:if>
	<!-- Pour la génération d'une structure littérale -->
	<xsl:for-each select="granule">
		(generer-XML (str-cat "<xsl:apply-templates select="." mode="generation"/>") <xsl:value-of select="@modifiers"/>)
	</xsl:for-each>
</xsl:template>

<xsl:template match="assert" mode="action">
	(assert-fact <xsl:value-of select="translate(@fact,'()','  ')"/>)
</xsl:template>

<xsl:template match="retract" mode="action">
	<xsl:if test="@ref">(retract-fact <xsl:value-of select="@ref"/>)</xsl:if>
	<xsl:if test="@all">(retract-all <xsl:value-of select="@all"/>)</xsl:if>
</xsl:template>

<xsl:template match="reset" mode="action">
	(reset-counter <xsl:value-of select="@counter"/>)
</xsl:template>

<xsl:template match="increase" mode="action">
	(increase-counter <xsl:value-of select="@counter"/>)
</xsl:template>

<xsl:template match="set-string" mode="action">
	(bind ?*<xsl:value-of select="@name"/>* "<xsl:value-of select="@value"/>")
	(ajoute-action (format nil "    Modification de la variable globale ?*%s* = '%s'"
		<xsl:text> "</xsl:text><xsl:value-of select="@name"/><xsl:text>" </xsl:text>
		<xsl:text> "</xsl:text><xsl:value-of select="@value"/><xsl:text>"</xsl:text>))
</xsl:template>

<xsl:template match="set-symbol" mode="action">
	(bind ?*<xsl:value-of select="@name"/>* <xsl:value-of select="@value"/>)
	(ajoute-action "<xsl:value-of select="concat('    Modification de la variable globale ?*',@name,'* = ',@value)"/>")
</xsl:template>

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

<xsl:template match="ctrl" mode="action">
	(ctrl-<xsl:value-of select="@command"/>)
</xsl:template>

<!-- ============================================ -->
<!-- Pour la génération d'une structure littérale -->
<!-- ============================================ -->

<xsl:template match="granule" mode="generation">
	<xsl:param name="idpere" select="'nil'"/>
	<xsl:param name="prof" select="0"/>
	<xsl:param name="mod"/>
	<xsl:variable name="xmlid" select="generate-id()"/>
	<xsl:variable name="modifiers" select="concat($mod,' ',@modifiers)"/>
	
	<xsl:text>&lt;granule</xsl:text>
	<xsl:text> idgranule='</xsl:text><xsl:value-of select="$xmlid"/><xsl:text>'</xsl:text>
	<xsl:text> idconcept='</xsl:text><xsl:value-of select="@concept"/><xsl:text>'</xsl:text>
	
	<xsl:text> modifieurs='</xsl:text>
	<xsl:call-template name="isole-variables">
		<xsl:with-param name="chaine" select="$modifiers"/>
	</xsl:call-template>
	
	<xsl:text>'</xsl:text>
		
	<xsl:if test="@code"><xsl:text> code='</xsl:text><xsl:value-of select="@code"/><xsl:text>'</xsl:text></xsl:if>
	<xsl:if test="@role"><xsl:text> role='</xsl:text><xsl:value-of select="@role"/><xsl:text>'</xsl:text></xsl:if>
	
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
	<xsl:variable name="modifiers" select="concat($mod,' ',@modifiers)"/>
	
	<xsl:text>" (granule-to-XML </xsl:text>
	<xsl:value-of select="@ident"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="$modifiers"/>
	<xsl:text>) "</xsl:text>
</xsl:template>

<xsl:template name="isole-variables">
	<xsl:param name="chaine"/>
	<xsl:choose>
		<xsl:when test="contains($chaine, '?')">
			<xsl:variable name="var" select="substring-before(substring-after($chaine,'?'),' ')"/>
			<xsl:variable name="len" select="number(string-length($var))"/>

			<xsl:if test="$len!=0">
				<!-- un espace après la variable -->
				<xsl:value-of select="substring-before($chaine, '?')"/>
				<xsl:text>" ?</xsl:text><xsl:value-of select="$var"/><xsl:text> "</xsl:text>
				<xsl:call-template name="isole-variables">
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

<!-- ====================================== -->
<!-- Actions sur les structures de granules -->
<!-- ====================================== -->

<!-- connect-granule -->

<xsl:template match="connect-granule" mode="action">
	(connect-granule <xsl:value-of select="concat(@parent,' ',@child,' ',@role)"/>)
</xsl:template>

<!-- disconnect-granule -->

<xsl:template match="disconnect-granule" mode="action">
	(disconnect-granule <xsl:value-of select="@ident"/>)
</xsl:template>

<!-- delete-granule -->

<xsl:template match="delete-granule" mode="action">
	(delete-granule <xsl:value-of select="@ident"/>)
</xsl:template>

<!-- forget-granule -->

<xsl:template match="forget-granule" mode="action">
	(forget-granule <xsl:value-of select="@ident"/>)
</xsl:template>

<!-- change-granule -->

<xsl:template match="change-granule" mode="action">
	(change-granule <xsl:value-of select="concat(@ident,' ',@value)"/>)
</xsl:template>

<!-- create-granule -->

<xsl:template match="create-granule" mode="action">
	<xsl:param name="idpere"/>
	<xsl:variable name="id">
		<xsl:if test="@ident"><xsl:value-of select="@ident"/></xsl:if>
		<xsl:if test="not(@ident)"><xsl:value-of select="concat('?',generate-id())"/></xsl:if>
	</xsl:variable>
	
	<!-- Reconstruire le nom complet du concept dans $concept -->
	<xsl:variable name="concept">
		<xsl:choose>
		<xsl:when test="contains(@concept,':')">
			<xsl:variable name="con" select="substring-before(@concept,':')"/>
			<xsl:variable name="val" select="substring-after(@concept,':')"/>
			(sym-cat <xsl:value-of select="$con"/>: <xsl:value-of select="$val"/>)
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="@concept"/>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
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

<!-- reuse-granule -->

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

<!-- clone-granule -->

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

<!-- remplace-granule -->

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

<!-- =================================== -->
<!-- Test granules différents            -->
<!-- =================================== -->

<xsl:template name="neq-granules">
	<xsl:param name="granules"/>
	<xsl:if test="count($granules) > 1">
		<xsl:text>(test (differents$ (create$</xsl:text>
		<xsl:for-each select="$granules">
			<xsl:value-of select="concat(' ?gr-',generate-id())"/>
		</xsl:for-each>)))
	</xsl:if>
</xsl:template>

<!-- =================================== -->
<!-- Test granules ordonnés              -->
<!-- =================================== -->

<xsl:template name="ord-granules-1">
	<xsl:param name="granules"/>
	<xsl:if test="count($granules) > 1">
		<xsl:text>(test (ok-ordre-fact-liste-1 (create$</xsl:text>
		<xsl:for-each select="$granules">
			<xsl:value-of select="concat(' ?gr-',generate-id())"/>
		</xsl:for-each>)))
	</xsl:if>
</xsl:template>

<xsl:template name="ord-granules-2">
	<xsl:param name="granules"/>
	<xsl:if test="count($granules) > 1">
		<xsl:text>(test (ok-ordre-fact-liste-2 (create$</xsl:text>
		<xsl:for-each select="$granules">
			<xsl:value-of select="concat(' ?gr-',generate-id())"/>
		</xsl:for-each>)))
	</xsl:if>
</xsl:template>

<!-- =============================== -->
<!-- Test du concept dans un granule -->
<!-- =============================== -->

<!-- Possibilités d'unification (testé en test01) :

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

<!-- =================================================================== -->
<!-- Récupération des variables pour la précondition par défaut du catch -->
<!-- =================================================================== -->

<xsl:template name="scan-variables-catch">
	<xsl:param name="chaine"/>
	<xsl:choose>
		<xsl:when test="contains($chaine, '?')">
			<xsl:variable name="var1" select="substring-before(substring-after($chaine,'?'),' ')"/>
			<xsl:variable name="var2" select="substring-before(substring-after($chaine,'?'),')')"/>
			<xsl:variable name="len1" select="number(string-length($var1))"/>
			<xsl:variable name="len2" select="number(string-length($var2))"/>

			<xsl:if test="$len1!=0 and not($len2!=0 and $len2 &lt; $len1)">
				<!-- un espace après la variable -->
				?<xsl:value-of select="$var1"/>
				<xsl:text> </xsl:text>
				<xsl:call-template name="scan-variables-catch">
					<xsl:with-param name="chaine" select="substring-after(substring-after($chaine,'?'),' ')"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:if test="$len2!=0 and not($len1!=0 and $len1 &lt; $len2)">
				<!-- une parenthèse fermante après la variable -->			
				?<xsl:value-of select="$var2"/>
				<xsl:text> </xsl:text>
				<xsl:call-template name="scan-variables-catch">
					<xsl:with-param name="chaine" select="substring-after(substring-after($chaine,'?'),')')"/>
				</xsl:call-template>
			</xsl:if>
			
		</xsl:when>
	</xsl:choose>
</xsl:template>

<!-- ================================================================= -->
<!-- Sauvegarde et récupération des variables des préconditions exists -->
<!-- ================================================================= -->

<xsl:template name="assert-variables-exists">
	<xsl:param name="chaine"/>
	<xsl:param name="contexte"/>
	<xsl:variable name="apres" select="substring(substring-after($chaine,'?'),1,1)"/>
	<xsl:choose>
		
		<!-- Prise en compte des jockers monovalués -->
		<xsl:when test="contains($chaine, '?') and ($apres=' ' or $apres=')')">
			<xsl:call-template name="assert-variables-exists">
				<xsl:with-param name="chaine" select="substring-after($chaine,'?')"/>
				<xsl:with-param name="contexte" select="$contexte"/>
			</xsl:call-template>
		</xsl:when>
		
		<xsl:when test="contains($chaine, '?')">
			<xsl:variable name="var1" select="substring-before(substring-after($chaine,'?'),' ')"/>
			<xsl:variable name="var2" select="substring-before(substring-after($chaine,'?'),')')"/>
			<xsl:variable name="len1" select="number(string-length($var1))"/>
			<xsl:variable name="len2" select="number(string-length($var2))"/>

			<xsl:if test="$len1!=0 and not($len2!=0 and $len2 &lt; $len1)">
				<!-- un espace après la variable -->
				<xsl:if test="not(contains(preceding-sibling::exists/@fact,concat('?',$var1)))">
					(assert (variable
					(contexte <xsl:value-of select="$contexte"/>)
					(ident <xsl:value-of select="$var1"/>)
					(value ?<xsl:value-of select="$var1"/>)))
				</xsl:if>
				<xsl:call-template name="assert-variables-exists">
					<xsl:with-param name="chaine" select="substring-after(substring-after($chaine,'?'),' ')"/>
					<xsl:with-param name="contexte" select="$contexte"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:if test="$len2!=0 and not($len1!=0 and $len1 &lt; $len2)">
				<!-- une parenthèse fermante après la variable -->
				<xsl:if test="not(contains(preceding-sibling::exists/@fact,concat('?',$var2)))">	
					(assert (variable
					(contexte <xsl:value-of select="$contexte"/>)
					(ident <xsl:value-of select="$var2"/>)
					(value ?<xsl:value-of select="$var2"/>)))
				</xsl:if>
				<xsl:call-template name="assert-variables-exists">
					<xsl:with-param name="chaine" select="substring-after(substring-after($chaine,'?'),')')"/>
					<xsl:with-param name="contexte" select="$contexte"/>
				</xsl:call-template>
			</xsl:if>
			
		</xsl:when>
	</xsl:choose>
</xsl:template>

<xsl:template name="get-variables-exists">
	<xsl:param name="chaine"/>
	<xsl:param name="contexte"/>
	<xsl:variable name="apres" select="substring(substring-after($chaine,'?'),1,1)"/>
	<xsl:choose>
		
		<!-- Prise en compte des jockers monovalués -->
		<xsl:when test="contains($chaine, '?') and ($apres=' ' or $apres=')')">
			<xsl:call-template name="get-variables-exists">
				<xsl:with-param name="chaine" select="substring-after($chaine,'?')"/>
				<xsl:with-param name="contexte" select="$contexte"/>
			</xsl:call-template>
		</xsl:when>
		
		<xsl:when test="contains($chaine, '?')">
			<xsl:variable name="var1" select="substring-before(substring-after($chaine,'?'),' ')"/>
			<xsl:variable name="var2" select="substring-before(substring-after($chaine,'?'),')')"/>
			<xsl:variable name="len1" select="number(string-length($var1))"/>
			<xsl:variable name="len2" select="number(string-length($var2))"/>

			<xsl:if test="$len1!=0 and not($len2!=0 and $len2 &lt; $len1)">
				<!-- un espace après la variable -->
				<xsl:if test="not(contains(preceding-sibling::exists/@fact,concat('?',$var1)))">
					(variable
					(contexte <xsl:value-of select="$contexte"/>)
					(ident <xsl:value-of select="$var1"/>)
					(value ?<xsl:value-of select="$var1"/>))
				</xsl:if>
				<xsl:call-template name="get-variables-exists">
					<xsl:with-param name="chaine" select="substring-after(substring-after($chaine,'?'),' ')"/>
					<xsl:with-param name="contexte" select="$contexte"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:if test="$len2!=0 and not($len1!=0 and $len1 &lt; $len2)">
				<!-- une parenthèse fermante après la variable -->
				<xsl:if test="not(contains(preceding-sibling::exists/@fact,concat('?',$var2)))">	
					(variable
					(contexte <xsl:value-of select="$contexte"/>)
					(ident <xsl:value-of select="$var2"/>)
					(value ?<xsl:value-of select="$var2"/>))
				</xsl:if>
				<xsl:call-template name="get-variables-exists">
					<xsl:with-param name="chaine" select="substring-after(substring-after($chaine,'?'),')')"/>
					<xsl:with-param name="contexte" select="$contexte"/>
				</xsl:call-template>
			</xsl:if>
			
		</xsl:when>
	</xsl:choose>
</xsl:template>
	
<!-- =================================== -->
<!-- Transformation de la partie réponse -->
<!-- =================================== -->

<xsl:template name="transforme-speak">
	<xsl:param name="chaine"/>
	<xsl:choose>
		<!-- Présence d'une expression -->
		<xsl:when test="contains($chaine,'(')">
			<xsl:variable name="texte" select="normalize-space(substring-before($chaine,'('))"/>
			<xsl:variable name="expression" select="normalize-space(substring-before(substring-after($chaine,'('),')'))"/>
			<xsl:variable name="reste" select="normalize-space(substring-after($chaine,')'))"/>
			
			<xsl:if test="not($texte='')">
				(repondre "<xsl:value-of select="$texte"/>")
			</xsl:if>
			
			(<xsl:value-of select="$expression"/>)
			
			<xsl:if test="$reste">
				<xsl:call-template name="transforme-speak">
					<xsl:with-param name="chaine" select="$reste"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:when>
		<!-- Texte simple -->
		<xsl:otherwise>
			(repondre "<xsl:value-of select="$chaine"/>")
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- ========================================================= -->
<!-- Transformation des faits des actions assert pour affichage-->
<!-- ========================================================= -->

<!--
<xsl:template name="transforme-assert">
	<xsl:param name="chaine"/>	
	<xsl:choose>
		<xsl:when test="contains($chaine,'?')">
			<xsl:variable name="var" select="substring-before(substring-after($chaine,'?'),' ')"/>
			<xsl:value-of select="substring-before($chaine,'?')"/>
			<xsl:text>" (toString ?</xsl:text><xsl:value-of select="$var"/><xsl:text>) " </xsl:text>
			<xsl:call-template name="transforme-assert">
				<xsl:with-param name="chaine" select="substring-after(substring-after($chaine,'?'),' ')"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$chaine"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="normalize-space">
	<xsl:param name="chaine"/>	
	<xsl:value-of select="normalize-space($chaine)"/>
</xsl:template>
-->

<!-- ========================================== -->
<!-- Construction de la description de la règle -->
<!-- ========================================== -->

<xsl:template name="description-rule">
	<xsl:variable name="idrule" select="generate-id()"/>
		
	<!-- Type de la règle en construction -->
	
	<xsl:variable name="inference" select="boolean(@type='inference')"/>
	<xsl:variable name="dialogue" select="boolean(@type='dialogue')"/>
	<xsl:variable name="regissante" select="boolean(not(rule) and not(parent::rule))"/>
	<xsl:variable name="incidente" select="boolean(rule)"/>
	<xsl:variable name="terminale" select="boolean(@terminal='TRUE')"/>
	<xsl:variable name="contextuelle" select="boolean(parent::rule)"/>
	<xsl:variable name="contextuelle-term" select="boolean($contextuelle and $terminale)"/>
	<xsl:variable name="contextuelle-nterm" select="boolean($contextuelle and not($terminale))"/>
	
	<xsl:variable name="type">
		<xsl:choose>
			<xsl:when test="$inference">Inférence</xsl:when>
			<xsl:when test="$regissante">Règle régissante</xsl:when>
			<xsl:when test="$incidente">Règle incidente</xsl:when>
			<xsl:when test="$contextuelle-term">Règle contextuelle terminale</xsl:when>
			<xsl:when test="$contextuelle-nterm">Règle contextuelle non-terminale</xsl:when>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Construction de la liste des granules utilisés -->
	(bind ?liste-id (create$
	<xsl:for-each select="conditions//granule">
		<xsl:variable name="ident">
			<xsl:if test="@ident"><xsl:value-of select="@ident"/></xsl:if>
			<xsl:if test="not(@ident)">?<xsl:value-of select="generate-id()"/></xsl:if>
		</xsl:variable>
		<xsl:value-of select="concat(' (getNumber ',$ident,')')"/>
	</xsl:for-each>))
	
	(ajoute-action (format nil "### <xsl:value-of select="concat($type,' (',@descr,') granules=(%s) salience=%d id=%d')"/>" (implode$ ?liste-id) ?*salience-<xsl:value-of select="$idrule"/>* <xsl:value-of select="substring-after($idrule,'idm')"/>))
</xsl:template>

<!-- ========================================= -->
<!-- Reconnaissance des patterns de type Elisa -->
<!-- ========================================= -->

<xsl:template name="build-pattern">
	<xsl:param name="chaine"/>
	<xsl:param name="i" select="1"/>
	
	<xsl:variable name="tmp">		
		<xsl:if test="contains($chaine,' ')"><xsl:value-of select="substring-before($chaine,' ')"/></xsl:if>
		<xsl:if test="not(contains($chaine,' '))"><xsl:value-of select="$chaine"/></xsl:if>
	</xsl:variable>
	
	<xsl:variable name="optionnel" select="boolean(contains($tmp,'('))"/>

	<xsl:variable name="mot">		
		<xsl:if test="$optionnel"><xsl:value-of select="substring-before(substring-after($tmp,'('),')')"/></xsl:if>
		<xsl:if test="not($optionnel)"><xsl:value-of select="$tmp"/></xsl:if>
	</xsl:variable>
		
	<xsl:if test="$optionnel">(or </xsl:if>

	<!-- Début -->
	(mot (lemmes $?lemmes<xsl:value-of select="$i"/>) (texte ?texte<xsl:value-of select="$i"/>&amp;:(comp ?texte<xsl:value-of select="$i"/> "<xsl:value-of select="$mot"/>" ?lemmes<xsl:value-of select="$i"/>))
	<xsl:if test="$i = 1">(pos ?pos<xsl:value-of select="$i"/>) (fin ?fin<xsl:value-of select="$i"/>))</xsl:if>
	<xsl:if test="$i > 1">(pos ?pos<xsl:value-of select="$i"/>&amp;:(succ ?pos<xsl:value-of select="$i"/> ?fin<xsl:value-of select="$i - 1"/>)) (fin ?fin<xsl:value-of select="$i"/>))</xsl:if>
	<!-- Fin -->
	
	<xsl:if test="$optionnel">(mot (texte "") (pos ?fin<xsl:value-of select="$i - 1"/>) (fin ?fin<xsl:value-of select="$i"/>)))</xsl:if>
	
	<xsl:if test="contains($chaine,' ')">
		<xsl:call-template name="build-pattern">
			<xsl:with-param name="chaine" select="substring-after($chaine,' ')"/>
			<xsl:with-param name="i" select="$i + 1"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!-- ====================================== -->
<!-- Pour afficher les règles déclenchables -->
<!-- ====================================== -->

<xsl:template match="rule" mode="agenda">
	
	<xsl:param name="regle-mere"/>
	<xsl:variable name="idrule" select="generate-id()"/>
	
	<!-- Typologie des règles et autres attributs (détermine une stratégie de dialogue) -->
	
	<xsl:variable name="inference" select="boolean(@type='inference')"/>
	<xsl:variable name="dialogue" select="boolean(@type='dialogue')"/>
	<xsl:variable name="immediate" select="boolean(@priority='HIGH')"/>
	<xsl:variable name="terminale" select="boolean(@terminal='TRUE')"/>
	<xsl:variable name="incidente" select="boolean(rule)"/>
	<xsl:variable name="contextuelle" select="boolean(parent::rule)"/>
	<xsl:variable name="regissante" select="boolean(not($incidente) and not($contextuelle) and not($immediate))"/>
	<xsl:variable name="opportuniste" select="boolean(not($incidente) and not($contextuelle) and $immediate)"/>
	<xsl:variable name="contextuelle-term" select="boolean(not($incidente) and $contextuelle and $terminale)"/>
	<xsl:variable name="contextuelle-nterm" select="boolean(not($incidente) and $contextuelle and not($terminale))"/>
	
	<xsl:variable name="type-regle">
		<xsl:choose>
			<xsl:when test="$inference">INF</xsl:when>
			<xsl:when test="$incidente">INC</xsl:when>
			<xsl:when test="$regissante">REG</xsl:when>
			<xsl:when test="$opportuniste">ROP</xsl:when>
			<xsl:when test="$contextuelle-term">RCT</xsl:when>
			<xsl:when test="$contextuelle-nterm">RCNT</xsl:when>
			<xsl:otherwise>ERROR</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:variable name="type">
		<xsl:choose>
			<xsl:when test="$inference">Inférence</xsl:when>
			<xsl:when test="$regissante">Règle régissante</xsl:when>
			<xsl:when test="$incidente">Règle incidente</xsl:when>
			<xsl:when test="$contextuelle-term">Règle contextuelle terminale</xsl:when>
			<xsl:when test="$contextuelle-nterm">Règle contextuelle non-terminale</xsl:when>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Construction de la règle -->
	
	(defrule YADERULE::agenda-<xsl:value-of select="$idrule"/>
	(declare (salience 9999))
	
	<xsl:if test="$dialogue">
		<!-- Pour ne pas déclencher la règle deux fois de suite -->
		?liste &lt;- (liste $?liste-regles)
		(test (not (member$ <xsl:value-of select="$idrule"/> ?liste-regles)))
	</xsl:if>
	
	(contexte (indice ?indice)
	<xsl:choose>
		<xsl:when test="$dialogue and ($regissante or ($incidente and not($contextuelle)))">(pile-contextes ?contexte&amp;0)</xsl:when>
		<xsl:otherwise>(pile-contextes ?contexte $?)</xsl:otherwise>
	</xsl:choose>
	<xsl:if test="$incidente and not($contextuelle)">(pile-regles ~<xsl:value-of select="$idrule"/> $?)</xsl:if>
	<xsl:if test="$contextuelle and not($incidente)">(pile-regles <xsl:value-of select="$regle-mere"/> $?)</xsl:if>
	<xsl:if test="$contextuelle and $incidente">(pile-regles <xsl:value-of select="$regle-mere"/>&amp;~<xsl:value-of select="$idrule"/> $?)</xsl:if>
	)
	
	<!-- Pour récupérer les variables dans le cas d'une règle contextuelle -->
	<xsl:if test="$contextuelle">
		<xsl:apply-templates select="ancestor::rule/conditions/descendant::granule[contains(@ident,'?')]" mode="get-variable-id"/>
		<xsl:apply-templates select="ancestor::rule/conditions/descendant::granule[contains(@concept,':?')]" mode="get-variable-co"/>
		<xsl:apply-templates select="ancestor::rule/conditions/exists[@ref]" mode="get-variable-1"/>
		<xsl:apply-templates select="ancestor::rule/conditions/exists[contains(@fact,'?')]" mode="get-variable-2"/>
		<xsl:apply-templates select="ancestor::rule/actions/bind" mode="get-variable"/>
	</xsl:if>
	
	<!-- Motifs de granules et autres conditions -->
	<xsl:apply-templates select="conditions/*" mode="condition">
		<xsl:with-param name="scpere" select="conditions/@scope"/>
	</xsl:apply-templates>
	
	<!-- Pour ajouter la condition granules différents -->
	<xsl:call-template name="neq-granules">
		<xsl:with-param name="granules" select="conditions//granule"/>
    </xsl:call-template>
	
	<!-- Pour ajouter la condition granules-racines ordonnés (version 1 = ordonnés seulement) -->
	<xsl:if test="conditions/@ordered='TRUE'">
		<xsl:call-template name="ord-granules-1">
			<xsl:with-param name="granules" select="conditions/granule"/>
    	</xsl:call-template>
	</xsl:if>
	
	<!-- Pour ajouter la condition granules-racines ordonnés (version 2 = ordonnés + au plus proche) -->
	<xsl:if test="conditions/@nearest='TRUE'">
		<xsl:call-template name="ord-granules-2">
			<xsl:with-param name="granules" select="conditions/granule"/>
    	</xsl:call-template>
	</xsl:if>
	
	<!-- Pour vérifier qu'un granule ou un fait au moins est nouveau (indice courant) SAUF S'IL Y A UN NOT GRANULE !!! -->
	<xsl:if test="conditions//granule and not(conditions//nogranule)">
		(test (member$ ?indice (create$
		<xsl:for-each select="conditions//granule"> ?indice-<xsl:value-of select="generate-id()"/></xsl:for-each>
		<xsl:for-each select="conditions//exists"> ?indice-<xsl:value-of select="generate-id()"/></xsl:for-each>
		)))
	</xsl:if>
	
	=>
	
	(ajoute-action (format nil "??? <xsl:value-of select="concat($type,' (',@descr,') salience=%d id=%d')"/>" ?*salience-<xsl:value-of select="$idrule"/>* <xsl:value-of select="substring-after($idrule,'idm')"/>))		
	)
	
	<!-- Pour construire les règles contextuelles -->
	<xsl:apply-templates select="rule" mode="agenda">
		<xsl:with-param name="regle-mere" select="$idrule"/>
	</xsl:apply-templates>
	
</xsl:template>

</xsl:stylesheet>
