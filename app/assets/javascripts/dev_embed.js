$(function () {

    var socket = new easyXDM.Socket({
    remote: "http://localhost:3000/demo", // the path to the provider

//    remote: "http://talkycloud.com/demo", // the path to the provider

    onMessage: function (message, origin) {
    resize(message);
    },
onReady: function () {
    socket.postMessage("Yay, it works!");
    }
});


setTimeout(function () {
    var like = document.createElement('iframe');
    like.src = "//localhost:3000/demo?k=" + talkyCostumerKey +"&u=" + window.location.hostname + "&p=" + window.location.pathname + "";

//                  like.src = "//talkycloud.com/demo?k=123&u=" + window.location.hostname + "&p=" + window.location.pathname + "";

                  like.scrolling = 'no';
                  like.frameBorder = 0;
                  like.id = "talky-frame";
                  like.allowTransparency = 'true';
                  like.style.border = 0;
                  like.style.cursor = 'pointer';
                  like.style.width = '550px';
                  like.style.position = 'absolute';
                  var this_script = document.getElementById("talky-script");
                  this_script.parentNode.insertBefore(like, this_script);
              }, 500);
});

resize = function (h) {
    h = parseInt(h);
    document.getElementById('talky-frame').style.height = h + "px";

    }
