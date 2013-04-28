(function(e){function t(){e.fn.ajaxSubmit.debug&&window.console&&window.console.log&&window.console.log("[jquery.form] "+Array.prototype.join.call(arguments,""))}e.fn.ajaxSubmit=function(a){function r(){function r(){if(!h++){f.detachEvent?f.detachEvent("onload",r):f.removeEventListener("load",r,!1);var a=!0;try{if(p)throw"timeout";var i,s;s=f.contentWindow?f.contentWindow.document:f.contentDocument?f.contentDocument:f.document;var u="xml"==o.dataType||s.XMLDocument||e.isXMLDoc(s);if(t("isXml="+u),!u&&(null==s.body||""==s.body.innerHTML))return--g?(h=0,setTimeout(r,100),void 0):(t("Could not access iframe DOM after 50 tries."),void 0);if(m.responseText=s.body?s.body.innerHTML:null,m.responseXML=s.XMLDocument?s.XMLDocument:s,m.getResponseHeader=function(e){var t={"content-type":o.dataType};return t[e]},"json"==o.dataType||"script"==o.dataType){var c=s.getElementsByTagName("textarea")[0];m.responseText=c?c.value:m.responseText}else"xml"!=o.dataType||m.responseXML||null==m.responseText||(m.responseXML=n(m.responseText));i=e.httpData(m,o.dataType)}catch(v){a=!1,e.handleError(o,m,"error",v)}a&&(o.success(i,"success"),d&&e.event.trigger("ajaxSuccess",[m,o])),d&&e.event.trigger("ajaxComplete",[m,o]),d&&!--e.active&&e.event.trigger("ajaxStop"),o.complete&&o.complete(m,a?"success":"error"),setTimeout(function(){l.remove(),m.responseXML=null},100)}}function n(e,t){return window.ActiveXObject?(t=new ActiveXObject("Microsoft.XMLDOM"),t.async="false",t.loadXML(e)):t=(new DOMParser).parseFromString(e,"text/xml"),t&&t.documentElement&&"parsererror"!=t.documentElement.tagName?t:null}var i=c[0];if(e(":input[name=submit]",i).length)return alert('Error: Form elements must not be named "submit".'),void 0;var o=e.extend({},e.ajaxSettings,a),s=e.extend(!0,{},e.extend(!0,{},e.ajaxSettings),o),u="jqFormIO"+(new Date).getTime(),l=e('<iframe id="'+u+'" name="'+u+'" src="about:blank" />'),f=l[0];l.css({position:"absolute",top:"-1000px",left:"-1000px"});var m={aborted:0,responseText:null,responseXML:null,status:0,statusText:"n/a",getAllResponseHeaders:function(){},getResponseHeader:function(){},setRequestHeader:function(){},abort:function(){this.aborted=1,l.attr("src","about:blank")}},d=o.global;if(d&&!e.active++&&e.event.trigger("ajaxStart"),d&&e.event.trigger("ajaxSend",[m,o]),s.beforeSend&&s.beforeSend(m,s)===!1)return s.global&&e.active--,void 0;if(!m.aborted){var h=0,p=0,v=i.clk;if(v){var b=v.name;b&&!v.disabled&&(a.extraData=a.extraData||{},a.extraData[b]=v.value,"image"==v.type&&(a.extraData[name+".x"]=i.clk_x,a.extraData[name+".y"]=i.clk_y))}setTimeout(function(){var t=c.attr("target"),n=c.attr("action");i.setAttribute("target",u),"POST"!=i.getAttribute("method")&&i.setAttribute("method","POST"),i.getAttribute("action")!=o.url&&i.setAttribute("action",o.url),a.skipEncodingOverride||c.attr({encoding:"multipart/form-data",enctype:"multipart/form-data"}),o.timeout&&setTimeout(function(){p=!0,r()},o.timeout);var s=[];try{if(a.extraData)for(var m in a.extraData)s.push(e('<input type="hidden" name="'+m+'" value="'+a.extraData[m]+'" />').appendTo(i)[0]);l.appendTo("body"),f.attachEvent?f.attachEvent("onload",r):f.addEventListener("load",r,!1),i.submit()}finally{i.setAttribute("action",n),t?i.setAttribute("target",t):c.removeAttr("target"),e(s).remove()}},10);var g=50}}if(!this.length)return t("ajaxSubmit: skipping submit process - no element selected"),this;"function"==typeof a&&(a={success:a});var n=e.trim(this.attr("action"));n&&(n=(n.match(/^([^#]+)/)||[])[1]),n=n||window.location.href||"",a=e.extend({url:n,type:this.attr("method")||"GET"},a||{});var i={};if(this.trigger("form-pre-serialize",[this,a,i]),i.veto)return t("ajaxSubmit: submit vetoed via form-pre-serialize trigger"),this;if(a.beforeSerialize&&a.beforeSerialize(this,a)===!1)return t("ajaxSubmit: submit aborted via beforeSerialize callback"),this;var o=this.formToArray(a.semantic);if(a.data){a.extraData=a.data;for(var s in a.data)if(a.data[s]instanceof Array)for(var u in a.data[s])o.push({name:s,value:a.data[s][u]});else o.push({name:s,value:a.data[s]})}if(a.beforeSubmit&&a.beforeSubmit(o,this,a)===!1)return t("ajaxSubmit: submit aborted via beforeSubmit callback"),this;if(this.trigger("form-submit-validate",[o,this,a,i]),i.veto)return t("ajaxSubmit: submit vetoed via form-submit-validate trigger"),this;var l=e.param(o);"GET"==a.type.toUpperCase()?(a.url+=(a.url.indexOf("?")>=0?"&":"?")+l,a.data=null):a.data=l;var c=this,f=[];if(a.resetForm&&f.push(function(){c.resetForm()}),a.clearForm&&f.push(function(){c.clearForm()}),!a.dataType&&a.target){var m=a.success||function(){};f.push(function(t){e(a.target).html(t).each(m,arguments)})}else a.success&&f.push(a.success);a.success=function(e,t){for(var r=0,n=f.length;n>r;r++)f[r].apply(a,[e,t,c])};for(var d=e("input:file",this).fieldValue(),h=!1,p=0;d.length>p;p++)d[p]&&(h=!0);var v=!1;return a.iframe||h||v?a.closeKeepAlive?e.get(a.closeKeepAlive,r):r():e.ajax(a),this.trigger("form-submit-notify",[this,a]),this},e.fn.ajaxForm=function(t){return this.ajaxFormUnbind().bind("submit.form-plugin",function(){return e(this).ajaxSubmit(t),!1}).each(function(){e(":submit,input:image",this).bind("click.form-plugin",function(t){var a=this.form;if(a.clk=this,"image"==this.type)if(void 0!=t.offsetX)a.clk_x=t.offsetX,a.clk_y=t.offsetY;else if("function"==typeof e.fn.offset){var r=e(this).offset();a.clk_x=t.pageX-r.left,a.clk_y=t.pageY-r.top}else a.clk_x=t.pageX-this.offsetLeft,a.clk_y=t.pageY-this.offsetTop;setTimeout(function(){a.clk=a.clk_x=a.clk_y=null},10)})})},e.fn.ajaxFormUnbind=function(){return this.unbind("submit.form-plugin"),this.each(function(){e(":submit,input:image",this).unbind("click.form-plugin")})},e.fn.formToArray=function(t){var a=[];if(0==this.length)return a;var r=this[0],n=t?r.getElementsByTagName("*"):r.elements;if(!n)return a;for(var i=0,o=n.length;o>i;i++){var s=n[i],u=s.name;if(u)if(t&&r.clk&&"image"==s.type)s.disabled||r.clk!=s||(a.push({name:u,value:e(s).val()}),a.push({name:u+".x",value:r.clk_x},{name:u+".y",value:r.clk_y}));else{var l=e.fieldValue(s,!0);if(l&&l.constructor==Array)for(var c=0,f=l.length;f>c;c++)a.push({name:u,value:l[c]});else null!==l&&"undefined"!=typeof l&&a.push({name:u,value:l})}}if(!t&&r.clk){var m=e(r.clk),d=m[0],u=d.name;u&&!d.disabled&&"image"==d.type&&(a.push({name:u,value:m.val()}),a.push({name:u+".x",value:r.clk_x},{name:u+".y",value:r.clk_y}))}return a},e.fn.formSerialize=function(t){return e.param(this.formToArray(t))},e.fn.fieldSerialize=function(t){var a=[];return this.each(function(){var r=this.name;if(r){var n=e.fieldValue(this,t);if(n&&n.constructor==Array)for(var i=0,o=n.length;o>i;i++)a.push({name:r,value:n[i]});else null!==n&&"undefined"!=typeof n&&a.push({name:this.name,value:n})}}),e.param(a)},e.fn.fieldValue=function(t){for(var a=[],r=0,n=this.length;n>r;r++){var i=this[r],o=e.fieldValue(i,t);null===o||"undefined"==typeof o||o.constructor==Array&&!o.length||(o.constructor==Array?e.merge(a,o):a.push(o))}return a},e.fieldValue=function(e,t){var a=e.name,r=e.type,n=e.tagName.toLowerCase();if("undefined"==typeof t&&(t=!0),t&&(!a||e.disabled||"reset"==r||"button"==r||("checkbox"==r||"radio"==r)&&!e.checked||("submit"==r||"image"==r)&&e.form&&e.form.clk!=e||"select"==n&&-1==e.selectedIndex))return null;if("select"==n){var i=e.selectedIndex;if(0>i)return null;for(var o=[],s=e.options,u="select-one"==r,l=u?i+1:s.length,c=u?i:0;l>c;c++){var f=s[c];if(f.selected){var m=f.value;if(m||(m=f.attributes&&f.attributes.value&&!f.attributes.value.specified?f.text:f.value),u)return m;o.push(m)}}return o}return e.value},e.fn.clearForm=function(){return this.each(function(){e("input,select,textarea",this).clearFields()})},e.fn.clearFields=e.fn.clearInputs=function(){return this.each(function(){var e=this.type,t=this.tagName.toLowerCase();"text"==e||"password"==e||"textarea"==t?this.value="":"checkbox"==e||"radio"==e?this.checked=!1:"select"==t&&(this.selectedIndex=-1)})},e.fn.resetForm=function(){return this.each(function(){("function"==typeof this.reset||"object"==typeof this.reset&&!this.reset.nodeType)&&this.reset()})},e.fn.enable=function(e){return void 0==e&&(e=!0),this.each(function(){this.disabled=!e})},e.fn.selected=function(t){return void 0==t&&(t=!0),this.each(function(){var a=this.type;if("checkbox"==a||"radio"==a)this.checked=t;else if("option"==this.tagName.toLowerCase()){var r=e(this).parent("select");t&&r[0]&&"select-one"==r[0].type&&r.find("option").selected(!1),this.selected=t}})}})(jQuery);