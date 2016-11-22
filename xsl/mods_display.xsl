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
	<xsl:key name="namesByDisplayLabel" match="mods:name" use="@displayLabel"/>
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
	
	<xsl:template match="mods:titleInfo[normalize-space(.)]">
	<!-- <dc:title> -->
			<tr><td>
			<xsl:choose>
			  <xsl:when test="not(@displayLabel)">
			   <xsl:value-of select="$title"/>
			 </xsl:when></xsl:choose>
			 <xsl:value-of select="@displayLabel"/>
			
			</td><td class="modsTitle">

<!--<xsl:if test="position()!=last()">-->

<!--
                        <xsl:value-of select="mods:nonSort"/>
			<xsl:if test="mods:nonSort">
				<xsl:analyze-string select="." regex="[Ane]$">
                		<xsl:matching-substring>
				<xsl:text> </xsl:text>
				</xsl:matching-substring></xsl:analyze-string> 
			</xsl:if>
-->
			<xsl:value-of select="mods:nonSort"/>
			<xsl:if test="mods:nonSort">
				<xsl:text> </xsl:text>
			</xsl:if>

<!--
			<xsl:variable name="nonSortRegEx" select="'[Ane]$'"/>
        		<xsl:value-of select="mods:nonSort"/>
        		<xsl:if test="mods:nonSort">
            			<xsl:choose>
        	 			<xsl:when test="matches(mods:nonSort, $nonSortRegEx)">
                     				<xsl:text> </xsl:text>
                			</xsl:when>
                			<xsl:otherwise/>
            			</xsl:choose>  
        		</xsl:if>
-->


			<xsl:value-of select="mods:title"/>
			<xsl:if test="mods:subTitle">
				<!-- <xsl:text>: </xsl:text> -->
				<xsl:value-of select="mods:subTitle"/>
			</xsl:if>
			<xsl:if test="mods:partNumber">
				<!--<xsl:text>. </xsl:text> -->
				<xsl:value-of select="mods:partNumber"/>
			</xsl:if>
			<xsl:if test="mods:partName">
				<!--<xsl:text>. </xsl:text> -->
				<xsl:value-of select="mods:partName"/>
			</xsl:if>
			</td></tr>
 	<!-- </dc:title> -->
	</xsl:template>

	<xsl:template match="mods:name[1]">
		<xsl:for-each select="//mods:name[count(. | key('namesByDisplayLabel', @displayLabel)[1]) = 1]">
		<xsl:variable name="nameType" select="@type"/>
		<tr>
			<td>
				<xsl:choose>
					<xsl:when test="not(@displayLabel)">
                    	<xsl:value-of select="$name"/>
                    </xsl:when></xsl:choose>
		     <xsl:value-of select="@displayLabel"/>
			</td>
			<td class="modsContributor">
				<xsl:choose>
					<xsl:when test="not(@displayLabel)">
						<xsl:for-each select="mods:namePart">
							<a>
								<xsl:attribute name="href">
									<xsl:choose>
										<xsl:when test="$nameType">
											<xsl:value-of select="'/islandora/search/mods_name_'"/>
											<xsl:value-of select="$nameType"/>
											<xsl:text>_namePart_mt%3A%2522</xsl:text>
											<xsl:value-of select="."/>
											<xsl:text>%2522</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="'/islandora/search/mods_name_namePart_mt%3A%2522'"/>
											<xsl:value-of select="."/>
											<xsl:value-of select="'%2522'"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:value-of select="."/>
							</a>
							<br />
						</xsl:for-each>
					</xsl:when>
				</xsl:choose>
				<xsl:for-each select="key('namesByDisplayLabel', @displayLabel)">
					<a>
						<xsl:attribute name="href">
							<xsl:choose>
								<xsl:when test="$nameType">
									<xsl:value-of select="'/islandora/search/mods_name_'"/>
									<xsl:value-of select="$nameType"/>
									<xsl:text>_namePart_mt%3A%2522</xsl:text>
									<xsl:value-of select="mods:namePart"/>
									<xsl:text>%2522</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'/islandora/search/mods_name_namePart_mt%3A%2522'"/>
									<xsl:value-of select="mods:namePart"/>
									<xsl:value-of select="'%2522'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:value-of select="mods:namePart"/>
					</a>
					<br />
				</xsl:for-each>
			</td>
		</tr>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="mods:classification">
		<tr><td>
		    <xsl:value-of select="$classification"/>
		</td><td>
			<xsl:value-of select="."/>
		</td></tr>
	</xsl:template>

	<xsl:template match="mods:subject[mods:topic][1]">
		<tr>
			<td>
				<xsl:if test="normalize-space(mods:topic)">
					<xsl:choose>
						<xsl:when test="not(@displayLabel)">
							<xsl:value-of select="$subjectTopic"/>
						</xsl:when>
					</xsl:choose>
					<xsl:value-of select="@displayLabel"/>
				</xsl:if>
			</td>
			<td>
				<a>
					<xsl:attribute name="href">
						<xsl:for-each select="mods:topic">
							<xsl:if test="position()=1">
								<xsl:value-of select="'/islandora/search/mods_subject_topic_ms%3A'"/>
							</xsl:if>
							<xsl:text>%2522</xsl:text>
							<xsl:value-of select="."/>
							<xsl:text>%2522</xsl:text>
						</xsl:for-each>
					</xsl:attribute>
					<xsl:for-each select="mods:topic">
						<xsl:value-of select="."/>
						<xsl:if test="position()!=last()">--</xsl:if>
					</xsl:for-each>
				</a>
				<br />
				<xsl:for-each select="following-sibling::mods:subject[mods:topic]">
					<a>
						<xsl:attribute name="href">
							<xsl:for-each select="mods:topic">
								<xsl:if test="position()=1">
								<xsl:value-of select="'/islandora/search/mods_subject_topic_ms%3A'"/>
								</xsl:if>
								<xsl:text>%2522</xsl:text>
								<xsl:value-of select="."/>
								<xsl:text>%2522</xsl:text>
							</xsl:for-each>
						</xsl:attribute>
						<xsl:for-each select="mods:topic">
							<xsl:value-of select="."/>
							<xsl:if test="position()!=last()">--</xsl:if>
						</xsl:for-each>
					</a>
					<br />
				</xsl:for-each>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="mods:subject[mods:geographic][1]">
		<tr>
			<td>
				<xsl:if test="normalize-space(mods:geographic)">
					<xsl:choose>
						<xsl:when test="not(@displayLabel)">
							<xsl:value-of select="$subjectGeographic"/>
						</xsl:when>
					</xsl:choose>
					<xsl:value-of select="@displayLabel"/>
				</xsl:if>
			</td>
			<td>
				<xsl:for-each select="mods:geographic">
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="'/islandora/search/mods_subject_geographic_ms%3A%2522'"/>
							<xsl:value-of select="."/>
							<xsl:value-of select="'%2522'"/>
						</xsl:attribute>
						<xsl:value-of select="."/>
					</a>
					<br />
				</xsl:for-each>
				<xsl:for-each select="following-sibling::mods:subject[mods:geographic]">
					<xsl:for-each select="mods:geographic">
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="'/islandora/search/mods_subject_geographic_ms%3A%2522'"/>
								<xsl:value-of select="."/>
								<xsl:value-of select="'%2522'"/>
							</xsl:attribute>
							<xsl:value-of select="."/>
						</a>
					</xsl:for-each>
					<br />
				</xsl:for-each>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="mods:subject[mods:temporal][1]">
		<tr>
			<td>
				<xsl:if test="normalize-space(mods:temporal)">
					<xsl:choose>
						<xsl:when test="not(@displayLabel)">
							<xsl:value-of select="$subjectTemporal"/>
						</xsl:when>
					</xsl:choose>
					<xsl:value-of select="@displayLabel"/>
				</xsl:if>
			</td>
			<td>
				<xsl:for-each select="mods:temporal">
					<a>
						<xsl:attribute name="href">
							<xsl:value-of select="'/islandora/search/mods_subject_temporal_ms%3A%2522'"/>
							<xsl:value-of select="."/>
							<xsl:value-of select="'%2522'"/>
						</xsl:attribute>
						<xsl:value-of select="."/>
					</a>
					<br />
				</xsl:for-each>
				<xsl:for-each select="following-sibling::mods:subject[mods:temporal]">
					<xsl:for-each select="mods:temporal">
						<a>
							<xsl:attribute name="href">
								<xsl:value-of select="'/islandora/search/mods_subject_temporal_ms%3A%2522'"/>
								<xsl:value-of select="."/>
								<xsl:value-of select="'%2522'"/>
							</xsl:attribute>
							<xsl:value-of select="."/>
						</a>
					</xsl:for-each>
					<br />
				</xsl:for-each>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="mods:subject[mods:occupation | mods:hierarchicalGeographic | mods:cartographics ] ">
<!-- 	<xsl:template match="mods:subject[mods:topic | mods:name | mods:occupation | mods:geographic | mods:hierarchicalGeographic | mods:cartographics | mods:temporal] "> -->
	
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
	      <tr><td><xsl:value-of select="$subjectTemporal"/></td><td>
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
		  <tr><td><xsl:choose><xsl:when test="not(@displayLabel)">
                                <xsl:value-of select="$abstract"/>
                        </xsl:when></xsl:choose><xsl:value-of select="@displayLabel"/> </td><td>			
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
		<xsl:variable name="urlchar" select="'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-#:%_+.~?&amp;/='"/>
		<xsl:variable name="noteUrl" select="substring-before(substring-after(., 'http'), substring(translate(substring-after(., 'http'), $urlchar, ''),1,1))"/>
		<xsl:if test="normalize-space(.)">
			<tr><td>
				<xsl:choose>
					<xsl:when test="not(@displayLabel)">
						<xsl:value-of select="$note"/>
					</xsl:when>
				</xsl:choose>
				<xsl:value-of select="@displayLabel"/>
			</td>
				<td>
					<xsl:choose>	
						<xsl:when test="contains(., 'http')">
							<xsl:value-of select="substring-before(., 'http')"/>
							<xsl:element name="a">
								<xsl:attribute name="href">
									<xsl:text>http</xsl:text>
									<xsl:choose>
										<xsl:when test="$noteUrl = ''">
											<xsl:value-of select="substring-after(., 'http')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$noteUrl"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:text>http</xsl:text>				
								<xsl:choose>
									<xsl:when test="$noteUrl = ''">
										<xsl:value-of select="substring-after(., 'http')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$noteUrl"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
							<xsl:choose>
								<xsl:when test="$noteUrl = ''">
									<!--do nothing-->
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring-after(., $noteUrl)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</td></tr>
		</xsl:if>
	</xsl:template>

	<!-- date stuff -->
<!--
	<xsl:template match="mods:originInfo">
	<xsl:for-each select="mods:dateIssued">
	<tr><td><xsl:value-of select="$dateCreated"/></td><td>aoeuaoeu<xsl:value-of select="."/></td></tr>
	</xsl:for-each>
	</xsl:template>
-->
<xsl:template match="mods:originInfo">
	<xsl:if test="mods:dateCreated">
		<tr>
			<td><xsl:value-of select="$dateCreated"/></td>
			<td><xsl:value-of select="mods:dateCreated"/>
				<xsl:if test="mods:dateCreated/@qualifier">
					<xsl:text> (</xsl:text>
					<xsl:value-of select="mods:dateCreated/@qualifier"/>
					<xsl:text>)</xsl:text>
				</xsl:if>
				<xsl:if test="mods:dateCreated[@point='end']">
					<xsl:text> - </xsl:text>
					<xsl:value-of select="mods:dateCreated[@point='end']"/>
					<xsl:if test="mods:dateCreated/@qualifier">
						<xsl:text> (</xsl:text>
						<xsl:value-of select="mods:dateCreated/@qualifier"/>
						<xsl:text>)</xsl:text>
					</xsl:if>
				</xsl:if>
			</td>
		</tr>
	</xsl:if>
	<xsl:if test="mods:dateCaptured">
		<tr>
			<td><xsl:value-of select="$dateCaptured"/></td>
			<td><xsl:value-of select="mods:dateCaptured"/>
				<xsl:if test="mods:dateCaptured/@qualifier">
					<xsl:text> (</xsl:text>
					<xsl:value-of select="mods:dateCaptured/@qualifier"/>
					<xsl:text>)</xsl:text>
				</xsl:if>
				<xsl:if test="mods:dateCaptured[@point='end']">
					<xsl:text> - </xsl:text>
					<xsl:value-of select="mods:dateCaptured[@point='end']"/>
					<xsl:if test="mods:dateCaptured/@qualifier">
						<xsl:text> (</xsl:text>
						<xsl:value-of select="mods:dateCaptured/@qualifier"/>
						<xsl:text>)</xsl:text>
					</xsl:if>
				</xsl:if>
			</td>
		</tr>
	</xsl:if>
	<xsl:if test="mods:dateIssued">
		<tr>
			<td><xsl:value-of select="$dateIssued"/></td>
			<td><xsl:value-of select="mods:dateIssued"/>
				<xsl:if test="mods:dateIssued/@qualifier">
					<xsl:text> (</xsl:text>
					<xsl:value-of select="mods:dateIssued/@qualifier"/>
					<xsl:text>)</xsl:text>
				</xsl:if>
				<xsl:if test="mods:dateIssued[@point='end']">
					<xsl:text> - </xsl:text>
					<xsl:value-of select="mods:dateIssued[@point='end']"/>
					<xsl:if test="mods:dateIssued/@qualifier">
						<xsl:text> (</xsl:text>
						<xsl:value-of select="mods:dateIssued/@qualifier"/>
						<xsl:text>)</xsl:text>
					</xsl:if>
				</xsl:if>
			</td>
		</tr>
	</xsl:if>
</xsl:template>	
	<!--
<xsl:template match="mods:originInfo">
       <xsl:if test="mods:dateIssued[contains(@point,'start')] and mods:dateIssued[contains(@point,'end')] and not(mods:dateIssued[@qualifier])"><tr><td><xsl:value-of select="$dateIssued"/></td><td><xsl:value-of select="mods:dateIssued[contains(@point,'start')]"/>-<xsl:value-of select="mods:dateIssued[contains(@point,'end')]"/></td></tr></xsl:if>
       <xsl:if test="mods:dateIssued[contains(@point,'start')] and mods:dateIssued[contains(@point,'end')] and mods:dateIssued[@qualifier]"><tr><td><xsl:value-of select="$dateIssued"/></td><td>Approximately <xsl:value-of select="mods:dateIssued[contains(@point,'start')]"/>-<xsl:value-of select="mods:dateIssued[contains(@point,'end')]"/></td></tr></xsl:if>
       <xsl:if test="mods:dateIssued[contains(@keydate,'yes')] and not(mods:dateIssued[@point]) and not(mods:dateIssued[@qualifier])"><tr><td><xsl:value-of select="$dateIssued"/></td><td><xsl:value-of select="mods:dateIssued"/></td></tr></xsl:if>
       <xsl:if test="mods:dateIssued[contains(@keydate,'yes')] and not(mods:dateIssued[@point]) and mods:dateIssued[@qualifier]"><tr><td><xsl:value-of select="$dateIssued"/></td><td>Approximately <xsl:value-of select="mods:dateIssued"/></td></tr></xsl:if>
       <xsl:if test="mods:dateCreated"><tr><td><xsl:value-of select="$dateCreated"/></td><td><xsl:value-of select="mods:dateCreated"/></td></tr></xsl:if>
       <xsl:if test="mods:dateCaptured"><tr><td><xsl:value-of select="$dateCaptured"/></td><td><xsl:value-of select="mods:dateCaptured"/></td></tr></xsl:if>
       <xsl:if test="mods:dateIssued"><tr><td><xsl:value-of select="$dateIssued"/></td><td><xsl:value-of select="mods:dateIssued"/></td></tr></xsl:if>
   </xsl:template>
   -->
<!--
	<xsl:template match="mods:originInfo">
		<tr><td><xsl:copy-of select="name(.)"/></td><td><xsl:value-of select="."/></td></tr>
		<xsl:if test="mods:dateIssued"><tr><td><xsl:value-of select="$dateIssued"/></td>
	<td><xsl:analyze-string select="." regex="([0-9]{8})">
		<xsl:matching-substring>
		<xsl:text>"match"</xsl:text></xsl:matching-substring>
	    </xsl:analyze-string> 
			<xsl:value-of select="."/></td></tr></xsl:if>
		
		<xsl:if test="mods:dateCreated"><tr><td><xsl:value-of select="$dateCreated"/></td>
	<td>
		<xsl:value-of select="."/></td></tr></xsl:if>
		
		<xsl:if test="mods:dateCaptured"><tr><td><xsl:value-of select="$dateCaptured"/></td>
	<td>
		<xsl:value-of select="."/></td></tr></xsl:if>
	<tr><td><xsl:copy-of select="name(.)"/></td><td><xsl:value-of select="."/></td></tr>
	</xsl:template>
-->
<!--	
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
-->
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

<!--	<xsl:template match="mods:identifier">
	  <tr>
	  	<td>
	  		<xsl:value-of select="$identifier"/>
	  	</td>
	  	<td>
	      <xsl:value-of select="."/> Identify yourself
	  	</td>
	  </tr>-->
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
	<!--</xsl:template>-->

<!-- will's template for physloc -->
	<xsl:template match="mods:location">
		<xsl:for-each select="mods:physicalLocation[not(@displayLabel='OCLC Member Symbol')]">
			<tr>
				<td>
				<xsl:choose>
					<xsl:when test="not(@displayLabel)">
	        	    	<xsl:value-of select="$physicalLocation"/>
	            	</xsl:when>
				</xsl:choose>
	        	<xsl:value-of select="@displayLabel"/>
	        	</td>
				<td>
					<xsl:value-of select="."/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>

<!--
	<xsl:template match="mods:location">
	  <xsl:if test="normalize-space(mods:physicalLocation)">
	    <tr><td><xsl:choose><xsl:when test="not(@displayLabel)">
                                <xsl:value-of select="$physicalLocation"/>
                        </xsl:when></xsl:choose>
                        <xsl:value-of select="@displayLabel"/></td><td>
		<xsl:for-each select="mods:physicalLocation">
		  <xsl:value-of select="."/>
		</xsl:for-each>
	    </td></tr>
	  </xsl:if>
	  <xsl:if test="normalize-space(mods:shelfLocation)">
	  <tr><td><xsl:value-of select="$shelfLocation"/></td><td>
	      <xsl:for-each select="mods:shelfLocation">
		<xsl:value-of select="."/>
	      </xsl:for-each>
	  </td></tr>
	  </xsl:if>
-->
	<!--  <xsl:if test="normalize-space(mods:url)">
	    <tr><td><xsl:value-of select="$url"/></td><td>
		<xsl:for-each select="mods:url">
		  <xsl:value-of select="."/>
		</xsl:for-each>
	    </td></tr>
	  </xsl:if> 
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
		  </xsl:for-each>
		  </td></tr>
	  </xsl:if>
	  <xsl:if test="normalize-space(mods:holdingSimple/mods:copyInformation/mods:shelfLocation)">
		<tr><td><xsl:value-of select="$holdingShelfLocator"/></td><td>
		  <xsl:for-each select="mods:holdingSimple/mods:copyInformation/mods:shelfLocator">
		    <xsl:value-of select="."/>
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
-->

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
<!-- <start will's own loop>-->
	<xsl:template match="mods:identifier[not(@displayLabel='Object File Name')]">
		<tr>
			<td>
				<xsl:value-of select="@displayLabel"/>
			</td>
			<td>
				<xsl:value-of select="."/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="mods:relatedItem[mods:titleInfo]">
		<xsl:for-each select="mods:titleInfo">
		<tr>
			<td>
				<xsl:value-of select="@displayLabel"/>
			</td>
			<td>
				<xsl:value-of select="mods:title"/>
			</td>
		</tr>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="mods:relatedItem[mods:part]">
		<xsl:for-each select="mods:part">
			<tr>
				<td>
					<xsl:text>Part of</xsl:text>
				</td>
				<td>
					<xsl:value-of select="mods:detail/mods:title"/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>
	
	<!--<xsl:template match="mods:relatedItem[mods:titleInfo | mods:identifier | mods:location]">
<!-\-	<xsl:template match="mods:relatedItem[mods:titleInfo | mods:name | mods:identifier | mods:location]"> -\->
		<xsl:choose>
			<xsl:when test="@type='original'">
			  <tr><td><xsl:value-of select="mods:titleInfo/@displayLabel | identifier/@displayLabel  | mods:location/mods:url/@displayLabel"/></td><td>
					<xsl:for-each
						select="mods:titleInfo/mods:title | mods:identifier | mods:location/mods:recommendedCitation">
						<xsl:if test="normalize-space(.)!= ''">
							<xsl:value-of select="."/>
							<xsl:if test="position()!=last()">-\-</xsl:if>
						</xsl:if>
					</xsl:for-each>
			  </td></tr>
			</xsl:when>
			<xsl:when test="mods:titleInfo/@type='alternative'">
				<tr>
					<td>
						<xsl:value-of select="mods:titleInfo[@type='alternative']/@displayLabel | identifier/@displayLabel  | mods:location/mods:url/@displayLabel"/>
					</td>
					<td>
						<xsl:for-each select="mods:titleInfo[@type='alternative']/mods:title | mods:identifier | mods:location/mods:recommendedCitation">
							<xsl:if test="normalize-space(.)!= ''">
								<xsl:value-of select="."/> and alternative
								<xsl:if test="position()!=last()">-\-</xsl:if>
							</xsl:if>
						</xsl:for-each>
					</td>
				</tr>
			</xsl:when>
			<xsl:when test="@type='series'"/>
			<xsl:otherwise>
			  <tr>
			  	<td>
			  		<xsl:value-of select="mods:titleInfo/@displayLabel | mods:identifier/@displayLabel  | mods:location/mods:url/@displayLabel"/>
			  	</td>
			  	<td>
					<xsl:for-each
						select="mods:titleInfo/mods:title | mods:identifier | mods:location/mods:recommendedCitation">
						<xsl:if test="normalize-space(.)!= ''">
							<xsl:value-of select="."/> and otherwise
							<xsl:if test="position()!=last()">-\-</xsl:if>
						</xsl:if>
					</xsl:for-each>
			  	</td>
			  </tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>-->

	<xsl:template match="mods:accessCondition">
		<xsl:variable name="urlchar" select="'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-#:%_+.~?&amp;/='"/>
		<xsl:variable name="accessUrl" select="substring-before(substring-after(., 'http'), substring(translate(substring-after(., 'http'), $urlchar, ''),1,1))"/>
		<xsl:if test="normalize-space(.)">
			<tr><td>
				<xsl:choose>
					<xsl:when test="not(@displayLabel)">
						<xsl:value-of select="$accessCondition"/>
					</xsl:when>
				</xsl:choose>
				<xsl:value-of select="@displayLabel"/>
			</td>
				<td>
					<xsl:choose>	
						<xsl:when test="contains(., 'http')">
							<xsl:value-of select="substring-before(., 'http')"/>
							<xsl:element name="a">
								<xsl:attribute name="href">
									<xsl:text>http</xsl:text>
									<xsl:choose>
										<xsl:when test="$accessUrl = ''">
											<xsl:value-of select="substring-after(., 'http')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$accessUrl"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:text>http</xsl:text>
								
								<xsl:choose>
									<xsl:when test="$accessUrl = ''">
										<xsl:value-of select="substring-after(., 'http')"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$accessUrl"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:element>
							<xsl:choose>
								<xsl:when test="$accessUrl = ''">
									<!--do nothing-->
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="substring-after(., $accessUrl)"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
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
