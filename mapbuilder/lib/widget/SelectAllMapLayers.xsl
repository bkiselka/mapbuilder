<?xml version="1.0" encoding="ISO-8859-1"?>

<!--
Description: link to load the WMS Capabilities doc as a context document.  
            This works with the Caps2Context tool which implements the listener
Author:      adair
Licence:     LGPL as specified in http://www.gnu.org/copyleft/lesser.html .

$Id$
$Name:  $
-->

<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:wms="http://www.opengis.net/wms"
		xmlns:ogc="http://www.opengis.net/ogc"
    xmlns:xlink="http://www.w3.org/1999/xlink">

  <xsl:output method="xml" omit-xml-declaration="yes" encoding="utf-8" indent="yes"/>

  <!-- The coordinates of the DHTML Layer on the HTML page -->
  <xsl:param name="modelId"/>
  <xsl:param name="widgetId"/>
  
  <!-- template rule matching source root element -->
  <xsl:template match="/WMT_MS_Capabilities | /wms:WMS_Capabilities">
    <p>
      <a href="javascript:config.objects.{$modelId}.setParam('mapAllLayers')">map all layers</a>
    </p>
  </xsl:template>

  <xsl:template match="text()|@*"/>

</xsl:stylesheet>
