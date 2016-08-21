// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Pending and Accepted Filters

function showVolunteers(){
  $('.pending-volunteers').click( function(e){
    e.preventDefault();
    $(this).toggleClass('current');
    $('a.approved-volunteers').removeClass('current');
    $('a.banned-volunteers').removeClass('current');
    $('div.approved.volunteer-box').addClass('hide');
    $('div.banned.volunteer-box').addClass('hide');
    $('div.pending.volunteer-box').removeClass('hide');
  });
  $('.approved-volunteers').click( function(e){
    e.preventDefault();
    $(this).toggleClass('current');
    $('a.pending-volunteers').removeClass('current');
    $('a.banned-volunteers').removeClass('current');
    $('div.pending.volunteer-box').addClass('hide');
    $('div.banned.volunteer-box').addClass('hide');
    $('div.approved.volunteer-box').removeClass('hide');
  });
  $('.banned-volunteers').click( function(e){
    e.preventDefault();
    $(this).toggleClass('current');
    $('a.pending-volunteers').removeClass('current');
    $('a.approved-volunteers').removeClass('current');
    $('div.pending.volunteer-box').addClass('hide');
    $('div.approved.volunteer-box').addClass('hide');
    $('div.banned.volunteer-box').removeClass('hide');
  });
}

$(document).ready(function(){
  showVolunteers();
});