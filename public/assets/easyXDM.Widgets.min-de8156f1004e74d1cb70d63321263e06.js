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
easyXDM.WidgetManager=function(e){function f(n,r){e.listeners&&e.listeners[n]&&e.listeners[n](t,r)}function l(e,t){t in o||(o[t]=[]),o[t].push(e)}function c(e,t,n){e.initialize(u,function(n){if(n.isInitialized){s[t]=e;var r=n.subscriptions.length;while(r--)l(t,n.subscriptions[r]);f(i.WidgetInitialized,{url:t})}else e.destroy(),f(i.WidgetFailed,{url:t})})}function h(e,t,n){var r=o[t];if(r){var i=r.length,u;while(i--)u=r[i],u!==e&&s[u].send(e,t,n)}}function p(t,i){var s=new easyXDM.Rpc({channel:"widget"+r++,local:n,remote:t,container:i.container||a,swf:e.swf,onReady:function(){c(s,t,i)}},{local:{subscribe:{isVoid:!0,method:function(e){l(t,e)}},publish:{isVoid:!0,method:function(e,n){h(t,e,n)}}},remote:{initialize:{},send:{isVoid:!0}}})}var t=this,n=e.local,r=0,i={WidgetInitialized:"widgetinitialized",WidgetFailed:"widgetfailed"},s={},o={},u={hosturl:location.href};easyXDM.apply(u,e.widgetSettings);var a=e.container||document.body;this.addWidget=function(e,t){if(e in s)throw new Error("A widget with this url has already been initialized");p(e,t)},this.removeWidget=function(e){if(e in s){for(var t in o)if(o.hasOwnProperty(t)){var n=o[t],r=n.length;while(r--)if(n[r]===e){n.splice(r,1);break}}s[e].destroy(),delete s[e]}},this.publish=function(e,t){h("",e,t)},this.broadcast=function(e){for(var t in s)s.hasOwnPropert(t)&&s[t].send({url:"",topic:"broadcast",data:e})}},easyXDM.Widget=function(e){var t=this,n,r=new easyXDM.Rpc({swf:e.swf},{remote:{subscribe:{isVoid:!0},publish:{isVoid:!0}},local:{initialize:{method:function(n){return e.initialized(t,r),{isInitialized:!0,subscriptions:e.subscriptions}}},send:{isVoid:!0,method:function(e,t,r){n(e,t,r)}}}});window.onunload=function(){r.destroy()},this.publish=function(e,t){r.publish(e,t)},this.subscribe=function(e){r.subscribe(e)},this.registerMessageHandler=function(e){n=e},e.initialize(this,r)};