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
(function(e){e.InFieldLabels=function(t,n,r){var i=this;i.$label=e(t),i.label=t,i.$field=e(n),i.field=n,i.$label.data("InFieldLabels",i),i.showing=!0,i.init=function(){i.options=e.extend({},e.InFieldLabels.defaultOptions,r),i.$field.val()!=""&&(i.$label.hide(),i.showing=!1),i.$field.focus(function(){i.fadeOnFocus()}).blur(function(){i.checkForEmpty(!0)}).bind("keydown.infieldlabel",function(e){i.hideOnChange(e)}).change(function(e){i.checkForEmpty()}).bind("onPropertyChange",function(){i.checkForEmpty()})},i.fadeOnFocus=function(){i.showing&&i.setOpacity(i.options.fadeOpacity)},i.setOpacity=function(e){i.$label.stop().animate({opacity:e},i.options.fadeDuration),i.showing=e>0},i.checkForEmpty=function(e){i.$field.val()==""?(i.prepForShow(),i.setOpacity(e?1:i.options.fadeOpacity)):i.setOpacity(0)},i.prepForShow=function(e){i.showing||(i.$label.css({opacity:0}).show(),i.$field.bind("keydown.infieldlabel",function(e){i.hideOnChange(e)}))},i.hideOnChange=function(e){if(e.keyCode==16||e.keyCode==9)return;i.showing&&(i.$label.hide(),i.showing=!1),i.$field.unbind("keydown.infieldlabel")},i.init()},e.InFieldLabels.defaultOptions={fadeOpacity:.5,fadeDuration:300},e.fn.inFieldLabels=function(t){return this.each(function(){var n=e(this).attr("for");if(!n)return;var r=e("input#"+n+"[type='text'],"+"input#"+n+"[type='password'],"+"textarea#"+n);if(r.length==0)return;new e.InFieldLabels(this,r[0],t)})}})(jQuery);