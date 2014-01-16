function initialize() {
  var input = /** @type {HTMLInputElement} */(document.getElementById('search-text-field'));

  var options = {
    types: ["(cities)"]
  };

  var autocomplete = new google.maps.places.Autocomplete(input, options);
}

google.maps.event.addDomListener(window, 'load', initialize);
