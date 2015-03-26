<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StocksPage.aspx.cs" Inherits="Stocks.WebForm1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8">
	<title>Χρηματιστήριο</title>
	
    <link id="Link1" rel="stylesheet" runat="server" media="screen" href="~/css/style.css" />
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
	<script type="text/javascript" src="js/xa.js" charset="windows-1253" ></script>
    <%--<script type="text/javascript" src="js/Flash.js" charset="windows-1253" ></script>
    <script type="text/javascript" src="js/stocks.js" charset="windows-1253" ></script>--%>
    <link href='http://fonts.googleapis.com/css?family=Ubuntu|Roboto+Condensed:700&subset=greek,latin' rel='stylesheet' type='text/css'>

</head>
<body>
<%--<body style="width: 690px;height: 800px;">
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
</body>--%>

    
	<h1 class="fontRob fontB">ΧΡΗΜΑΤΙΣΤΗΡΙΟ</h1>
	
    <div class="page" runat="server" id="LoadHTML" />
	
    <div id="infoCnt">
		<h2>ΑΝΕΜΟΣ</h2>
		<table>
			<tr>
				<td>Κατηγορία Μετοχής</td>
				<td>Κατασκευαστές &amp; Υλικά Κατασκευών</td>
			</tr>
			<tr>
				<td>Τιμή Μετοχής</td>
				<td>0.33 &euro;</td>
			</tr>
			<tr>
				<td>Συνολικός Όγκος</td>
				<td>0</td>
			</tr>
		</table>
	</div>

     <p>Οι τιμές του πίνακα και του ticker παρουσιάζονται με 15λεπτη καθυστέρηση. Πηγή: <strong>Globalsoft</strong></p>

</body>	
</html>
