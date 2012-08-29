//
// Typehead
//
$("input[data-provide='typeahead']").typeahead({
    source: function () {
        // console.log(typeahead);
        alert("yo");
        console.log(this);
        console.log($this.closest("form").attr('action'));
        // return [{value: 'Charlie'}, {value: 'Gudbergur'}];
        // return $.post($this.closest("form").attr('action'), { query: query }, function (data) {
        //     return typeahead.process(data);
        // });
    }
});


//
// Optimize remote forms
// Show loading... and disable submit input or button on submit
//
$("form[data-remote='true']").on('submit', function() {
    $this = $(this)
    $btn  = $this.find("input[name='commit'][type='submit'], button[type='submit']")
                 .attr('data-loading-text', 'loading...')
                 .button('loading')

    $this.on('ajax:complete', function() {
        $btn.button('reset')
        $this.off('ajax:complete')
    })
});


//
// Optimize Nav-Tabs
//
$('.nav.nav-tabs.nav-js a').click(function (e)
{
    e.preventDefault()
    window.location.hash = $(this).attr('href')
    $(this).tab('show')
})

if(window.location.hash) {
    $('.nav-js a[href="'+window.location.hash+'"]').tab('show')
}


//
// Optimize data-confirm
//
$.rails.allowAction = function(element)
{
    var message = element.attr('data-confirm'),
        answer = false,
        callback;
        console.log(message)
    if (!message) { return true; }

    if ($.rails.fire(element, 'confirm')) {
        answer   = $.rails.confirm(element, message);
        callback = $.rails.fire(element, 'confirm:complete', [answer]);
    }
    console.log(answer, callback)
    return answer && callback;
}

$.rails.confirm = function(element, message)
{
    if (!element.attr('data-confirm')) {
        return true
    }

    var html, body = "";

    if (element.data('message') && element.data('message').length > 0) {
        body = "<div class=\"modal-body\">\n    <p>" + element.data('message') + "</p>\n  </div>\n"
    }

    html = "<div class=\"modal fade\" id=\"modal-confirmation\" role=\"dialog\">\n  <div class=\"modal-header\">\n    <a class=\"close\" data-dismiss=\"modal\">×</a>\n    <h3>" + message + "</h3>\n  </div>\n  " + body + "  <div class=\"modal-footer\">\n    <a data-dismiss=\"modal\" class=\"btn\">Cancel</a>\n    <a data-dismiss=\"modal\" class=\"btn btn-primary confirm\">OK</a>\n  </div>\n</div>";

    $(html).modal()
            .find('.confirm').on('click.rails', function() {
              console.log(element)
                element.attr('data-confirm', null).attr('data-message', null)
                $(element).click()
            })
            .on('hidden', function () {
                $(this).remove()
            })

    return false;
}
