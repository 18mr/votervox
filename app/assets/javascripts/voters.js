// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Match, UnMatched, Completed Filters

function showVoters(){
  $('a.voters-toggle').click( function(e){
    e.preventDefault();
    //highlight the selected toggle
    $('.voters-toggle').removeClass('current');
    $(this).addClass('current');
    //show the selected voter types and hide the rest using data-voters attribute
    var votersType = $(this).attr('data-voters');
    if ($('#'+votersType).length) {
      $('.voter-boxes').addClass('hide');
      $('#'+ votersType).removeClass('hide');
    }
  });
}