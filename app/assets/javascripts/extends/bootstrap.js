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
    // var scr = document.body.scrollTop;
    window.location.hash = $(this).attr('href')
    // document.body.scrollTop = scr;
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
      return true;
    }
    $.rails.showConfirmDialog(link);
    return false;
};

$.rails.confirmed = function(link)
{
    console.log("confirmed")
    console.log(link)
    link.removeAttr('data-confirm');
    return link.trigger('click.rails');
};

$.rails.showConfirmDialog = function(link)
{
    var html, message;
    message = link.attr('data-confirm');

    html = "<div class=\"modal hide fade\" id=\"modal-confirmation\" tabindex=\"-1\" role=\"dialog\">\n  <div class=\"modal-header\">\n    <a class=\"close\" data-dismiss=\"modal\">×</a>\n    <h3>" + message + "</h3>\n  </div>\n  <div class=\"modal-body\">\n    <p>Are you sure you want to delete?</p>\n  </div>\n  <div class=\"modal-footer\">\n    <a data-dismiss=\"modal\" class=\"btn\">Cancel</a>\n    <a data-dismiss=\"modal\" class=\"btn btn-primary confirm\">OK</a>\n  </div>\n</div>";
    $(html).modal('show')
           .on('hidden', function () {
                $(this).remove()
            })
           .find('.confirm').on('click', function() {
                return $.rails.confirmed(link);
            })
};
