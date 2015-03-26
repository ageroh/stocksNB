
var origOffsetY = $('.bottomWrapper').offset().top;// + $('#wrapper').offset().top;
var menuH = $('.bottomWrapper').height();
var logoH = $('.logo').height();

$(window).scroll(function () {
    if ($(window).scrollTop() >= origOffsetY && !$('.bottomWrapper').hasClass('sticky')) {
        $('.bottomWrapper').addClass('sticky');
		$('.logo').height(logoH + menuH);
		//console.log('add: '+$(window).scrollTop()+' >= '+origOffsetY +' MH: '+menuH+' LH: '+logoH+' RLH: '+$('.logo').height());
    }
    else if ($(window).scrollTop() < origOffsetY && $('.bottomWrapper').hasClass('sticky'))
    {
		$('.bottomWrapper').removeClass('sticky');
		$('.logo').height(logoH);
		//console.log('re: '+$(window).scrollTop()+' < '+origOffsetY +' MH: '+menuH+' LH: '+logoH+' RLH: '+$('.logo').height());
    }

});

