<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:Image="urn:Image"
                xmlns:res="urn:Resource" 
                xmlns:Developer="urn:Developer" 
                xmlns:Urls="urn:Urls"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:atcom="http://atcom.gr/" 
                xmlns:asp="remove" 
                xmlns:Strings="urn:Strings"
                xmlns:dt="urn:schemas-microsoft-com:datatypes" xmlns:ms="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="xsl Image res Urls msxsl atcom asp dt ms Strings Developer">
  <xsl:output method="html" indent="yes"/>
  <xsl:param name="PageID"/>
  <xsl:param name="LanguageID"/>

  <xsl:template match="/">

    <script>
      <![CDATA[var daysWithNoPublications =[]]>
      <xsl:for-each select="/Nopub/day">
        <![CDATA["]]><xsl:value-of select="msxsl:format-date(daysWithNoPublications,'yyyy-M-d')"/><![CDATA[",]]>
      </xsl:for-each>];
    </script>

  </xsl:template>
</xsl:stylesheet>