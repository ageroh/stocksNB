<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StocksWidgetN.aspx.cs" Inherits="StocksNews.StocksWidgetN" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Stocks Widget</title>
    <base target="_parent" />
    <link rel="stylesheet" media="screen" href="css/stocks.css?v=27" />
    <script type="text/javascript" src="js/jquery-1.8.3.min.js" ></script>
    <script type="text/javascript" src="js/NewsFlash.js?v=22" charset="windows-1253" ></script>
    <script type="text/javascript" src="js/NewsStocks.js?v=22" charset="windows-1253" ></script>
    
</head>
<body class="newsWid">
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
                        <!--<img alt="stocks" src="media/stocks/metoxes_V2.jpg" />-->
                    </div>
                    <script>
                        document.write(Flash.CreateStocksWidget());
                    </script>
                    <div style="margin-top:30px;text-align:center;padding: 5px;" class="stock-ad">
                        <img src="http://webservice.inforex.gr/chart/newsgr/images/tickerLeftLogo.png" alt="">
                    </div>
                    <div class="stock-footr">
                        <span style="font-size: 9px;">Οι τιμές παρουσιάζονται με 15λεπτη καθυστέρηση. Πηγή: Globalsoft&nbsp;</span>

                    </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</body>
</html>
