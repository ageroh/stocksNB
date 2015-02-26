<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                exclude-result-prefixes="xsl">
  <xsl:param name="CodesWidget"/>

  <xsl:template match="/">


    <div class="paperwidget1" style="background-color:#8E8E8E;min-height:416px;" >
      <img src="../Media/ajax-loader-widget-paper.gif" id="ajax-loader-widget-paper" style="margin-left:130px"/>
      <!--<div class="PapersWidgetPlayer" style="margin:0 auto;display:none">-->
      <div class="PapersWidgetPlayer" style="margin: 0px auto; height: 265px; position: relative;">
        <xsl:apply-templates select="/PaperesResults/details"/>
      </div>
    </div>
  </xsl:template>
  
  <xsl:template match="/PaperesResults/details">

    <xsl:variable name="PaperLink" select="concat('/?pid=85','&amp;la=1','&amp;pbid=',pbid)"/>
    <a href="{$PaperLink}" title="{Title} - {paperUrl}">
      <!--<img title="{Title}" alt="{Title}" src="{Image:AnchoredFit(publ_photo, 277, 343,'Top')}"/>-->
      <img title="{Title}" alt="{Title}" src="http://dev.newsbeast.gr/{publ_photo_277x343}" />
    </a>

  </xsl:template>
</xsl:stylesheet>