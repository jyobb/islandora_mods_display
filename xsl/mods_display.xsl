<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:mods="http://www.loc.gov/mods/v3" exclude-result-prefixes="mods dc xsi oai_dc srw_dc"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:srw_dc="info:srw/schema/1/dc-schema"
	xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"	
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   


<!-- 
This stylesheet transforms MODS version 3.2 records and collections of records to simple Dublin Core (DC) records, 
based on the Library of Congress' MODS to simple DC mapping <http://www.loc.gov/standards/mods/mods-dcsimple.html> 
		
The stylesheet will transform a collection of MODS 3.2 records into simple Dublin Core (DC)
as expressed by the SRU DC schema <http://www.loc.gov/standards/sru/dc-schema.xsd>

The stylesheet will transform a single MODS 3.2 record into simple Dublin Core (DC)
as expressed by the OAI DC schema <http://www.openarchives.org/OAI/2.0/oai_dc.xsd>
		
Because MODS is more granular than DC, transforming a given MODS element or subelement to a DC element frequently results in less precise tagging, 
and local customizations of the stylesheet may be necessary to achieve desired results. 

This stylesheet makes the following decisions in its interpretation of the MODS to simple DC mapping: 
	
When the roleTerm value associated with a name is creator, then name maps to dc:creator
When there is no roleTerm value associated with name, or the roleTerm value associated with name is a value other than creator, then name maps to dc:contributor
Start and end dates are presented as span dates in dc:date and in dc:coverage
When the first subelement in a subject wrapper is topic, subject subelements are strung together in dc:subject with hyphens separating them
Some subject subelements, i.e., geographic, temporal, hierarchicalGeographic, and cartographics, are also parsed into dc:coverage
The subject subelement geographicCode is dropped in the transform

	
Revision 1.1	2007-05-18 <tmee@loc.gov>
		Added modsCollection conversion to DC SRU
		Updated introductory documentation
	
Version 1.0	2007-05-04 Tracy Meehleib <tmee@loc.gov>

-->

	<xsl:output method="xml" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:template match="/">
	  <xsl:param name="title" />
	  <xsl:param name="name" />
	  <xsl:param name="classification" />
	  <xsl:param name="subjectTopic" />
	  <xsl:param name="subjectOccupation" />
	  <xsl:param name="subjectName" />
	  <xsl:param name="subjectGeographic" />
	  <xsl:param name="subjectHierGeographic" />
	  <xsl:param name="subjectCartographic" />
	  <xsl:param name="subjectTemporal" />
	  <xsl:param name="subjectLocalname" />
	  <xsl:param name="abstract" />
	  <xsl:param name="toc" />
	  <xsl:param name="note" />
	  <xsl:param name="dateIssued" />
	  <xsl:param name="dateCreated" />
	  <xsl:param name="dateCaptured" />
	  <xsl:param name="dateOther" />
	  <xsl:param name="publisher" />
	  <xsl:param name="genre" />
	  <xsl:param name="typeOfResource" />
	  <xsl:param name="extent" />
	  <xsl:param name="form" />
	  <xsl:param name="mediaType" />
	  <xsl:param name="mimeType" />
	  <xsl:param name="identifier" />
	  <xsl:param name="physicalLocation" />
	  <xsl:param name="shelfLocation" />
	<!--  <xsl:param name="url" /> -->
	  <xsl:param name="recommendedCitation" />
	  <xsl:param name="holdingSubLocation" />
	  <xsl:param name="holdingShelfLocator" />
	  <xsl:param name="electronicLocator" />
	  <xsl:param name="language" />
	  <xsl:param name="relatedItem" />
	  <xsl:param name="accessCondition" />

		<xsl:choose>
		<xsl:when test="//mods:modsCollection">			
			<srw_dc:dcCollection xsi:schemaLocation="info:srw/schema/1/dc-schema http://www.loc.gov/standards/sru/dc-schema.xsd">
				<xsl:apply-templates/>
			<xsl:for-each select="mods:modsCollection/mods:mods">			
				<srw_dc:dc xsi:schemaLocation="info:srw/schema/1/dc-schema http://www.loc.gov/standards/sru/dc-schema.xsd">
				<xsl:apply-templates/>
			</srw_dc:dc>
			</xsl:for-each>
			</srw_dc:dcCollection>
		</xsl:when>
		<xsl:otherwise>
			<xsl:for-each select="mods:mods">
<!--			<oai_dc:dc xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd"> -->
<table>
<tr><th colspan="2"><h3 class="islandora-obj-details-metadata-title">Metadata <span class="islandora-obj-details-dsid">(MODS)</span></h3></th></tr>
				<xsl:apply-templates/>
</table>
<!--			</oai_dc:dc> -->
			</xsl:for-each>
		</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="mods:titleInfo">
		<!-- <dc:title> -->
		<tr><td><xsl:value-of select="$title"/></td><td>
			<xsl:value-of select="mods:nonSort"/>
			<xsl:if test="mods:nonSort">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:value-of select="mods:title"/>
			<xsl:if test="mods:subTitle">
				<xsl:text>: </xsl:text>
				<xsl:value-of select="mods:subTitle"/>
			</xsl:if>
			<xsl:if test="mods:partNumber">
				<xsl:text>. </xsl:text>
				<xsl:value-of select="mods:partNumber"/>
			</xsl:if>
			<xsl:if test="mods:partName">
				<xsl:text>. </xsl:text>
				<xsl:value-of select="mods:partName"/>
			</xsl:if>
			</td></tr>
 	<!-- </dc:title> -->
	</xsl:template>


	<xsl:template match="mods:name">
		<tr>
		  <td>
		    <xsl:value-of select="$name"/>
		  </td><td>

		<xsl:choose>
			<xsl:when
				test="mods:role/mods:roleTerm[@type='text']='creator' or mods:role/mods:roleTerm[@type='code']='cre' ">
					<xsl:call-template name="name"/>
			</xsl:when>

			<xsl:otherwise>
					<xsl:call-template name="name"/>
			</xsl:otherwise>
		</xsl:choose>
		  </td>
		</tr>
	</xsl:template>

	<xsl:template match="mods:classification">
		<tr>
		  <td>
		    <xsl:value-of select="$classification"/>
		  </td>
		  <td>
			<xsl:value-of select="."/>
		</td>
		</tr>
	</xsl:template>

	<xsl:template match="mods:subject[mods:topic | mods:occupation | mods:geographic | mods:hierarchicalGeographic | mods:cartographics | mods:temporal] ">
<!-- 	<xsl:template match="mods:subject[mods:topic | mods:name | mods:occupation | mods:geographic | mods:hierarchicalGeographic | mods:cartographics | mods:temporal] "> -->
	  <xsl:if test="normalize-space(mods:topic)">
	    <tr>
	      <td><xsl:value-of select="$subjectTopic"/>
                  <xsl:value-of select="."/><br>
		  <!--<xsl:if test="position()!=last()">dashdash</xsl:if>-->
                  </xsl:for-each>
	      </td>  
	    </tr>
	  </xsl:if>			

	  <xsl:if test="normalize-space(mods:occupation)">
	    <xsl:for-each select="mods:occupation">
	      <tr><td><xsl:value-of select="$subjectOccupation"/></td><td>
		  <xsl:value-of select="."/>
		  <xsl:if test="position()!=last()">--</xsl:if>
	      </td></tr>
	    </xsl:for-each>		
	  </xsl:if>

	  <xsl:if test="normalize-space(mods:name)">
	    <xsl:for-each select="mods:name">
	      <tr><td><xsl:value-of select="$subjectName"/></td><td>
		  <xsl:call-template name="name"/>
	      </td></tr>
	    </xsl:for-each>
	  </xsl:if>
	
	  <xsl:if test="normalize-space(mods:geographic)">
	    <xsl:for-each select="mods:geographic">
	      <tr><td><xsl:value-of select="$subjectGeographic"/></td><td>
		  <xsl:value-of select="."/>
	      </td></tr>
	    </xsl:for-each>
	  </xsl:if>
	  <xsl:if test="normalize-space(mods:hierarchicalGeographic)">
	  <xsl:for-each select="mods:hierarchicalGeographic">
		  <tr><td><xsl:value-of select="$subjectHierGeographic"/></td><td>
				<xsl:for-each
					select="mods:continent|mods:country|mods:provence|mods:region|mods:state|mods:territory|mods:county|mods:city|mods:island|mods:area">
					<xsl:value-of select="."/>
					<xsl:if test="position()!=last()">--</xsl:if>
				</xsl:for-each>
		  </td></tr>
		</xsl:for-each>
	  </xsl:if>
	  <xsl:if test="normalize-space(mods:cartographics)">
	    <xsl:for-each select="mods:cartographics/*">
	      <tr><td><xsl:value-of select="$subjectCartographic"/></td><td>
		  <xsl:value-of select="."/>
	      </td></tr>
	    </xsl:for-each>
	  </xsl:if>
	  <xsl:if test="normalize-space(mods:temporal)">
	    <xsl:if test="mods:temporal">
	      <tr><td><xsl:value-of select="subjectTemporal"/></td><td>
		  <xsl:for-each select="mods:temporal">
		    <xsl:value-of select="."/>
		    <xsl:if test="position()!=last()">-</xsl:if>
		  </xsl:for-each>
	      </td></tr>
	    </xsl:if>
	  </xsl:if>
		<xsl:if test="*[1][local-name()='topic'] and *[local-name()!='topic']">
		  <tr><td><xsl:value-of select="$subjectLocalname"/></td><td>
				<xsl:for-each select="*[local-name()!='cartographics' and local-name()!='geographicCode' and local-name()!='hierarchicalGeographic'] ">
					<xsl:value-of select="."/>
					<xsl:if test="position()!=last()">--</xsl:if>
				</xsl:for-each>
			</td></tr>
		</xsl:if>
	</xsl:template>

	<xsl:template match="mods:abstract">
	  <!-- <xsl:if test="mods:abstract =''"> -->
	  <xsl:if test="normalize-space()">
		  <tr><td><xsl:value-of select="$abstract"/></td><td>			
			<xsl:value-of select="."/>
		  </td></tr>
	  </xsl:if>
	</xsl:template>

	<xsl:template match="mods:tableOfContents">
	  <!-- <xsl:if test="mods:tableOfContents =''"> -->
	  <xsl:if test="normalize-space(.)">
		  <tr><td><xsl:value-of select="toc"/></td><td>			
			<xsl:value-of select="."/>
		  </td></tr>
	  </xsl:if>
	</xsl:template>

	<xsl:template match="mods:note">
	  <xsl:if test="normalize-space(.)">	
	  <tr><td><xsl:value-of select="$note"/></td><td>			
			<xsl:value-of select="."/>
		  </td></tr>
</xsl:if>
	</xsl:template>


	<xsl:template match="mods:originInfo">
		<xsl:apply-templates select="*[@point='start']"/>

		<xsl:for-each select="mods:dateIssued[@point!='start' and @point!='end']">
		  <tr><td><xsl:value-of select="$dateIssued"/></td><td>			
				<xsl:value-of select="."/>
				</td></tr>
		</xsl:for-each>


		<xsl:for-each select="mods:dateCreated[@point!='start' and @point!='end']">
		  <tr><td><xsl:value-of select="$dateCreated"/></td><td>
				<xsl:value-of select="."/>
			</td></tr>
		</xsl:for-each>

		<xsl:for-each select="mods:dateCaptured[@point!='start' and @point!='end']">
		  <tr><td><xsl:value-of select="$dateCaptured"/></td><td>
				<xsl:value-of select="."/>
			</td></tr>
		</xsl:for-each>

		<xsl:for-each select="mods:dateOther[@point!='start' and @point!='end']">
		  <tr><td><xsl:value-of select="$dateOther"/></td><td>
				<xsl:value-of select="."/>
			</td></tr>
		</xsl:for-each>



		<xsl:for-each select="mods:publisher">
		  <xsl:if test="normalize-space(mods:publisher)">
		  <tr><td><xsl:value-of select="$publisher"/></td><td>			
				<xsl:value-of select="."/>
		  </td></tr>
		  </xsl:if>
		</xsl:for-each>
	</xsl:template>
<!--
	<xsl:template match="mods:dateIssued | mods:dateCreated | mods:dateCaptured">
		<dc:date>
			<xsl:choose>
				<xsl:when test="@point='start'">
					<xsl:value-of select="."/>
					<xsl:text> - </xsl:text>
				</xsl:when>
				<xsl:when test="@point='end'">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</dc:date>
	</xsl:template>
-->
	<xsl:template match="mods:genre">
	  <xsl:if test="normalize-space()">
	  <tr><td><xsl:value-of select="$genre"/></td><td>
	      <xsl:value-of select="."/>
	  </td></tr>
	  </xsl:if>
	  <!--
		<xsl:choose>
			<xsl:when test="@authority='dct'">
				<dc:type>
					<xsl:value-of select="."/>
				</dc:type>
				<xsl:for-each select="mods:typeOfResource">
					<dc:type>
						<xsl:value-of select="."/>
					</dc:type>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<dc:type>
					<xsl:value-of select="."/>
				</dc:type>
			</xsl:otherwise>
		</xsl:choose>
		-->
	</xsl:template>

	<xsl:template match="mods:typeOfResource">
	  <tr><td><xsl:value-of select="$typeOfResource"/></td><td>
	      <xsl:value-of select="."/>
	  </td></tr>
<!--
		<xsl:if test="@collection='yes'">
			<dc:type>Collection</dc:type>
		</xsl:if>
		<xsl:if test=". ='software' and ../mods:genre='database'">
			<dc:type>DataSet</dc:type>
		</xsl:if>
		<xsl:if test=".='software' and ../mods:genre='online system or service'">
			<dc:type>Service</dc:type>
		</xsl:if>
		<xsl:if test=".='software'">
			<dc:type>Software</dc:type>
		</xsl:if>
		<xsl:if test=".='cartographic material'">
			<dc:type>Image</dc:type>
		</xsl:if>
		<xsl:if test=".='multimedia'">
			<dc:type>InteractiveResource</dc:type>
		</xsl:if>
		<xsl:if test=".='moving image'">
			<dc:type>MovingImage</dc:type>
		</xsl:if>
		<xsl:if test=".='three-dimensional object'">
			<dc:type>PhysicalObject</dc:type>
		</xsl:if>
		<xsl:if test="starts-with(.,'sound recording')">
			<dc:type>Sound</dc:type>
		</xsl:if>
		<xsl:if test=".='still image'">
			<dc:type>StillImage</dc:type>
		</xsl:if>
		<xsl:if test=". ='text'">
			<dc:type>Text</dc:type>
		</xsl:if>
		<xsl:if test=".='notated music'">
			<dc:type>Text</dc:type>
		</xsl:if>
-->
	</xsl:template>

	<xsl:template match="mods:physicalDescription">
		<xsl:if test="mods:extent">
		  <xsl:if test="normalize-space(mods:extent)">
			<tr><td><xsl:value-of select="$extent"/></td><td>
				<xsl:value-of select="mods:extent"/>
			</td></tr>
		  </xsl:if>
		</xsl:if>
		<xsl:if test="mods:form">
		  <xsl:if test="normalize-space(mods:form)">
		    <tr><td><xsl:value-of select="$form"/></td><td>
			<xsl:value-of select="mods:form"/>
                    </td></tr>
		  </xsl:if>
		</xsl:if>
               <xsl:if test="mods:internetMediaType">
		  <xsl:if test="normalize-space(mods:internetMediaType)">
		  <tr><td><xsl:value-of select="$mediaType"/></td><td>
		    <xsl:value-of select="mods:internetMediaType"/>
               </td></tr>
		  </xsl:if>
	       </xsl:if>
	</xsl:template>

	<xsl:template match="mods:mimeType">
		  <xsl:if test="normalize-space(.)">
		    <tr><td><xsl:value-of select="$mimeType"/></td><td>
			<xsl:value-of select="."/>
		    </td></tr>
		  </xsl:if>
	</xsl:template>

	<xsl:template match="mods:identifier">
	  <xsl:if test="normalize-space(.)">
	  <tr><td><xsl:value-of select="$identifier"/></td><td>
	      <xsl:value-of select="."/>
	  </td></tr>
	  </xsl:if>
	  <!--
		<xsl:variable name="type" select="translate(@type,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
		<xsl:choose>
			<xsl:when test="contains ('isbn issn uri doi lccn uri', $type)">
				<dc:identifier>
					<xsl:value-of select="$type"/>: <xsl:value-of select="."/>
				</dc:identifier>
			</xsl:when>
			<xsl:otherwise>
				<dc:identifier>
					<xsl:value-of select="."/>
				</dc:identifier>
			</xsl:otherwise>
		</xsl:choose>
		-->
	</xsl:template>

	<xsl:template match="mods:location">
	  <xsl:if test="normalize-space(mods:physicalLocation)">
	    <tr><td><xsl:value-of select="$physicalLocation"/></td><td>
		<xsl:for-each select="mods:physicalLocation">
		  <xsl:value-of select="."/>
		  <xsl:if test="position()!=last()">--</xsl:if>
		</xsl:for-each>
	    </td></tr>
	  </xsl:if>
	  <xsl:if test="normalize-space(mods:shelfLocation)">
	  <tr><td><xsl:value-of select="$shelfLocation"/></td><td>
	      <xsl:for-each select="mods:shelfLocation">
		<xsl:value-of select="."/>
		<xsl:if test="position()!=last()">--</xsl:if>
	      </xsl:for-each>
	  </td></tr>
	  </xsl:if>
	<!--  <xsl:if test="normalize-space(mods:url)">
	    <tr><td><xsl:value-of select="$url"/></td><td>
		<xsl:for-each select="mods:url">
		  <xsl:value-of select="."/>
		</xsl:for-each>
	    </td></tr>
	  </xsl:if>  -->
	  <xsl:if test="normalize-space(mods:recommendedCitation)">
	    <tr><td><xsl:value-of select="$recommendedCitation"/></td><td>
		<xsl:for-each select="mods:recommendedCitation">
		  <xsl:value-of select="."/>
		</xsl:for-each>
	    </td></tr>
	  </xsl:if>
	  <xsl:if test="normalize-space(mods:holdingSimple/mods:copyInformation/mods:sublocation)">
		<tr><td><xsl:value-of select="$holdingSubLocation"/></td><td>
		  <xsl:for-each select="mods:holdingSimple/mods:copyInformation/mods:sublocation">
		    <xsl:value-of select="."/>
		    <xsl:if test="position()!=last()">--</xsl:if>
		  </xsl:for-each>
		  </td></tr>
	  </xsl:if>
	  <xsl:if test="normalize-space(mods:holdingSimple/mods:copyInformation/mods:shelfLocation)">
		<tr><td><xsl:value-of select="$holdingShelfLocator"/></td><td>
		  <xsl:for-each select="mods:holdingSimple/mods:copyInformation/mods:shelfLocator">
		    <xsl:value-of select="."/>
		    <xsl:if test="position()!=last()">--</xsl:if>
		  </xsl:for-each>
		  </td></tr>
	  </xsl:if>
	  <xsl:if test="normalize-space(mods:holdingSimple/mods:copyInformation/mods:electronicLocator)">
		<tr><td><xsl:value-of select="$electronicLocator"/></td><td>
			<xsl:for-each select="mods:holdingSimple/mods:copyInformation/mods:electronicLocator">
				<xsl:value-of select="."/>
			</xsl:for-each>
		</td></tr>
	  </xsl:if>
	</xsl:template>
<!--
	<xsl:template match="mods:location/mods:holdingSimple/mods:copyInformation">
	  <dc:identifier>
	    <xsl:for-each select="mods:sublocation | mods:shelfLocator | mods:electronicLocator">
	      <xsl:value-of select="."/>
	      <xsl:if test="position()!=last()"></xsl:if>
	    </xsl:for-each>
	  </dc:identifier>
	</xsl:template>
-->

	<xsl:template match="mods:language">
<xsl:if test="mods:language =''">
	  <tr><td><xsl:value-of select="$language"/></td><td>
	      <xsl:value-of select="normalize-space(.)"/>
	</td></tr>
</xsl:if>
	</xsl:template>

	<xsl:template match="mods:relatedItem[mods:titleInfo | mods:identifier | mods:location]">
<!--	<xsl:template match="mods:relatedItem[mods:titleInfo | mods:name | mods:identifier | mods:location]"> -->
		<xsl:choose>
			<xsl:when test="@type='original'">
			  <tr><td><xsl:value-of select="$relatedItem"/></td><td>
					<xsl:for-each
						select="mods:titleInfo/mods:title | mods:identifier | mods:location/mods:recommendedCitation">
						<xsl:if test="normalize-space(.)!= ''">
							<xsl:value-of select="."/>
							<xsl:if test="position()!=last()">--</xsl:if>
						</xsl:if>
					</xsl:for-each>
			  </td></tr>
			</xsl:when>
			<xsl:when test="@type='series'"/>
			<xsl:otherwise>
			  <tr><td><xsl:value-of select="$relatedItem"/></td><td>
					<xsl:for-each
						select="mods:titleInfo/mods:title | mods:identifier | mods:location/mods:recommendedCitation">
						<xsl:if test="normalize-space(.)!= ''">
							<xsl:value-of select="."/>
							<xsl:if test="position()!=last()">--</xsl:if>
						</xsl:if>
					</xsl:for-each>
			  </td></tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="mods:accessCondition">
	  <xsl:if test="normalize-space(.)">
	    <tr><td><xsl:value-of select="$accessCondition"/></td><td>
		<xsl:value-of select="."/>
	    </td></tr>
	    </xsl:if>
	</xsl:template>

	<xsl:template name="name">
	  	<xsl:value-of select="mods:namePart"/>
<!--
		<xsl:variable name="name-value">
			<xsl:for-each select="mods:namePart[not(@type)]">
				<xsl:value-of select="."/>
				<xsl:text> </xsl:text>
			</xsl:for-each>
			<xsl:value-of select="mods:namePart[@type='family']"/>
			<xsl:if test="mods:namePart[@type='given']">
				<xsl:text>, </xsl:text>
				<xsl:value-of select="mods:namePart[@type='given']"/>
			</xsl:if>
			<xsl:if test="mods:namePart[@type='date']">
				<xsl:text>, </xsl:text>
				<xsl:value-of select="mods:namePart[@type='date']"/>
				<xsl:text/>
			</xsl:if>
			<xsl:if test="mods:namePart[@type='personal']">
				<xsl:text>, </xsl:text>
				<xsl:value-of select="mods:namePart[@type='personal']"/>
				<xsl:text/>
			</xsl:if>

			<xsl:if test="mods:displayForm">
				<xsl:text> (</xsl:text>
				<xsl:value-of select="mods:displayForm"/>
				<xsl:text>) </xsl:text>
			</xsl:if>
			<xsl:for-each select="mods:role[mods:roleTerm[@type='text']!='creator']">
				<xsl:text> (</xsl:text>
				<xsl:value-of select="normalize-space(.)"/>
				<xsl:text>) </xsl:text>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="normalize-space(name-value)"/>
-->
	</xsl:template>
<!--
	<xsl:template match="mods:dateIssued[@point='start'] | mods:dateCreated[@point='start'] | mods:dateCaptured[@point='start'] | mods:dateOther[@point='start'] ">
		<xsl:variable name="dateName" select="local-name()"/>
			<dc:date>
				<xsl:value-of select="."/>-<xsl:value-of select="../*[local-name()=$dateName][@point='end']"/>
			</dc:date>
	</xsl:template>
	
	<xsl:template match="mods:temporal[@point='start']  ">
		<xsl:value-of select="."/>-<xsl:value-of select="../mods:temporal[@point='end']"/>
	</xsl:template>
	
	<xsl:template match="mods:temporal[@point!='start' and @point!='end']  ">
		<xsl:value-of select="."/>
	</xsl:template>
-->	
	<!-- suppress all else:-->
	<xsl:template match="*"/>
			
</xsl:stylesheet>
