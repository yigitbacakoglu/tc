// This JavaScript file activates and customizes plugins.

/* =====================================
	Contents :
	1. Toggle Domain Portfolio
	2. Preload Images
	3. Enhance Form Labels
	4. Load Twitter Feed
	5. Form Validating/Processing
===================================== */

$(function(){ // When the page is loaded...


	// 1. Toggle the Domain Portfolio to hide and show your domain list
	// =====================================================================================================

	$('a#portfolioButton').click(function() {
		$('#domainPortfolio').slideToggle(400);
		return false;
	});


	// 2. Simple preload images script by http://www.mattfarina.com/2007/02/01/preloading_images_with_jquery
	// =====================================================================================================
	jQuery.preloadImages = function()
	{
	  for(var i = 0; i<arguments.length; i++)
	  {
		jQuery("<img>").attr("src", arguments[i]);
	  }
	}
	$.preloadImages("/assets/blogs/button-gradient-over.png", "/assets/blogs/button-gradient-down.png"); // The list of images to preload


	// 3. Enhanced form label
	// ======================

	$("label").css({'position' : 'absolute', 'left' : '3px', 'padding' : '10px', 'top' : '0'});
	$("label").inFieldLabels();


	// 4. Load Twitter Feed
	// ====================

	// display loading message
	$("#twitter").append("<p><em>Loading feed, please wait.</em></p>");

	getTwitters('twitter', {
		id: 'ycbacakoglu', // Your Twitter ID here
		count: 1,
		enableLinks: true,
		ignoreReplies: true,
		clearContents: true,
		template: '<p>"%text%"</p><p><a href="http://twitter.com/%user_screen_name%/" class="button" target="_blank"><img src="/assets/blogs/icons/twitter.gif" alt="twitter" />Follow Me</a></p>'
	});


	// 5. Validate, then Send the Form
	// ===============================

	// cached selectors
	var formSection = $('#formSection');
	var offerForm = $('#offerForm');

	$("a#submit").css({'display' : 'inline-block'});

	// Set the anchor tag to submit form
	$("#submit").click(function(){
		offerForm.submit();
		return false;
	});

	// Block the form while it is processing
	jQuery().ajaxStart(function() {
		formSection.block({ message: null, overlayCSS: { backgroundColor: '#333' } }); // Loading
	}).ajaxStop(function() {
		formSection.unblock();
	}).ajaxError(function(a, b, e) {
		throw e;
	});
	// Validate form
	offerForm.validate({
		submitHandler: function(form) {
			// Submit form
			offerForm.ajaxSubmit({
                dataType: 'script',
				success: function(msg) {
					formSection.slideUp('slow');
                    console.log(msg);
					if(msg == 'error')
					{
						$('.formerror').slideDown('medium');
					}
					else
					{       console.log(msg);
						$('.success').slideDown('medium');
					}
				}
	   		});
		}
	});

});