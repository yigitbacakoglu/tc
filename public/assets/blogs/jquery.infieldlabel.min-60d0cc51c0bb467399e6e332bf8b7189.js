/*
 * In-Field Label jQuery Plugin
 * http://fuelyourcoding.com/in-field-labels/
 *
 * Copyright (c) 2009 Doug Neiner
 * Dual licensed under the MIT and GPL licenses.
 * Uses the same license as jQuery, see:
 * http://docs.jquery.com/License
 *
 * @version 0.1
 */
(function(n){n.InFieldLabels=function(e,i,t){var o=this;o.$label=n(e),o.label=e,o.$field=n(i),o.field=i,o.$label.data("InFieldLabels",o),o.showing=!0,o.init=function(){o.options=n.extend({},n.InFieldLabels.defaultOptions,t),""!=o.$field.val()&&(o.$label.hide(),o.showing=!1),o.$field.focus(function(){o.fadeOnFocus()}).blur(function(){o.checkForEmpty(!0)}).bind("keydown.infieldlabel",function(n){o.hideOnChange(n)}).change(function(){o.checkForEmpty()}).bind("onPropertyChange",function(){o.checkForEmpty()})},o.fadeOnFocus=function(){o.showing&&o.setOpacity(o.options.fadeOpacity)},o.setOpacity=function(n){o.$label.stop().animate({opacity:n},o.options.fadeDuration),o.showing=n>0},o.checkForEmpty=function(n){""==o.$field.val()?(o.prepForShow(),o.setOpacity(n?1:o.options.fadeOpacity)):o.setOpacity(0)},o.prepForShow=function(){o.showing||(o.$label.css({opacity:0}).show(),o.$field.bind("keydown.infieldlabel",function(n){o.hideOnChange(n)}))},o.hideOnChange=function(n){16!=n.keyCode&&9!=n.keyCode&&(o.showing&&(o.$label.hide(),o.showing=!1),o.$field.unbind("keydown.infieldlabel"))},o.init()},n.InFieldLabels.defaultOptions={fadeOpacity:.5,fadeDuration:300},n.fn.inFieldLabels=function(e){return this.each(function(){var i=n(this).attr("for");if(i){var t=n("input#"+i+"[type='text'],"+"input#"+i+"[type='password'],"+"textarea#"+i);0!=t.length&&new n.InFieldLabels(this,t[0],e)}})}})(jQuery);