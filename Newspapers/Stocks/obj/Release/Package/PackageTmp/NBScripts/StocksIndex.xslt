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
                case "Stocks_Price": return "% Διαφορά Τιμής"; 
                case "Stocks_TotalVolume": return "Μέγιστη Τιμή"; 
                case "Stocks_PercentChange": return "Ελάχιστη Τιμή"; 
                case "Stocks_HighPrice": return "Προηγούμενη Τιμή"; 
                case "Stocks_LowPrice": return "Τιμή Αγοράς"; 
                case "Stocks_PreviousPrice": return "Όγκος Αγοράς"; 
                case "Stocks_BuyPrice": return "Τιμή Πώλησης"; 
                case "Stocks_BuyVolume": return "Όγκος Πώλησης"; 
                case "Stocks_SellPrice": return "Τελευταία Ενημέρωση"; 
                default: return "Συνολικός Όγκος";
            }
        }
    ]]>
  </msxsl:script>


    
  <xsl:output method="html" indent="yes" omit-xml-declaration="yes"/>

  <xsl:param name="PageID"/>
  <xsl:param name="LanguageID"/>

  <xsl:template match="/">
    <div class="stock-ticker">
      <div class="left">
        <p>
          <xsl:text>Γενικός Δείκτης ΧΑΑ: </xsl:text>
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
          <xsl:text> </xsl:text>
          <span>
            <xsl:value-of select="Stocks/MainIndex/PChange" />
            <xsl:text>%</xsl:text>
          </span>
          <xsl:text> ΤΖΙΡΟΣ: </xsl:text>
          <span>
            <xsl:value-of select="Stocks/MainIndex/Volume" />
            <xsl:text> εκ.</xsl:text>
          </span>
        </p>
      </div>
      <div class="right">
        <p>
          <b>
            <xsl:text>Τελ. Ενημέρωση:</xsl:text>
          </b>
          <xsl:text> </xsl:text>
          <xsl:value-of select="msxsl:format-date(/Stocks/@LastUpdate,'dd/MM/yyyy')" />
          <xsl:text> </xsl:text>
          <b>
            <xsl:value-of select="msxsl:format-time(/Stocks/@LastUpdate,'HH:mm')" />
          </b>
        </p>
      </div>
    </div>
    <div class="stock-table-main">
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
    <table cellspacing="0" cellpadding="0" border="0">
      <tbody>
        <xsl:call-template name="Row">
          <xsl:with-param name="Stocks" select="$Stocks" />
          <xsl:with-param name="RowCount" select="$RowCount" />
          <xsl:with-param name="Letter" select="$Letter" />
        </xsl:call-template>
      </tbody>
    </table>
  </xsl:template>
  <xsl:template name="Row">
    <xsl:param name="Stocks" />
    <xsl:param name="Letter" />
    <xsl:param name="RowCount" />
    <xsl:param name="Current" select="1" />
    <xsl:if test="$Current &lt;= $RowCount">
      <tr>
        <xsl:if test="$Current = 1">
          <th align="center" rowspan="{$RowCount}" class="letter">
            <xsl:value-of select="$Letter"/>
          </th>
        </xsl:if>
        <xsl:apply-templates select="msxsl:node-set($Stocks)[position() &gt; ($Current - 1) * 9 and position() &lt;= ($Current * 9)]" mode="HTML" />
        <xsl:call-template name="Row">
          <xsl:with-param name="Stocks" select="$Stocks" />
          <xsl:with-param name="RowCount" select="$RowCount" />
          <xsl:with-param name="Letter" select="$Letter" />
          <xsl:with-param name="Current" select="$Current + 1" />
        </xsl:call-template>
      </tr>
    </xsl:if>

  </xsl:template>
  <xsl:template match="Stock" mode="HTML">
    <td align="center">
      <xsl:value-of select="@Key"/>
    </td>
  </xsl:template>
</xsl:stylesheet>