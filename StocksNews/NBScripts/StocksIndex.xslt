<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
                xmlns:currency="urn:currency"
                xmlns:percent="urn:percent"
                xmlns:currencychange="urn:currencychange"
                xmlns:percentchange="urn:percentchange"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:msxml="urn:schemas-microsoft-com:xslt" 
                xmlns:Image="urn:Image"
                xmlns:res="urn:Resource"
                xmlns:Developer="urn:Developer"
                xmlns:Urls="urn:Urls"
                xmlns:Page="urn:Page"
                xmlns:msxsl="urn:schemas-microsoft-com:xslt"
                xmlns:asp="remove"
                xmlns:Strings="urn:Strings"
                xmlns:QueryString="urn:QueryString"
                xmlns:dt="urn:schemas-microsoft-com:datatypes"
                xmlns:ms="urn:schemas-microsoft-com:xslt"
                xmlns:myfunctionlib="urn:myfunctionlib"
                exclude-result-prefixes="xsl Image res Urls msxsl asp dt ms Strings Developer QueryString Page percent currency currencychange percentchange myfunctionlib">

  <msxsl:script language="C#" implements-prefix="myfunctionlib">
    <msxml:assembly name="System.Web"/>
    <msxml:assembly name="System"/>
    
    <msxml:using namespace="System.Web"/>
      <![CDATA[
        public string GetValueFromConstants(string key)
        {
            switch (key)
            {
                case "Stocks_Category": return "Κατηγορία Μετοχής"; 
                case "Stocks_Price": return "Τιμή Μετοχής"; 
                case "Stocks_TotalVolume": return "Συνολικός Όγκος"; 
                case "Stocks_PercentChange": return "% Διαφορά Τιμής"; 
                case "Stocks_HighPrice": return "Μέγιστη Τιμή"; 
                case "Stocks_LowPrice": return "Ελάχιστη Τιμή"; 
                case "Stocks_PreviousPrice": return "Προηγούμενη Τιμή"; 
                case "Stocks_BuyPrice": return "Τιμή Αγοράς"; 
                case "Stocks_BuyVolume": return "Όγκος Αγοράς"; 
                case "Stocks_SellPrice" : return "Τιμή Πώλησης";
                case "Stocks_SellVolume" : return "Όγκος Πώλησης";
                default: return "";
            }
        }
    ]]>
  </msxsl:script>


    
  <xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>

  <xsl:param name="PageID"/>
  <xsl:param name="LanguageID"/>

  <xsl:template match="/">

    <div class="headCnt fontRob fontB">
      
      <div class="textCnt">
        <h2>
          <span class="colLB">ΓΕΝΙΚΟΣ ΔΕΙΚΤΗΣ ΧΑΑ:</span>
          <xsl:text> </xsl:text>
          <b>
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="Stocks/MainIndex/PChange = 0">
                  <xsl:text>zero</xsl:text>
                </xsl:when>
                <xsl:when test="Stocks/MainIndex/PChange > 0">
                  <xsl:text>positive</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>negative</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="Stocks/MainIndex/Value"/>
          </b>
          <span>
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="Stocks/MainIndex/PChange = 0">
                  <xsl:text>box zero</xsl:text>
                </xsl:when>
                <xsl:when test="Stocks/MainIndex/PChange > 0">
                  <xsl:text>box green</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>box red</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:value-of select="Stocks/MainIndex/PChange" />
            <xsl:text>%</xsl:text>
          </span>
        </h2>
        <h2>
          <span class="colLB">ΤΖΙΡΟΣ: </span>
          <xsl:value-of select="Stocks/MainIndex/Volume" />
          <xsl:text> εκ.</xsl:text>
        </h2>
        <h2>
          <span class="colLB">Τελ. ενημ.: </span>
          <xsl:text> </xsl:text>
          <xsl:value-of select="msxsl:format-date(/Stocks/@LastUpdate,'dd/MM/yyyy')" />
          <xsl:text>, </xsl:text>
          <xsl:value-of select="msxsl:format-time(/Stocks/@LastUpdate,'HH:mm')" />
        </h2>
      </div>
      <div class="fClear"></div>
    </div>



    <div class="stocksCnt">
      <xsl:apply-templates select="/Stocks/Letters/Letter" />
    </div>
    
    <script type="text/javascript">
      <xsl:text>var stocks = {</xsl:text>
      <xsl:apply-templates select="/Stocks/Stock" mode="JSON" />
      <xsl:text>};</xsl:text>
    </script>
    
  </xsl:template>

  <xsl:template match="Stock" mode="JSON">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="@Key"/>
    <xsl:text>":{</xsl:text>
    <xsl:for-each select="*">
      <xsl:text>"</xsl:text>
      <xsl:value-of select="myfunctionlib:GetValueFromConstants(concat('Stocks_', local-name()))"/>
      <xsl:text>":</xsl:text>
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
  <xsl:template match="percent:*" mode="value">
    <xsl:text>{"type":"percent","value":"</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"}</xsl:text>
  </xsl:template>
  <xsl:template match="currency:*" mode="value">
    <xsl:text>{"type":"currency","value":"</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"}</xsl:text>
  </xsl:template>

  <xsl:template match="percentchange:*" mode="value">
    <xsl:text>{"type":"percentchange","value":"</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"}</xsl:text>
  </xsl:template>
  <xsl:template match="currencychange:*" mode="value">
    <xsl:text>{"type":"currencychange","value":"</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"}</xsl:text>
  </xsl:template>
  <xsl:template match="*" mode="value">
    <xsl:text>{"type":"plain","value":"</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"}</xsl:text>
  </xsl:template>

  
  <xsl:template match="Letter">
    <xsl:variable name="Letter" select="." />
    <xsl:variable name="Stocks" select="/Stocks/Stock[@Letter = $Letter]" />
    <xsl:variable name="RowCount" select="ceiling(count($Stocks) div  9)" />
    <div class="block">
      <xsl:call-template name="Row">
        <xsl:with-param name="Stocks" select="$Stocks" />
        <xsl:with-param name="RowCount" select="$RowCount" />
        <xsl:with-param name="Letter" select="$Letter" />
      </xsl:call-template>
      <xsl:text disable-output-escaping="yes">&lt;/div&gt;</xsl:text>
    </div>  
  </xsl:template>
  
  <xsl:template name="Row">
    <xsl:param name="Stocks" />
    <xsl:param name="Letter" />
    <xsl:param name="RowCount" />
    <xsl:param name="Current" select="1" />
    <xsl:if test="$Current &lt;= $RowCount">
        <xsl:if test="$Current = 1">
          <h3>
            <xsl:value-of select="$Letter"/>
          </h3>
          <xsl:text disable-output-escaping="yes">&lt;div  class="linksCnt"&gt;</xsl:text>
        </xsl:if>
      
        <xsl:apply-templates select="msxsl:node-set($Stocks)[position() &gt; ($Current - 1) * 9 and position() &lt;= ($Current * 9)]" mode="HTML" />
        <xsl:call-template name="Row">
          <xsl:with-param name="Stocks" select="$Stocks" />
          <xsl:with-param name="RowCount" select="$RowCount" />
          <xsl:with-param name="Letter" select="$Letter" />
          <xsl:with-param name="Current" select="$Current + 1" />
        </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="Stock" mode="HTML">
      <a href="#">
        <xsl:value-of select="@Key"/>
      </a>
  </xsl:template>
</xsl:stylesheet>