$(function(){$("a#portfolioButton").click(function(){return $("#domainPortfolio").slideToggle(400),!1}),jQuery.preloadImages=function(){for(var t=0;arguments.length>t;t++)jQuery("<img>").attr("src",arguments[t])},$.preloadImages("/assets/blogs/button-gradient-over.png","/assets/blogs/button-gradient-down.png"),$("label").css({position:"absolute",left:"3px",padding:"10px",top:"0"}),$("label").inFieldLabels(),$("#twitter").append("<p><em>Loading feed, please wait.</em></p>"),getTwitters("twitter",{id:"ycbacakoglu",count:1,enableLinks:!0,ignoreReplies:!0,clearContents:!0,template:'<p>"%text%"</p><p><a href="http://twitter.com/%user_screen_name%/" class="button" target="_blank"><img src="/assets/blogs/icons/twitter.gif" alt="twitter" />Follow Me</a></p>'});var t=$("#formSection"),e=$("#offerForm");$("a#submit").css({display:"inline-block"}),$("#submit").click(function(){return e.submit(),!1}),jQuery().ajaxStart(function(){t.block({message:null,overlayCSS:{backgroundColor:"#333"}})}).ajaxStop(function(){t.unblock()}).ajaxError(function(t,e,o){throw o}),e.validate({submitHandler:function(){e.ajaxSubmit({dataType:"script",success:function(e){t.slideUp("slow"),console.log(e),"error"==e?$(".formerror").slideDown("medium"):(console.log(e),$(".success").slideDown("medium"))}})}})});