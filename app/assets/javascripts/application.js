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
  setupComments();

    $(".newsfeed-title1, .newsfeed-title2").click(function(){
      $(".newsfeed-active").each(function(){
        $(this).removeClass("newsfeed-active");
      });
      $(this).addClass("newsfeed-active");
    });

  $("#FavSeeMore").click(function(){
    $(".newsfeed-active").each(function(){
      $(this).removeClass("newsfeed-active");
    });
    $(".newsfeed-title2:last").addClass("newsfeed-active");
  });

  $(".stats1, .stats2").click(function(){
    $(".stats-active").each(function(){
      $(this).removeClass("stats-active");
    });
    $(this).addClass("stats-active");
  });

  if($(".artist-Tile .panel-ProfilePic")){
    $(".artist-Tile .panel-ProfilePic img").css("display", "none");
    $banner = $(".panel-ProfilePic");
    $banner.css("background", "url(" + $(".panel-ProfilePic img").attr("src") + ") no-repeat");
    $banner.css("background-size", "cover");
    $banner.css("background-position", "50%");
  }

  if($(".profile-Banner")){
    $(".profile-Banner img").css("display", "none");
    $banner = $(".profile-Banner");
    $banner.css("background", "url(" + $(".profile-Banner img").attr("src") + ") no-repeat");
    $banner.css("background-size", "cover");
    $banner.css("background-position", "50%");
  }

  if($(".user-picture")){
    $(".user-picture img").css("display", "none");
    $profilePic = $(".user-picture");
    $profilePic.css("background", "url(" + $(".user-picture img").attr("src") + ") no-repeat");
    $profilePic.css("background-size", "cover");
    $profilePic.css("background-position", "50%");
  }
});

window.jQuery(function() {
  // detect browser scroll bar width
  var scrollDiv = $('<div class="scrollbar-measure"></div>')
        .appendTo(document.body)[0],
      scrollBarWidth = scrollDiv.offsetWidth - scrollDiv.clientWidth;

  $(document)
    .on('hidden.bs.modal', '.modal', function(evt) {
      // use margin-right 0 for IE8
      $(document.body).css('margin-right', '');
      $("nav .container3").css('margin-right', '');
      $("nav .logo").css('margin-right', '');
    })
    .on('show.bs.modal', '.modal', function() {
      // When modal is shown, scrollbar on body disappears.  In order not
      // to experience a "shifting" effect, replace the scrollbar width
      // with a right-margin on the body.
      if ($(window).height() < $(document).height()) {
        $(document.body).css('margin-right', scrollBarWidth + 'px');
        $rightmpx = parseFloat($("nav .container3").css('margin-right')) + scrollBarWidth;
        $("nav .container3").css('margin-right', $rightmpx + 'px');
        $("nav .logo").css('margin-left', - (18 + scrollBarWidth) + 'px');
      }
    });
});

// Allows submitting by pressing "Enter" for comment fields
function setupComments(){
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
}
