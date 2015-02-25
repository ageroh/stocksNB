<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Newspapers.aspx.cs" Inherits="Newspapers.WebForm1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link id="Link1" rel="stylesheet" runat="server" media="screen" href="~/css/newspapers.css" />
    <link rel="stylesheet" type="text/css" href="~/css/newspapers-datepicker.css" media="all" charset="windows-1253"/> 
    <link media="all" href="~/css/thickbox_newspapers.css" type="text/css" rel="stylesheet" charset="windows-1253" />
    <link media="all" href="~/css/paper-widget-new.css" type="text/css" rel="stylesheet" charset="windows-1253" />

    <script type="text/javascript" src="js/widget_builder.js" charset="windows-1253" ></script>
    <script type="text/javascript" src="js/widget.js" charset="windows-1253" ></script>
    <script type="text/javascript" src="js/jquery-1.8.3.min.js" ></script>
    <script type="text/javascript" src="js/utilities.js" charset="windows-1253" ></script>
    <script type="text/javascript">var switchTo5x = true;</script>
    <script type="text/javascript" src="http://w.sharethis.com/button/buttons.js"></script>

</head>
<body style="width: 690px;height: 800px;">

    <div id="customNewsPapersPage">

        <div id="LoadHTMLNoPub" runat="server"></div>

        <div id="wrapper">
	        <div id="content">
		        <div id="col-full">
			        <div class="newspapers-page">
				        <div id="LoadHTMLPager" runat="server"></div>
                        <div id="LoadHTMLCategories" runat="server"></div>

                        <div id="WidgetNP" runat="server">
                            <div id="WidgetAllPapers" runat="server"></div>
                        </div>
			        </div>
		        </div>	
	        </div>

	        <div id="footer">
	        </div>
        </div>

    </div>

</body>
</html>
