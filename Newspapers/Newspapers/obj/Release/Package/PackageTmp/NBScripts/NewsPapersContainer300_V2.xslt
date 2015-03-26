<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ms="urn:schemas-microsoft-com:xslt" 
                xmlns:dt="urn:schemas-microsoft-com:datatypes" 
                xmlns:Image="urn:Image"
                exclude-result-prefixes="xsl Image ms dt">

  <xsl:output method="html" indent="yes"/>


  <xsl:variable name="SafeQueryString" select="'hash&lt;string&gt;'"/>

  <xsl:template match="/">
    <xsl:param name="shortDate" select="All/Detail/shortDate"/>
    <xsl:param name="prevDate1" select="All/Detail/prevDate1"/>
    <xsl:param name="prevDate2" select="All/Detail/prevDate2"/>
    <xsl:param name="prevDate3" select="All/Detail/prevDate3"/>
    <xsl:param name="prevDate4" select="All/Detail/prevDate4"/>
    <xsl:param name="prevDate5" select="All/Detail/prevDate5"/>

    
    <div class="wrapper-big">

      <div class="head-big">
        <h1>
          <a href="http://www.newsbeast.gr/newspapers/?pct=0&amp;utm_source=newspapers&amp;utm_medium=newspapers_widget_300&amp;utm_campaign=newspapers&amp;utm_placement=title" target="_blank" >
            εφημερίδεs
          </a>
        </h1>
      </div>


      <div class="main-big">
        <ul class="type">
          <li class="active" id="cover-front">
            <a href="javascript:void(0);">πρωτοσέλιδα</a>
          </li>
          <li id="cover-back">
            <a href="javascript:void(0);">οπισθόφυλλα</a>
          </li>
          <li id="nbLogo">
            <a href="#" target="_blank"></a>
          </li>
        </ul>
        <div class="top"  >
          <xsl:variable name="smallcase" select="'αβγδεζηθικλμνξοπρστυφχψω'"/>
          <xsl:variable name="uppercase" select="'ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ'"/>
          <ul>
            <li id="old_dates1" style="list-style:none outside;margin:0">
              <xsl:if test="ms:format-date($shortDate, 'd/M/yyyy') =  ms:format-date($prevDate1, 'd/M/yyyy')">
                <xsl:attribute name="class">active</xsl:attribute>
              </xsl:if>
              <a class="dateLinks" href="javascript:handleCssStatus(1);" id="{ms:format-date($prevDate1, 'dd/MM/yyyy')}">
                <xsl:value-of select="ms:format-date($prevDate1, 'dd')"/>
                <br/>
                <span>
                  <xsl:value-of select="translate(ms:format-date($prevDate1, 'MMM','el'), $smallcase, $uppercase)"/>
                </span>
              </a>
            </li>
            <li id="old_dates2" style="list-style:none outside;margin:0">
              <xsl:if test="ms:format-date($shortDate, 'd/M/yyyy') =  ms:format-date($prevDate2, 'd/M/yyyy')">
                <xsl:attribute name="class">active</xsl:attribute>
              </xsl:if>
              <a class="dateLinks" href="javascript:handleCssStatus(2);" id="{ms:format-date($prevDate2, 'dd/MM/yyyy')}">
                <xsl:value-of select="ms:format-date($prevDate2, 'dd')"/>
                <br/>
                <span>
                  <xsl:value-of select="translate(ms:format-date($prevDate2, 'MMM','el'), $smallcase, $uppercase)"/>
                </span>
              </a>
            </li>
            <li id="old_dates3" style="list-style:none outside;margin:0">
              <xsl:if test="ms:format-date($shortDate, 'd/M/yyyy') =  ms:format-date($prevDate3, 'd/M/yyyy')">
                <xsl:attribute name="class">active</xsl:attribute>
              </xsl:if>
              <a class="dateLinks" href="javascript:handleCssStatus(3);" id="{ms:format-date($prevDate3, 'dd/MM/yyyy')}">
                <xsl:value-of select="ms:format-date($prevDate3, 'dd')"/>
                <br/>
                <span>
                  <xsl:value-of select="translate(ms:format-date($prevDate3, 'MMM','el'), $smallcase, $uppercase)"/>
                </span>
              </a>
            </li>
            <li id="old_dates4" style="list-style:none outside;margin:0">
              <xsl:if test="ms:format-date($shortDate, 'd/M/yyyy') =  ms:format-date($prevDate4, 'd/M/yyyy')">
                <xsl:attribute name="class">active</xsl:attribute>
              </xsl:if>

              <a class="dateLinks" href="javascript:handleCssStatus(4);" id="{ms:format-date($prevDate4, 'dd/MM/yyyy')}">
                <xsl:value-of select="ms:format-date($prevDate4, 'dd')"/>
                <br/>
                <span>
                  <xsl:value-of select="translate(ms:format-date($prevDate4, 'MMM','el'), $smallcase, $uppercase)"/>
                </span>
              </a>
            </li>
            <li id="old_dates5" style="list-style:none outside;margin:0">
              <xsl:if test="ms:format-date($shortDate, 'd/M/yyyy') =  ms:format-date($prevDate5, 'd/M/yyyy')">
                <xsl:attribute name="class">active</xsl:attribute>
              </xsl:if>

              <a class="dateLinks" href="javascript:handleCssStatus(5);" id="{ms:format-date($prevDate5, 'dd/MM/yyyy')}">
                <xsl:value-of select="ms:format-date($prevDate5, 'dd')"/>
                <br/>
                <span>
                  <xsl:value-of select="translate(ms:format-date($prevDate5, 'MMM','el'), $smallcase, $uppercase)"/>
                </span>
              </a>
            </li>
          </ul>

        </div>

        <div class="left">
          <div id="mainFrame" class="paper-big">
            <input type="hidden" name="CatsSelected" value="-1"/>
            <input type="hidden" name="BackOrFront" value="1"/>
            <input type="hidden" name="dt" /> 
            <!--<input type="hidden" name="hash" value="f6b32c9893eb9ef81099a67da5629b37"/>
            <input type="hidden" name="dt" value="03/02/2015"/>-->
            <span>DYNAMICALLY_ADD_CONTENT</span>
            <div class="arrows-big">
              <ul>
                <li class="prev">
                  <a href="javascript:return false;"></a>
                </li>
                <li class="pause" id="pause_play_widget">
                  <a href="javascript:void(0);"></a>
                </li>
                <li class="next">
                  <a href="javascript:void(0);"></a>
                </li>
              </ul>
            </div>
          </div>
        </div>
        
        <xsl:variable name="BuildWidget" select="concat('/?pid=154','&amp;la=1')"/>
        <div class="foot-big">
          <p class="footp">
            <a href="{$BuildWidget}" target="_blank">ΠΡΟΣΘΕΣΤΕ ΤΟ WIDGET ΣΤΗ ΣΕΛΙΔΑ ΣΑΣ</a>
            <xsl:text disable-output-escaping="yes"><![CDATA[ &raquo;]]> </xsl:text>
          </p>
        </div>
      </div>
    </div>
  </xsl:template>


</xsl:stylesheet>