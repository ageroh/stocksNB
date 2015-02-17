<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StocksPage.aspx.cs" Inherits="Stocks.WebForm1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link id="Link1" rel="stylesheet" runat="server" media="screen" href="~/css/stocks.css" />
    <script type="text/javascript" src="js/jquery-1.8.3.min.js" ></script>
    <script type="text/javascript" src="js/Flash.js" charset="windows-1253" ></script>
    <script type="text/javascript" src="js/stocks.js" charset="windows-1253" ></script>
</head>
<body style="width: 690px;height: 800px;">
    <div id="customStocksPage">
        <div id="wrapper">
            <div id="content">
                <div id="col-full">
                </div>
                <div id="col-left">
                    <div class="page" runat="server" id="LoadHTML">
                        <!-- StocksIndex goes here !! -->
                    </div>
                </div>
                <div class="commentStocks">
                    <p>Οι τιμές του πίνακα και του ticker παρουσιάζονται με 15λεπτη καθυστέρηση. Πηγή: <strong>Globalsoft</strong></p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
