// This JavaScript file activates and customizes plugins.
/* =====================================
	Contents :
	1. Toggle Domain Portfolio
	2. Preload Images
	3. Enhance Form Labels
	4. Load Twitter Feed
	5. Form Validating/Processing
===================================== */
$(function(){$("a#portfolioButton").click(function(){return $("#domainPortfolio").slideToggle(400),!1}),jQuery.preloadImages=function(){for(var e=0;e<arguments.length;e++)jQuery("<img>").attr("src",arguments[e])},$.preloadImages("/assets/blogs/button-gradient-over.png","/assets/blogs/button-gradient-down.png"),$("label").css({position:"absolute",left:"3px",padding:"10px",top:"0"}),$("label").inFieldLabels(),$("#twitter").append("<p><em>Loading feed, please wait.</em></p>"),getTwitters("twitter",{id:"ycbacakoglu",count:1,enableLinks:!0,ignoreReplies:!0,clearContents:!0,template:'<p>"%text%"</p><p><a href="http://twitter.com/%user_screen_name%/" class="button" target="_blank"><img src="/assets/blogs/icons/twitter.gif" alt="twitter" />Follow Me</a></p>'});var e=$("#formSection"),t=$("#offerForm");$("a#submit").css({display:"inline-block"}),$("#submit").click(function(){return t.submit(),!1}),jQuery().ajaxStart(function(){e.block({message:null,overlayCSS:{backgroundColor:"#333"}})}).ajaxStop(function(){e.unblock()}).ajaxError(function(e,t,n){throw n}),t.validate({submitHandler:function(n){t.ajaxSubmit({dataType:"script",success:function(t){e.slideUp("slow"),console.log(t),t=="error"?$(".formerror").slideDown("medium"):(console.log(t),$(".success").slideDown("medium"))}})}})});