<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StocksWidget.aspx.cs" Inherits="StocksNewsBeast.StocksWidget" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Stocks Widget</title>
    <base target="_parent" />
    <link rel="stylesheet" media="screen" href="css/stocks.css?v=30" />
    <script type="text/javascript" src="js/jquery-1.8.3.min.js" ></script>
    <script type="text/javascript" src="js/NewsFlash.js?v=41" charset="windows-1253" ></script>
    <script type="text/javascript" src="js/NewsStocks.js?v=42" charset="windows-1253" ></script>
   <script type="text/javascript">
       
       function initDom() {
           window.document.domain = "newsbeast.gr"; //getUrlVars()["u"];
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
</head>
<body onload="initDom()">
    <div id="customWidgetStocks">
        <div id="wrapper">
            <div id="content">
                <div id="col-full">
                </div>
                <div id="col-left">
                </div>
                <div id="col-right">
                    <div style="position: relative;" class="stocks-widget-for-others">
                    <div style="position: absolute; top: 16px;">
                        <img alt="stocks" src="media/stocks/metoxes_V2.jpg" />
                    </div>
                    <script>
                        document.write(Flash.CreateStocksWidget());
                    </script>
                    <div style="margin-top: 0px;" class="stock-ad">
                        <a href="http://www.piraeusbank.gr/" target="_blank"><img alt="" src="media/stocks/metoxesBottom.jpg" /></a>
                    </div>
                    <div class="stock-footr">
                        <span style="font-size: 9px;">Οι τιμές παρουσιάζονται με 15λεπτη καθυστέρηση. Πηγή: Globalsoft&nbsp;</span>
                        <p>
                        <a  href="http://stage.newsbeast.gr/xrimatistirio" target="_parent">
                            ΔΕΙΤΕ ΟΛΕΣ ΤΙΣ ΜΕΤΟΧΕΣ</a> »
                        </p>
                    </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</body>
</html>
