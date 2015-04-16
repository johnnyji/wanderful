$(document).ready(function() {
  var $editProfile = $('.edit-profile');
  var $editIcon = $('.edit-profile-icon');
  var $dropdownMenu = $('.drop-icon');
  var $headerRight = $('.right');
  var $headerLeft = $('.left');

  $dropdownMenu.click(function() {
    $headerRight.slideToggle(300);
    $headerLeft.toggleClass('border-bottom');
  });

  var integrateMobileHeader = function() {
    if ($(window).width() < 450) {
      $editIcon.removeClass('hidden');
      $dropdownMenu.removeClass('hidden');
      $editProfile.addClass('hidden');
      $headerRight.hide();
      $headerLeft.removeClass('border-bottom');
    } else {
      $editIcon.addClass('hidden');
      $editProfile.removeClass('hidden');
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