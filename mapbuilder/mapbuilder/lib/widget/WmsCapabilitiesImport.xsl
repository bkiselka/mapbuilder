<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
Description: Provides a form to enter a WMS GetCapabilities URL into.
Author:      Cameron Shorter cameron ATshorter.net
Licence:     GPL as per: http://www.gnu.org/copyleft/gpl.html

$Id$
$Name$
-->

  <xsl:output method="xml" encoding="utf-8"/>

  <xsl:param name="modelId"/>
  <xsl:param name="widgetId"/>

  <!-- Main html -->
  <xsl:template match="/">
    <form>
      <h3>Load WMS GetCapabilities:</h3>
      <textarea cols="40" rows="1" onkeypress="config.{$modelId}.{$widgetId}.onKeyPress(event)">http://localhost/mapbuilder/lib/widget/wms/GmapCapabilities.xml</textarea> 
    </form>
  </xsl:template>
  
  <xsl:template match="text()|@*"/>
</xsl:stylesheet>

