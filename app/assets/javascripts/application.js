// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap.min
//= require_tree ./plugins
//= require rmonitor


var delay = (function(){
    var timer = 0;
    return function(callback, ms){
        clearTimeout(timer);
        timer = setTimeout(callback, ms);
    };
})();

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

$(document).on('ujs:everythingStopped', function() { console.log("ujs:everythingStopped") })