$(document).ready(function() {
	var $scrollButton = $(".scroll-up");
	var $logoutTitle = $(".app-title");
	var $logoutSearchBar = $(".app-search");
	var $searchButton = $(".logout-search");
	var $downButton = $(".fa-chevron-down");
	var $signedOutTitle = $(".signed-out-feed");
	var $usernameField = $("#user_username");
	var $usernameHint = $(".username-hint");
	var bounceInLeft = "animated bounceInLeft";
	var bounceInRight = "animated bounceInRight";
	var bounceInDown = "animated bounceInDown";
	var bounce = "animated bounce";
	var usernameFormat = /^\d*[a-zA-Z][a-zA-Z\d]*$/i;

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

	//CANNOT USER PREDETERMINED VARIABLES BECAUSE AJAX OVERRIDES THEM
	$(document).on("focus", "#user_username", function() {
		if ($("#user_username").val().match(usernameFormat)) {
			$(".unconfirm").slideUp(300);
			$(".confirm").slideDown(300);
		} else {
			$(".confirm").slideUp(300);
			$(".unconfirm").slideDown(300);
		}
		$(".username-hint").slideDown(300);
	});

	$(document).on("blur", "#user_username", function() {
		if ($("#user_username").val().match(usernameFormat)) {
			$(".unconfirm").slideUp(300);
			$(".confirm").slideDown(300);
		} else {
			$(".confirm").slideUp(300);
			$(".unconfirm").slideDown(300);
		}
	});
	

	//displays signed out title on scroll down
	$(window).scroll(function() {
		var $topOfScreen = $(window).scrollTop();
		if ($topOfScreen > 200) {
			$signedOutTitle.text("Worldwide Feed");
		}
	});

	//jumps the signed out user down if they click down arrow instead of scrolling
	$downButton.click(function() {
			$("html, body").animate({
				scrollTop: $signedOutTitle.offset().top - 50
			}, 500);
	});

	// search bar on logout page slide in right
	$logoutSearchBar.addClass(bounceInRight);


	// toggles the "join here" text
	$(".sign-up a").click(function() {
		if ($(this).text() === "Join here!") {
			$(this).text("Scroll down, you're 90% there!");
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