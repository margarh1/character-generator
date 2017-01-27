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
//= require_self

$(document).on('turbolinks:load', function() {
  // form-triggered events
  var skills_str = [];

  $('#character_character_class, #character_name, #character_gender, #Strength, #Dexterity, #Constitution, #Intelligence, #Wisdom, #Charisma').change(function() {
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
    var bg = $('#' + this.id).val();
    get_data('backgrounds');
    // unchecks, removes, and re-enables skills
    if (has_background) {
      for (old_skill of data[$('.character_background').text()]['skills']) {
        $('input[name^="skills_' + old_skill + '"]').prop('checked', false);
        $('input[name^="skills_' + old_skill + '"]').prop('disabled', false);
        skills_str = skills_str.filter(function(skill) {
          return skill != old_skill;
        });
      };
    };
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

  var old_race;
  var old_subrace;
  $('#character_race').change(function() {
    var race = $('#' + this.id).val().split(' - ')[0];
    var subrace = $('#' + this.id).val().split(' - ')[1];
    get_data('races');
    // removes race modifiers from traits
    if (old_race != null) {
      for (trait of Object.keys(data[old_race]['trait'])) {
        var current = Number($('#' + trait).val());
        var bonus = data[old_race]['trait'][trait];
        $('#' + trait).val(current - bonus);
        $('.' + trait).text($('#' + trait).val());
      }
      if (old_race === 'Half-orc') {
        $('input[name^="skills_Intimidation"]').prop('checked', false);
        $('input[name^="skills_Intimidation"]').prop('disabled', false);
        skills_str = skills_str.filter(function(skill) {
          return skill != 'Intimidation';
        });
        $('.skills').text(skills_str.join(', '));
      }
    }
    if (old_subrace != null) {
      for (trait of Object.keys(data[old_race]['subraces'][old_subrace]['trait'])) {
        var current = Number($('#' + trait).val());
        var bonus = data[old_race]['subraces'][old_subrace]['trait'][trait];
        $('#' + trait).val(current - bonus);
        $('.' + trait).text($('#' + trait).val());
      };
    };
    // adds race modifiers to traits
    for (trait of Object.keys(data[race]['trait'])) {
      var current = Number($('#' + trait).val());
      var bonus = data[race]['trait'][trait];
      $('#' + trait).val(current + bonus);
      $('.' + trait).text($('#' + trait).val());
    }
    if (subrace != null) {
      for (trait of Object.keys(data[race]['subraces'][subrace]['trait'])) {
        var current = Number($('#' + trait).val());
        var bonus = data[race]['subraces'][subrace]['trait'][trait];
        $('#' + trait).val(current + bonus);
        $('.' + trait).text($('#' + trait).val());
      };
    };
    if (race === 'Half-orc') {
      $('input[name^="skills_Intimidation"]').prop('checked', true);
      $('input[name^="skills_Intimidation"]').prop('disabled', true);
      skills_str.push('Intimidation');
      $('.skills').text(skills_str.join(', '));
    }
    $('.' + this.id).text($('#' + this.id).prop('value'));
    old_race = race;
    old_subrace = subrace;
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

  // checking skills
  function check_skills() {
    var race_skills = 0;
    var class_skills = 0;
    var background_skills = 0;

    var c_class = $('.character_character_class').text();
    if (c_class != '----') {
      get_data('classes');
      if (c_class === 'Bard') {
        class_skills = data[c_class]['skills'];
      } else {
        class_skills = Number(Object.keys(data[c_class]['skills'])[0]);
      };
    };

    var bg = $('.character_background').text();
    if (bg != '----') {
      get_data('backgrounds');
      background_skills = data[bg]['skills'].length;
    };

    var race = $('.character_race').text();
    if (race === 'Half-elf') {
      race_skills = 2;
    } else if (race === 'Half-orc') {
      race_skills = 1;
    };

    var total_skills = race_skills + class_skills + background_skills;
  };

});
