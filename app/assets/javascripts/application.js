// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap.min

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
$('.nav.nav-tabs.nav-js a').click(function (e) {
    e.preventDefault()
    // var scr = document.body.scrollTop;
    window.location.hash = $(this).attr('href')
    // document.body.scrollTop = scr;
    $(this).tab('show')
})

if(window.location.hash) {
    $('.nav-js a[href="'+window.location.hash+'"]').tab('show')
}
