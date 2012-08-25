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
$.rails.allowAction = function(link)
{
    if (!link.attr('data-confirm')) {
      return true
    }
    $.rails.showConfirmDialog(link)
    return false
}

$.rails.confirmed = function(link)
{
    link.removeAttr('data-confirm')
    return link.trigger('click.rails')
}

$.rails.showConfirmDialog = function(link)
{
    var html, 
        message = "",
        body = "";
    message = link.attr('data-confirm')
    if (link.attr('data-message') && link.attr('data-message').length > 0) {
        body = "<div class=\"modal-body\">\n    <p>" + link.attr('data-message') + "</p>\n  </div>\n"
    }

    html = "<div class=\"modal fade\" id=\"modal-confirmation\" role=\"dialog\">\n  <div class=\"modal-header\">\n    <a class=\"close\" data-dismiss=\"modal\">×</a>\n    <h3>" + message + "</h3>\n  </div>\n  " + body + "  <div class=\"modal-footer\">\n    <a data-dismiss=\"modal\" class=\"btn\">Cancel</a>\n    <a data-dismiss=\"modal\" class=\"btn btn-primary confirm\">OK</a>\n  </div>\n</div>";
    return $(html).modal()
                  .on('hidden', function () {
                      $(this).remove()
                  })
                  .find('.confirm').on('click', function() {
                      return $.rails.confirmed(link)
                  })
}
