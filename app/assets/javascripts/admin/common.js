$('.link_div').live('click', function () {
    location = $(this).data('link');
});
$('.generate_field').live('click', function () {
    var class_name = $(this).attr('data-target-class');
    var element = $('.' + class_name).first().clone();
    element = change_ids(element);
    $('.' + class_name + '_container').append(element);
    var delete_link = $('.remove_field').first().clone();
    delete_link.attr('href', "javascript:;");
    delete_link.removeAttr("data-confirm");
    $('.' + class_name + '_container').append(delete_link);
});

$('.remove_field').live('click', function (e) {
    if ($('.generatable').length != 1 && $(this).attr('href') == 'javascript:;') {
        $(this).prev('div').remove();
        $(this).remove();
    }
});

change_ids = function (element) {
    var new_id = new Date().getTime();
    element.find("input,select").each(function () {
        var el = $(this);
        el.val("");
        el.attr("id", el.attr("id").replace(/\d+/, new_id))
        el.attr("name", el.attr("name").replace(/\d+/, new_id))
        if (el.attr("type") == "number") {
            el.val(1);
        }
    })

    return element;
}
