<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:mods="http://www.loc.gov/mods/v3" exclude-result-prefixes="mods dc xsi oai_dc srw_dc"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:srw_dc="info:srw/schema/1/dc-schema"
                xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <!--
    This stylesheet modified by M. McFate, Grinnell College, from 24-Feb-2015 to ?????????? for use
    in https://digital.grinnell.edu.  Original forked from git://github.com/jyobb/islandora_mods_display.git
    file mods_display.xsl on 24-Feb-2015.

    All changes marked with a comment of the form "MM Added|Changed|Deleted <Date>" in the XSLT.
    -->

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

    <xsl:variable name="title">Title</xsl:variable>
    <xsl:variable name="name">Name</xsl:variable>
    <xsl:variable name="classification">Classification</xsl:variable>
    <xsl:variable name="subjectTopic">Subject: Topic</xsl:variable>
    <xsl:variable name="subjectOccupation">Subject: Occupation</xsl:variable>
    <xsl:variable name="subjectName">Subject: Name</xsl:variable>
    <xsl:variable name="subjectGeographic">Subject: Geographic</xsl:variable>
    <xsl:variable name="subjectHierGeographic">Subject: HierGeographic</xsl:variable>
    <xsl:variable name="subjectCartographic">Subject: Cartographic</xsl:variable>
    <xsl:variable name="subjectTemporal">Subject: Temporal</xsl:variable>
    <xsl:variable name="subjectLocalname">Subject: LocalName</xsl:variable>
    <xsl:variable name="abstract">Description</xsl:variable>  <!-- MM Changed 05-Nov-2015.  Abstract to Description -->
    <xsl:variable name="toc">Table of Contents</xsl:variable>
    <xsl:variable name="note">Note</xsl:variable>
    <xsl:variable name="dateIssued">Date Issued</xsl:variable>
    <xsl:variable name="dateCreated">Date Created</xsl:variable>
    <xsl:variable name="dateCaptured">Date Captured</xsl:variable>
    <xsl:variable name="dateOther">Date (Other)</xsl:variable>
    <xsl:variable name="publisher">Publisher</xsl:variable>
    <xsl:variable name="genre">Genre</xsl:variable>
    <xsl:variable name="typeOfResource">Type of Resource</xsl:variable>
    <xsl:variable name="extent">Extent</xsl:variable>
    <xsl:variable name="form">Form</xsl:variable>
    <xsl:variable name="mediaType">Media Type</xsl:variable>
    <xsl:variable name="mimeType">MIME Type</xsl:variable>
    <xsl:variable name="identifier">Identifier</xsl:variable>
    <xsl:variable name="physicalLocation">Physical Location</xsl:variable>
    <xsl:variable name="shelfLocation">Shelf Location</xsl:variable>
    <xsl:variable name="url">URL</xsl:variable>
    <xsl:variable name="holdingSubLocation">Holding Sublocation</xsl:variable>
    <xsl:variable name="holdingShelfLocator">Holding Shelf Locator</xsl:variable>
    <xsl:variable name="electronicLocator">Electronic Locator</xsl:variable>
    <xsl:variable name="language">Language</xsl:variable>
    <xsl:variable name="relatedItem">Related Item</xsl:variable>
    <xsl:variable name="accessCondition">Access Condition</xsl:variable>

    <xsl:template match="/">
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
                        <!-- MAM...need a subdued "Parent Metadata" header... -->
                        <tr><th colspan="2"><span class="islandora-obj-details-dsid">Parent Object Metadata</span></th></tr>
                        <xsl:apply-templates/>
                    </table>
                    <!--			</oai_dc:dc> -->
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="mods:titleInfo[not(@type)]">
        <!-- <dc:title> -->
        <!-- MM Changed 05-Nov-2015... Adding class='mods-metadata-label' to all labels. -->
        <tr><td style="width:16em;" class="mods-metadata-label"><xsl:value-of select="$title"/></td><td>
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

    <!-- MAM addition for Alt. Title -->

    <xsl:template match="mods:titleInfo[@type='alternative']">
        <!-- <dc:title> -->
        <tr><td class="mods-metadata-label">Alternative Title</td><td>
            <xsl:value-of select="mods:title"/>
        </td></tr>
        <!-- </dc:title> -->
    </xsl:template>


    <xsl:template match="mods:classification">
        <tr>
            <td class="mods-metadata-label">
                <xsl:value-of select="$classification"/>
            </td>
            <td>
                <xsl:value-of select="."/>
            </td>
        </tr>
    </xsl:template>

    <!-- MAM modified if test= clauses below to distinguish subject[not(@*)] from subject[@authority] -->

    <xsl:template match="mods:subject[mods:topic | mods:occupation | mods:geographic | mods:hierarchicalGeographic | mods:cartographics | mods:temporal] ">

        <!-- MAM...show displayLabel attribute value but only if it exists! -->

        <xsl:if test="normalize-space(mods:topic[@displayLabel])">
            <xsl:for-each select="mods:topic">
                <tr><td class="mods-metadata-label"><xsl:text>Keyword</xsl:text>&#160;(<xsl:value-of select="@displayLabel"/>)</td><td>
                    <xsl:value-of select="."/>
              <!--  <xsl:if test="position()!=last()">-</xsl:if>  -->
                </td></tr>
            </xsl:for-each>
        </xsl:if>

        <xsl:if test="normalize-space(mods:topic[not(@displayLabel)])">
            <xsl:for-each select="mods:topic">
                <tr><td class="mods-metadata-label"><xsl:text>Keyword</xsl:text></td><td>
                    <xsl:value-of select="."/>
              <!--  <xsl:if test="position()!=last()">-</xsl:if> -->
                </td></tr>
            </xsl:for-each>
        </xsl:if>

        <xsl:if test="normalize-space(mods:occupation)">
            <xsl:for-each select="mods:occupation">
                <tr><td> class="mods-metadata-label"<xsl:value-of select="$subjectOccupation"/></td><td>
                    <xsl:value-of select="."/>
                    <xsl:if test="position()!=last()">--</xsl:if>
                </td></tr>
            </xsl:for-each>
        </xsl:if>

        <!-- MAM commenting this out to overcome error... no template named 'name'
        <xsl:if test="normalize-space(mods:name)">
          <xsl:for-each select="mods:name">
            <tr><td><xsl:value-of select="$subjectName"/></td><td>
            <xsl:call-template name="name"/>
            </td></tr>
          </xsl:for-each>
        </xsl:if>
        -->

        <xsl:if test="normalize-space(mods:geographic)">
            <xsl:for-each select="mods:geographic">
                <tr><td class="mods-metadata-label"><xsl:value-of select="$subjectGeographic"/></td><td>
                    <xsl:value-of select="."/>
                </td></tr>
            </xsl:for-each>
        </xsl:if>

        <xsl:if test="normalize-space(mods:hierarchicalGeographic)">
            <xsl:for-each select="mods:hierarchicalGeographic">
                <tr><td class="mods-metadata-label"><xsl:value-of select="$subjectHierGeographic"/></td><td>
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
                <tr><td class="mods-metadata-label"><xsl:value-of select="$subjectCartographic"/></td><td>
                    <xsl:value-of select="."/>
                </td></tr>
            </xsl:for-each>
        </xsl:if>

        <xsl:if test="normalize-space(mods:temporal)">
            <xsl:if test="mods:temporal">
                <tr><td class="mods-metadata-label"><xsl:value-of select="$subjectTemporal"/></td><td>
                    <xsl:for-each select="mods:temporal">
                        <xsl:value-of select="."/>
                        <xsl:if test="position()!=last()">-</xsl:if>
                    </xsl:for-each>
                </td></tr>
            </xsl:if>
        </xsl:if>

        <xsl:if test="*[1][local-name()='topic'] and *[local-name()!='topic']">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$subjectLocalname"/></td><td>
                <xsl:for-each select="*[local-name()!='cartographics' and local-name()!='geographicCode' and local-name()!='hierarchicalGeographic'] ">
                    <xsl:value-of select="."/>
                    <xsl:if test="position()!=last()">--</xsl:if>
                </xsl:for-each>
            </td></tr>
        </xsl:if>
    </xsl:template>


    <xsl:template match="mods:subject[@authority='lcsh'][mods:topic | mods:occupation | mods:geographic | mods:hierarchicalGeographic | mods:cartographics | mods:temporal] ">

      <xsl:if test="normalize-space(mods:topic)">
          <xsl:for-each select="mods:topic">
              <tr><td class="mods-metadata-label"><xsl:text>Subject: Topic</xsl:text></td><td>
                  <xsl:value-of select="."/>
                  <xsl:if test="position()!=last()">--</xsl:if>
              </td></tr>
          </xsl:for-each>
      </xsl:if>

      <xsl:if test="normalize-space(mods:occupation)">
          <xsl:for-each select="mods:occupation">
              <tr><td class="mods-metadata-label"><xsl:value-of select="$subjectOccupation"/></td><td>
                  <xsl:value-of select="."/>
                  <xsl:if test="position()!=last()">--</xsl:if>
              </td></tr>
          </xsl:for-each>
      </xsl:if>

      <!-- MAM commenting this out to overcome error... no template named 'name'
      <xsl:if test="normalize-space(mods:name)">
        <xsl:for-each select="mods:name">
          <tr><td><xsl:value-of select="$subjectName"/></td><td>
          <xsl:call-template name="name"/>
          </td></tr>
        </xsl:for-each>
      </xsl:if>
      -->

      <xsl:if test="normalize-space(mods:geographic)">
          <xsl:for-each select="mods:geographic">
              <tr><td class="mods-metadata-label"><xsl:value-of select="$subjectGeographic"/></td><td>
                  <xsl:value-of select="."/>
              </td></tr>
          </xsl:for-each>
      </xsl:if>

      <xsl:if test="normalize-space(mods:hierarchicalGeographic)">
          <xsl:for-each select="mods:hierarchicalGeographic">
              <tr><td class="mods-metadata-label"><xsl:value-of select="$subjectHierGeographic"/></td><td>
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
              <tr><td class="mods-metadata-label"><xsl:value-of select="$subjectCartographic"/></td><td>
                  <xsl:value-of select="."/>
              </td></tr>
          </xsl:for-each>
      </xsl:if>

      <xsl:if test="normalize-space(mods:temporal)">
          <xsl:if test="mods:temporal">
              <tr><td class="mods-metadata-label"><xsl:value-of select="$subjectTemporal"/></td><td>
                  <xsl:for-each select="mods:temporal">
                      <xsl:value-of select="."/>
                      <xsl:if test="position()!=last()">-</xsl:if>
                  </xsl:for-each>
              </td></tr>
          </xsl:if>
      </xsl:if>

      <xsl:if test="*[1][local-name()='topic'] and *[local-name()!='topic']">
          <tr><td class="mods-metadata-label"><xsl:value-of select="$subjectLocalname"/></td><td>
              <xsl:for-each select="*[local-name()!='cartographics' and local-name()!='geographicCode' and local-name()!='hierarchicalGeographic'] ">
                  <xsl:value-of select="."/>
                  <xsl:if test="position()!=last()">--</xsl:if>
              </xsl:for-each>
          </td></tr>
      </xsl:if>

    </xsl:template>


    <xsl:template match="mods:abstract">
        <xsl:if test="normalize-space()">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$abstract"/></td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:if>
    </xsl:template>

    <xsl:template match="mods:tableOfContents">
        <xsl:if test="normalize-space(.)">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$toc"/></td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:if>
    </xsl:template>

    <xsl:template match="mods:note[not(@type)]">
        <xsl:if test="normalize-space(.)">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$note"/></td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:if>
    </xsl:template>

    <!-- MAM removing this logic...

    <xsl:template match="mods:note[not(@type='acquisition')]">
        <xsl:if test="normalize-space(.)">
            <tr><td><xsl:value-of select="$note"/></td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:if>
    </xsl:template>  -->

    <xsl:template match="mods:note[@type='provenance']">
        <xsl:if test="normalize-space(.)">
            <tr><td class="mods-metadata-label">Provenance</td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:if>
    </xsl:template>

    <xsl:template match="mods:note[@type='acquisition']">
        <xsl:if test="normalize-space(.)">
            <tr><td class="mods-metadata-label">Provenance</td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:if>
    </xsl:template>


    <!-- MAM additions for specific Note types -->

    <xsl:template match="mods:note[@type!='provenance' and @type!='acquisition']">
        <xsl:if test="normalize-space(.)">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$note"/> (<xsl:value-of select="@type"/>)</td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:if>
    </xsl:template>

    <xsl:template match="mods:originInfo">
        <!-- MAM addition for discrete dates with NO @point attribute -->
        <xsl:for-each select="mods:dateCreated[not(@*)]">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$dateCreated"/></td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:for-each>
        <xsl:for-each select="mods:dateIssued[not(@*)]">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$dateIssued"/></td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:for-each>
        <xsl:for-each select="mods:dateCaptured[not(@*)]">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$dateCaptured"/></td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:for-each>
        <xsl:for-each select="mods:dateOther[not(@*)]">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$dateOther"/></td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:for-each>
        <!-- End of MAM addition -->

        <xsl:apply-templates select="*[@point='start']"/>

        <xsl:for-each select="mods:dateIssued[@point!='start' and @point!='end']">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$dateIssued"/></td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:for-each>

        <xsl:for-each select="mods:dateCreated[@point!='start' and @point!='end']">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$dateCreated"/></td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:for-each>

        <xsl:for-each select="mods:dateCaptured[@point!='start' and @point!='end']">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$dateCaptured"/></td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:for-each>

        <xsl:for-each select="mods:dateOther[@point!='start' and @point!='end']">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$dateOther"/></td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:for-each>

        <!-- MAM adding edition output -->

        <xsl:for-each select="mods:edition">
                <tr><td class="mods-metadata-label">Edition</td><td>
                    <xsl:value-of select="."/>
                </td></tr>
        </xsl:for-each>

        <xsl:for-each select="mods:publisher">
            <xsl:if test="normalize-space(mods:publisher)">
                <tr><td class="mods-metadata-label"><xsl:value-of select="$publisher"/></td><td>
                    <xsl:value-of select="."/>
                </td></tr>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="mods:genre">
        <xsl:if test="normalize-space()">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$genre"/></td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:if>
    </xsl:template>

    <xsl:template match="mods:typeOfResource">
        <tr><td class="mods-metadata-label"><xsl:value-of select="$typeOfResource"/></td><td>
            <xsl:value-of select="."/>
        </td></tr>
    </xsl:template>

    <xsl:template match="mods:physicalDescription[ mods:extent | mods:form | mods:internetMediaType ]">

        <xsl:if test="mods:extent">
          <tr><td class="mods-metadata-label">Extent (Dimensions, etc.)</td><td>
          <xsl:for-each select="mods:extent">
              <xsl:value-of select="."/>
              <xsl:if test="position()!=last()"> -- </xsl:if>
          </xsl:for-each>
          </td></tr>
        </xsl:if>

        <!-- MAM changing "Form" label to "Medium (Form)" -->

        <xsl:if test="mods:form">
          <tr><td class="mods-metadata-label">Mediums (Forms)</td><td>
          <xsl:for-each select="mods:form">
            <xsl:value-of select="."/>
            <xsl:if test="position()!=last()"> -- </xsl:if>
          </xsl:for-each>
          </td></tr>
        </xsl:if>


        <xsl:if test="mods:internetMediaType">
            <xsl:if test="normalize-space(mods:internetMediaType)">
                <tr><td class="mods-metadata-label"><xsl:value-of select="$mediaType"/></td><td>
                    <xsl:value-of select="mods:internetMediaType"/>
                </td></tr>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="mods:mimeType">
        <xsl:if test="normalize-space(.)">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$mimeType"/></td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:if>
    </xsl:template>

    <!-- MAM bringing the identifier[@type] forward and changing label to "Reference" -->

    <xsl:template match="mods:identifier">
        <xsl:if test="normalize-space(.)">
            <tr><td class="mods-metadata-label">Reference/ID (<xsl:value-of select="@type"/>)</td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:if>
    </xsl:template>

    <xsl:template match="mods:location">
        <xsl:if test="normalize-space(mods:physicalLocation)">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$physicalLocation"/></td><td>
                <xsl:for-each select="mods:physicalLocation">
                    <xsl:value-of select="."/>
                    <xsl:if test="position()!=last()">--</xsl:if>
                </xsl:for-each>
            </td></tr>
        </xsl:if>
        <xsl:if test="normalize-space(mods:shelfLocation)">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$shelfLocation"/></td><td>
                <xsl:for-each select="mods:shelfLocation">
                    <xsl:value-of select="."/>
                    <xsl:if test="position()!=last()">--</xsl:if>
                </xsl:for-each>
            </td></tr>
        </xsl:if>
        <xsl:if test="normalize-space(mods:url)">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$url"/></td><td>
                <xsl:for-each select="mods:url">
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </td></tr>
        </xsl:if>
        <xsl:if test="normalize-space(mods:holdingSimple/mods:copyInformation/mods:sublocation)">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$holdingSubLocation"/></td><td>
                <xsl:for-each select="mods:holdingSimple/mods:copyInformation/mods:sublocation">
                    <xsl:value-of select="."/>
                    <xsl:if test="position()!=last()">--</xsl:if>
                </xsl:for-each>
            </td></tr>
        </xsl:if>
        <xsl:if test="normalize-space(mods:holdingSimple/mods:copyInformation/mods:shelfLocation)">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$holdingShelfLocator"/></td><td>
                <xsl:for-each select="mods:holdingSimple/mods:copyInformation/mods:shelfLocator">
                    <xsl:value-of select="."/>
                    <xsl:if test="position()!=last()">--</xsl:if>
                </xsl:for-each>
            </td></tr>
        </xsl:if>
        <xsl:if test="normalize-space(mods:holdingSimple/mods:copyInformation/mods:electronicLocator)">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$electronicLocator"/></td><td>
                <xsl:for-each select="mods:holdingSimple/mods:copyInformation/mods:electronicLocator">
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </td></tr>
        </xsl:if>
    </xsl:template>

    <xsl:template match="mods:language">
        <xsl:if test="mods:language =''">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$language"/></td><td>
                <xsl:value-of select="normalize-space(.)"/>
            </td></tr>
        </xsl:if>
    </xsl:template>

    <!-- MAM suppress display of relatedItem[@displayLabel]
    <xsl:template match="mods:relatedItem[mods:titleInfo | mods:identifier | mods:location | mods:note]"> -->

    <xsl:template match="mods:relatedItem[not(@displayLabel)][mods:titleInfo | mods:identifier | mods:location | mods:note]">
        <xsl:choose>
            <xsl:when test="@type='original'">
                <tr><td class="mods-metadata-label"><xsl:value-of select="$relatedItem"/></td><td>
                    <xsl:for-each
                            select="mods:titleInfo/mods:title | mods:identifier | mods:location/mods:url">
                        <xsl:if test="normalize-space(.)!= ''">
                            <xsl:value-of select="."/>
                            <xsl:if test="position()!=last()">--</xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </td></tr>
            </xsl:when>
            <xsl:when test="@type='series'"/>
            <xsl:when test="@type='admin'"/>   <!-- MM Added to inhibit display of 'admin' (private) notes. 24-Feb-2015 -->
            <xsl:otherwise>
                <tr><td class="mods-metadata-label"><xsl:value-of select="$relatedItem"/></td><td>
                    <xsl:for-each
                            select="mods:titleInfo/mods:title | mods:identifier | mods:location/mods:url | mods:note">
                        <xsl:if test="normalize-space(.)!= ''">
                            <xsl:value-of select="."/>
                            <xsl:if test="position()!=last()">--</xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </td></tr>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- MAM...Don't display accessCondition for a compound parent object.

    <xsl:template match="mods:accessCondition">
        <xsl:if test="normalize-space(.)">
            <tr><td class="mods-metadata-label"><xsl:value-of select="$accessCondition"/></td><td>
                <xsl:value-of select="."/>
            </td></tr>
        </xsl:if>
    </xsl:template> -->

    <!-- MAM...trying to improve our names output -->

    <xsl:template match="mods:name[@type][mods:role/mods:roleTerm]">
        <tr><td class="mods-metadata-label">Name (<xsl:value-of select="mods:role/mods:roleTerm"/>)</td><td>
            <xsl:value-of select="mods:namePart[not(@type)]"/>
        </td></tr>
    </xsl:template>

    <!-- Original construct for creator/contributor names

    <xsl:template match="mods:name">
        <tr><td><xsl:value-of select="$name"/></td><td>
            <xsl:value-of select="mods:namePart[not(@type)]"/>
        </td></tr>
    </xsl:template> -->

    <!-- suppress all else:-->
    <xsl:template match="*"/>

</xsl:stylesheet>
