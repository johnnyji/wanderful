$(document).ready(function() {
  var $shareLink = $('.share-link');
  var $shareLinkIcon = $('.share-link-icon');
  var $dropdownMenu = $('.drop-icon');
  var $headerRight = $('.right');
  var $headerLeft = $('.left');

  $dropdownMenu.click(function() {
    $headerRight.slideToggle(300);
    $headerLeft.toggleClass('border-bottom');
  });

  var integrateMobileHeader = function() {
    if ($(window).width() < 450) {
      $shareLinkIcon.removeClass('hidden');
      $dropdownMenu.removeClass('hidden');
      $shareLink.addClass('hidden');
      $headerRight.hide();
      $headerLeft.removeClass('border-bottom');
    } else {
      $shareLinkIcon.addClass('hidden');
      $shareLink.removeClass('hidden');
      $dropdownMenu.addClass('hidden');
      $headerRight.removeClass('mobile');
      $headerRight.show();
    }
  }
  
  integrateMobileHeader()

  $(window).resize(function() {
    integrateMobileHeader()
  });
});