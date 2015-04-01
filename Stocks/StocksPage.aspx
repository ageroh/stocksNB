<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StocksPage.aspx.cs" Inherits="Stocks.WebForm1" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8"/>
	<title>Χρηματιστήριο</title>
    <link rel="stylesheet" media="screen" href="css/style.css?v=18" />
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
	<script type="text/javascript" src="js/xa.js?v=18" charset="windows-1253" ></script>
    <link href='http://fonts.googleapis.com/css?family=Ubuntu|Roboto+Condensed:700&subset=greek,latin' rel='stylesheet' type='text/css'/>
    <script type="text/javascript">

        $(function () {

            var _tmrResize = null;
            $(window).on("resize orientationchange", _resizeEvent);

            function _resizeEvent(e) {
                if (_tmrResize != null) {
                    clearTimeout(_tmrResize);
                }
                _tmrResize = setTimeout(_doResize, 250);
            }

            function _doResize() {
                if (_tmrResize != null)
                    clearTimeout(_tmrResize);
                _tmrResize = null;

                //sto diko mas... 8a htan kati tetoio...
                var _h = $(document).height();
                window.parent.setIFrameHeight(_h);
            }
        });
    </script>
</head>
<body oninit="_doResize();">
    
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
