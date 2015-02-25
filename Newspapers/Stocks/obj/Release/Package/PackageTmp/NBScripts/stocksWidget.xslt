<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:currency="urn:currency"
                xmlns:percent="urn:percent"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:Image="urn:Image"
                xmlns:res="urn:Resource"
                xmlns:Resources="urn:ResourceManager"
                xmlns:Developer="urn:Developer"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:atcom="http://atcom.gr/"
                xmlns:asp="remove"
                xmlns:Strings="urn:Strings"
                xmlns:QueryString="urn:QueryString"
                xmlns:dt="urn:schemas-microsoft-com:datatypes"
                xmlns:ms="urn:schemas-microsoft-com:xslt"
                exclude-result-prefixes="xsl Image res msxsl atcom asp dt ms Strings Developer Resources QueryString percent currency">
  <xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>

  <xsl:param name="PageID"/>
  <xsl:param name="LanguageID"/>
  <xsl:param name="StocksIndexPageID" select="151" />
  <xsl:param name="WidgetPageID" select="152" />
  
  <xsl:template match="/">
    <!-- ARG :  <xsl:value-of select="Page:SetContentType('application/json')"/> -->
    <xsl:text>{"s":{</xsl:text>
    <xsl:apply-templates select="/Stocks/Stock" mode="JSON" />
    <xsl:text>},"u":"</xsl:text>
    <xsl:value-of select="concat('?pid=',$StocksIndexPageID,'&amp;la=1')"/>
    <xsl:text>","w":"</xsl:text>
    <xsl:value-of select="concat('?pid=',$WidgetPageID,'&amp;la=1')"/>
    <xsl:text>","d":"</xsl:text>
    <xsl:value-of select="concat(ms:format-date(Stocks/LastUpdate,'dd/MM/yyyy'),' ',ms:format-time(Stocks/LastUpdate,'HH:mm'))"/>
    <xsl:text>",</xsl:text>
    <xsl:apply-templates select="/Stocks/MainIndex" mode="JSON" />
    <xsl:text>}</xsl:text>
  </xsl:template>

  <xsl:template match="MainIndex" mode="JSON">
    <xsl:for-each select="*">
      <xsl:text>"</xsl:text>

      <xsl:value-of select="local-name()"/>
      <xsl:text>"</xsl:text>

      <xsl:text>:</xsl:text>
      <xsl:apply-templates select="." mode="value" />
      <xsl:if test="position() != last()">
        <xsl:text>,</xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="Stock" mode="JSON">
    <xsl:text>"</xsl:text>

    <xsl:value-of select="@Key"/>
    <xsl:text>":{</xsl:text>
    <xsl:for-each select="*">

      <xsl:text>"</xsl:text>

      <xsl:value-of select="local-name()"/>

      <xsl:text>"</xsl:text>

      <xsl:text>:</xsl:text>
      <xsl:apply-templates select="." mode="value" />
      <xsl:if test="position() != last()">
        <xsl:text>,</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:text>}</xsl:text>
    <xsl:if test="position() != last()">
      <xsl:text>,</xsl:text>
    </xsl:if>
  </xsl:template>
  <xsl:template match="*" mode="value">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"</xsl:text>
  </xsl:template>
</xsl:stylesheet>