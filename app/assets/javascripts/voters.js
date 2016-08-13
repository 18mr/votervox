// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Match, UnMatched, Completed Filters

function showVoters(){
  $('.unmatched-voters').click( function(e){
    e.preventDefault();
    $(this).toggleClass('current');
    $('.matched-voters, .completed-matches').removeClass('current');
    $('div.unmatched.voter-box').toggleClass('hide');
  });
  $('.matched-voters').click( function(e){
    e.preventDefault();
    $(this).toggleClass('current');
    $('.unmatched-voters, .completed-matches').removeClass('current');
    $('div.matched.voter-box').toggleClass('hide');
  });
  $('.completed-matches').click( function(e){
    e.preventDefault();
    $(this).toggleClass('current');
    $('.matched-voters, .unmatched-voters').removeClass('current');
    $('div.completed.voter-box').toggleClass('hide');
  });
}

$(document).ready(function(){
  showVoters();
});