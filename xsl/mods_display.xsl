<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:mods="http://www.loc.gov/mods/v3" exclude-result-prefixes="mods xsi"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!--
    This stylesheet modified by M. McFate, Grinnell College, from 24-Feb-2015 to ?????????? for use
    in https://digital.grinnell.edu.  Original forked from git://github.com/jyobb/islandora_mods_display.git
    file mods_display.xsl on 24-Feb-2015.

    Most changes marked with a comment of the form "MM Added|Changed|Deleted <Date>" in the XSLT.

    Sweeping change made on 16-Nov-2015 when all normailize-space( ) was removed from all test=normalize-space(...) clauses,
     and normalize-space( ) was applied to the subsequent select elements instead.  This change corrected countless warnings
     since normalize-space( ) returns a string and not a boolean.

    Adding @displayLabel logic like the following on 24-Nov-2015...
    
    <tr>
      <td class="mods-metadata-label">
        <xsl:choose>
          <xsl:when test="*[@displayLabel]">
            <xsl:value-of select="@displayLabel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$altTitle"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:value-of select="normalize-space(mods:title)"/>
      </td>
    </tr>

    Because MODS is more granular than DC, transforming a given MODS element or subelement to a DC element frequently results in less precise tagging,
    and local customizations of the stylesheet may be necessary to achieve desired results.

    This stylesheet makes the following decisions in its interpretation of the MODS to simple DC mapping:

    When the roleTerm value associated with a name is creator, then name maps to dc:creator
    When there is no roleTerm value associated with name, or the roleTerm value associated with name is a value other than creator, then name maps to dc:contributor
    Start and end dates are presented as span dates in dc:date and in dc:coverage
    When the first subelement in a subject wrapper is topic, subject subelements are strung together in dc:subject with hyphens separating them
    Some subject subelements, i.e., geographic, temporal, hierarchicalGeographic, and cartographics, are also parsed into dc:coverage
    The subject subelement geographicCode is dropped in the transform

    -->

  <xsl:output method="xml" indent="yes"/>
  <xsl:strip-space elements="*"/>

  <xsl:variable name="title">Title</xsl:variable>
  <xsl:variable name="altTitle">Alternative Title</xsl:variable>
  <xsl:variable name="name">Name</xsl:variable>
  <xsl:variable name="classification">Classification</xsl:variable>
  <xsl:variable name="subjectTopic">Topic</xsl:variable>
  <xsl:variable name="subjectOccupation">Occupation</xsl:variable>
  <xsl:variable name="subjectName">Subject Name</xsl:variable>
  <xsl:variable name="subjectGeographic">Geographic</xsl:variable>
  <xsl:variable name="subjectHierGeographic">HierGeographic</xsl:variable>
  <xsl:variable name="subjectCartographic">Cartographic</xsl:variable>
  <xsl:variable name="subjectTemporal">Temporal</xsl:variable>
  <xsl:variable name="subjectLocalname">LocalName</xsl:variable>
  <xsl:variable name="abstract">Description</xsl:variable>
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
  <xsl:variable name="internetMediaType">Media Type</xsl:variable>
  <xsl:variable name="mimeType">MIME Type</xsl:variable>
  <xsl:variable name="provenance">Provenance</xsl:variable>
  <xsl:variable name="identifier">Identifier</xsl:variable>
  <xsl:variable name="physicalLocation">Physical Location</xsl:variable>
  <xsl:variable name="shelfLocator">Shelf Locator</xsl:variable>
  <xsl:variable name="url">URL</xsl:variable>
  <xsl:variable name="holdingSubLocation">Holding Sublocation</xsl:variable>
  <xsl:variable name="holdingShelfLocator">Holding Shelf Locator</xsl:variable>
  <xsl:variable name="electronicLocator">Electronic Locator</xsl:variable>
  <xsl:variable name="language">Language</xsl:variable>
  <xsl:variable name="relatedItem">Related Item</xsl:variable>
  <xsl:variable name="accessCondition">Access Condition</xsl:variable>
  <xsl:variable name="edition">Edition</xsl:variable>
  <xsl:variable name="form">Medium</xsl:variable>
  <xsl:variable name="digitalOrigin">Digital Origin</xsl:variable>

  <!-- MAM...Fetch the CModel from the MODS record. -->
  <xsl:variable name="hasCModel">
    <xsl:value-of select="/mods:mods/mods:extension/mods:CModel"/>
  </xsl:variable>

  <!-- **************** The BIG loop over all elements of the record **************** -->
  <xsl:template match="/">
    <xsl:for-each select="mods:mods">
      <table>
        <xsl:if test="$hasCModel='islandora:compoundCModel'">
          <tr>
            <th colspan="2">
              <span class="islandora-parent-object-heading">Group Record</span>
            </th>
          </tr>
        </xsl:if>
        <xsl:apply-templates/>
      </table>
    </xsl:for-each>
  </xsl:template>

  <!-- Now for all the detail templates -->
  <!-- MM Changed 05-Nov-2015... Adding class='mods-metadata-label' to all labels. -->

  <!-- Name with or without attribute -->
  <xsl:template match="mods:name">
    <xsl:for-each select="self::node()/mods:namePart">
      <tr class="do-not-hide">
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="../mods:role/mods:roleTerm[@displayLabel]">
              <xsl:value-of select="../mods:role/mods:roleTerm[@displayLabel]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="../mods:role/mods:roleTerm"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <!-- Name with NO @type attribute
  <xsl:template match="mods:name[not(@type)]">
    <xsl:for-each select="self::node()/mods:namePart">
      <tr class="do-not-hide">
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="../mods:role/mods:roleTerm[@displayLabel]">
              <xsl:value-of select="../mods:role/mods:roleTerm[@displayLabel]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="../mods:role/mods:roleTerm"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template> -->

  <!-- Original construct for creator/contributor names
    <xsl:template match="mods:name">
        <tr><td><xsl:value-of select="$name"/></td><td>
            <xsl:value-of select="mods:namePart[not(@type)]"/>
        </td></tr>
    </xsl:template> -->

  <!-- Title -->
  <xsl:template match="mods:titleInfo[not(@type)]">
    <tr class="do-not-hide">
      <td style="width:16em;" class="mods-metadata-label">
        <xsl:choose>
          <xsl:when test="*[@displayLabel]">
            <xsl:value-of select="@displayLabel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$title"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
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
      </td>
    </tr>
  </xsl:template>

  <!-- MAM addition for Alternative Title -->
  <xsl:template match="mods:titleInfo[@type='alternative']">
    <xsl:for-each select="mods:title">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$altTitle"/>
            </xsl:otherwise>
          </xsl:choose>
          <td>
            <xsl:value-of select="normalize-space(.)"/>
          </td>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <!-- Classification -->
  <xsl:template match="mods:classification">
    <tr>
      <td class="mods-metadata-label">
        <xsl:choose>
          <xsl:when test="*[@displayLabel]">
            <xsl:value-of select="@displayLabel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$classification"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:value-of select="normalize-space(.)"/>
      </td>
    </tr>
  </xsl:template>

  <!-- MAM modified if test= clauses below to distinguish subject[not(@*)] from subject[@authority] -->

  <!-- Subjects with NO @authority attribute and with a specific child -->
  <xsl:template
      match="mods:subject[mods:topic|mods:occupation|mods:geographic|mods:hierarchicalGeographic|mods:cartographics|mods:temporal] ">

    <!-- MAM...show displayLabel attribute as the label but only if it exists! -->
    <xsl:if test="mods:topic[@displayLabel]">
      <xsl:for-each select="mods:topic">
        <tr>
          <td class="mods-metadata-label">
            <xsl:value-of select="@displayLabel"/>
          </td>
          <td>
            <xsl:value-of select="normalize-space(.)"/>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>

    <xsl:if test="mods:topic[not(@displayLabel)]">
      <xsl:for-each select="mods:topic">
        <tr>
          <td class="mods-metadata-label">
            <xsl:text>Keyword</xsl:text>
          </td>
          <td>
            <xsl:value-of select="normalize-space(.)"/>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>

    <xsl:if test="mods:occupation">
      <xsl:for-each select="mods:occupation">
        <tr>
          <td class="mods-metadata-label">
            <xsl:choose>
              <xsl:when test="*[@displayLabel]">
                <xsl:value-of select="@displayLabel"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$subjectOccupation"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <xsl:value-of select="normalize-space(.)"/>
          </td>
        </tr>
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

    <xsl:if test="mods:geographic">
      <xsl:for-each select="mods:geographic">
        <tr>
          <td class="mods-metadata-label">
            <xsl:choose>
              <xsl:when test="*[@displayLabel]">
                <xsl:value-of select="@displayLabel"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$subjectGeographic"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <xsl:value-of select="normalize-space(.)"/>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>

    <xsl:if test="mods:hierarchicalGeographic">
      <xsl:for-each select="mods:hierarchicalGeographic">
        <tr>
          <td class="mods-metadata-label">
            <xsl:choose>
              <xsl:when test="*[@displayLabel]">
                <xsl:value-of select="@displayLabel"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$subjectHierGeographic"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <xsl:for-each
                select="mods:continent|mods:country|mods:province|mods:region|mods:state|mods:territory|mods:county|mods:city|mods:island|mods:area">
              <xsl:value-of select="normalize-space(.)"/>
              <!-- <xsl:if test="position()!=last()">-</xsl:if> -->
            </xsl:for-each>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>

    <xsl:if test="mods:cartographics">
      <xsl:for-each select="mods:cartographics/*">
        <tr>
          <td class="mods-metadata-label">
            <xsl:choose>
              <xsl:when test="*[@displayLabel]">
                <xsl:value-of select="@displayLabel"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$subjectCartographic"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <xsl:value-of select="normalize-space(.)"/>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>

    <xsl:if test="mods:temporal">
      <xsl:if test="mods:temporal">
        <tr>
          <td class="mods-metadata-label">
            <xsl:choose>
              <xsl:when test="*[@displayLabel]">
                <xsl:value-of select="@displayLabel"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$subjectTemporal"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <xsl:for-each select="mods:temporal">
              <xsl:value-of select="normalize-space(.)"/>
              <xsl:if test="position()!=last()">-</xsl:if>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
    </xsl:if>

    <xsl:if test="*[1][local-name()='topic'] and *[local-name()!='topic']">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$subjectLocalname"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:for-each
              select="*[local-name()!='cartographics' and local-name()!='geographicCode' and local-name()!='hierarchicalGeographic'] ">
            <xsl:value-of select="."/>
            <!-- MAM removed 06-July-2016
            <xsl:if test="position()!=last()">-</xsl:if>  -->
          </xsl:for-each>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>


  <!-- Subjects WITH @authority attribute and with a specific child -->
  <xsl:template
      match="mods:subject[@authority='lcsh'][mods:topic | mods:occupation | mods:geographic | mods:hierarchicalGeographic | mods:cartographics | mods:temporal] ">

    <xsl:if test="mods:topic">
      <xsl:for-each select="mods:topic">
        <tr>
          <td class="mods-metadata-label">
            <xsl:choose>
              <xsl:when test="*[@displayLabel]">
                <xsl:value-of select="@displayLabel"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$subjectTopic"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <xsl:value-of select="normalize-space(.)"/>
            <!--  <xsl:if test="position()!=last()">-</xsl:if> -->
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>

    <xsl:if test="mods:occupation">
      <xsl:for-each select="mods:occupation">
        <tr>
          <td class="mods-metadata-label">
            <xsl:choose>
              <xsl:when test="*[@displayLabel]">
                <xsl:value-of select="@displayLabel"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$subjectOccupation"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <xsl:value-of select="normalize-space(.)"/>
            <!-- <xsl:if test="position()!=last()">-</xsl:if> -->
          </td>
        </tr>
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

    <xsl:if test="mods:geographic">
      <xsl:for-each select="mods:geographic">
        <tr>
          <td class="mods-metadata-label">
            <xsl:choose>
              <xsl:when test="*[@displayLabel]">
                <xsl:value-of select="@displayLabel"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$subjectGeographic"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <xsl:value-of select="normalize-space(.)"/>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>

    <xsl:if test="mods:hierarchicalGeographic">
      <xsl:for-each select="mods:hierarchicalGeographic">
        <tr>
          <td class="mods-metadata-label">
            <xsl:choose>
              <xsl:when test="*[@displayLabel]">
                <xsl:value-of select="@displayLabel"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$subjectHierGeographic"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <xsl:for-each
                select="mods:continent|mods:country|mods:province|mods:region|mods:state|mods:territory|mods:county|mods:city|mods:island|mods:area">
              <xsl:value-of select="normalize-space(.)"/>
              <!-- <xsl:if test="position()!=last()">-</xsl:if> -->
            </xsl:for-each>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>

    <xsl:if test="mods:cartographics">
      <xsl:for-each select="mods:cartographics/*">
        <tr>
          <td class="mods-metadata-label">
            <xsl:choose>
              <xsl:when test="*[@displayLabel]">
                <xsl:value-of select="@displayLabel"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$subjectCartographic"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <xsl:value-of select="normalize-space(.)"/>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>

    <xsl:if test="mods:temporal">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$subjectTemporal"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:for-each select="mods:temporal">
            <xsl:value-of select="normalize-space(.)"/>
            <!-- <xsl:if test="position()!=last()">-</xsl:if> -->
          </xsl:for-each>
        </td>
      </tr>
    </xsl:if>

    <xsl:if test="*[1][local-name()='topic'] and *[local-name()!='topic']">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$subjectLocalname"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:for-each
              select="*[local-name()!='cartographics' and local-name()!='geographicCode' and local-name()!='hierarchicalGeographic'] ">
            <xsl:value-of select="normalize-space(.)"/>
            <!-- <xsl:if test="position()!=last()">-</xsl:if> -->
          </xsl:for-each>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>

  <!-- Abstract -->
  <xsl:template match="mods:abstract"/>
  <!-- MAM changed this on 16-Nov-2015 so that mods:abstract is NEVER printed as part of the MODS display
    <tr>
      <td class="mods-metadata-label">
        <xsl:value-of select="$abstract"/>
      </td>
      <td>
        <xsl:value-of select="normalize-space(.)"/>
      </td>
    </tr>
  </xsl:template>  -->

  <!-- Table of Contents -->
  <xsl:template match="mods:tableOfContents">
    <tr>
      <td class="mods-metadata-label">
        <xsl:choose>
          <xsl:when test="*[@displayLabel]">
            <xsl:value-of select="@displayLabel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$toc"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:value-of select="normalize-space(.)"/>
      </td>
    </tr>
  </xsl:template>

  <!-- Note with NO @type attribute -->
  <xsl:template match="mods:note[not(@type)]">
    <tr>
      <td class="mods-metadata-label">
        <xsl:choose>
          <xsl:when test="@displayLabel">
            <xsl:value-of select="@displayLabel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$note"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:value-of select="normalize-space(.)"/>
      </td>
    </tr>
  </xsl:template>

  <!-- Provenance or Acquisition or Provenance History -->
  <xsl:template
      match="mods:note[@type='provenance' or @type='acquisition' or @type='provenance history']">
    <tr>
      <td class="mods-metadata-label">
        <xsl:choose>
          <xsl:when test="@displayLabel">
            <xsl:value-of select="@displayLabel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$provenance"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:value-of select="normalize-space(.)"/>
      </td>
    </tr>
  </xsl:template>

  <!-- NOT Provenance nor Acquisition nor Provenance History -->
  <xsl:template
      match="mods:note[@type!='provenance' and @type!='acquisition' and @type!='provenance history']">
    <tr>
      <td class="mods-metadata-label">
        <xsl:choose>
          <xsl:when test="@displayLabel">
            <xsl:value-of select="@displayLabel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@type"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:value-of select="normalize-space(.)"/>
      </td>
    </tr>
  </xsl:template>

  <!-- Origin Info -->
  <xsl:template match="mods:originInfo">

    <!-- MAM addition for discrete dates with NO @point attribute -->
    <xsl:for-each select="mods:dateCreated[not(@*)]">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$dateCreated"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="mods:dateIssued[not(@*)]">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$dateIssued"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="mods:dateCaptured[not(@*)]">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$dateCaptured"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <xsl:for-each select="mods:dateOther[not(@*)]">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$dateOther"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>
    <!-- End of MAM addition -->

    <xsl:apply-templates select="*[@point='start']"/>

    <xsl:for-each select="mods:dateIssued[@point!='start' and @point!='end']">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$dateIssued"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>

    <xsl:for-each select="mods:dateCreated[@point!='start' and @point!='end']">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$dateCreated"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>

    <xsl:for-each select="mods:dateCaptured[@point!='start' and @point!='end']">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$dateCaptured"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>

    <xsl:for-each select="mods:dateOther[@point!='start' and @point!='end']">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$dateOther"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>

    <!-- Edition -->
    <xsl:for-each select="mods:edition">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$edition"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="."/>
        </td>
      </tr>
    </xsl:for-each>

    <!-- Publisher -->
    <xsl:for-each select="mods:publisher">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$publisher"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="normalize-space(.)"/>
        </td>
      </tr>
    </xsl:for-each>

  </xsl:template>    <!-- End of originInfo template -->

  <!-- Genre -->
  <xsl:template match="mods:genre">
    <tr>
      <td class="mods-metadata-label">
        <xsl:choose>
          <xsl:when test="*[@displayLabel]">
            <xsl:value-of select="@displayLabel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$genre"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:value-of select="normalize-space(.)"/>
      </td>
    </tr>
  </xsl:template>

  <!-- Type of Resource -->
  <xsl:template match="mods:typeOfResource">
    <tr>
      <td class="mods-metadata-label">
        <xsl:choose>
          <xsl:when test="*[@displayLabel]">
            <xsl:value-of select="@displayLabel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$typeOfResource"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:value-of select="normalize-space(.)"/>
      </td>
    </tr>
  </xsl:template>

  <!-- Physical description... extent, form, internetMediaType, digitalOrigin or note -->
  <xsl:template
      match="mods:physicalDescription[mods:extent|mods:form|mods:internetMediaType|mods:digitalOrigin|mods:note]">
    <xsl:for-each select="./*">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="@displayLabel">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:if test="name(.)='note'"><xsl:value-of select="$note"/></xsl:if>
              <xsl:if test="name(.)='extent'"><xsl:value-of select="$extent"/></xsl:if>
              <xsl:if test="name(.)='internetMediaType'"><xsl:value-of select="$internetMediaType"/></xsl:if>
              <xsl:if test="name(.)='digitalOrigin'"><xsl:value-of select="$digitalOrigin"/></xsl:if>
              <xsl:if test="name(.)='form'"><xsl:value-of select="$form"/></xsl:if>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="normalize-space(.)"/>
        </td>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <!-- Identifier -->
  <!-- MAM bringing the identifier[@type] forward -->
  <xsl:template match="mods:identifier">
    <tr>
      <td class="mods-metadata-label">
        <xsl:choose>
          <xsl:when test="*[@displayLabel]">
            <xsl:value-of select="@displayLabel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$identifier"/> (<xsl:value-of select="@type"/>) </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:value-of select="normalize-space(.)"/>
      </td>
    </tr>
  </xsl:template>

  <!-- Location -->
  <xsl:template match="mods:location">
    <xsl:for-each select="mods:physicalLocation">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$physicalLocation"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="normalize-space(.)"/>
        </td>
      </tr>
    </xsl:for-each>

    <xsl:for-each select="mods:shelfLocator">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$shelfLocator"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="normalize-space(.)"/>
        </td>
      </tr>
    </xsl:for-each>

    <xsl:for-each select="mods:url">
      <tr>
        <td class="mods-metadata-label">
          <xsl:choose>
            <xsl:when test="*[@displayLabel]">
              <xsl:value-of select="@displayLabel"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$url"/>
            </xsl:otherwise>
          </xsl:choose>
        </td>
        <td>
          <xsl:value-of select="normalize-space(.)"/>
        </td>
      </tr>
    </xsl:for-each>

    <!-- MAM...holdingSimple appears to be a invalid element.
    <xsl:if test="mods:holdingSimple/mods:copyInformation/mods:sublocation">
      <tr>
        <td class="mods-metadata-label">
          <xsl:value-of select="$holdingSubLocation"/>
        </td>
        <td>
          <xsl:for-each select="mods:holdingSimple/mods:copyInformation/mods:sublocation">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position()!=last()">-</xsl:if>
          </xsl:for-each>
        </td>
      </tr>
    </xsl:if>

    <xsl:if test="mods:holdingSimple/mods:copyInformation/mods:shelfLocation">
      <tr>
        <td class="mods-metadata-label">
          <xsl:value-of select="$holdingShelfLocator"/>
        </td>
        <td>
          <xsl:for-each select="mods:holdingSimple/mods:copyInformation/mods:shelfLocator">
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:if test="position()!=last()">-</xsl:if>
          </xsl:for-each>
        </td>
      </tr>
    </xsl:if>

    <xsl:if test="mods:holdingSimple/mods:copyInformation/mods:electronicLocator">
      <tr>
        <td class="mods-metadata-label">
          <xsl:value-of select="$electronicLocator"/>
        </td>
        <td>
          <xsl:for-each select="mods:holdingSimple/mods:copyInformation/mods:electronicLocator">
            <xsl:value-of select="normalize-space(.)"/>
          </xsl:for-each>
        </td>
      </tr>
    </xsl:if> -->
  </xsl:template>

  <!-- Language -->
  <xsl:template match="mods:language">
    <tr>
      <td class="mods-metadata-label">
        <xsl:choose>
          <xsl:when test="*[@displayLabel]">
            <xsl:value-of select="@displayLabel"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$language"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td>
        <xsl:for-each select="mods:languageTerm">
          <xsl:choose>
            <xsl:when test="@type='text'">
              <xsl:value-of select="normalize-space(.)"/>
            </xsl:when>
            <xsl:when test="@type='code'"/>
            <!--   <xsl:text> [</xsl:text>                         MAM removed on 01-December-2015
                   <xsl:value-of select="normalize-space(.)"/>
                   <xsl:text>] </xsl:text>
                 </xsl:when> -->
          </xsl:choose>
        </xsl:for-each>

      </td>
    </tr>
  </xsl:template>

  <!-- Related Item ... suppress display of @type="constituent"! -->
  <xsl:template match="mods:relatedItem[not(@type='constituent')]">
    <xsl:choose>
      <!-- MM adding this to inhibit display of 'admin' (private) notes. 24-Feb-2015 -->
      <xsl:when test="@type='admin'"/>
      <xsl:otherwise>
        <tr>
          <td class="mods-metadata-label">
            <xsl:choose>
              <xsl:when test="*[@displayLabel]">
                <xsl:value-of select="@displayLabel"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$relatedItem"/>
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td>
            <xsl:for-each select="mods:titleInfo/mods:title|mods:identifier|mods:location|mods:note">
              <xsl:value-of select="."/>
              <xsl:if test="position()!=last()"> -- </xsl:if>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Access Condition -->
  <xsl:template match="mods:accessCondition">
    <tr>
      <td class="mods-metadata-label">
        <xsl:value-of select="$accessCondition"/>
      </td>
      <td>
        <xsl:value-of select="normalize-space(.)"/>
      </td>
    </tr>
  </xsl:template>

  <!-- Suppress all else:-->
  <xsl:template match="*"/>

</xsl:stylesheet>
