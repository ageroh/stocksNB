<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>

  <xsl:template match="/">
    <xsl:text disable-output-escaping="yes">&lt;?xml version="1.0" encoding="UTF-8" standalone="yes"?&gt;
</xsl:text>
    <xsl:copy-of select="*"/>
  </xsl:template>
</xsl:stylesheet>