<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
Description: parses an OGC context document to generate an array of DHTML layers.
Author:      adair
Licence:     GPL as specified in http://www.gnu.org/copyleft/gpl.html .

$Id$
$Name$
-->

<xsl:stylesheet version="1.0" xmlns:wmc="http://www.opengis.net/context" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:output method="xml"/>
  <xsl:strip-space elements="*"/>
  <!--
  <xsl:include href="ogcMapImgObjects.xsl" />
  -->

  <!-- The coordinates of the DHTML Layer on the HTML page -->
  <xsl:param name="modelId"/>
  <xsl:param name="widgetId"/>

  <xsl:param name="bbox"/>
  <xsl:param name="width"/>
  <xsl:param name="height"/>
  <xsl:param name="srs"/>
  
  <xsl:template match="wmc:Layer">
    <xsl:param name="version">
        <xsl:value-of select="wmc:Server/@version"/>    
    </xsl:param>
    <xsl:variable name="format">
      <xsl:choose>
        <xsl:when test="wmc:FormatList"><xsl:value-of select="wmc:FormatList/wmc:Format[@current='1']"/></xsl:when>
        <xsl:otherwise>image/gif</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="styleParam">
      <xsl:choose>
        <xsl:when test="wmc:StyleList/wmc:Style[@current='1']/wmc:SLD">
          SLD=<xsl:value-of select="wmc:StyleList/wmc:Style[@current='1']/wmc:SLD/wmc:OnlineResource/@xlink:href"/>
        </xsl:when>
        <xsl:when test="wmc:StyleList/wmc:Style[@current='1']/wmc:SLD/wmc:StyeLayerDescriptor">
          SLD=<xsl:value-of select="wmc:StyleList/wmc:Style[@current='1']/wmc:SLD/wmc:StyeLayerDescriptor"/>
        </xsl:when>
        <xsl:when test="wmc:StyleList/wmc:Style[@current='1']/wmc:SLD/wmc:FeatureTypeStyle">
          SLD=<xsl:value-of select="wmc:StyleList/wmc:Style[@current='1']/wmc:SLD/wmc:FeatureTypeStyle"/>
        </xsl:when>
        <xsl:otherwise>
          STYLES=<xsl:value-of select="wmc:StyleList/wmc:Style[@current='1']/wmc:Name"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="visibility">
      <xsl:choose>
        <xsl:when test="@hidden='1'">hidden</xsl:when>
        <xsl:otherwise>visible</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="mapRequest">
      <xsl:choose>
        <xsl:when test="starts-with($version, '1.0')">
            WMTVER=<xsl:value-of select="$version"/>&amp;REQUEST=map
        </xsl:when>            
        <xsl:otherwise>
            VERSION=<xsl:value-of select="$version"/>&amp;REQUEST=GetMap
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <GetMap>
      <QueryString>
        <xsl:variable name="src">    
            <xsl:value-of select="$mapRequest"/>
   &amp;SRS=<xsl:value-of select="$srs"/>
  &amp;BBOX=<xsl:value-of select="$bbox"/>
 &amp;WIDTH=<xsl:value-of select="$width"/>
&amp;HEIGHT=<xsl:value-of select="$height"/>
&amp;LAYERS=<xsl:value-of select="wmc:Name"/>
&amp;FORMAT=<xsl:value-of select="$format"/>
       &amp;<xsl:value-of select="$styleParam"/>
&amp;TRANSPARENT=true
<!--	
  //TBD: these still to be properly handled 
  //also sld support
  if (this.transparent) src += '&' + 'TRANSPARENT=' + this.transparent;
	if (this.bgcolor) src += '&' + 'BGCOLOR=' + this.bgcolor;
	//if (this.exceptions) src += '&' + 'EXCEPTIONS=' + this.exceptions;
	if (this.vendorstr) src += '&' + this.vendorstr;
  // -->
        </xsl:variable>
        <xsl:value-of select="translate(normalize-space($src),' ', '' )" disable-output-escaping="no"/>
      </QueryString>
    </GetMap>
  </xsl:template>

</xsl:stylesheet>