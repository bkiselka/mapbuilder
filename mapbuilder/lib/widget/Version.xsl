<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
Description: Displays the mapbuilder version.
             The $Version: $ tag is changed during the ant build process to
             the current version.
Author:      Cameron Shorter
Licence:     LGPL as per: http://www.gnu.org/copyleft/lesser.html

$Id$
$Name$
-->

  <xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes"/>
  <!-- Main html -->
  <xsl:template match="/">
    <div>
      <!-- Version tag will be inserted below by build.xml process -->
      <!--Version--><!--VersionEnd-->
    </div>
  </xsl:template>
  
  <xsl:template match="text()|@*"/>
</xsl:stylesheet>
