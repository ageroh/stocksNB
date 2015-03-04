<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:asp="asp.net" 
                xmlns:res="urn:Resource"
                xmlns:ms="urn:schemas-microsoft-com:xslt" 
                xmlns:QueryString="urn:QueryString" 
                exclude-result-prefixes="xsl msxsl asp res QueryString">

  <xsl:output method="html" indent="yes"/>
  <xsl:variable name="SafeQueryString" select="'tp&lt;int&gt;dt&lt;datetime&gt;pct&lt;int&gt;'"/>
  <xsl:param name="QueryStringMask" select="'tp&lt;int&gt;pct&lt;int&gt;'"/>
  <xsl:param name="PublicationString"/>
  <xsl:param name="LanguageID"/>
  <xsl:param name="PapersCategory"/>

  <xsl:variable name="Papers">
    <details type="link"/>
    <xsl:copy-of select="/PaperesResults/details[position() &lt; 3]"/>
    <details type="ads"/>
    <xsl:copy-of select="/PaperesResults/details[position() &gt; 2]"/>
  </xsl:variable>

  <xsl:variable name="currDate">
    <xsl:value-of select="ms:format-date(/PaperesResults/details[position() = 1]/publ_date, 'MM/dd/yyyy','el')"/>
  </xsl:variable>

  <xsl:variable name="currDisplayDate">
    <xsl:value-of select="ms:format-date(/PaperesResults/details[position() = 1]/publ_date, 'dd/MM/yyyy','el')"/>
  </xsl:variable>

  <xsl:template name="AllPapers" match="/PaperesResults/details">

    <xsl:if test="Category != 9">
      <xsl:variable name="prevCat" select="preceding-sibling::details[1]/Category"/>

      <xsl:if test="Category != $prevCat or position()=1">
        <div class="fasa paps">
          <h1>
            <xsl:value-of select="CatName" disable-output-escaping="yes"/>
          </h1>
        </div>
      </xsl:if>


      <xsl:choose>
        <xsl:when test="position()=1">
          <div class="paper-holder">
            <h2 class="paper-name">
              <span class="ic">&#160;</span>
              <span>
                FREE WIDGET
              </span>



            </h2>
            <div class="">
              <a href="{concat('?pid=',154,'&amp;la=',$LanguageID)}" style="margin-right:16px; float:left;">
                <img src="~/media/NewspaperWidget.jpg"/>
              </a>
            </div>
          </div>
          <div class="paper-holder"  id="np{pbid}">
            <h2 class="paper-name">
              <span class="ic">&#160;</span>
              <span>
                <xsl:value-of disable-output-escaping="yes" select="Title"/>
              </span>
            </h2>
            <div style="float:right" class="sh{pbid}">
              <span class='st_email_large' displayText='Email' st_url='http://www.newsbeast.gr/newspapers/?dt={$currDate}#np{pbid}' st_title='{Title} {$currDisplayDate} | Newsbeast.gr' st_image='http://dev.newsbeast.gr/{publ_photo}'></span>
            </div>


            <div class="magni">
              <a name="{Title} np{pbid}" href="http://dev.newsbeast.gr/{publ_photo}" rel="magnify-title" class="thickbox" onclick="var scrollTop = $(window).scrollTop();NewsPaperOffset=scrollTop;"></a>
            </div>

            <xsl:if test="publ_photo != ''">
              <div class="paper-image">
                <a title="{Title} np{pbid}" href="http://dev.newsbeast.gr/{publ_photo}" rel="magnify-title" class="thickbox" onclick="var scrollTop = $(window).scrollTop();NewsPaperOffset=scrollTop;">
                  <!-- original size : 213, 298 -->  
                  <img title="{Title}" alt="{Title}" src="http://dev.newsbeast.gr/{publ_photo_213x298}"/>
                </a>
              </div>
            </xsl:if>
          </div>
        </xsl:when>

        <xsl:otherwise>
          <xsl:if test="position()=3">
            <tmplitem itemname="Nv.TextHtml" texthtmlname="NewsPapers_Banner_1" id="NewsPapers_Banner_1"/>
          </xsl:if>

          <xsl:if test="position()=6">
            <tmplitem itemname="Nv.TextHtml" texthtmlname="NewsPapers_Banner_2" id="NewsPapers_Banner_2"/>
          </xsl:if>

          <div class="paper-holder" id="np{pbid}">
            <div class="paper-name">
              <span class="ic">&#160;</span>
              <xsl:value-of disable-output-escaping="yes" select="Title"/>
            </div>
            <div style="float:right" class="sh{pbid}">
              <span class='st_email_large' displayText='Email' st_url='http://www.newsbeast.gr/newspapers/?dt={$currDate}#np{pbid}' st_title='{Title} {$currDisplayDate} | Newsbeast.gr' st_image='http://dev.newsbeast.gr{publ_photo}'></span>
            </div>


            <div class="magni">

              <a name="{Title} np{pbid}" href="http://dev.newsbeast.gr/{publ_photo}" rel="magnify-title" class="thickbox" onclick="var scrollTop = $(window).scrollTop();NewsPaperOffset=scrollTop;">
              </a>
            </div>

            <xsl:if test="publ_photo != ''">
              <div class="paper-image">
                <a title="{Title} np{pbid}" href="http://dev.newsbeast.gr/{publ_photo}" rel="magnify-title" class="thickbox" onclick="var scrollTop = $(window).scrollTop();NewsPaperOffset=scrollTop;">
                  <!-- original size : 213, 298 -->
                  <img title="{Title}" alt="{Title}" src="http://dev.newsbeast.gr/{publ_photo_213x298}"/>
                </a>
              </div>
            </xsl:if>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="/">

    <tmplitem alt="" directory="Newspaper" itemname="Common.Javascript" id="NewspaperJavascript"/>

    <xsl:choose>
      <xsl:when test="$PapersCategory = 0">
        <xsl:apply-templates select="/PaperesResults/details"/>
      </xsl:when>
      <xsl:otherwise>


        <xsl:if test="$PublicationString !=0">
          <script type="text/javascript">
            <![CDATA[
			var NewsPaperOffset=-1;
			jQuery(document).ready(function () {			
				]]>

            <xsl:value-of disable-output-escaping="yes" select="$PublicationString"/><![CDATA[
			})
			]]>
          </script>
        </xsl:if>
        <xsl:call-template name="Split">
          <xsl:with-param name="Nodes" select="ms:node-set($Papers)/details"/>
          <xsl:with-param name="Increment" select="4" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="Split">
    <xsl:param name="StartIndex" select="1"/>
    <xsl:param name="Nodes"/>
    <xsl:param name="Increment"/>
    <xsl:variable name="Fragment" select="$Nodes[position() &gt;= $StartIndex and position() &lt; $StartIndex + $Increment]"/>
    <xsl:if test="count($Fragment) != 0">
      <xsl:apply-templates select="$Fragment"/>

      <xsl:if test="$StartIndex = 1"> </xsl:if>

      <xsl:call-template name="Split">
        <xsl:with-param name="StartIndex" select="$StartIndex + $Increment" />
        <xsl:with-param name="Increment" select="$Increment" />
        <xsl:with-param name="Nodes" select="$Nodes"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="details">
    <xsl:choose>
      <xsl:when test="@type = 'link'">
        <div class="paper-holder" >
          <h2 class="paper-name">
            <span class="ic">&#160;</span>
            <span>FREE WIDGET</span>



          </h2>
          <div class="">
            <a href="{concat('?pid=',154,'&amp;la=',$LanguageID)}" style="margin-right:16px; float:left;">
              <img src="../media/NewspaperWidget.jpg"/>
            </a>
          </div>
        </div>
      </xsl:when>
      <xsl:when test="@type = 'ads'">
        <tmplitem itemname="Nv.TextHtml" texthtmlname="NewsPapers_Banner_1" id="NewsPapers_Banner_1"/>
      </xsl:when>
      <xsl:otherwise>
        <div class="paper-holder" id="np{pbid}">
          <xsl:if test="position() = last()">
            <xsl:attribute name="class">
              <xsl:text>paper-holder</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <div class="paper-name">
            <span class="ic">&#160;</span>
            <xsl:value-of disable-output-escaping="yes" select="Title"/>
          </div>
          <div style="float:right" class="sh{pbid}">
            <span class='st_email_large' displayText='Email' st_url='http://www.newsbeast.gr/newspapers/?dt={$currDate}#np{pbid}' st_title='{Title} {$currDisplayDate} | Newsbeast.gr' st_image='http://dev.newsbeast.gr/{publ_photo}'></span>
          </div>


          <div class="magni">

            <a name="{Title} np{pbid}" href="http://dev.newsbeast.gr/{publ_photo}" rel="magnify-title" class="thickbox" onclick="var scrollTop = $(window).scrollTop();NewsPaperOffset=scrollTop;">
            </a>
          </div>
          <xsl:if test="publ_photo != ''">
            <div class="paper-image">
              <a href="http://dev.newsbeast.gr/{publ_photo}" class="thickbox" onclick="var scrollTop = $(window).scrollTop();NewsPaperOffset=scrollTop;" rel="gallery-plants" title="{Title} np{pbid}">
                <!-- original size : 213, 298 -->
                <img title="{Title}" alt="{Title}" src="http://dev.newsbeast.gr/{publ_photo_213x298}"/>
              </a>
              <xsl:if test="string-length(fr_image) &gt; 0">
                <span style="position: absolute; right: -6px; bottom: -6px;">
                  <img src="{fr_image}"/>
                </span>
              </xsl:if>
            </div>
          </xsl:if>
        </div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>