$(function () {

    var like = document.createElement('iframe');
    like.src = "//localhost:3000/demo?k=" + talkyCostumerKey + "&u=" + window.location.hostname + "&p=" + window.location.pathname + "";

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
    var div = document.createElement('div')
    div.id = "talky-div";
    div.innerHTML = like.outerHTML;
    div.style.width = "100%";
    div.style.height = "auto";
    div.style.minHeight = "300px";
    this_script.parentNode.insertBefore(div, this_script);
    div.addEventListener('click', divClick);


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

});

resize = function (h) {
    h = parseInt(h);
    if (h < 550) h = 550;
    document.getElementById('talky-frame').style.height = h + "px";
}

divClick = function () {
}
