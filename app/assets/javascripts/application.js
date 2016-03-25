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
//= require jquery-ui
//= require jquery_ujs
//= require jquery.pjax
//= require bootstrap-sprockets
//= require_tree .

$(function() {
  $(document).pjax('a:not([data-remote]):not([data-behavior]):not([data-skip-pjax])', '[data-pjax-container]')
});
soundManager.setup({
  url: '/app/assets/javascripts/swf/'
});
$(document).on('ready pjax:success', function() {
  // Allows submitting by pressing "Enter" for comment fields
  $('.comment-field').keypress(function(e){
    if (e.which == 13){
      if (e.shiftKey){
        e.currentTarget.val(e.currentTarget.val() + "\n");
      } else{
        var id = e.currentTarget.closest('form').id;
        $("#" + id).submit();
      }
    }
  });

  $(".newsfeed-title1, .newsfeed-title2").click(function(){
    $(".newsfeed-active").each(function(){
      $(this).removeClass("newsfeed-active");
    });
    $(this).addClass("newsfeed-active");
  });

  $(".stats1, .stats2").click(function(){
    $(".stats-active").each(function(){
      $(this).removeClass("stats-active");
    });
    $(this).addClass("stats-active");
  });

});
