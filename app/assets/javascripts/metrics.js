// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// highlight the currently selected timeframe with class 'current'

$(document).ready(function(){
	if( $('main.dashboard').hasClass('metrics') ) {
		var parameters = $.urlParam('timeframe');
		if (parameters.length) {
			var timeframe = decodeURIComponent($.urlParam('timeframe')); 
			$('input.'+timeframe).addClass("current");
		}
	}
})