<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StocksPageN.aspx.cs" Inherits="StocksNews.StocksPageN" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta charset="UTF-8" />
	<title>Χρηματιστήριο</title>
	
    <link rel="stylesheet" media="screen" href="css/style.css?v=23" />
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
	<script type="text/javascript" src="js/NewsXa.js?v=23" charset="windows-1253" ></script>

    <link rel="stylesheet" href="//cdn.jsdelivr.net/chartist.js/latest/chartist.min.css" />
    <script src="//cdn.jsdelivr.net/chartist.js/latest/chartist.min.js"></script>

    <link href='http://fonts.googleapis.com/css?family=Ubuntu|Roboto+Condensed:700&subset=greek,latin' rel='stylesheet' type='text/css'/>

    <script type="text/javascript">
        
        function checkOnLoad() {
            var stock = getUrlVars()["stock"];
            if (stock == '' || stock == null) {
                $(".newstmp").css("display", "none");
                // remove everything.
                $("#LoadHTML").remove();

            }
            else {
                // enable dd
                DisplayStockDetails(stock);
            }
        }



        function DisplayStockDetails(stock) {
            $(".newstmp").css("display", "block");
            $(".stocksCnt").css("display", "none");
            stk = decodeURI(stock);

            //populate DD if its not already populated.
            if ($("#allStocksDD").find('option').length <= 1)
                PopulateDDStocks(stk);


            $(".linksCnt a").each(function (e) {
                if ( allStocks[$(this).text()].Stock.value === stk)
                {
                    // alert("found stock");
                    $(this).trigger("click");


                    //$(".stocksCnt").remove();
                    $("#infoCnt").removeAttr('style');
                    $("#infoCnt").css('top', 'auto').css('left', 'auto');
                    $("#infoCnt").css('display', 'block');

                    // All you need to do is pass your configuration as third parameter to the chart function
                    new Chartist.Line('.ct-chart', dataStockWeek, optionsStocks);

                    return;
                }
            });

        }


        function PopulateDDStocks(stock) {
            if (allStocks != null) {
                var option = '';
                
                for (var x in allStocks) {
                    cssClassStock = "ok";
                    /*
                    for (var t1 in tmpdataStockWeek) {
                        if( tmpdataStockWeek[t1] != null)
                            if( tmpdataStockWeek[t1].VolumeWeek.value == 0)
                            { 
                                cssClassStock = "notNegotiate";  
                                break;
                            }
                    }
                    */
                    option += '<option class="'+ cssClassStock + '" value="' + allStocks[x].Stock.value + '">' + x + '</option>';
                }

                $('#allStocksDD').append(option);

                if (stock != '')
                    $('#allStocksDD').val(stock);
            }
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
<body class="newstmp"  onload="checkOnLoad();">
    
	<%--<h1 class="fontRob fontB">ΧΡΗΜΑΤΙΣΤΗΡΙΟ</h1>
	--%>
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

     
    
    <div class="graphStock">
        <span style="display: block;margin-bottom: .5em;">Δεκαήμερη μεταβολή κλεισίματος της μετοχής.</span>
        <div class="ct-chart ct-major-second"></div>
    </div>
<div class="selCont">
        <span>Eπιλέξτε άλλη μετοχή:</span>
        <select id="allStocksDD" name="allStocksDD"></select>
        <span style="display:block;font-size:12px;margin-top:10px">Οι τιμές παρουσιάζονται με 15λεπτη καθυστέρηση. Πηγή: <strong>Globalsoft</strong></span>
    </div>

    

<script type="text/javascript">
    /* options for Chartist.JS */
    dataStockWeek = null;
    var highs = [];
    var lows = [];
    var closes = [];
    var lb = [];
    hsVal = false;

    var dataStockWeek = {
        labels: [],
        series: []
    };

    i = 0;
    for (var stk in tmpdataStockWeek) {
        //dataStockWeek.labels.push(stk);
        lb.push(stk);
        highs.push(tmpdataStockWeek[stk].HighWeek.value);
        lows.push(tmpdataStockWeek[stk].LowWeek.value);
        closes.push(tmpdataStockWeek[stk].CloseWeek.value);
        if (tmpdataStockWeek[stk].CloseWeek.value != 0)
            hsVal = true;
        i++;
    }

    dataStockWeek.labels = lb.reverse();
   // dataStockWeek.series.push(highs.reverse());
   // dataStockWeek.series.push(lows.reverse());
    dataStockWeek.series.push(closes.reverse());

    //  var options = { seriesBarDistance: 15 };
    // We are setting a few options for our chart and override the defaults
    var optionsStocks = {
        // Don't draw the line chart points
        showPoint: true,
        // Disable line smoothing
        lineSmooth: false,
	chartPadding: 40
        //// X-Axis specific configuration
        //axisX: {
        //    // We can disable the grid for this axis
        //    showGrid: false,
        //    // and also don't show the label
        //    showLabel: true
        //},
        //// Y-Axis specific configuration
        //axisY: {
        //    // Lets offset the chart a bit from the labels
        //    offset: 60,
        //    // The label interpolation function enables you to modify the values
        //    // used for the labels on each axis. Here we are converting the
        //    // values into million pound.
        //    labelInterpolationFnc: function (value) {
        //        return '$' + value + 'm';
        //    }
        //}
    };

    if (hsVal) {
        // All you need to do is pass your configuration as third parameter to the chart function
	Chartist.precision = 2;
        new Chartist.Line('.ct-chart', dataStockWeek, optionsStocks);
    }
    else {
        $(".graphStock").css('display', 'none');
    }


    $('#allStocksDD').change(function () {

        if ($(this).val() != null) {
            urlh = document.location.href;
            sUrl = urlh.substr(0, urlh.indexOf("?stock=") + 7);

            //document.location.href = sUrl + $(this).val();
            window.top.location.href = "http://www.news.gr/stockdetails?symbol=" + $(this).val();

            //        DisplayStockDetails($(this).val());
        }
    });
</script>

</body>	
</html>
