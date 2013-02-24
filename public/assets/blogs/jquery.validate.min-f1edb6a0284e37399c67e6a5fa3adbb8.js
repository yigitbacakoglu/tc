/*
 * jQuery validation plug-in 1.5.5
 *
 * http://bassistance.de/jquery-plugins/jquery-plugin-validation/
 * http://docs.jquery.com/Plugins/Validation
 *
 * Copyright (c) 2006 - 2008 Jörn Zaefferer
 *
 * $Id: jquery.validate.js 6403 2009-06-17 14:27:16Z joern.zaefferer $
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 * OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
(function(e){e.extend(e.fn,{validate:function(t){if(!this.length){t&&t.debug&&window.console&&console.warn("nothing selected, can't validate, returning nothing");return}var n=e.data(this[0],"validator");return n?n:(n=new e.validator(t,this[0]),e.data(this[0],"validator",n),n.settings.onsubmit&&(this.find("input, button").filter(".cancel").click(function(){n.cancelSubmit=!0}),n.settings.submitHandler&&this.find("input, button").filter(":submit").click(function(){n.submitButton=this}),this.submit(function(t){function r(){if(n.settings.submitHandler){if(n.submitButton)var t=e("<input type='hidden'/>").attr("name",n.submitButton.name).val(n.submitButton.value).appendTo(n.currentForm);return n.settings.submitHandler.call(n,n.currentForm),n.submitButton&&t.remove(),!1}return!0}return n.settings.debug&&t.preventDefault(),n.cancelSubmit?(n.cancelSubmit=!1,r()):n.form()?n.pendingRequest?(n.formSubmitted=!0,!1):r():(n.focusInvalid(),!1)})),n)},valid:function(){if(e(this[0]).is("form"))return this.validate().form();var t=!0,n=e(this[0].form).validate();return this.each(function(){t&=n.element(this)}),t},removeAttrs:function(t){var n={},r=this;return e.each(t.split(/\s/),function(e,t){n[t]=r.attr(t),r.removeAttr(t)}),n},rules:function(t,n){var r=this[0];if(t){var i=e.data(r.form,"validator").settings,s=i.rules,o=e.validator.staticRules(r);switch(t){case"add":e.extend(o,e.validator.normalizeRule(n)),s[r.name]=o,n.messages&&(i.messages[r.name]=e.extend(i.messages[r.name],n.messages));break;case"remove":if(!n)return delete s[r.name],o;var u={};return e.each(n.split(/\s/),function(e,t){u[t]=o[t],delete o[t]}),u}}var a=e.validator.normalizeRules(e.extend({},e.validator.metadataRules(r),e.validator.classRules(r),e.validator.attributeRules(r),e.validator.staticRules(r)),r);if(a.required){var f=a.required;delete a.required,a=e.extend({required:f},a)}return a}}),e.extend(e.expr[":"],{blank:function(t){return!e.trim(t.value)},filled:function(t){return!!e.trim(t.value)},unchecked:function(e){return!e.checked}}),e.validator=function(t,n){this.settings=e.extend({},e.validator.defaults,t),this.currentForm=n,this.init()},e.validator.format=function(t,n){return arguments.length==1?function(){var n=e.makeArray(arguments);return n.unshift(t),e.validator.format.apply(this,n)}:(arguments.length>2&&n.constructor!=Array&&(n=e.makeArray(arguments).slice(1)),n.constructor!=Array&&(n=[n]),e.each(n,function(e,n){t=t.replace(new RegExp("\\{"+e+"\\}","g"),n)}),t)},e.extend(e.validator,{defaults:{messages:{},groups:{},rules:{},errorClass:"error",validClass:"valid",errorElement:"label",focusInvalid:!0,errorContainer:e([]),errorLabelContainer:e([]),onsubmit:!0,ignore:[],ignoreTitle:!1,onfocusin:function(e){this.lastActive=e,this.settings.focusCleanup&&!this.blockFocusCleanup&&(this.settings.unhighlight&&this.settings.unhighlight.call(this,e,this.settings.errorClass,this.settings.validClass),this.errorsFor(e).hide())},onfocusout:function(e){!this.checkable(e)&&(e.name in this.submitted||!this.optional(e))&&this.element(e)},onkeyup:function(e){(e.name in this.submitted||e==this.lastElement)&&this.element(e)},onclick:function(e){e.name in this.submitted&&this.element(e)},highlight:function(t,n,r){e(t).addClass(n).removeClass(r)},unhighlight:function(t,n,r){e(t).removeClass(n).addClass(r)}},setDefaults:function(t){e.extend(e.validator.defaults,t)},messages:{required:"This field is required.",remote:"Please fix this field.",email:"Please enter a valid email address.",url:"Please enter a valid URL.",date:"Please enter a valid date.",dateISO:"Please enter a valid date (ISO).",dateDE:"Bitte geben Sie ein gültiges Datum ein.",number:"Please enter a valid number.",numberDE:"Bitte geben Sie eine Nummer ein.",digits:"Please enter only digits",creditcard:"Please enter a valid credit card number.",equalTo:"Please enter the same value again.",accept:"Please enter a value with a valid extension.",maxlength:e.validator.format("Please enter no more than {0} characters."),minlength:e.validator.format("Please enter at least {0} characters."),rangelength:e.validator.format("Please enter a value between {0} and {1} characters long."),range:e.validator.format("Please enter a value between {0} and {1}."),max:e.validator.format("Please enter a value less than or equal to {0}."),min:e.validator.format("Please enter a value greater than or equal to {0}.")},autoCreateRanges:!1,prototype:{init:function(){function r(t){var n=e.data(this[0].form,"validator");n.settings["on"+t.type]&&n.settings["on"+t.type].call(n,this[0])}this.labelContainer=e(this.settings.errorLabelContainer),this.errorContext=this.labelContainer.length&&this.labelContainer||e(this.currentForm),this.containers=e(this.settings.errorContainer).add(this.settings.errorLabelContainer),this.submitted={},this.valueCache={},this.pendingRequest=0,this.pending={},this.invalid={},this.reset();var t=this.groups={};e.each(this.settings.groups,function(n,r){e.each(r.split(/\s/),function(e,r){t[r]=n})});var n=this.settings.rules;e.each(n,function(t,r){n[t]=e.validator.normalizeRule(r)}),e(this.currentForm).delegate("focusin focusout keyup",":text, :password, :file, select, textarea",r).delegate("click",":radio, :checkbox",r),this.settings.invalidHandler&&e(this.currentForm).bind("invalid-form.validate",this.settings.invalidHandler)},form:function(){return this.checkForm(),e.extend(this.submitted,this.errorMap),this.invalid=e.extend({},this.errorMap),this.valid()||e(this.currentForm).triggerHandler("invalid-form",[this]),this.showErrors(),this.valid()},checkForm:function(){this.prepareForm();for(var e=0,t=this.currentElements=this.elements();t[e];e++)this.check(t[e]);return this.valid()},element:function(t){t=this.clean(t),this.lastElement=t,this.prepareElement(t),this.currentElements=e(t);var n=this.check(t);return n?delete this.invalid[t.name]:this.invalid[t.name]=!0,this.numberOfInvalids()||(this.toHide=this.toHide.add(this.containers)),this.showErrors(),n},showErrors:function(t){if(t){e.extend(this.errorMap,t),this.errorList=[];for(var n in t)this.errorList.push({message:t[n],element:this.findByName(n)[0]});this.successList=e.grep(this.successList,function(e){return!(e.name in t)})}this.settings.showErrors?this.settings.showErrors.call(this,this.errorMap,this.errorList):this.defaultShowErrors()},resetForm:function(){e.fn.resetForm&&e(this.currentForm).resetForm(),this.submitted={},this.prepareForm(),this.hideErrors(),this.elements().removeClass(this.settings.errorClass)},numberOfInvalids:function(){return this.objectLength(this.invalid)},objectLength:function(e){var t=0;for(var n in e)t++;return t},hideErrors:function(){this.addWrapper(this.toHide).hide()},valid:function(){return this.size()==0},size:function(){return this.errorList.length},focusInvalid:function(){if(this.settings.focusInvalid)try{e(this.findLastActive()||this.errorList.length&&this.errorList[0].element||[]).filter(":visible").focus()}catch(t){}},findLastActive:function(){var t=this.lastActive;return t&&e.grep(this.errorList,function(e){return e.element.name==t.name}).length==1&&t},elements:function(){var t=this,n={};return e([]).add(this.currentForm.elements).filter(":input").not(":submit, :reset, :image, [disabled]").not(this.settings.ignore).filter(function(){return!this.name&&t.settings.debug&&window.console&&console.error("%o has no name assigned",this),this.name in n||!t.objectLength(e(this).rules())?!1:(n[this.name]=!0,!0)})},clean:function(t){return e(t)[0]},errors:function(){return e(this.settings.errorElement+"."+this.settings.errorClass,this.errorContext)},reset:function(){this.successList=[],this.errorList=[],this.errorMap={},this.toShow=e([]),this.toHide=e([]),this.formSubmitted=!1,this.currentElements=e([])},prepareForm:function(){this.reset(),this.toHide=this.errors().add(this.containers)},prepareElement:function(e){this.reset(),this.toHide=this.errorsFor(e)},check:function(t){t=this.clean(t),this.checkable(t)&&(t=this.findByName(t.name)[0]);var n=e(t).rules(),r=!1;for(method in n){var i={method:method,parameters:n[method]};try{var s=e.validator.methods[method].call(this,t.value.replace(/\r/g,""),t,i.parameters);if(s=="dependency-mismatch"){r=!0;continue}r=!1;if(s=="pending"){this.toHide=this.toHide.not(this.errorsFor(t));return}if(!s)return this.formatAndAdd(t,i),!1}catch(o){throw this.settings.debug&&window.console&&console.log("exception occured when checking element "+t.id+", check the '"+i.method+"' method"),o}}if(r)return;return this.objectLength(n)&&this.successList.push(t),!0},customMetaMessage:function(t,n){if(!e.metadata)return;var r=this.settings.meta?e(t).metadata()[this.settings.meta]:e(t).metadata();return r&&r.messages&&r.messages[n]},customMessage:function(e,t){var n=this.settings.messages[e];return n&&(n.constructor==String?n:n[t])},findDefined:function(){for(var e=0;e<arguments.length;e++)if(arguments[e]!==undefined)return arguments[e];return undefined},defaultMessage:function(t,n){return this.findDefined(this.customMessage(t.name,n),this.customMetaMessage(t,n),!this.settings.ignoreTitle&&t.title||undefined,e.validator.messages[n],"<strong>Warning: No message defined for "+t.name+"</strong>")},formatAndAdd:function(e,t){var n=this.defaultMessage(e,t.method);typeof n=="function"&&(n=n.call(this,t.parameters,e)),this.errorList.push({message:n,element:e}),this.errorMap[e.name]=n,this.submitted[e.name]=n},addWrapper:function(e){return this.settings.wrapper&&(e=e.add(e.parent(this.settings.wrapper))),e},defaultShowErrors:function(){for(var e=0;this.errorList[e];e++){var t=this.errorList[e];this.settings.highlight&&this.settings.highlight.call(this,t.element,this.settings.errorClass,this.settings.validClass),this.showLabel(t.element,t.message)}this.errorList.length&&(this.toShow=this.toShow.add(this.containers));if(this.settings.success)for(var e=0;this.successList[e];e++)this.showLabel(this.successList[e]);if(this.settings.unhighlight)for(var e=0,n=this.validElements();n[e];e++)this.settings.unhighlight.call(this,n[e],this.settings.errorClass,this.settings.validClass);this.toHide=this.toHide.not(this.toShow),this.hideErrors(),this.addWrapper(this.toShow).show()},validElements:function(){return this.currentElements.not(this.invalidElements())},invalidElements:function(){return e(this.errorList).map(function(){return this.element})},showLabel:function(t,n){var r=this.errorsFor(t);r.length?(r.removeClass().addClass(this.settings.errorClass),r.attr("generated")&&r.html(n)):(r=e("<"+this.settings.errorElement+"/>").attr({"for":this.idOrName(t),generated:!0}).addClass(this.settings.errorClass).html(n||""),this.settings.wrapper&&(r=r.hide().show().wrap("<"+this.settings.wrapper+"/>").parent()),this.labelContainer.append(r).length||(this.settings.errorPlacement?this.settings.errorPlacement(r,e(t)):r.insertAfter(t))),!n&&this.settings.success&&(r.text(""),typeof this.settings.success=="string"?r.addClass(this.settings.success):this.settings.success(r)),this.toShow=this.toShow.add(r)},errorsFor:function(e){return this.errors().filter("[for='"+this.idOrName(e)+"']")},idOrName:function(e){return this.groups[e.name]||(this.checkable(e)?e.name:e.id||e.name)},checkable:function(e){return/radio|checkbox/i.test(e.type)},findByName:function(t){var n=this.currentForm;return e(document.getElementsByName(t)).map(function(e,r){return r.form==n&&r.name==t&&r||null})},getLength:function(t,n){switch(n.nodeName.toLowerCase()){case"select":return e("option:selected",n).length;case"input":if(this.checkable(n))return this.findByName(n.name).filter(":checked").length}return t.length},depend:function(e,t){return this.dependTypes[typeof e]?this.dependTypes[typeof e](e,t):!0},dependTypes:{"boolean":function(e,t){return e},string:function(t,n){return!!e(t,n.form).length},"function":function(e,t){return e(t)}},optional:function(t){return!e.validator.methods.required.call(this,e.trim(t.value),t)&&"dependency-mismatch"},startRequest:function(e){this.pending[e.name]||(this.pendingRequest++,this.pending[e.name]=!0)},stopRequest:function(t,n){this.pendingRequest--,this.pendingRequest<0&&(this.pendingRequest=0),delete this.pending[t.name],n&&this.pendingRequest==0&&this.formSubmitted&&this.form()?e(this.currentForm).submit():!n&&this.pendingRequest==0&&this.formSubmitted&&e(this.currentForm).triggerHandler("invalid-form",[this])},previousValue:function(t){return e.data(t,"previousValue")||e.data(t,"previousValue",previous={old:null,valid:!0,message:this.defaultMessage(t,"remote")})}},classRuleSettings:{required:{required:!0},email:{email:!0},url:{url:!0},date:{date:!0},dateISO:{dateISO:!0},dateDE:{dateDE:!0},number:{number:!0},numberDE:{numberDE:!0},digits:{digits:!0},creditcard:{creditcard:!0}},addClassRules:function(t,n){t.constructor==String?this.classRuleSettings[t]=n:e.extend(this.classRuleSettings,t)},classRules:function(t){var n={},r=e(t).attr("class");return r&&e.each(r.split(" "),function(){this in e.validator.classRuleSettings&&e.extend(n,e.validator.classRuleSettings[this])}),n},attributeRules:function(t){var n={},r=e(t);for(method in e.validator.methods){var i=r.attr(method);i&&(n[method]=i)}return n.maxlength&&/-1|2147483647|524288/.test(n.maxlength)&&delete n.maxlength,n},metadataRules:function(t){if(!e.metadata)return{};var n=e.data(t.form,"validator").settings.meta;return n?e(t).metadata()[n]:e(t).metadata()},staticRules:function(t){var n={},r=e.data(t.form,"validator");return r.settings.rules&&(n=e.validator.normalizeRule(r.settings.rules[t.name])||{}),n},normalizeRules:function(t,n){return e.each(t,function(r,i){if(i===!1){delete t[r];return}if(i.param||i.depends){var s=!0;switch(typeof i.depends){case"string":s=!!e(i.depends,n.form).length;break;case"function":s=i.depends.call(n,n)}s?t[r]=i.param!==undefined?i.param:!0:delete t[r]}}),e.each(t,function(r,i){t[r]=e.isFunction(i)?i(n):i}),e.each(["minlength","maxlength","min","max"],function(){t[this]&&(t[this]=Number(t[this]))}),e.each(["rangelength","range"],function(){t[this]&&(t[this]=[Number(t[this][0]),Number(t[this][1])])}),e.validator.autoCreateRanges&&(t.min&&t.max&&(t.range=[t.min,t.max],delete t.min,delete t.max),t.minlength&&t.maxlength&&(t.rangelength=[t.minlength,t.maxlength],delete t.minlength,delete t.maxlength)),t.messages&&delete t.messages,t},normalizeRule:function(t){if(typeof t=="string"){var n={};e.each(t.split(/\s/),function(){n[this]=!0}),t=n}return t},addMethod:function(t,n,r){e.validator.methods[t]=n,e.validator.messages[t]=r||e.validator.messages[t],n.length<3&&e.validator.addClassRules(t,e.validator.normalizeRule(t))},methods:{required:function(t,n,r){if(!this.depend(r,n))return"dependency-mismatch";switch(n.nodeName.toLowerCase()){case"select":var i=e("option:selected",n);return i.length>0&&(n.type=="select-multiple"||(e.browser.msie&&!i[0].attributes.value.specified?i[0].text:i[0].value).length>0);case"input":if(this.checkable(n))return this.getLength(t,n)>0;default:return e.trim(t).length>0}},remote:function(t,n,r){if(this.optional(n))return"dependency-mismatch";var i=this.previousValue(n);this.settings.messages[n.name]||(this.settings.messages[n.name]={}),this.settings.messages[n.name].remote=typeof i.message=="function"?i.message(t):i.message,r=typeof r=="string"&&{url:r}||r;if(i.old!==t){i.old=t;var s=this;this.startRequest(n);var o={};return o[n.name]=t,e.ajax(e.extend(!0,{url:r,mode:"abort",port:"validate"+n.name,dataType:"json",data:o,success:function(e){var t=e===!0;if(t){var r=s.formSubmitted;s.prepareElement(n),s.formSubmitted=r,s.successList.push(n),s.showErrors()}else{var o={};o[n.name]=i.message=e||s.defaultMessage(n,"remote"),s.showErrors(o)}i.valid=t,s.stopRequest(n,t)}},r)),"pending"}return this.pending[n.name]?"pending":i.valid},minlength:function(t,n,r){return this.optional(n)||this.getLength(e.trim(t),n)>=r},maxlength:function(t,n,r){return this.optional(n)||this.getLength(e.trim(t),n)<=r},rangelength:function(t,n,r){var i=this.getLength(e.trim(t),n);return this.optional(n)||i>=r[0]&&i<=r[1]},min:function(e,t,n){return this.optional(t)||e>=n},max:function(e,t,n){return this.optional(t)||e<=n},range:function(e,t,n){return this.optional(t)||e>=n[0]&&e<=n[1]},email:function(e,t){return this.optional(t)||/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i.test(e)},url:function(e,t){return this.optional(t)||/^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(e)},date:function(e,t){return this.optional(t)||!/Invalid|NaN/.test(new Date(e))},dateISO:function(e,t){return this.optional(t)||/^\d{4}[\/-]\d{1,2}[\/-]\d{1,2}$/.test(e)},dateDE:function(e,t){return this.optional(t)||/^\d\d?\.\d\d?\.\d\d\d?\d?$/.test(e)},number:function(e,t){return this.optional(t)||/^-?(?:\d+|\d{1,3}(?:,\d{3})+)(?:\.\d+)?$/.test(e)},numberDE:function(e,t){return this.optional(t)||/^-?(?:\d+|\d{1,3}(?:\.\d{3})+)(?:,\d+)?$/.test(e)},digits:function(e,t){return this.optional(t)||/^\d+$/.test(e)},creditcard:function(e,t){if(this.optional(t))return"dependency-mismatch";if(/[^0-9-]+/.test(e))return!1;var r=0,i=0,s=!1;e=e.replace(/\D/g,"");for(n=e.length-1;n>=0;n--){var o=e.charAt(n),i=parseInt(o,10);s&&(i*=2)>9&&(i-=9),r+=i,s=!s}return r%10==0},accept:function(e,t,n){return n=typeof n=="string"?n.replace(/,/g,"|"):"png|jpe?g|gif",this.optional(t)||e.match(new RegExp(".("+n+")$","i"))},equalTo:function(t,n,r){return t==e(r).val()}}}),e.format=e.validator.format})(jQuery),function(e){var t=e.ajax,n={};e.ajax=function(r){r=e.extend(r,e.extend({},e.ajaxSettings,r));var i=r.port;return r.mode=="abort"?(n[i]&&n[i].abort(),n[i]=t.apply(this,arguments)):t.apply(this,arguments)}}(jQuery),function(e){e.each({focus:"focusin",blur:"focusout"},function(t,n){e.event.special[n]={setup:function(){if(e.browser.msie)return!1;this.addEventListener(t,e.event.special[n].handler,!0)},teardown:function(){if(e.browser.msie)return!1;this.removeEventListener(t,e.event.special[n].handler,!0)},handler:function(t){return arguments[0]=e.event.fix(t),arguments[0].type=n,e.event.handle.apply(this,arguments)}}}),e.extend(e.fn,{delegate:function(t,n,r){return this.bind(t,function(t){var i=e(t.target);if(i.is(n))return r.apply(i,arguments)})},triggerEvent:function(t,n){return this.triggerHandler(t,[e.event.fix({type:t,target:n})])}})}(jQuery);