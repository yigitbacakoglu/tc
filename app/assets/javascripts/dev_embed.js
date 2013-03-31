$(function () {
    var this_script = document.getElementById("talky-script");
    var div = document.createElement('div');
    div.id = "talky-div";
    div.style.width = "100%";
    div.style.minHeight = "300px";
    this_script.parentNode.insertBefore(div, this_script);

    var transport = new easyXDM.Socket(/** The configuration */{
        remote: "http://localhost:3000/ping?k=" + talkyCostumerKey + "&u=" + window.location.hostname + "&p=" + window.location.pathname + "",
        container: "talky-div",
        onMessage: function (message, origin) {
            var frame = this.container.getElementsByTagName("iframe")[0];
            frame.scrolling = "no";
            frame.style.width = "100%";
            frame.style.height = message + "px";
        }
    });
});