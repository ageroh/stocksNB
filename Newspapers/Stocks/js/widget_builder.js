jQuery(document).ready(function(){
	HookSubmitButton_Builder();
	
	HandleCheckBoxes();
	
})

var CatsSelected;
var justClickedID;
var justClicked_Status;
var justClicked_class;
var catsAlreadySelected ;
var CatsArray;
var newCats;
var catExists;
var doAjax =false;
var backOrFront;

function removeByElement(arrayName,arrayElement)
 {
    for(var i=0; i<arrayName.length;i++ )
     { 
        if(arrayName[i]==arrayElement)
            arrayName.splice(i,1); 
      } 
  }
/*
var NewsPaperAjaxRequest = function(Cats,theDate,Cover,page){
	var hash = $("input:hidden[name='hash']").val();
	var dt = $("input:hidden[name='dt']").val();
	var targetPage = "widget-xml";
	if(theDate!="")
		dt = theDate;
		
	if(page=="small")	
		targetPage = "widget-xml-200";
		
	$(".PapersWidgetPlayer").html("<img style='padding-left:80px;padding-top:120px;' src='themes/1/default/media/ajax-loader-widget.gif'/>");
	$.ajax(
	{
		
		url: "/newspapers/"+targetPage,
		type: "GET",
		cache: false,
		asynch: true,
		//data: "hash=" + hash + "&CatsSelected="+Cats+"&tp="+Cover+"&dt="+dt,
		data: "hash=" + hash + "&tp="+Cover+"&dt="+dt,
		success: function(response) {
			$(".PapersWidgetPlayer").html("");
			$("#mainFrame").html(response);
			if(justClicked_class=="selected")
				$("#share-cats-li-"+justClickedID+"").removeClass("selected");
			else
				$("#share-cats-li-"+justClickedID+"").addClass("selected");
					
			},
			error: function(XMLHttpRequest, textStatus, errorThrown) { }
	});
	
} 
*/
 
var NewsPaperAjaxRequest = function(Cats,theDate,Cover,page){
	var hash = $("input:hidden[name='hash']").val();
	var dt = $("input:hidden[name='dt']").val();
	var targetPage = "widget-xml";
	if(theDate!="")
		dt = theDate;
		
	if(page=="small")	
		targetPage = "widget-xml-200";
		
	$(".PapersWidgetPlayer").html("<img style='padding-left:80px;padding-top:120px;' src='../media/ajax-loader-widget.gif'/>");
	$.ajax(
	{
		
		url: "/newspapers/"+targetPage,
		type: "GET",
		cache: true,
		asynch: true,
		//data: "hash=" + hash + "&CatsSelected="+Cats+"&tp="+Cover+"&dt="+dt,
		data: "isClicked=1&hash=" + hash + "&tp="+Cover+"&dt="+dt,
		success: function(response) {
			$(".PapersWidgetPlayer").html("");
			$("#mainFrame").html(response);
			if(justClicked_class=="selected")
				$("#share-cats-li-"+justClickedID+"").removeClass("selected");
			else
				$("#share-cats-li-"+justClickedID+"").addClass("selected");
					
			},
			error: function(XMLHttpRequest, textStatus, errorThrown) { }
	});
	
}   
  
var ShareWidgetHandle = function()
{	
	
	jQuery("#cover-front").click(function(e) {
	
		newCats = catsAlreadySelected = $("input:hidden[name='CatsSelected']").val();
		backOrFront = $("input:hidden[name='BackOrFront']").val();
		
		if(backOrFront==2)
			{
				NewsPaperAjaxRequest(newCats,"",3,"big");
				$(this).addClass("active");
			}
		else if(backOrFront==3)		
			{
				NewsPaperAjaxRequest(newCats,"",2,"big");
				$(this).removeClass("active");
			}		
			
	})
	
	jQuery("#cover-front-small").click(function(e) {
	
		newCats = catsAlreadySelected = $("input:hidden[name='CatsSelected']").val();
		backOrFront = $("input:hidden[name='BackOrFront']").val();
		
		if(backOrFront==2)
			{
				NewsPaperAjaxRequest(newCats,"",3,"small");
				$(this).addClass("active");
			}
		else if(backOrFront==3)		
			{
				NewsPaperAjaxRequest(newCats,"",2,"small");
				$(this).removeClass("active");
			}		
			
	})
	
	jQuery("#cover-back").click(function(e) {
		
		newCats = catsAlreadySelected = $("input:hidden[name='CatsSelected']").val();
		
		backOrFront = $("input:hidden[name='BackOrFront']").val();
		if(backOrFront==1)	
			{
				NewsPaperAjaxRequest(newCats,"",3,"big");
				$(this).addClass("active");
			}
		else if(backOrFront==3)		
			{
				NewsPaperAjaxRequest(newCats,"",1,"big");
				$(this).removeClass("active");
			}
	})
	
	jQuery("#cover-back-small").click(function(e) {
		
		newCats = catsAlreadySelected = $("input:hidden[name='CatsSelected']").val();
		
		backOrFront = $("input:hidden[name='BackOrFront']").val();
		if(backOrFront==1)	
			{
				NewsPaperAjaxRequest(newCats,"",3,"small");
				$(this).addClass("active");
			}
		else if(backOrFront==3)		
			{
				NewsPaperAjaxRequest(newCats,"",1,"small");
				$(this).removeClass("active");
			}
	})
	
	*$(".dateLinks").click(function(e) {
		newCats = catsAlreadySelected = $("input:hidden[name='CatsSelected']").val();
		var dateLink = $(this).attr("id");
		//alert(dateLink);
		NewsPaperAjaxRequest(newCats,dateLink,1,"big");
		
	})
	/*$(".share-cats").click(function(e) {
		
		justClickedID = $(this).attr("id");
		catsAlreadySelected = $("input:hidden[name='CatsSelected']").val();
		backOrFront = $("input:hidden[name='BackOrFront']").val();
		CatsArray  = catsAlreadySelected.split(",");
		
		catExists = jQuery.inArray(justClickedID, CatsArray)				
		
		if(catExists == -1) //add category if not exists
		{
			doAjax = true;
			CatsArray.push(justClickedID);		
		}
		else
		{
			
			if(CatsArray.length>1)
			{			
				doAjax = true;
				removeByElement(CatsArray,justClickedID)
			}
			else //last category left
				doAjax = false;
		}
		
		
		var newCats = CatsArray.join(",");		
		
		
		if(doAjax)
		{
			
			justClicked_class = $("#share-cats-li-"+justClickedID).attr("class");			 
			CatsSelected = $(this).attr("id");
			NewsPaperAjaxRequest(newCats,"",backOrFront);
				
		}
	 });
	 */

}

ShareWidgetHandle();



function handleCssStatus(id)
{
	jQuery("#cover-front").addClass("active");
	jQuery("#cover-back").removeClass("active");
	if(id==1)
	{
		$("#old_dates2").removeClass("active");			
		$("#old_dates3").removeClass("active");	
		$("#old_dates4").removeClass("active");	
		$("#old_dates5").removeClass("active");	
		$("#old_dates1").addClass("active");
	}
	else if(id==2)
	{
		$("#old_dates1").removeClass("active");			
		$("#old_dates3").removeClass("active");	
		$("#old_dates4").removeClass("active");	
		$("#old_dates5").removeClass("active");	
		$("#old_dates2").addClass("active");
	}
	else if(id==3)
	{
		$("#old_dates1").removeClass("active");			
		$("#old_dates2").removeClass("active");	
		$("#old_dates4").removeClass("active");	
		$("#old_dates5").removeClass("active");	
		$("#old_dates3").addClass("active");
	}
	else if(id==4)
	{
		$("#old_dates1").removeClass("active");			
		$("#old_dates3").removeClass("active");	
		$("#old_dates2").removeClass("active");	
		$("#old_dates5").removeClass("active");	
		$("#old_dates4").addClass("active");
	}
	else if(id==5)
	{
		$("#old_dates1").removeClass("active");			
		$("#old_dates3").removeClass("active");	
		$("#old_dates4").removeClass("active");	
		$("#old_dates2").removeClass("active");	
		$("#old_dates5").addClass("active");
	}
}

var HandleCheckBoxes = function(){

	$(':checkbox').each(function() {
	 $(this).click(function(e) {
		if($(this).val()=='ALL')
			{
				if($(this).attr('checked')==true)
				{
				$(':checkbox').each(function() {
					$(this).attr('checked','checked');
				})
				}
			}
		else
			$("#ALL").attr('checked',false);
	 })
	});

}



var HookSubmitButton_Builder = function() {
    jQuery("#btnSubmitWidgetBuilder").click(function(e) {
        e.preventDefault();        
        SubmitForm_Builder();
    });
};



var SubmitForm_Builder = function() {
	var result = true;
	var error_string="";
	
        if ($('#widget_domain').val() == "") {
            error_string = error_string + "<br/>Συμπληρώστε το domain";
            result = false;	    
        }  
	
	if ($('#widget_width300').attr('checked')==false &&  $('#widget_width200').attr('checked')==false ) {
		
            error_string = error_string + "<br/>Επιλέξτε πλάτος";
            result = false;
        }  	
	var boxes = $('input[name$="cats"]').serializeArray();
	if(boxes.length==0)
		{
			error_string = error_string + "<br/>Επιλέξτε κατηγορία(ες)";
			result = false;
		}
	

        if (result == true) {
            $('div#errorBox').html("");
	    $('div#errorBox').hide();
	    doSubmit();
        }
        else
	    {
		$('div#errorBox').html("<p class='errorP' style='color:red'>"+error_string+"</p>");
		$('div#errorBox').show();
	    }
	    
	//alert(error_string);
}



var doSubmit = function() {


	var domain = $('#widget_domain').val() ;
	var width ;
	var cats="";
	var counter=0;
	 if ($('#widget_width300').attr('checked')==false &&  $('#widget_width200').attr('checked')==true ) 
	 {
		width  = 200;
	 }
	 else
		width  = 300;
		
	 
	var boxes = $('input[name$="cats"]').serializeArray();
	jQuery.each(boxes, function(i, field){
		if(counter==0)
		{
			//cats = "'"+field.value+"'";
			cats = field.value;
			counter = counter+1;
		}
		else
		{
			cats = cats +","+ field.value;
			counter = counter+1;
		}
		if(field.value=='ALL')
		{
			cats = "ALL";
			return false;
		}
	});
	
    
   
    $.ajax({
        url: "/newspapersBuilderWidget.aspx",
        type: "GET",
        data: "&cats=" + cats + "&domain=" + domain + "&width=" + width ,
        cache: false,
        success: function(response) {
            $("#widget_script").val(response);
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) { }
    });
    
};


function MyNewsletterService(email, newsletter, reportsD,reportsW) {
    var formid;
    
    if (newsletter == 1) {
        formid = 93;
    }
    if (newsletter == 0) {
        formid = 94;
    }
                    
    $.ajax({
        url: "/newsletterServices.aspx",
        type: "POST",
        cache: false,
        asynch: true,        
        data: "email=" + email + "&fmrid="+formid,
        success: function(response) {
        },
        error: function(XMLHttpRequest, textStatus, errorThrown) { }
    });

    if (reportsD == 1) {
        $.ajax({
            url: "/newsletterServices.aspx",
            type: "POST",
            cache: false,
            asynch: true,
            data: "email=" + email + "&fmrid=95",
            success: function(response) {

            },
            error: function(XMLHttpRequest, textStatus, errorThrown) { }
        });
     }
	 if (reportsD == 0) {
        $.ajax({
            url: "/newsletterServices.aspx",
            type: "POST",
            cache: false,
            asynch: true,
            data: "email=" + email + "&fmrid=96",
            success: function(response) {

            },
            error: function(XMLHttpRequest, textStatus, errorThrown) { }
        });
    }
	if (reportsW == 0) {
        $.ajax({
            url: "/newsletterServices.aspx",
            type: "POST",
            cache: false,
            asynch: true,
            data: "email=" + email + "&fmrid=98",
            success: function(response) {

            },
            error: function(XMLHttpRequest, textStatus, errorThrown) { }
        });
    }
    if (reportsW == 1) {
         $.ajax({
            url: "/newsletterServices.aspx",
            type: "POST",
            cache: false,
            asynch: true,
            data: "email=" + email + "&fmrid=97",
            success: function(response) {

            },
            error: function(XMLHttpRequest, textStatus, errorThrown) { }
        });
	}

    
}



