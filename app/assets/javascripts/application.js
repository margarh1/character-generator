// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-3.3.7.min
//= require_tree .

$(document).on('turbolinks:load', function() {

  $.ajax({
    method: 'GET',
    url: '/reference/backgrounds',
    success: onSuccess,
    error: 'Still not fucking working, you ass'
  });

  function onSuccess(json) {
    console.log(json.backgrounds);
  };

  $('input').focusout(function() {
    console.log(this);
    console.log(this.name);
    console.log($('#' + this.id).val());
    console.log($('#' + this.id).prop('checked'));
    if ((this.id.includes('skills')) && ($('#' + this.id).prop('checked'))) {
      $('.skills').append($('#' + this.id).val() + ', ');
    } else {
      $('.' + this.id).text($('#' + this.id).prop('value'));
    };
  });

  $('select').focusout(function() {
    console.log(this);
    console.log(this.name);
    console.log($('#' + this.id).val());
    $('.' + this.id).text($('#' + this.id).prop('value'));
  });

});
