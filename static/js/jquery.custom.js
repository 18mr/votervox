
// Written by Mike Lacourse - 09/2015

$(document).ready(function() {

	// Mobile Menu Toggle

	$('#mobile-nav-open').click(function() {
		$(this).parent().toggleClass('open');
		$('.site-nav').toggleClass('open');
		$('.site-nav').slideToggle();
	});

	// Email List Signup

	$('.email-signup').magnificPopup({
		type: 'inline',
		closeBtnInside: true,
		mainClass: 'mfp-zoom-in',
		removalDelay: 350,
		callbacks: {
			beforeOpen: function() {
			   this.st.mainClass = this.st.el.attr('data-effect');
			}
		},
	});

	// Load IndieGoGo popup after set time

	var load_time = 5000; //ms

	setTimeout(function() {
		if ($('#indie-gogo-pop').length && !$.magnificPopup.instance.isOpen) {
			$.magnificPopup.open({
				items: { src: '#indie-gogo-pop' },
				type: 'inline',
				mainClass: 'mfp-zoom-in',
				removalDelay: 350
			});
	   }
	}, load_time);
	
	// Checks if our email signup elements exist, once they do update them
	// - Cayden wanted to continue to use action network as their preferred email management tool
	// - Its important to leave the embed script as there are special keys generated on the fly

	// Setup loop to check if elements exist
	window.signup_check = setInterval(check_trigger, 500);

	function check_trigger() {
		if ( $('#can_sidebar h4').length > 0 ){
			$('#can_sidebar h4').text('Join our email list');
			$('#can_sidebar h4').after( "<p>Get updates on VoterVOX straight to your inbox.</p>" );
			$('#can_sidebar #error_message').text('Please enter a valid email address.');
			$('#can_sidebar input[name^="commit"]').val('Go');
			$('#can_sidebar #form-zip_code').val('00000');
			$('#email-signup #can_thank_you').text('<h4>Thanks!</h4><p>We\'ll update you when we have news.</p><div class="homepage-button"><a href="http://bit.ly/VoterVOX" class="email-signup">Back Us On Indiegogo</a></div>');
			check_clear(); // clear function
			
			// If user has already submitted email remove the submit button
			if ( $('#action_welcome_message_inner').length > 0 ) {
				$('#email-signup #can_sidebar input[type="submit"]').addClass('signed-in');
				$('#email-signup #can_sidebar input[type="submit"]').wrap('<div style="max-width:200px;margin:auto;"></div>');
				$('#email-signup #can_sidebar input[type="submit"]').val('Sign Up Now');
			}
			
		}
	}

	// Clear loop once elements are updated
	function check_clear() {
		clearInterval(window.signup_check);
	}

});

// Parallax effect for homepage background image

// var lastScrollY = 0,
//     ticking = false,
//     bgElm = document.getElementById('hero-bg'),
//     speedDivider = 2;

// // Update scroll value and request tick
// var doScroll = function() {
//   lastScrollY = window.pageYOffset;
//   requestTick();
// };

// window.addEventListener('scroll', doScroll, false);


// var requestTick = function() {
//   if (!ticking) {
//     window.requestAnimationFrame(updatePosition);
//     ticking = true;
//   }
// };


// var updatePosition = function() {
//   var translateValue = lastScrollY / speedDivider;

//   // We don't want parallax to happen if scrollpos is below 0
//   if (translateValue < 0)
//     translateValue = 0;

//   translateY3d(bgElm, translateValue);

//   // Stop ticking
//   ticking = false;
// };

// // Translates an element on the Y axis using translate3d
// // to ensure that the rendering is done by the GPU
// var translateY3d = function(elm, value) {
//   var translate = 'translate3d(0px,' + value + 'px, 0px)';
//   elm.style['-webkit-transform'] = translate;
//   elm.style['-moz-transform'] = translate;
//   elm.style['-ms-transform'] = translate;
//   elm.style['-o-transform'] = translate;
//   elm.style.transform = translate;
// };
