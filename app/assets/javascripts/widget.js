$.fn.raty.defaults.path = "/assets";
$.fn.raty.defaults.half_show = true;

$(function () {
    apply_raty();
});

function apply_raty() {
    $(".star").raty({
        score:function () {
            return $(this).attr('data-rating')
        },
        number:function () {
            return $(this).attr('data-star-count')
        },
        click:function (score, evt) {
            $.ajax({
                type:'POST',
                beforeSend:function (xhr) {
                    xhr.setRequestHeader('X-CSRF-Token',
                        $('meta[name="csrf-token"]').attr('content'));
                },
                url:$(this).attr('data-url'),
                data:{
                    value:score,
					id: $(this).attr('data-id'),
                    class_name:$(this).attr("data-classname")
                },
                dataType: "script"
            });
        }
    });
}