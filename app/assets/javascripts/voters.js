// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Match, UnMatched, Completed Filters

function showVoters(){
  $('.unmatched-voters').click( function(e){
    e.preventDefault();
    $(this).addClass('current');
    $('.matched-voters, .completed-matches').removeClass('current');
    $('div.unmatched.voter-box').removeClass('hide');
    $('div.matched.voter-box, div.completed.voter-box').addClass('hide');
  });
  $('.matched-voters').click( function(e){
    e.preventDefault();
    $(this).addClass('current');
    $('.unmatched-voters, .completed-matches').removeClass('current');
    $('div.matched.voter-box').removeClass('hide');
    $('div.unmatched.voter-box, div.completed.voter-box').addClass('hide');
  });
  $('.completed-matches').click( function(e){
    e.preventDefault();
    $(this).addClass('current');
    $('.matched-voters, .unmatched-voters').removeClass('current');
    $('div.completed.voter-box').removeClass('hide');
    $('div.matched.voter-box, div.unmatched.voter-box').addClass('hide');
  });
}

$(document).ready(function(){
  showVoters();
});