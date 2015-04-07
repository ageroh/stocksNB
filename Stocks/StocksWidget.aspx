<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StocksWidget.aspx.cs" Inherits="StocksNews.StocksWidget" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Stocks Widget</title>
    <base target="_parent" />
    <link rel="stylesheet" media="screen" href="css/stocks.css?v=18" />
    <script type="text/javascript" src="js/jquery-1.8.3.min.js" ></script>
    <script type="text/javascript" src="js/Flash.js?v=18" charset="windows-1253" ></script>
    <script type="text/javascript" src="js/stocks.js?v=18" charset="windows-1253" ></script>
   
</head>
<body>
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
                        <a onclick="window.open('/StocksWidget.aspx' , 'sctockswindow','menubar=no,resizable=no,width=300,height=435'); return false;" href="/x/widget/" target="_blank">
                            ΑΝΟΙΞΤΕ ΤΟ TICKER ΣΕ ΝΕΟ ΠΑΡΑΘΥΡΟ</a> »
                        </p>
                    </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</body>
</html>
