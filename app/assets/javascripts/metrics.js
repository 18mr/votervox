// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// highlight the currently selected timeframe with class 'current'

$(document).ready(function(){
	if( $('main.dashboard').hasClass('metrics') ) {
		var timeframe = decodeURIComponent($.urlParam('timeframe')); 
		if (timeframe != "") {
			$('input.'+timeframe).addClass("current");
		}
	}
})