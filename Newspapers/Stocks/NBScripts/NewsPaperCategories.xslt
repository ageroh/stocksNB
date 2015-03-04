<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:Developer="urn:Developer"
                xmlns:atcom="http://atcom.gr/"
                xmlns:asp="asp.net"
                xmlns:res="urn:Resource"
                xmlns:ms="urn:schemas-microsoft-com:xslt"
                xmlns:NewsBeast="urn:NewsBeast"
                xmlns:Custom="urn:Custom"
                exclude-result-prefixes="NewsBeast xsl msxsl atcom asp res Custom">

  
  <!--All the possible query string-->
  <xsl:param name="pct"></xsl:param>
  <xsl:param name="tp"></xsl:param>
  <xsl:param name="dt"></xsl:param>
  <xsl:param name="pbid"></xsl:param>

  <xsl:param name="QueryStringMask" select="'tp&lt;int&gt;dt&lt;datetime&gt;pct&lt;int&gt;'"/>

  <xsl:template match="/">
    <div class="paper-kind-titles">
      <ul>
        <li>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="$pct = 0 or $pct = ''">active</xsl:when>
            </xsl:choose>
          </xsl:attribute>
          <a href="NewsPapersMain.aspx?pct={$pct}&amp;tp={$tp}&amp;dt={$dt}&amp;pbid={$pbid}">
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
          <xsl:when test="$pct = catID">active</xsl:when>
        </xsl:choose>
      </xsl:attribute>
      <a href="NewsPapersMain.aspx?pct={catID}&amp;tp={$tp}&amp;dt={$dt}&amp;pbid={$pbid}">
        <span>
          <xsl:value-of disable-output-escaping="yes" select="Catname"/>
        </span>
        <em class="ic">&#160;</em>
      </a>
    </li>
  </xsl:template>
</xsl:stylesheet>