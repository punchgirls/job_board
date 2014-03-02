// AVOID SUBMIT ON ENTER WHEN SEARCHING LOCATION

function noSubmit() {
  var inputLocation = document.getElementById("search-text-field");

  if (inputLocation) {
    inputLocation.onkeypress = function(e){
      if (!e) e = window.event;
      var keyCode = e.keyCode || e.which;

      if (keyCode == '13'){
        // Enter pressed
        return false;
      }
    };
  }
}

// WHEN THE DOCUMENT LOADS

window.onload = function() {
  noSubmit();
}
