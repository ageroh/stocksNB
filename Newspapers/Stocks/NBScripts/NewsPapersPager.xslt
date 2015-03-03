<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
                xmlns:ext="http://exslt.org/common"
                xmlns:asp="asp.net" 
                xmlns:res="urn:Resource"
                xmlns:ms="urn:schemas-microsoft-com:xslt" 
                xmlns:Urls="urn:Urls" 
                xmlns:QueryString="urn:QueryString" 
                xmlns:NewsBeast="urn:NewsBeast" 
                xmlns:Image="urn:Image" 
                xmlns:Custom="urn:Custom"
                exclude-result-prefixes="NewsBeast xsl msxsl asp res Image Urls QueryString Custom">
  <xsl:param name="QueryStringMask" select="'tp&lt;int&gt;dt&lt;string&gt;pct&lt;int&gt;'"/>
  <xsl:param name="QueryStringParam" select="'dt'"/>
  <xsl:param name="PublicationString"/>
  <xsl:output method="html" omit-xml-declaration="yes"/>

  <msxsl:script implements-prefix="Custom" language="c#">
    <msxsl:using namespace="System.Globalization"/><![CDATA[
    public string ToUpper(string s){
            return RemoveDiacritics(s.ToUpperInvariant()).ToUpperInvariant();
    }
    private string RemoveDiacritics(String s)
    {
            String normalizedString = s.Normalize(NormalizationForm.FormD);
            StringBuilder stringBuilder = new StringBuilder();

            for (int i = 0; i < normalizedString.Length; i++)
            {
                Char c = normalizedString[i];
                if (CharUnicodeInfo.GetUnicodeCategory(c) != UnicodeCategory.NonSpacingMark)
                    stringBuilder.Append(c);
            }

            return stringBuilder.ToString();
    }
    ]]>
  </msxsl:script>

  <xsl:template match="/">
    <xsl:variable name="Active" select="/NewsPapers/Active"/>
    <xsl:variable name="TotalDates" select="count(/NewsPapers/Dates/Date)" />
    <xsl:variable name="ActivePosition">
      <xsl:for-each select="/NewsPapers/Dates/Date">
        <xsl:if test="D = $Active">
          <xsl:value-of select="position()"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:comment>
      <xsl:value-of select="count(/NewsPapers)"/>
    </xsl:comment>
    <xsl:variable name="next" select="/NewsPapers/Dates/Date[position() &gt; $ActivePosition and HasRecords = 1][position() = 1]/D"/>
    <xsl:variable name="previous" select="/NewsPapers/Dates/Date[position() &lt; $ActivePosition and HasRecords = 1][position() = last()]/D"/>



    <div class="papers-dates">
      <div class="kind-selector" xmlns:querystring="urn:QueryString">
        <script type="text/javascript">

      <![CDATA[ 
          function parseUri(str) {
          var o = parseUri.options,
          m = o.parser[o.strictMode ? "strict" : "loose"].exec(str),
          uri = {},
          i = 14;

          while (i--) uri[o.key[i]] = m[i] || "";

          uri[o.q.name] = {};
          uri[o.key[12]].replace(o.q.parser, function($0, $1, $2) {
          if ($1) uri[o.q.name][$1] = $2;
          });

          return uri;
          };

          parseUri.options = {
          strictMode: false,
          key: ["source", "protocol", "authority", "userInfo", "user", "password", "host", "port", "relative", "path", "directory", "file", "query", "anchor"],
          q: {
          name: "queryKey",
          parser: /(?:^|&)([^&=]*)=?([^&]*)/g
          },
          parser: {
          strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,
          loose: /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/
          }
          };


          function redirectPage(id)
          {
          var u = parseUri(window.location.href);
          if(id == 2)
          u.queryKey['tp'] = 2;
          else
          delete u.queryKey['tp'];
          var query = [];
          for (var p in u.queryKey) {
          query.push(p + '=' + u.queryKey[p]);
          }
          window.location.href = u.path + '?' + query.join('&');
          }
          ]]>
          
        </script>
        <select name="tp" id="tp" onchange="redirectPage(this.options[this.selectedIndex].value)">
          <option value="1">
            Πρωτοσέλιδα
          </option>
          <option value="2">
            Οπισθόφυλλα
          </option>
        </select>
      </div>

      <div id="NewsPapersToolbar" runat="server"></div>
      <div class="papers-date-wrapper">
        <div class="papers-dates-arrow left">
          <xsl:if test="string-length($previous) = 0">
            <xsl:attribute name="class">
              <xsl:text>papers-dates-arrow left inactive</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="onclick">
              <xsl:text>return false;</xsl:text>
            </xsl:attribute>
          </xsl:if>

          <a href="{$QueryStringParam}"> <!-- Developer:ReplaceQueryStringParameter($QueryStringParam,msxsl:format-date($previous,'M/d/yyyy'),$QueryStringMask) -->
            <xsl:if test="string-length($previous) = 0">
              <xsl:attribute name="href">
                <xsl:text>#</xsl:text>
              </xsl:attribute>
            </xsl:if>
            <img src="../Media/papers-dates-arrow-left.png"/>
          </a>
        </div>

        <ul>
          <xsl:for-each select="/NewsPapers/Dates/Date[position() &gt; ($ActivePosition - 6) and position() &lt; ($ActivePosition + 4)]">
            <li>
              <xsl:if test="D = /NewsPapers/Active">
                <xsl:attribute name="class">
                  <xsl:text>active</xsl:text>
                </xsl:attribute>
              </xsl:if>
              <xsl:choose>
                <xsl:when test="HasRecords = 1">
                  <a href="{$QueryStringParam}"> <!-- {Developer:ReplaceQueryStringParameter($QueryStringParam,msxsl:format-date(D,'M/d/yyyy'),$QueryStringMask)}  -->
                    <xsl:value-of select="msxsl:format-date(D,'dd/MM')"/>
                  </a>
                </xsl:when>
                <xsl:otherwise>
                  <span>
                    <xsl:value-of select="msxsl:format-date(D,'dd/MM')"/>
                  </span>
                </xsl:otherwise>
              </xsl:choose>
            </li>
          </xsl:for-each>
        </ul>

        <div class="papers-dates-arrow right">
          <xsl:if test="string-length($next) = 0">
            <xsl:attribute name="class">
              <xsl:text>papers-dates-arrow right inactive</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="onclick">
              <xsl:text>return false;</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <a href="{$QueryStringParam}"> <!-- $QueryStringParam msxsl:format-date($next,'M/d/yyyy') $QueryStringMask -->
            <xsl:if test="string-length($next) = 0">
              <xsl:attribute name="href">
                <xsl:text>#</xsl:text>
              </xsl:attribute>
            </xsl:if>
            <img src="../Media/papers-dates-arrow-right.png"/>
          </a>
        </div>
      </div>
      <script>
        <![CDATA[

          jQuery(function () {

            jQuery("#calendarDateSelected").datepicker({
                  showOn: "button",
                  buttonImage: '../media/papers-calendar.png',
                  buttonImageOnly: true
                  ,beforeShowDay: isAvailable
                  ,maxDate: 0
                  ,minDate: new Date(2010, 8, 5)
                  , closeText: 'Κλείσιμο',
                  prevText: 'Προηγούμενος',
                  nextText: 'Επόμενος',
                  currentText: 'Τρέχων Μήνας',
                  monthNames: ['Ιανουάριος', 'Φεβρουάριος', 'Μάρτιος', 'Απρίλιος', 'Μάιος', 'Ιούνιος', 'Ιούλιος', 'Αύγουστος', 'Σεπτέμβριος', 'Οκτώβριος', 'Νοέμβριος', 'Δεκέμβριος'],
                  monthNamesShort: ['Ιαν', 'Φεβ', 'Μαρ', 'Απρ', 'Μαι', 'Ιουν', 'Ιουλ', 'Αυγ', 'Σεπ', 'Οκτ', 'Νοε', 'Δεκ'],
                  dayNames: ['Κυριακή', 'Δευτέρα', 'Τρίτη', 'Τετάρτη', 'Πέμπτη', 'Παρασκευή', 'Σάββατο'],
                  dayNamesShort: ['Κυρ', 'Δευ', 'Τρι', 'Τετ', 'Πεμ', 'Παρ', 'Σαβ'],
                  dayNamesMin: ['Κυ', 'Δε', 'Τρ', 'Τε', 'Πε', 'Πα', 'Σα'],
                  weekHeader: 'Εβδ',
                  dateFormat: 'mm/dd/yy',
                  firstDay: 1,
                  isRTL: false,
                  showMonthAfterYear: false,
                  yearSuffix: ''
          };

          $("#calendarDateSelected").extend($.datepicker,{_checkOffset:function(inst,offset,isFixed){return offset}});
            

        });
  $(document).ready(function() {
        jQuery(".ui-datepicker-trigger").mouseover(function() {
            
            jQuery(this).attr('alt','Επιλέξτε ημερομηνία');
            jQuery(this).attr('title','Επιλέξτε ημερομηνία');
        })

       });
     
    function isAvailable(date){
       var dateAsString = date.getFullYear().toString() + "-" + (date.getMonth()+1).toString() + "-" + date.getDate();
       var result = $.inArray( dateAsString, daysWithNoPublications) ==-1 ? [true] : [false];
       return result;
    }

    function redirectToNewDate(newDate)
    {
        document.location="/newspapers/?dt="+newDate;
    }

    ]]>
      </script>

      <div class="paper-calendar">
        <p>
          <xsl:value-of select="Custom:ToUpper(msxsl:format-date($Active,'d MMMM yyyy','el-gr'))"/>
        </p>
        <input type="hidden" style="width:70px;display:block;" name="calendarDateSelected" id="calendarDateSelected" value="{msxsl:format-date(D,'dd/MM')}" onchange="redirectToNewDate($(this).val())"/>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>

