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

  $(".modalClosable").click(function(){
    $('.modal-backdrop').remove();
    $('body').removeClass('modal-open');
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
    $(".artist-Tile .panel-ProfilePic").each(function(){
      $profileIcon = $(this);
      $profileIcon.find("img").css("display", "none");
      $profileIcon.css("background", "url(" + $profileIcon.find("img").attr("src") + ") no-repeat");
      $profileIcon.css("background-size", "cover");
      $profileIcon.css("background-position", "50%");
    });
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
  $(document)
    .on('hidden.bs.modal', '.modal', function(evt) {
      // use margin-right 0 for IE8
      $(document.body).css('margin-right', '');
      $("nav .container3").css('margin-right', '');
      $("nav .logo").css('margin-left', '');
    })
    .on('show.bs.modal', '.modal', function() {
      // When modal is shown, scrollbar on body disappears.  In order not
      // to experience a "shifting" effect, replace the scrollbar width
      // with a right-margin on the body.
      var scrollDiv = $('<div class="scrollbar-measure"></div>')
            .appendTo(document.body)[0],
            scrollBarWidth = scrollDiv.offsetWidth - scrollDiv.clientWidth;
      $(document.body).css('margin-right', scrollBarWidth + 'px');
      $rightmpx = parseFloat($("nav .container3").css('margin-right')) + scrollBarWidth;
      $("nav .container3").css('margin-right', $rightmpx + 'px');
      $("nav .logo").css('margin-left', - (18 + scrollBarWidth) + 'px');
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




































var $input = $('<div class="modal-body"><input type="text" class="form-control" placeholder="Message"></div>')

$(document).on('click', '.js-msgGroup', function () {
  $('.js-msgGroup, .js-newMsg').addClass('hide')
  $('.js-conversation').removeClass('hide')
  $('.modal-title').html('<a href="#" class="js-gotoMsgs">Back</a>')
  $input.insertBefore('.js-modalBody')
})

$(function () {
  function getRight() {
    return ($(window).width() - ($('[data-toggle="popover"]').offset().left + $('[data-toggle="popover"]').outerWidth()))
  }

  $(window).on('resize', function () {
    var instance = $('[data-toggle="popover"]').data('bs.popover')
    if (instance) {
      instance.options.viewport.padding = getRight()
    }
  })

  $('[data-toggle="popover"]').popover({
    template: '<div class="popover" role="tooltip"><div class="arrow"></div><div class="popover-content p-x-0"></div></div>',
    title: '',
    html: true,
    trigger: 'manual',
    placement:'bottom',
    viewport: {
      selector: 'body',
      padding: getRight()
    },
    content: function () {
      var $nav = $('.app-navbar .navbar-nav:last-child').clone()
      return '<div class="nav nav-stacked" style="width: 160px">' + $nav.html() + '</div>'
    }
  })

  $('[data-toggle="popover"]').on('click', function (e) {
    e.stopPropagation()

    if ($('[data-toggle="popover"]').data('bs.popover').tip().hasClass('in')) {
      $('[data-toggle="popover"]').popover('hide')
      $(document).off('click.app.popover')

    } else {
      $('[data-toggle="popover"]').popover('show')

      setTimeout(function () {
        $(document).one('click.app.popover', function () {
          $('[data-toggle="popover"]').popover('hide')
        })
      }, 1)
    }
  })

})

$(document).on('click', '.js-gotoMsgs', function () {
  $input.remove()
  $('.js-conversation').addClass('hide')
  $('.js-msgGroup, .js-newMsg').removeClass('hide')
  $('.modal-title').html('Messages')
})

$(document).on('click', '[data-action=growl]', function (e) {
  e.preventDefault()

  $('#app-growl').append(
    '<div class="alert alert-dark alert-dismissible fade in" role="alert">'+
      '<button type="button" class="close" data-dismiss="alert" aria-label="Close">'+
        '<span aria-hidden="true">×</span>'+
      '</button>'+
      '<p>Click the x on the upper right to dismiss this little thing. Or click growl again to show more growls.</p>'+
    '</div>'
  )
})

$(document).on('focus', '[data-action="grow"]', function () {
  if ($(window).width() > 1000) {
    $(this).animate({
      width: 300
    })
  }
})

$(document).on('blur', '[data-action="grow"]', function () {
  if ($(window).width() > 1000) {
    var $this = $(this).animate({
      width: 180
    })
  }
})

// back to top button - docs
$(function () {
  if ($('.docs-top').length) {
    _backToTopButton()
    $(window).on('scroll', _backToTopButton)
    function _backToTopButton () {
      if ($(window).scrollTop() > $(window).height()) {
        $('.docs-top').fadeIn()
      } else {
        $('.docs-top').fadeOut()
      }
    }
  }
})

$(function () {
    // doc nav js
    var $toc    = $('#markdown-toc')
    var $window = $(window)

    if ($toc[0]) {

      maybeActivateDocNavigation()
      $window.on('resize', maybeActivateDocNavigation)

      function maybeActivateDocNavigation () {
        if ($window.width() > 768) {
          activateDocNavigation()
        } else {
          deactivateDocNavigation()
        }
      }

      function deactivateDocNavigation() {
        $window.off('resize.theme.nav')
        $window.off('scroll.theme.nav')
        $toc.css({
          position: '',
          left: '',
          top: ''
        })
      }

      function activateDocNavigation() {

        var cache = {}

        function updateCache() {
          cache.containerTop   = $('.docs-content').offset().top - 40
          cache.containerRight = $('.docs-content').offset().left + $('.docs-content').width() + 45
          measure()
        }

        function measure() {
          var scrollTop = $window.scrollTop()
          var distance =  Math.max(scrollTop - cache.containerTop, 0)

          if (!distance) {
            $($toc.find('li')[1]).addClass('active')
            return $toc.css({
              position: '',
              left: '',
              top: ''
            })
          }

          $toc.css({
            position: 'fixed',
            left: cache.containerRight,
            top: 40
          })
        }

        updateCache()

        $(window)
          .on('resize.theme.nav', updateCache)
          .on('scroll.theme.nav', measure)

        $('body').scrollspy({
          target: '#markdown-toc',
          selector: 'li > a'
        })

        setTimeout(function () {
          $('body').scrollspy('refresh')
        }, 1000)
      }
    }
})
