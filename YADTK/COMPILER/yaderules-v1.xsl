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

<xsl:stylesheet version="1.0"	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								xmlns:user="http://www.univ-lemans.fr/functions"
								extension-element-prefixes="user">

<xsl:import href="yadexsl/user-functions.xsl"/>
<xsl:import href="yadexsl/LHS-granules.xsl"/>
<xsl:import href="yadexsl/LHS-others.xsl"/>
<xsl:import href="yadexsl/RHS-granules.xsl"/>
<xsl:import href="yadexsl/RHS-others.xsl"/>

<xsl:output method="text"/>

<xsl:template match="/">
    <xsl:call-template name="initial-facts"/>
	<xsl:apply-templates select="yaderules/set-string" mode="defglobal"/>
	<xsl:apply-templates select="yaderules/set-symbol" mode="defglobal"/>
	<xsl:apply-templates select="yaderules//rule" mode="defglobal"/>
	<xsl:apply-templates select="yaderules/rule" mode="defrule"/>
</xsl:template>

<!--
##############################################################################
# Les faits initiaux 
##############################################################################
-->

<xsl:template name="initial-facts">
(deffacts YADEGLOB::initial-facts
    <xsl:for-each select="yaderules/initial">
	    <xsl:value-of select="@fact"/>
    </xsl:for-each>)
</xsl:template>

<!--
##############################################################################
# Les variables globales 
##############################################################################
-->

<xsl:template match="set-string" mode="defglobal">
	(defglobal YADEGLOB ?*<xsl:value-of select="@name"/>* = "<xsl:value-of select="@value"/>")
</xsl:template>

<xsl:template match="set-symbol" mode="defglobal">
	(defglobal YADEGLOB ?*<xsl:value-of select="@name"/>* = <xsl:value-of select="@value"/>)
</xsl:template>

<xsl:template match="rule" mode="defglobal">
	(defglobal YADERULE ?*salience-<xsl:value-of select="generate-id()"/>* = 0)
</xsl:template>

<!--
##############################################################################
# Modèle général d'une règle YADE
##############################################################################
-->

<xsl:template match="rule" mode="defrule">
	
	<!-- En cas de règle contextuelle -->
	<xsl:param name="regle-mere"/>
	<!-- Identificateur de la règle -->
	<xsl:variable name="idrule" select="generate-id()"/>
	<!-- Une règle incidence contient une sous-règle -->
	<xsl:variable name="incidente" select="boolean(rule)"/>
	<!-- Une règle contextuelle possède une règle mère -->
	<xsl:variable name="contextuelle" select="boolean(parent::rule)"/>
	<!-- Une règle terminale possède un attribut terminal -->
	<xsl:variable name="terminale" select="boolean(@terminal='TRUE')"/>
	
	(defrule YADERULE::<xsl:value-of select="$idrule"/>
	<xsl:if test="@descr"> "<xsl:value-of select="@descr"/>"</xsl:if>
	(declare (salience ?*salience-<xsl:value-of select="$idrule"/>*))	
	
	<!-- Contrainte sur le contexte d'application -->
	(contexte (indice ?indice) (pile-contextes ?contexte $?)
	<xsl:if test="$incidente and not($contextuelle)">(pile-regles ~<xsl:value-of select="$idrule"/> $?)</xsl:if>
	<xsl:if test="$contextuelle and not($incidente)">(pile-regles <xsl:value-of select="$regle-mere"/> $?)</xsl:if>
	<xsl:if test="$contextuelle and $incidente">(pile-regles <xsl:value-of select="$regle-mere"/>&amp;~<xsl:value-of select="$idrule"/> $?)</xsl:if>
	)
		
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
    
	<!-- Pour récupérer les variables dans le cas d'une règle contextuelle -->
	<xsl:if test="$contextuelle">
		<xsl:apply-templates select="ancestor::rule/conditions/descendant::granule[contains(@ident,'?')]" mode="get-variable-id"/>
		<xsl:apply-templates select="ancestor::rule/conditions/descendant::granule[contains(@concept,':?')]" mode="get-variable-co"/>
		<xsl:apply-templates select="ancestor::rule/conditions/exists[@ref]" mode="get-variable-1"/>
		<xsl:apply-templates select="ancestor::rule/conditions/exists[contains(@fact,'?')]" mode="get-variable-2"/>
		<xsl:apply-templates select="ancestor::rule/actions/bind" mode="get-variable"/>
	</xsl:if>
	
	<!-- Pour empêcher les déclenchements multiples d'une même règle -->
	(not (fired ?indice <xsl:value-of select="$idrule"/> <xsl:call-template name="cree-liste-granules-LHS"/>))
	
	<!-- Pour actualiser la priorité dynamique -->
	<xsl:apply-templates select="conditions//granule[not(parent::granule)]" mode="get-poids"/>
	(test (bind ?*salience-<xsl:value-of select="$idrule"/>* <xsl:call-template name="calcul-dynamic-salience"/>))
	
	=>
	
	<!-- Pour empêcher les déclenchements multiples d'une même règle -->
	(assert (fired ?indice <xsl:value-of select="$idrule"/> <xsl:call-template name="cree-liste-granules-RHS"/>))
    
	<!-- Construction de la description de la règle -->
	<xsl:call-template name="description-rule"/>
    
	<!-- Règle incidente => empiler un nouveau contexte et sauvegarder les variables -->
	<xsl:if test="$incidente">
		(empiler-contexte <xsl:value-of select="$idrule"/>)
		<xsl:apply-templates select="conditions/descendant::granule[contains(@ident,'?')]" mode="set-variable-id"/>
		<xsl:apply-templates select="conditions/descendant::granule[contains(@concept,':?')]" mode="set-variable-co"/>
		<xsl:apply-templates select="conditions/exists[@ref]" mode="set-variable-1"/>
		<xsl:apply-templates select="conditions/exists[contains(@fact,'?')]" mode="set-variable-2"/>
		<!-- Pour empêcher le déclenchement d'une autre règle -->
		(pop-focus)
	</xsl:if>
	
    <!-- Groupes des expressions régulières -->
	<xsl:apply-templates select="conditions/input[@regexp]" mode="set-variable-re"/>
	
	<!-- Actions sans ou avec post-condition -->
	<xsl:for-each select="actions/*">
		<xsl:if test="not(@test)"><xsl:apply-templates select="." mode="action"/></xsl:if>
		<xsl:if test="@test">(if <xsl:value-of select="@test"/> then <xsl:apply-templates select="." mode="action"/>)</xsl:if>
	</xsl:for-each>
	
	<xsl:if test="$terminale">(depiler-contexte)</xsl:if>
	
	(calcule-poids-des-granules))
	
	<!-- Pour construire les règles contextuelles -->
	<xsl:apply-templates select="rule" mode="defrule">
		<xsl:with-param name="regle-mere" select="$idrule"/>
	</xsl:apply-templates>
	
</xsl:template>

<!--
##############################################################################
# Construction des listes de granules pour le LHS et le RHS
##############################################################################
-->

<xsl:template name="cree-liste-granules-LHS">
	<xsl:for-each select="conditions//granule">
		<xsl:variable name="ident">
			<xsl:if test="@ident"><xsl:value-of select="@ident"/></xsl:if>
			<xsl:if test="not(@ident)">?<xsl:value-of select="generate-id()"/></xsl:if>
		</xsl:variable>
		<xsl:value-of select="concat(' =(string-to-field (getNumber ',$ident,'))')"/>
	</xsl:for-each>
</xsl:template>

<xsl:template name="cree-liste-granules-RHS">
	<xsl:for-each select="conditions//granule">
		<xsl:variable name="ident">
			<xsl:if test="@ident"><xsl:value-of select="@ident"/></xsl:if>
			<xsl:if test="not(@ident)">?<xsl:value-of select="generate-id()"/></xsl:if>
		</xsl:variable>
		<xsl:value-of select="concat(' (string-to-field (getNumber ',$ident,'))')"/>
	</xsl:for-each>
</xsl:template>

<!--
##############################################################################
-->

<!-- Pointer les granules utilisés -->

<xsl:template match="granule" mode="used">
	<xsl:variable name="ident">
		<xsl:if test="@ident"><xsl:value-of select="@ident"/></xsl:if>
		<xsl:if test="not(@ident)">?<xsl:value-of select="generate-id()"/></xsl:if>
	</xsl:variable>
	(propage-used <xsl:value-of select="$ident"/>)
</xsl:template>

<!--
##############################################################################
# Créer les faits variable dans RHS des règles incidentes
##############################################################################
-->

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

<!--
##############################################################################
# Récupérer les groupes des expressions régulières du LHS
##############################################################################
-->

<xsl:template match="input[@regexp]" mode="set-variable-re">
     (bind ?expr "<xsl:value-of select="@regexp"/>")
</xsl:template>

<!--
<xsl:template match="input[@regexp]" mode="set-variable-re">
	<xsl:call-template name="bind-group">
		<xsl:with-param name="regexp" select="@regexp"/>
	</xsl:call-template>    
</xsl:template>

<xsl:template name="bind-group">
	<xsl:param name="regexp"/>
	<xsl:param name="i" select="0"/>        
	<xsl:if test="contains($regexp,'(')">
        (bind ?group-<xsl:value-of select="$i"/> (pythonRegexpGroup "<xsl:value-of select="@regexp"/>" ?texte <xsl:value-of select="$i"/>))
        <xsl:variable name="reste" select="normalize-space(substring-after($regexp,'('))"/>
        <xsl:call-template name="bind-group">
            <xsl:with-param name="regexp" select="$reste"/>
            <xsl:with-param name="i" select="$i + 1"/>
        </xsl:call-template>
	</xsl:if>
</xsl:template>
-->

<!--
##############################################################################
# Récupérer les faits variable dans LHS des règles contextuelles
##############################################################################
-->

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

<!--
##############################################################################
# Calcul de la priorité dynamique
##############################################################################
-->

<xsl:template name="calcul-dynamic-salience">
	<!-- Une règle de dialogue produit au moins un énoncé -->
	<xsl:variable name="dialogue" select="boolean(actions/speak)"/>
    <!-- Une règle de requête doit être déclenchée en tout dernier -->
	<xsl:variable name="requete" select="boolean(@request='TRUE')"/>
    <!-- Une règle incidente ouvre un nouveau contexte -->
	<xsl:variable name="incidente" select="boolean(rule)"/>
	<!-- Une règle terminale ferme le contexte courant -->
	<xsl:variable name="terminale" select="boolean(@terminal='TRUE')"/>
	<!-- Une règle d'inférence simple ne produit ni énoncé ni changement de contexte -->
	<xsl:variable name="inference-simple" select="boolean(not($dialogue) and not($incidente) and not($terminale) and not($requete))"/>
	<!-- Une règle de dialogue simple produit un énoncé mais pas de changement de contexte -->
	<xsl:variable name="dialogue-simple" select="boolean($dialogue and not($incidente) and not($terminale) and not($requete))"/>
    
	(+
	<!-- Priorité liée au type de la règle -->
	<xsl:if test="$inference-simple"> 500 </xsl:if>
	<xsl:if test="$dialogue-simple"> 400 </xsl:if>
	<xsl:if test="$incidente"> 300 </xsl:if>
	<xsl:if test="$terminale"> 200 </xsl:if>
	<xsl:if test="$requete"> 100 </xsl:if>
    	
	<!-- Nombre d'items dans les préconditions -->
	<xsl:value-of select="count(conditions/descendant::*)"/>
	
	<!-- Poids des granules racines -->
	<xsl:for-each select="conditions//granule[not(parent::granule)]">
		<xsl:variable name="ident">
			<xsl:if test="@ident"><xsl:value-of select="@ident"/></xsl:if>
			<xsl:if test="not(@ident)">?<xsl:value-of select="generate-id()"/></xsl:if>
		</xsl:variable>
		<xsl:value-of select="concat(' ',$ident,'-poids')"/>
	</xsl:for-each>
	
	<!-- Priorité utilisateur -->
	<xsl:if test="@salience"><xsl:value-of select="concat(' ',@salience)"/></xsl:if>
	)
</xsl:template>

<!-- Pour récupérer les poids des granules utilisés dans le LHS -->

<xsl:template match="granule" mode="get-poids">
	<xsl:variable name="idrule" select="generate-id(ancestor::rule[1])"/>
	<xsl:variable name="ident">
		<xsl:if test="@ident"><xsl:value-of select="@ident"/></xsl:if>
		<xsl:if test="not(@ident)">?<xsl:value-of select="generate-id()"/></xsl:if>
	</xsl:variable>
	(poids-granule (ident <xsl:value-of select="$ident"/>) (poids <xsl:value-of select="$ident"/>-poids))
</xsl:template>

<!-- ======================================================================================================= -->
<!-- Actions Actions Actions Actions Actions Actions Actions Actions Actions Actions Actions Actions Actions -->
<!-- ======================================================================================================= -->




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

<!--
##############################################################################
# Construction de la description de la règle pour la trace
##############################################################################
-->

<xsl:template name="description-rule">
	<xsl:variable name="idrule" select="generate-id()"/>
		
	<!-- Détermination du type de la règle -->
	<xsl:variable name="inference" select="boolean(not(actions/speak))"/>
	<xsl:variable name="opportuniste" select="boolean(not(rule) and not(parent::rule))"/>
	<xsl:variable name="incidente" select="boolean(rule)"/>
	<xsl:variable name="terminale" select="boolean(@terminal='TRUE')"/>
	<xsl:variable name="contextuelle" select="boolean(parent::rule)"/>
	<xsl:variable name="contextuelle-inc" select="boolean($contextuelle and $incidente)"/>
	<xsl:variable name="contextuelle-term" select="boolean($contextuelle and $terminale)"/>
	<xsl:variable name="contextuelle-nterm" select="boolean($contextuelle and not($terminale))"/>
	
	<xsl:variable name="type">
		<xsl:choose>
			<xsl:when test="$inference">Inference rule</xsl:when>
			<xsl:when test="$opportuniste">Standalone rule</xsl:when>
			<xsl:when test="$incidente">Initiative rule</xsl:when>
			<xsl:when test="$contextuelle-inc">Nested initiative rule</xsl:when>
			<xsl:when test="$contextuelle-term">Nested terminal rule</xsl:when>
			<xsl:when test="$contextuelle-nterm">Nested non terminal rule</xsl:when>
		</xsl:choose>
	</xsl:variable>
	
	<!-- Construction de la liste des granules utilisés -->
	(bind ?liste-id (create$ <xsl:call-template name="cree-liste-granules-RHS"/>))
	
	(writeLog
		(format nil "### <xsl:value-of select="concat($type,' (',@descr,') granules=(%s) salience=%d id=%s')"/>"
			(implode$ ?liste-id)
			?*salience-<xsl:value-of select="$idrule"/>*
			<xsl:value-of select="$idrule"/>))
</xsl:template>

</xsl:stylesheet>
