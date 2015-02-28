$(document).ready(function() {
	var $scrollButton = $(".scroll-up");
	$top = $(window).scrollTop();
	// hides and shows scroll-up div
	$(window).scroll(function() {
		var $topOfScreen = $(window).scrollTop();

		if ($topOfScreen > 500) {
			$scrollButton.fadeIn(500);
			console.log("hit");
		}

		if ($topOfScreen < 300) {
			$scrollButton.fadeOut(500);
		}
	});

	// scrolls back up
	$scrollButton.click(function() {
		if ($(window).scrollTop !== 0) {
			$("html, body").animate({
				scrollTop: '0'
			}, 400);
		}
	});

});