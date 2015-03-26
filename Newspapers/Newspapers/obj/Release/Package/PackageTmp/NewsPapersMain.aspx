<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Newspapers.aspx.cs" Inherits="Newspapers.NewsPaperMain" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Newsbeast.gr - NewsPapers</title>
    
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.3/themes/smoothness/jquery-ui.css"/>
    <script src="//code.jquery.com/jquery-1.10.2.js"></script>
    <script src="//code.jquery.com/ui/1.11.3/jquery-ui.js"></script>

    <script>
        var ArticleId = 0;
    </script>
    
    <link rel="stylesheet" type="text/css" href="~/css/thickbox.css" media="all" /> 
    <link rel="stylesheet" type="text/css" href="~/css/modules.css" media="all" /> 
    <link rel="stylesheet" type="text/css" href="~/css/last-news_widget.css" media="all" /> 
    <link rel="stylesheet" type="text/css" href="~/css/kiosk.css" media="all" /> 
    <link rel="stylesheet" type="text/css" href="~/css/formating.css" media="all" /> 
    <link rel="stylesheet" type="text/css" href="~/css/structure.css" media="all" /> 

    
    <link rel="stylesheet" type="text/css" href="~/css/newspapers-datepicker.css" media="all" charset="utf-8"/> 
    <%-- ??   <link rel="stylesheet" href="Themes/1/Default/Css/print.css" type="text/css" media="print" />--%>
    <link media="all" href="~/css/thickbox_newspapers.css" type="text/css" rel="stylesheet"  charset="utf-8" />
    <link rel="icon" type="image/png" href="~/media/newsbeast.png" /> 

    <script src="js/jquery-ui.min.js"></script>
    <script type="text/javascript">var switchTo5x = true;</script>
    <script type="text/javascript" src="http://w.sharethis.com/button/buttons.js"></script>
    <script type="text/javascript">stLight.options({ publisher: "1892fc32-e6ea-48da-bb8d-80eef48ef0a7", doNotHash: false, doNotCopy: false, hashAddressBar: false });</script>
    <script type="text/javascript" src="js/utilities.js" charset="windows-1253" ></script>

    <script type="text/javascript" src="http://wd-edge.sharethis.com/button/getAllAppDefault.esi?cb=stLight.allDefault&amp;app=all&amp;publisher=1892fc32-e6ea-48da-bb8d-80eef48ef0a7&amp;domain=newsbeast.gr"></script>
    <script type="text/javascript" src="http://wd-edge.sharethis.com/button/checkOAuth.esi"></script>
    <link rel="stylesheet" type="text/css" href="http://w.sharethis.com/button/css/buttons.1be8af3324f0d6a3f57225413b0da78b.css"/>
<%--    <style>
      .stLarge{
          background: url("~/media/sprites.png") no-repeat scroll -239px 5px transparent !important;
         width:30px !important;
         height:26px !important;
      }
    </style>--%>

    
</head>
<body class="js">

    <form id="Form1" runat="server" enableviewstate="false">

        <div id="LoadHTMLNoPub" runat="server"></div>                           <%--Maybe replace from Service of INNEWS.GR check xml field / http://www.timeanddate.com/holidays/greece/ --%>
        <!-- PAGER COLOR ? -->

        <div id="wrapper">
	        <div id="content">
		        <div id="col-full">
			        <div class="newspapers-page">
                        
                        <div id="LoadHTMLPager" style="padding-top: 10px;" runat="server" ></div>           <%-- SQL/XSLT: NewsPapersPager --%>
                        <div id="LoadHTMLCategories" runat="server"></div>       <%-- SQL/XSLT: NewsPaperCategories --%>
                        
                        <div id="NewsPapersListNew" runat="server"></div>        <!-- All newspapers here -->
			        </div>
		        </div>
	        </div>
	        <div id="footer">
	        </div>
        </div>
        <script>
            $(document).ready(function () {
                if (document.location.hash) {
                    tb_remove();
                    $(document.location.hash + ' .thickbox').trigger("click");
                }
            })
        </script>
    </form>

</body>
</html>
