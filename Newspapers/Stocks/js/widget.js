var status=1;
var status_small=1;

$(document).ready(function() {
	
	$('#ajax-loader-widget-paper').hide();
	if($('.wrapper-big').length)
		$('.PapersWidgetPlayer').height(265);
	else
		$('.PapersWidgetPlayer').height(224);
	$('.PapersWidgetPlayer').show();
	
	if($('.arrows-big').length>0)
	{	
		$('.PapersWidgetPlayer').cycle({
			fx: 'fade' ,
			prev:'.paper-arrows .prev',
			next:'.paper-arrows .next'
		});
	}
	if($('.arrows-big').length>0)
	{	
		$('.PapersWidgetPlayer').cycle({
			fx: 'fade' ,
			prev:'.arrows-big .prev',
			next:'.arrows-big .next'
		});
	}
	
	
	$('#pause_play_widget').click(function() { 
		if(status==1)
		{
		    $('.PapersWidgetPlayer').cycle('pause'); 
			$('#pause_play_widget').removeClass('pause'); 
			$('#pause_play_widget').addClass('play'); 
			status=0;
		}
		else
		{
			$('.PapersWidgetPlayer').cycle('resume'); 
			$('#pause_play_widget').removeClass('play'); 
			$('#pause_play_widget').addClass('pause'); 
			status=1;
		}
	});
	
	
	
	
	
	if($('.arrows').length>0)
	{	
		$('.PapersWidgetPlayer').cycle({
			fx: 'fade' ,
			prev:'.paper-arrows .prev',
			next:'.paper-arrows .next'
		});
	}
	if($('.arrows').length>0)
	{	
		$('.PapersWidgetPlayer').cycle({
			fx: 'fade' ,
			prev:'.arrows .prev',
			next:'.arrows .next'
		});
	}
	
	
	$('#pause_play_widget').click(function() { 
		if(status_small==1)
		{
		    $('.PapersWidgetPlayer').cycle('pause'); 
			$('#pause_play_widget').removeClass('pause'); 
			$('#pause_play_widget').addClass('play'); 
			status_small=0;
		}
		else
		{
			$('.PapersWidgetPlayer').cycle('resume'); 
			$('#pause_play_widget').removeClass('play'); 
			$('#pause_play_widget').addClass('pause'); 
			status_small=1;
		}
	});
	
	
});



$(function() {
	
	var totalPanels			= $(".scrollContainer").children().size();
		
	var regWidth			= $(".panel").css("width");
	var regImgWidth			= $(".panel img").css("width");
	var regTitleSize		= $(".panel h2").css("font-size");
	var regParSize			= $(".panel p").css("font-size");
	
	var movingDistance	    	= 68;
	
	var curWidth			= 74;
	var curImgWidth			= 74;
	var curTitleSize		= "20px";
	var curParSize			= "15px";

	var $panels			= $('#slider .scrollContainer > div');
	var $container			= $('#slider .scrollContainer');

	$panels.css({'float' : 'left','position' : 'relative'});
    
	$("#slider").data("currentlyMoving", false);
	if($panels[0])
	{
	
	$container
		.css('width', ($panels[0].offsetWidth * $panels.length) + 50 )
		.css('left', "-74px");
	}
	var scroll = $('#slider .scroll').css('overflow', 'hidden');

	function returnToNormal(element) {
		$(element)
			.find("a")
			.removeClass("large")
		    .end()
			.animate({ width: regWidth })
			.find("img")
			.animate({ width: regImgWidth })
		    .end()			
			.find("h2")
			.animate({ fontSize: regTitleSize })
			.end()
			.find("p")
			.animate({ fontSize: regParSize });
	};
	
	function growBigger(element) {
		$(element)						
			.animate({ width: curWidth })
			.find("img")
			.animate({ width: curImgWidth })
		    .end()						
			.find("h2")
			.animate({ fontSize: curTitleSize })
			.end()
			.find("p")
			.animate({ fontSize: curParSize })
			.end()
			.find("a")
			.addClass("large").delay(4000)
		    .end();
			
	}
	
	//direction true = right, false = left
	function change(direction) {
	   
	    //if not at the first or last panel
		if((direction && !(curPanel < totalPanels)) || (!direction && (curPanel <= 1))) 
			{
				
				return false; 
			}	
        
		
		
		
		
        //if not currently moving
        if (($("#slider").data("currentlyMoving") == false)) {
			//alert('1');
			//jQuery('#scrollButtons_right').show();
            
			$("#slider").data("currentlyMoving", true);
			
			var next         = direction ? curPanel + 1 : curPanel - 1;
			var leftValue    = $(".scrollContainer").css("left");
			var movement	 = direction ? parseFloat(leftValue, 10) - movingDistance : parseFloat(leftValue, 10) + movingDistance;
		
			$(".scrollContainer")
				.stop()
				.animate({
					"left": movement
				}, function() {
					$("#slider").data("currentlyMoving", false);
				});
			
			returnToNormal("#panel_"+curPanel);
			growBigger("#panel_"+next);
			
			curPanel = next;
			
			//remove all previous bound functions
			$("#panel_"+(curPanel+1)).unbind();	
			
			//go forward
			$("#panel_"+(curPanel+1)).click(function(){ change(true); });
			
            //remove all previous bound functions															
			$("#panel_"+(curPanel-1)).unbind();
			
			//go back
			$("#panel_"+(curPanel-1)).click(function(){ change(false); }); 
			
			//remove all previous bound functions
			$("#panel_"+curPanel).unbind();
			jQuery('#scrollButtons_right').show();		
			jQuery('#scrollButtons_left').show();			
		}
		
		if (curPanel ==(totalPanels-1) )
		{			
			jQuery('#scrollButtons_right').hide();			
		}
		if (curPanel ==1 )
		{			
			jQuery('#scrollButtons_left').hide();			
		}
		
	}
	
	// Set up "Current" panel and next and prev
	growBigger("#panel_3");	
	var curPanel = 3;
	
	$("#panel_"+(curPanel+1)).click(function(){ change(true); });
	$("#panel_"+(curPanel-1)).click(function(){ change(false); });
	
	//when the left/right arrows are clicked
	$(".right").click(function(){ change(true); });	
	$(".left").click(function(){ change(false); });
	
	$(window).keydown(function(event){
	  switch (event.keyCode) {
			case 13: //enter
				$(".right").click();
				break;
			case 32: //space
				$(".right").click();
				break;
	    case 37: //left arrow
				$(".left").click();
				break;
			case 39: //right arrow
				$(".right").click();
				break;
	  }
	});
	
});