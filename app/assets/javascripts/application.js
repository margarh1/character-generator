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
  // form-triggered events
  var skills_str = [];

  $('#character_name, #character_gender, #Strength, #Dexterity, #Constitution, #Intelligence, #Wisdom, #Charisma').change(function() {
    console.log(this);
    // console.log(this.name);
    // console.log($('#' + this.id).val());
    // console.log($('#' + this.id).prop('checked'));
    $('.' + this.id).text($('#' + this.id).prop('value'));
  });

  $('#character_level, #character_exp').change(function() {
    link_lv_exp(this.id);
    $('.character_level').text($('#character_level').prop('value'));
    $('.character_exp').text($('#character_exp').prop('value'));
  });

  $('input[name^="skills_"]').change(function() {
    // add to skills_str if checked
    if ($('#' + this.id).prop('checked')) {
      skills_str.push($('#' + this.id).val());
      $('.skills').text(skills_str.join(', '));
    } else if (!($('#' + this.id).prop('checked'))) {
      // remove from skills_str if unchecked
      var to_check = $('#' + this.id).val();
      skills_str = skills_str.filter(function(skill) {
        return skill != to_check;
      });
      $('.skills').text(skills_str.join(', '));
    };
  });

  var has_background = false;
  $('#character_background').change(function() {
    // unchecks, removes, and re-enables skills
    if (has_background) {
      for (old_skill of data[$('.character_background').text()]['skills']) {
        $('input[name^="skills_' + old_skill + '"]').prop('checked', false);
        $('input[name^="skills_' + old_skill + '"]').prop('disabled', false);
        skills_str = skills_str.filter(function(skill) {
          return skill != old_skill
        });
      };
    };
    var bg = $('#' + this.id).val();
    get_data('backgrounds');
    // checks, disables, and adds associated skills
    for (skill of data[bg]['skills']) {
      $('input[name^="skills_' + skill + '"]').prop('checked', true);
      $('input[name^="skills_' + skill + '"]').prop('disabled', true);
      skills_str.push(skill);
    };
    $('.' + this.id).text($('#' + this.id).prop('value'));
    $('.skills').text(skills_str.join(', '));
    has_background = true;
  });

  $('#character_race').change(function() {

  });

  // data binding callbacks
  var data;

  function get_data(file_name) {
    $.ajax({
      async: false,
      method: 'GET',
      url: '/reference/' + file_name,
      success: onSuccess,
      error: onError
    });

    function onSuccess(json) {
      data = json[file_name];
      // console.log(data);
    };

    function onError(xhr, status, errorThrown) {
      alert('Sorry, there was a problem!');
      console.log('Error: ' + errorThrown);
      console.log('Status: ' + status);
      console.dir(xhr);
    };
  };

  // binding level and exp fields
  function link_lv_exp(name) {
    get_data('levels');
    var level = $('#character_level').val();
    var exp = $('#character_exp').val();
    if ((name === 'character_level') && ((data[level]['exp'] >= exp) || (data[level]['exp'] <= exp))) {
      $('#character_exp').val(data[level]['exp']);
    } else if (name === 'character_exp') {
      for (pair of Object.keys(data)) {
        if (exp >= data[pair]['exp']) {
          $('#character_level').val(pair);
        };
      };
    };
  };

});
