$(document).ready(function() {
	var $scrollButton = $(".scroll-up");
	var $logoutTitle = $(".app-title");
	var $logoutSearchBar = $(".app-search");
	var $searchButton = $(".logout-search");
	var bounceInLeft = "animated bounceInLeft";
	var bounceInRight = "animated bounceInRight";
	var bounceInDown = "animated bounceInDown";
	var bounce = "animated bounce";

	// title slide in and bounce when mouse hovers over
	$logoutTitle.addClass(bounceInLeft);
	setTimeout(function() {
		$logoutTitle.removeClass(bounceInLeft);
	}, 1000);

	$logoutTitle.hover(function() {
		$logoutTitle.addClass(bounce);
		setTimeout(function() {
			$logoutTitle.removeClass(bounce);
		}, 1000);
	});

	// search bar on logout page slide in right
	$logoutSearchBar.addClass(bounceInRight);


	// toggles the "join here" text
	$(".sign-up a").click(function() {
		if ($(this).text() === "Join here!") {
			$(this).text("You're 90% there!");
		} else {
			$(this).text("Join here!");
		}
	});
 
	// drops in the search bar button
	$searchButton.hide();
	setTimeout(function() {
		$searchButton.addClass(bounceInDown);
		$searchButton.show();
	}, 800);


	// hides and shows scroll-up div
	$(window).scroll(function() {
		var $topOfScreen = $(window).scrollTop();

		if ($topOfScreen > 500) {
			$scrollButton.fadeIn(500);
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