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
	<!ENTITY NBSP "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'> </xsl:text>">
	<!ENTITY CRLF "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>&#10;</xsl:text>">
	<!ENTITY LINE "<xsl:text xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>----------------------------------</xsl:text>">
]>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text"/>

<xsl:key name="k1" match="granule" use="@concept"/>
<xsl:key name="k2" match="granule[@root='TRUE']" use="@concept"/>
<xsl:key name="k3" match="granule[not(granule)]" use="@concept"/>
<xsl:key name="k4" match="granule[@root='TRUE' and not(granule)]" use="@concept"/>
<xsl:key name="k5" match="granule[@rescued='TRUE']" use="@concept"/>
<xsl:key name="k6" match="granule[@inferred='TRUE']" use="@text"/>
<xsl:key name="k7" match="granule[parent::granule]" use="concat(parent::granule/@concept,@code,@concept)"/>

<xsl:template match="/">
	&CRLF;
	&LINE;&CRLF;
	<xsl:text>Statistics</xsl:text>
	&CRLF;&LINE;&CRLF;
	<xsl:text>Total Utterances: </xsl:text>
	<xsl:variable name="nb" select="count(//structure)"/>
	<xsl:value-of select="$nb"/>
	&CRLF;
	<xsl:text>Total Granules: </xsl:text>
	<xsl:variable name="total" select="count(//granule)"/>
	<xsl:value-of select="concat($total,' (',$total div $nb,' granules/utt)')"/>
	&CRLF;
	<xsl:text>Root Granules: </xsl:text>
	<xsl:variable name="roots" select="count(//granule[@root='TRUE'])"/>
	<xsl:value-of select="concat($roots,' (',$roots div $nb,' roots/utt) (',$roots div $total * 100,'% of granules)')"/>
	&CRLF;
	<xsl:text>Leaf Granules: </xsl:text>
	<xsl:variable name="leaves" select="count(//granule[not(granule)])"/>
	<xsl:value-of select="concat($leaves,' (',$leaves div $nb,' leaves/utt) (',$leaves div $total * 100,'% of granules)')"/>
	&CRLF;
	<xsl:text>Free Granules: </xsl:text>
	<xsl:variable name="free" select="count(//granule[@root='TRUE' and not(granule)])"/>
	<xsl:value-of select="concat($free,' (',$free div $nb,' free/utt) (',$free div $total * 100,'% of granules)')"/>	
	&CRLF;
	<xsl:text>Rescued Granules: </xsl:text>
	<xsl:variable name="rescued" select="count(//granule[@rescued='TRUE'])"/>
	<xsl:value-of select="concat($rescued,' (',$rescued div $nb,' rescued/utt) (',$rescued div $total * 100,'% of granules)')"/>	
	&CRLF;
	<xsl:text>Inferred Granules: </xsl:text>
	<xsl:variable name="inferred" select="count(//granule[@inferred='TRUE'])"/>
	<xsl:value-of select="concat($inferred,' (',$inferred div $nb,' inferred/utt) (',$inferred div $total * 100,'% of granules)')"/>	
	&CRLF;
	<xsl:text>Dependencies: </xsl:text>
	<xsl:variable name="dep" select="count(//granule[parent::granule])"/>
	<xsl:value-of select="concat($dep,' (',$dep div $nb,' dep/utt)')"/>
	&CRLF;
	<xsl:text>Conflicts: </xsl:text>
	<xsl:variable name="conf" select="count(//conflict)"/>
	<xsl:value-of select="concat($conf,' (',$conf div $nb,' conf/utt)')"/>
	
	<!-- Total granules -->
	
	&CRLF;&LINE;&CRLF;
	<xsl:value-of select="count(//granule)"/>
	<xsl:text> Granules</xsl:text>
	&CRLF;&LINE;
	<xsl:for-each select="//granule[generate-id() = generate-id(key('k1', @concept)[1])]">
		<xsl:sort select="count(key('k1', @concept))" order="descending" data-type="number"/>
		&CRLF;
		<xsl:value-of select="count(key('k1', @concept))"/>
		&NBSP;
		<xsl:value-of select="concat('[',@concept,']')"/>
	</xsl:for-each>
	
	<!-- Root granules -->
	
	&CRLF;&LINE;&CRLF;
	<xsl:value-of select="count(//granule[@root='TRUE'])"/>
	<xsl:text> Root Granules</xsl:text>
	&CRLF;&LINE;
	<xsl:for-each select="//granule[generate-id() = generate-id(key('k2', @concept)[1])]">
		<xsl:sort select="count(key('k2', @concept))" order="descending" data-type="number"/>
		&CRLF;
		<xsl:value-of select="count(key('k2', @concept))"/>
		&NBSP;
		<xsl:value-of select="concat('[',@concept,']')"/>
	</xsl:for-each>
	
	<!-- Leaf granules -->
	
	&CRLF;&LINE;&CRLF;
	<xsl:value-of select="count(//granule[not(granule)])"/>
	<xsl:text> Leaf Granules</xsl:text>
	&CRLF;&LINE;
	<xsl:for-each select="//granule[generate-id() = generate-id(key('k3', @concept)[1])]">
		<xsl:sort select="count(key('k3', @concept))" order="descending" data-type="number"/>
		&CRLF;
		<xsl:value-of select="count(key('k3', @concept))"/>
		&NBSP;
		<xsl:value-of select="concat('[',@concept,']')"/>
	</xsl:for-each>
	
	<!-- Free granules -->
	
	&CRLF;&LINE;&CRLF;
	<xsl:value-of select="count(//granule[@root='TRUE' and not(granule)])"/>
	<xsl:text> Free Granules</xsl:text>
	&CRLF;&LINE;
	<xsl:for-each select="//granule[generate-id() = generate-id(key('k4', @concept)[1])]">
		<xsl:sort select="count(key('k4', @concept))" order="descending" data-type="number"/>
		&CRLF;
		<xsl:value-of select="count(key('k4', @concept))"/>
		&NBSP;
		<xsl:value-of select="concat('[',@concept,']')"/>
	</xsl:for-each>
	
	<!-- Rescued granules -->
	
	&CRLF;&LINE;&CRLF;
	<xsl:value-of select="count(//granule[@rescued='TRUE'])"/>
	<xsl:text> Rescued Granules</xsl:text>
	&CRLF;&LINE;
	<xsl:for-each select="//granule[generate-id() = generate-id(key('k5', @concept)[1])]">
		<xsl:sort select="count(key('k5', @concept))" order="descending" data-type="number"/>
		&CRLF;
		<xsl:value-of select="count(key('k5', @concept))"/>
		&NBSP;
		<xsl:value-of select="concat('[',@concept,']')"/>
	</xsl:for-each>
	
	<!-- Inferred granules -->
	
	&CRLF;&LINE;&CRLF;
	<xsl:value-of select="count(//granule[@inferred='TRUE'])"/>
	<xsl:text> Inferred Granules</xsl:text>
	&CRLF;&LINE;
	<xsl:for-each select="//granule[generate-id() = generate-id(key('k6', @text)[1])]">
		<xsl:sort select="@text" order="ascending" data-type="text"/>
		&CRLF;
		<xsl:value-of select="count(key('k6', @text))"/>
		&NBSP;
		<xsl:value-of select="concat('(',@text,') = {',@offers,'}')"/>
	</xsl:for-each>
	
	<!-- Dependencies -->
	
	&CRLF;&LINE;&CRLF;
	<xsl:value-of select="count(//granule[parent::granule])"/>
	<xsl:text> Dependencies</xsl:text>
	&CRLF;&LINE;
	<xsl:for-each select="//granule[generate-id() = generate-id(key('k7', concat(parent::granule/@concept,@code,@concept))[1])]">
		<xsl:sort select="count(key('k7', concat(parent::granule/@concept,@code,@concept)))" order="descending" data-type="number"/>
		<xsl:sort select="@code" order="ascending" data-type="text"/>
		&CRLF;
		<xsl:value-of select="count(key('k7', concat(parent::granule/@concept,@code,@concept)))"/>
		&NBSP;
		<xsl:value-of select="concat('[',parent::granule/@concept,'] ',@code,' [',@concept,']')"/>
		<xsl:if test="@concept = 'inferred'">
			<xsl:value-of select="concat(' (',@text,')')"/>
		</xsl:if>
	</xsl:for-each>	
	
	<!-- Conflicts -->
	
	&CRLF;&LINE;&CRLF;
	<xsl:value-of select="count(//conflict)"/>
	<xsl:text> Conflicts</xsl:text>
	&CRLF;&LINE;
	<xsl:for-each select="//conflict">
		<xsl:variable name="id1" select="@id1"/>
		<xsl:variable name="id2" select="@id2"/>
		<xsl:variable name="c1" select="//granule[@id = $id1]/@concept"/>
		<xsl:variable name="c2" select="//granule[@id = $id2]/@concept"/>
		&CRLF;
		<xsl:value-of select="concat('[',$c1,'] &lt;> [',$c2,']')"/>
	</xsl:for-each>
	
	&CRLF;&CRLF;
</xsl:template>

</xsl:stylesheet>
