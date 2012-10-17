(function($, undefined) {

    var rmonitor;

    $.rmonitor = rmonitor = {

        remoteForms: 'form[data-remote]',

        remoteLinks: 'a[data-remote]',

        searchInputs: 'input[data-search]',

        navTabs: '.nav.nav-tabs.nav-js a',

        rightClickElements: "*[data-dropdown-menu]",

        timer: 0,

        modal: function(options)
        {
            var $modal, $html;
            var options = $.extend({
                title: "Are you sure ?",
                content: "",
                buttons: {}
            }, options);

            $html = $("<div class=\"modal\" role=\"dialog\"></div>");
            $html.addClass('fade');
            $html.append("<div class=\"modal-header\">\n    <a class=\"close\" data-dismiss=\"modal\">×</a>\n    <h3>" + options.title + "</h3>\n  </div>");

            if (options.content.length > 0) {
                $html.append("<div class=\"modal-body\">\n    <p>" + options.content + "</p>\n  </div>\n");
            }

            if (options.buttons.length > 0)
            {
                $html.append("<div class=\"modal-footer\"></div>");

                $.each(options.buttons, function(b) { 
                    $html.find('.modal-footer').append("<a data-dismiss=\"modal\" class=\"btn" + (this.class ? " " + this.class : "") + "\" rel=\"" + b + "\">" + this.label + "</a>");

                    if (this.callback) {
                        $html.find(".modal-footer a[rel='"+b+"']").on('click.rails', this.callback);
                    }
                });
            }

            $modal = $html.modal();

            return $modal.on('hidden', function () {
                            $(this).remove();
                        });
        },

        confirm: function(element, message)
        {
            var options = {
                title: element.data('confirm'),
                content: element.data('message'),
                buttons: [
                    {
                        label: "Cancel"
                    },
                    {
                        label: "OK",
                        class: "btn-primary confirm",
                        callback: function() {
                            element.removeAttr('data-confirm')
                                    .removeAttr('data-message');
                            element.click();
                        }
                    }
                ],
            };

            rmonitor.modal(options)

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
        },

        spinner: function(link, action)
        {
            if (action === 'show') {
                $('<div></div>').addClass('modal-backdrop').addClass('spinner').appendTo('body');
            }
            else if (action === 'hide') {
                $('div.modal-backdrop.spinner').remove();
            }
            else {
                return $('div.modal-backdrop.spinner');
            }
        },

        delay: function(callback, ms)
        {
            clearTimeout(rmonitor.timer);
            rmonitor.timer = setTimeout(callback, ms);
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
                         .button('loading');

            $this.on('ajax:complete', function() {
                $btn.button('reset');
                $this.off('ajax:complete');
            });
        });

        //
        // Optimize input search forms
        //
        $(document).delegate(rmonitor.searchInputs, 'keyup', function(e) {
            var $this = $(this);
            e.preventDefault();

            rmonitor.delay(function(){
                $this.closest('form').find("input[name='commit']").first().click();
            }, 250 );
        });

        //
        // Show spinner on remote link loading
        //
        $(document).delegate(rmonitor.remoteLinks, 'click', function(e) {
            var $this = $(this);

            // rmonitor.spinner($this, 'show');
            rmonitor.delay(function() {
                rmonitor.spinner($this, 'hide');
            }, 10000);

            $this.on('ajax:complete, ajaxComplete', function() {
                console.log('ajax:complete');
                rmonitor.spinner($this, 'hide');
                $this.off('ajax:complete');
            })
        });

        //
        // Open modal by event
        //
        $(document).delegate(document, 'rmonitor:modal:new', function(e, data) {
            e.preventDefault();
            rmonitor.modal(data);
        });

        //
        // Dropdown menu element
        // Inspiration: http://www.abeautifulsite.net/blog/2008/05/jquery-right-click-plugin/
        //
        $(document).delegate(rmonitor.rightClickElements, 'mousedown', function(e) {
            if (e.which !== 3) return;
            $(this)[0].oncontextmenu = function() { return false; };

            console.log("You right click!");
        });

        //
        // Optimize Nav-Tabs
        //
        $(document).delegate(rmonitor.navTabs, 'click', function(e) {
            e.preventDefault();
            window.location.hash = $(this).attr('href');
            $(this).tab('show');
        });
    // }

    $(function() {
        if (window.location.hash) {
            $('.nav-js a[href="'+window.location.hash+'"]').tab('show');
        }
    });

})( jQuery );