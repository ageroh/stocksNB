<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ext="http://exslt.org/common"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:atcom="http://atcom.gr/"
                xmlns:asp="asp.net"
                xmlns:res="urn:Resource"
                xmlns:ms="urn:schemas-microsoft-com:xslt"
                xmlns:Urls="urn:Urls"
                xmlns:NewsBeast="urn:NewsBeast"
                xmlns:Image="urn:Image"
                exclude-result-prefixes="NewsBeast xsl msxsl atcom asp res Image Urls ">

  <xsl:param name="PageID"/>
  <xsl:param name="LanguageID"/>
  <xsl:param name="QueryStringMask" select="'tp&lt;int&gt;dt&lt;datetime&gt;pct&lt;int&gt;'"/>

  <xsl:param name="qs-pct" />
  <xsl:param name="qs-catID" />
  
  <xsl:template match="/">
    <div class="paper-kind-titles">
      <ul>
        <li>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="$qs-pct = 0 or $qs-pct = ''">active</xsl:when>
            </xsl:choose>
          </xsl:attribute>
          <a href="{$qs-pct}">
            <span>ΟΛΕΣ</span>
            <em class="ic">&#160;</em>
          </a>
        </li>
        <xsl:apply-templates select="/CatsResults/details"/>
      </ul>
    </div>
  </xsl:template>

  <xsl:template match="/CatsResults/details">
    <li>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="$qs-pct = catID">active</xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <a href="{$qs-catID}">
        <span>
          <xsl:value-of disable-output-escaping="yes" select="Catname"/>
        </span>
        <em class="ic">&#160;</em>


      </a>
    </li>
  </xsl:template>
</xsl:stylesheet>