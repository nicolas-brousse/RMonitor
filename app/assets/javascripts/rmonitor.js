(function($, undefined) {

    var rmonitor;

    $.rmonitor = rmonitor = {

        remoteForms: 'form[data-remote]',

        navTabs: '.nav.nav-tabs.nav-js a',

        modal: function(options)
        {
            console.log(options)
            var html, body = "";
            var options = $.extend({
                title: "Are you sure ?",
                content: "",
                buttons: {
                    confirm: function() {},
                    cancel: function() {}
                }
            }, options);

            if (options.content && options.content.length > 0) {
                body = "<div class=\"modal-body\">\n    <p>" + options.content + "</p>\n  </div>\n"
            }

            html = "<div class=\"modal fade\" id=\"modal-confirmation\" role=\"dialog\">\n  <div class=\"modal-header\">\n    <a class=\"close\" data-dismiss=\"modal\">×</a>\n    <h3>" + options.title + "</h3>\n  </div>\n  " + body + "  <div class=\"modal-footer\">\n    <a data-dismiss=\"modal\" class=\"btn\">Cancel</a>\n    <a data-dismiss=\"modal\" class=\"btn btn-primary confirm\">OK</a>\n  </div>\n</div>";

            return $(html).modal();
        },

        confirm: function(element, message)
        {
            var options = {
                title: element.data('confirm'),
                content: element.data('message'),
            }

            rmonitor.modal(options)
                    .on('hidden', function () {
                        $(this).remove()
                    })
                    .find('.confirm').on('click.rails', function() {
                        element.removeAttr('data-confirm')
                                .removeAttr('data-message')
                        element.click()
                    })

            return false;
        },

        allowAction: function(element)
        {
            var message = element.attr('data-confirm'),
                answer = false,
                callback;
            if (!message) { return true; }

            if ($.rails.fire(element, 'confirm')) {
                answer   = rmonitor.confirm(element, message);
                callback = $.rails.fire(element, 'confirm:complete', [answer]);
            }

            // Don't stop the propagation!
            return answer && callback;
        }

    };

    // Overide $.rails.confirm
    $.rails.confirm = rmonitor.confim;

    // Overide $.rails.allowAction
    $.rails.allowAction = rmonitor.allowAction;

    // if (rails.fire($(document), 'rails:attachBindings')) {

        //
        // Optimize remote forms
        // Show loading... and disable submit input or button on submit
        //
        $(document).delegate(rmonitor.remoteForms, 'submit', function(e) {
            var $this = $(this), $btn;

            $btn  = $this.find("input[name='commit'][type='submit'], button[type='submit']")
                         .data('loading-text', 'loading...')
                         .button('loading')

            $this.on('ajax:complete', function() {
                $btn.button('reset')
                $this.off('ajax:complete')
            })
        });

        //
        // Optimize Nav-Tabs
        //
        $(document).delegate(rmonitor.navTabs, 'click', function(e) {
            e.preventDefault()
            window.location.hash = $(this).attr('href')
            $(this).tab('show')
        });
    // }

    if (window.location.hash) {
        $('.nav-js a[href="'+window.location.hash+'"]').tab('show')
    }

})( jQuery );