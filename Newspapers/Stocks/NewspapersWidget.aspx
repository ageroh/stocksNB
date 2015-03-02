<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="NewspapersWidget.aspx.cs" Inherits="Newspapers.NewsPaperWidget" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    


    <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
	<meta http-equiv='Content-Language' content='el' />
	<title>Newsbeast.gr | widget-share</title>
    <meta name='DESCRIPTION' content='' />
	<meta name='KEYWORDS' content='' />
	<%--<base href='http://www.newsbeast.gr/' />--%>
	<script type="text/javascript" src="js/jquery-1.8.3.min.js" ></script>
    <script>
        var ArticleId = 0;
    </script>
    <link media="all" href="~/css/paper-widget-new.css" type="text/css" rel="stylesheet" charset="windows-1253" />
    <link rel="stylesheet" type="text/css" href="css/jquery.lightbox-0.5.css" media="screen" />
    <link id="Link1" rel="stylesheet" runat="server" media="screen" href="~/css/newspapers.css" />

    <script type="text/javascript" src="js/widget_builder.js" charset="windows-1253"></script>
    <script type="text/javascript" src="js/widget.js" charset="windows-1253"></script>
    <script type="text/javascript" src="js/jquery.cycle.all.min.js"></script>
    
    <script type="text/javascript" src="js/jquery.innerfade.js" charset="windows-1253"></script>
    <script type="text/javascript" src="js/jquery.lightbox-0.5.min.js"></script>



</head>
<body>
    <div id="LoadHTMLNoPub" runat="server"></div>

    <form runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"/>
    
    <div id="WidgetContainer" runat="server"></div>
    <div id="WidgetAllPapers" runat="server"></div>


    <script type="text/javascript">
        jQuery(function () {
            jQuery('#gallery a').lightBox();
        });
    </script>

    <script type="text/javascript" src="js/widget_builder.js" charset="windows-1253" ></script>
        
    <script type = "text/javascript">

        var NewsPaperAjaxRequest = function (Cats, theDate, Cover, page) {
            var targetPage = "widget-xml";
            //if(page=="small")	
            //    targetPage = "widget-xml-200";
            if (theDate === "")
            {
                // get the date from input val
                theDate  = $("#mainFrame").find("input[name$='dt']").val();
            }

            // here should display loading gif
            $(".PapersWidgetPlayer").html("");
            $(".PapersWidgetPlayer").html("<img style='padding-left:80px;padding-top:120px;' src='../media/ajax-loader-widget.gif'/>");

            $.ajax({

                type: "POST",
                url: "NewspapersWidget.aspx/RefreshNewspapers",
                data: JSON.stringify({ dtStr: theDate, hash: getUrlVars()["hash"], tp: Cover, pbid: '1', isClicked: '1' }),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess,
                failure: function (response) {
                    console.log(response.d);
                }

            });
        }

           
        function OnSuccess(response) {
            // alert(response.d);

            //; .replaceAll(".paperwidget1");
            $(".PapersWidgetPlayer").html($(response.d).find(".PapersWidgetPlayer").children());
            

            $.getScript("js/widget.js", function (data, textStatus, jqxhr) {
                console.log(data); // Data returned
                console.log(textStatus); // Success
                console.log(jqxhr.status); // 200
                console.log("Load was performed.");
            });

            //if (justClicked_class == "selected")
            //    $("#share-cats-li-" + justClickedID + "").removeClass("selected");
            //else
            //    $("#share-cats-li-" + justClickedID + "").addClass("selected");
           
        }
    

        function getUrlVars() {
            var vars = [], hash;
            var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
            for (var i = 0; i < hashes.length; i++) {
                hash = hashes[i].split('=');
                vars.push(hash[0]);
                vars[hash[0]] = hash[1];
            }
            return vars;
        }
    </script>

    </form>

</body>
</html>
