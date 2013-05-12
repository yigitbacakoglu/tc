$.fn.raty.defaults.path = "/assets";
$.fn.raty.defaults.half_show = true;
old_id = ""
old_score = ""
$(function () {
    apply_raty();
});

function apply_raty() {
    $(".star").raty({
        score: function () {
            return $(this).attr('data-rating')
        },
        number: function () {
            return $(this).attr('data-star-count')
        },
        click: function (score, evt) {
            post_score(score, $(this).attr('data-id'), $(this).attr("data-classname"), $(this).attr('data-url'))
        }
    });
}

$('.rate_thumb').live('click', function () {
    var score = $(this).parent().attr('data-value');
    var data_id  = $(this).parent().parent('div').attr('data-id');
    post_score(score, data_id, $(this).parent().parent('div').attr("data-classname"), $(this).parent().parent('div').attr('data-url'))

    if (old_score == "1" && old_id == data_id) {
        $(this).parent().parent('div').children('.down').text(parseInt($(this).parent().parent('div').children('.down').text())-1)
    }
    if (old_score == "2" && old_id == data_id) {
        $(this).parent().parent('div').children('.up').text(parseInt($(this).parent().parent('div').children('.up').text())-1)
    }
    old_score = score;
    old_id = $(this).parent().parent('div').attr('data-id');;
    $(this).parent().next('span').text((parseInt($(this).parent().next('span').text()) + 1))
});

function post_score(score, comment_id, class_name, url) {
    $.ajax({
        type: 'POST',
        beforeSend: function (xhr) {
            xhr.setRequestHeader('X-CSRF-Token',
                $('meta[name="csrf-token"]').attr('content'));
        },
        url: url,
        data: {
            value: score,
            comment_id: comment_id,
            class_name: class_name
        },
        dataType: "script"
    });
}