// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Pending and Accepted Filters
function showVolunteers(){
  $('a.volunteers-toggle').click( function(e){
    e.preventDefault();
    //highlight the selected toggle
    $('.volunteers-toggle').removeClass('current');
    $(this).addClass('current');
    //show the selected voter types and hide the rest using data-voters attribute
    var volunteersType = $(this).attr('data-volunteers');
    if ($('#'+volunteersType).length) {
      $('.volunteer-boxes').addClass('hide');
      $('#'+ volunteersType).removeClass('hide');
    }
  });
}