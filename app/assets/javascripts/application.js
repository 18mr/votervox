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
  $('.menu-icon').click( function(){
    $(this).toggleClass('opened');

    if ( $(this).hasClass('opened') ) {
      $('header nav').slideDown(1000, function(){
        $('header nav').toggleClass('hide');
      });
    } else {
      $('header nav').slideUp(1000, function(){
        $('header nav').toggleClass('hide');
      });
    }
    
  })
}

$(document).ready(function(){
  tooltip();
  mobileNav();
  $( ".datepicker" ).datepicker();
});

//display navigation links if nav is hidden when browser size is larger than tablet

$( window ).resize(function() {
  var windowWidth = $(window).width();
  var hiddenNav = $('header nav').hasClass('hide');
  if ( windowWidth >= 640 && hiddenNav ) {
    $('header nav').removeClass('hide');
  }
});