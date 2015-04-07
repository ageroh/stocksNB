$(function(){
	
	var $w = $(window),
		$infoCnt = $("#infoCnt");
	

//--- Build ---
	var $stocksCnt = $(".stocksCnt"),
		groups = {};

	//normalize
	for(var s in stocks) {
		var thisStock = stocks[s];
		var letterGroup = s.charAt(0);
		
		if (!groups[letterGroup])
			groups[letterGroup] = [];

		groups[letterGroup].push({ name: s, details: thisStock});
	}

	//display
	var tableHtml = '';
	for(var s in groups) {
		var $divGroup = $('<div><div class="block"><h3>' + s + '</h3></div></div>');
		var $divStocks = $('<div class="linksCnt"></div>');
		$divGroup.find(".block").append($divStocks);

		$.each(groups[s], function(i,stock){
			$divStocks.append('<a href="#">' + stock.name + "</a>");
		});
		

		tableHtml += $divGroup.html();
	}
	
	$stocksCnt.html( tableHtml );

	$infoCnt.click(function(e){ e.stopPropagation(); });
	
	var $lnks = $(".linksCnt a");
	$lnks.on("click", function(e){
		e.preventDefault();
		e.stopPropagation();
		var $el = $(e.currentTarget),
			elW = $el.outerWidth(),
			elH = $el.outerHeight(),
			elX = $el.offset().left,
			elY = $el.offset().top;
		
		if ($el.hasClass("selected")){
			closeInfo();
			return;
		}
		
		$lnks.filter(".selected").removeClass("selected");
		$el.addClass("selected");
		
		openInfo(elX,elY,elW,elH, $el.text());
	});

	//Open PopUp
	function openInfo(elX,elY,elW,elH,stockID) {
				
		var infoW =  $infoCnt.width(),
			infoH = $infoCnt.outerHeight(),
			wWidth = $w.width(),
			wHeight = $w.outerHeight(),
			top = elY + elH + 3,
			bottom = (wHeight-elY) + 3,
			right = (wWidth-elX)-elW;

		//get stock data
		var _dt = stocks[stockID];
		if (typeof _dt == undefined) {
			//TODO: what happends here?
			return;
		}

		//display data
		$infoCnt.empty();

		stockDesc = "";
		if( _dt["Stocks_StockDesc"] != null)
    		stockDesc = _dt["Stocks_StockDesc"].value;
		
		stockPrice = 0;
		diffPrice = 0.0;
		if (_dt["% Διαφορά Τιμής"] != null)
		    diffPrice = _dt["% Διαφορά Τιμής"].value;

		typePrice = "";
		if (_dt["Τιμή Μετοχής"] != null)
		    stockPrice = _dt["Τιμή Μετοχής"].value;

		if (diffPrice > 0.0) typePrice = " green";
		if (diffPrice < 0.0) typePrice = " red";

		var _infoHtml = '<h2>' + stockID + '</h2>';
		_infoHtml += '<span class="stockdesc">' + stockDesc + '</span>';
		_infoHtml += '<span class="price' + typePrice + '">' + stockPrice + '</span>';

		if (stockPrice != 0)
            _infoHtml += '<span class="diffPrice">' + diffPrice + '%</span>';
		

		_infoHtml += '<table>';
		
        $.each(_dt, function(i,el){

		    if (i != "Stocks_StockDesc") {
		        _infoHtml += '<tr>';
		        _infoHtml += '<td>' + i + '<td>';
		        _infoHtml += '<td>' + el.value + '<td>';
		        _infoHtml += '</tr>';
		    }
		});
		_infoHtml += '</table>';
		$infoCnt.html(_infoHtml);
				
		//Stick to right
		if ((elX+infoW) > wWidth)
			$infoCnt.css({"top":top,"right":right,"left":"auto","bottom":"auto"});
		else
			$infoCnt.css({"top":top,"left":elX,"right":"auto","bottom":"auto"});
		
		//Stick to bottom
		if ((elY+infoH) > wHeight)
			$infoCnt.css({"top":"auto","bottom":bottom});
		
		//Show Info Pop Up
		$infoCnt.fadeIn();
	};
	
	//Close PopUp
	function closeInfo(){
		$lnks.removeClass("selected");
		$infoCnt.hide();
	}
	
//	$w.resize(function(){
//		closeInfo();
//	});
	
//	$("html,body").click(function(){
//		closeInfo();
//	});
	
});