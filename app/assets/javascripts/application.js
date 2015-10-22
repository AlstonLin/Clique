// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require jquery.jcrop
//= require papercrop
//= require bootstrap-sprockets
//= require masonry/jquery.masonry
//= require_tree .
  $('.dropdown-toggle').dropdown()

    jQuery(document).ready(function($) {
      // Audio
      $('#jplayer_audio_1').jPlayer({
        ready: function(event) {
          $(this).jPlayer('setMedia', {
            mp3: "<%= @pin.mp3.url %>",
          });
        },
        play: function() {
          $(this).jPlayer('pauseOthers');
        },
        cssSelectorAncestor: '#jp_gui_audio_1',
        swfPath: 'lib',
        supplied: 'mp3',
        smoothPlayBar: true,
        keyEnabled: true,
        wmode: 'window'
      });