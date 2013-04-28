/**
 * easyXDM
 * http://easyxdm.net/
 * Copyright(c) 2009-2011, Øyvind Sean Kinsey, oyvind@kinsey.no.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
easyXDM.WidgetManager=function(i){function n(n,t){i.listeners&&i.listeners[n]&&i.listeners[n](r,t)}function t(i,n){n in u||(u[n]=[]),u[n].push(i)}function e(i,e){i.initialize(f,function(s){if(s.isInitialized){c[e]=i;for(var o=s.subscriptions.length;o--;)t(e,s.subscriptions[o]);n(l.WidgetInitialized,{url:e})}else i.destroy(),n(l.WidgetFailed,{url:e})})}function s(i,n,t){var e=u[n];if(e)for(var s,o=e.length;o--;)s=e[o],s!==i&&c[s].send(i,n,t)}function o(n,o){var r=new easyXDM.Rpc({channel:"widget"+d++,local:a,remote:n,container:o.container||h,swf:i.swf,onReady:function(){e(r,n,o)}},{local:{subscribe:{isVoid:!0,method:function(i){t(n,i)}},publish:{isVoid:!0,method:function(i,t){s(n,i,t)}}},remote:{initialize:{},send:{isVoid:!0}}})}var r=this,a=i.local,d=0,l={WidgetInitialized:"widgetinitialized",WidgetFailed:"widgetfailed"},c={},u={},f={hosturl:location.href};easyXDM.apply(f,i.widgetSettings);var h=i.container||document.body;this.addWidget=function(i,n){if(i in c)throw new Error("A widget with this url has already been initialized");o(i,n)},this.removeWidget=function(i){if(i in c){for(var n in u)if(u.hasOwnProperty(n))for(var t=u[n],e=t.length;e--;)if(t[e]===i){t.splice(e,1);break}c[i].destroy(),delete c[i]}},this.publish=function(i,n){s("",i,n)},this.broadcast=function(i){for(var n in c)c.hasOwnPropert(n)&&c[n].send({url:"",topic:"broadcast",data:i})}},easyXDM.Widget=function(i){var n,t=this,e=new easyXDM.Rpc({swf:i.swf},{remote:{subscribe:{isVoid:!0},publish:{isVoid:!0}},local:{initialize:{method:function(){return i.initialized(t,e),{isInitialized:!0,subscriptions:i.subscriptions}}},send:{isVoid:!0,method:function(i,t,e){n(i,t,e)}}}});window.onunload=function(){e.destroy()},this.publish=function(i,n){e.publish(i,n)},this.subscribe=function(i){e.subscribe(i)},this.registerMessageHandler=function(i){n=i},i.initialize(this,e)};