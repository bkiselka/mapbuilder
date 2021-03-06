<?xml version="1.0" encoding="ISO-8859-1"?>

<!--
Description: parses an OGC context document to generate a GetFeatureInfo url
Author:      Nedjo
Licence:     LGPL as specified in http://www.gnu.org/copyleft/lesser.html .

$Id$
$Name$
-->
<xsl:stylesheet version="1.0" xmlns:wmc="http://www.opengis.net/context" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ows="http://www.opengis.net/ows">
  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:strip-space elements="*"/>

  <!-- parameters to be passed into the XSL -->
  <!-- The name of the WMS GetFeatureInfo layer -->
  <xsl:param name="queryLayer">route</xsl:param>
  <xsl:param name="layer">route</xsl:param>
  <xsl:param name="xCoord">1</xsl:param>
  <xsl:param name="yCoord">1</xsl:param>
  <xsl:param name="infoFormat">text/html</xsl:param>
  <xsl:param name="featureCount">1</xsl:param>

  <!-- Global variables -->
  <xsl:variable name="bbox">
    <xsl:choose>
      <xsl:when test="/wmc:ViewContext">
        <xsl:value-of select="/wmc:ViewContext/wmc:General/wmc:BoundingBox/@minx"/>,<xsl:value-of select="/wmc:ViewContext/wmc:General/wmc:BoundingBox/@miny"/>,<xsl:value-of select="/wmc:ViewContext/wmc:General/wmc:BoundingBox/@maxx"/>,<xsl:value-of select="/wmc:ViewContext/wmc:General/wmc:BoundingBox/@maxy"/>
      </xsl:when>
      <xsl:otherwise>
    <xsl:value-of select="translate(/wmc:OWSContext/wmc:General/ows:BoundingBox/ows:LowerCorner, ' ', ',')"/>,<xsl:value-of select="translate(/wmc:OWSContext/wmc:General/ows:BoundingBox/ows:UpperCorner, ' ', ',')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="width">
    <xsl:value-of select="/*/wmc:General/wmc:Window/@width"/>
  </xsl:variable>
  <xsl:variable name="height">
    <xsl:value-of select="/*/wmc:General/wmc:Window/@height"/>
  </xsl:variable>
  <xsl:variable name="srs" select="/wmc:ViewContext/wmc:General/wmc:BoundingBox/@SRS|/wmc:OWSContext/wmc:General/ows:BoundingBox/@crs"/>

  <!-- Root template -->
  <xsl:template match="/">
    <url>
      <xsl:apply-templates select="wmc:ViewContext/wmc:LayerList"/>
      <xsl:apply-templates select="wmc:OWSContext/wmc:ResourceList"/>
      <error>URL not calculated for layer=<xsl:value-of select="$queryLayer"/></error>
    </url>
  </xsl:template>

  <!-- Layer template -->
  <xsl:template match="wmc:Layer">
    <xsl:if test="wmc:Name=$queryLayer">
      <!-- Layer variables -->
      <xsl:variable name="version">
        <xsl:value-of select="wmc:Server/@version"/>    
      </xsl:variable>
      <xsl:variable name="baseUrl">
        <xsl:value-of select="wmc:Server/wmc:OnlineResource/@xlink:href"/>    
      </xsl:variable>
      <xsl:variable name="firstJoin">
        <xsl:choose>
          <xsl:when test="substring($baseUrl,string-length($baseUrl))='?'"></xsl:when>
          <xsl:when test="contains($baseUrl, '?')">&amp;</xsl:when> 
          <xsl:otherwise>?</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Print the URL -->
      <xsl:value-of select="$baseUrl"/><xsl:value-of select="$firstJoin"/>VERSION=<xsl:value-of select="$version"/>&amp;REQUEST=GetFeatureInfo&amp;LAYERS=<xsl:value-of select="$layer"/>&amp;SRS=<xsl:value-of select="$srs"/>&amp;BBOX=<xsl:value-of select="$bbox"/>&amp;WIDTH=<xsl:value-of select="$width"/>&amp;HEIGHT=<xsl:value-of select="$height"/>&amp;INFO_FORMAT=<xsl:value-of select="$infoFormat"/>&amp;FEATURE_COUNT=<xsl:value-of select="$featureCount"/>&amp;QUERY_LAYERS=<xsl:value-of select="$queryLayer"/>&amp;X=<xsl:value-of select="$xCoord"/>&amp;Y=<xsl:value-of select="$yCoord"/>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
