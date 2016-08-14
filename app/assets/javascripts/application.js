// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require ahoy
//= require_tree .


// This example displays an address form, using the autocomplete feature
// of the Google Places API to help users fill in the information.

// This example requires the Places library. Include the libraries=places
// parameter when you first load the API. For example:
// <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&libraries=places">

var placeSearch, autocomplete;
var componentForm = {
  street_number: 'short_name',
  route: 'long_name',
  locality: 'long_name',
  administrative_area_level_1: 'short_name',
  country: 'long_name',
  postal_code: 'short_name'
};

function initAutocomplete() {
  // Create the autocomplete object, restricting the search to geographical
  // location types.
  autocomplete = new google.maps.places.Autocomplete(
      /** @type {!HTMLInputElement} */(document.getElementById('autocomplete')),
      {types: ['geocode']});

  // When the user selects an address from the dropdown, populate the address
  // fields in the form.
  autocomplete.addListener('place_changed', fillInAddress);
}

function fillInAddress() {
  // Get the place details from the autocomplete object.
  var place = autocomplete.getPlace();

  for (var component in componentForm) {
    document.getElementById(component).value = '';
    document.getElementById(component).disabled = false;
  }

  // Get each component of the address from the place details
  // and fill the corresponding field on the form.
  for (var i = 0; i < place.address_components.length; i++) {
    var addressType = place.address_components[i].types[0];
    if (componentForm[addressType]) {
      var val = place.address_components[i][componentForm[addressType]];
      document.getElementById(addressType).value = val;
    }
  }
}

// Bias the autocomplete object to the user's geographical location,
// as supplied by the browser's 'navigator.geolocation' object.
function geolocate() {
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(position) {
      var geolocation = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      };
      var circle = new google.maps.Circle({
        center: geolocation,
        radius: position.coords.accuracy
      });
      autocomplete.setBounds(circle.getBounds());
      document.getElementById('latitude').value = position.coords.latitude;
      document.getElementById('longitude').value = position.coords.longitude;
    });
  }
}
//get latitude and longitude from Google Places

function getLatLong() {
  var geocoder = new google.maps.Geocoder();
  var address = document.getElementById('address').value;

  geocoder.geocode({ 'address': address }, function (results, status) {
    if (status == google.maps.GeocoderStatus.OK) {
        var latitude = results[0].geometry.location.lat();
        var longitude = results[0].geometry.location.lng();

    }
  });
  console.log(" latitude:" + latitude + " longitude:" + longitude);
};

function tooltip(){
  $('a.tooltip-hover').hover(function(){
    $('div.tooltip').toggleClass('hide');
  })
}

//Mobile Nav Menu

function mobileNav() {
  $('.menu-icon').click( function(e){
    e.preventDefault();
    var menu = $(this);
    var opened = $(this).hasClass('opened');
    console.log(opened);
    if ( !opened ) {
      $('header nav').slideDown(1000, function(){
        menu.addClass('opened');

      });
    } else {
      $('header nav').slideUp(1000, function(){
        menu.removeClass('opened');
      });
    }
    
  })
}

//open and close filters for /voter-resources & /matches
function filterShow() {
  $('a.filters').click( function(){
    $('section.filters div.filters').toggleClass('hide');
    $('i.fa').toggleClass('fa-caret-up').toggleClass('fa-caret-down');
  })
}
//filter Matches
function showMatches(){
  $('a.requested-voters').click( function(e){
    e.preventDefault();
    $(this).addClass('current');
    $('a.accepted-voters, a.completed-matches').removeClass('current');
    $('div.requested.voter-box').removeClass('hide');
    $('div.accepted.voter-box, div.completed.voter-box').addClass('hide');
  });
  $('a.accepted-voters').click( function(e){
    e.preventDefault();
    $(this).addClass('current');
    $('a.requested-voters, a.completed-matches').removeClass('current');
    $('div.accepted.voter-box').removeClass('hide');
    $('div.requested.voter-box, div.completed.voter-box').addClass('hide');
  });
  $('a.completed-matches').click( function(e){
    e.preventDefault();
    $(this).addClass('current');
    $('a.accepted-voters, a.requested-voters').removeClass('current');
    $('div.completed.voter-box').removeClass('hide');
    $('div.requested.voter-box, div.accepted.voter-box').addClass('hide');
  });
}
//lightbox display with data attribute lightbox
function showLightBox() {
  $('.lightbox-button').click( function(e){
    e.preventDefault();
    var lightboxID = $(this).attr('data-lightbox');
    if ($('#'+lightboxID).length) {
      $('#'+lightboxID).removeClass('hide');
      $('.green-overlay').removeClass('hide');
    }
  });
}

function closeLightBox() {
  $('.lightbox .close-icon').click(function(){
    $(this).parent().addClass('hide');
    $('.green-overlay').addClass('hide');
  })
}
/* FILE UPLOAD - get filename that will be uploaded and display in fake placeholder field*/
function getFilePath(){
     $('input[type=file]').change(function () {
         var filename=$('#file_upload')[0].files[0].name;
         $('#file_name').prop('placeholder',filename);
     });
}

$(document).ready(function(){
  tooltip();
  mobileNav();
  $( ".datepicker" ).datepicker();
  getFilePath();
  showMatches();
  showLightBox();
  closeLightBox();
  filterShow();
});



//display navigation links if nav is hidden when browser size is larger than tablet

$( window ).resize(function() {
  var windowWidth = $(window).width();
  var hiddenNav = $('header nav').hasClass('hide');
  if ( windowWidth >= 640 && hiddenNav ) {
    $('header nav').removeClass('hide');
  }
});

