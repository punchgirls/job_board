var updateFrm = document.getElementById('update-form');
var updateErrors = document.getElementById('update-errors');
var updateBtn = document.getElementById('updateBtn');
var card_details = document.getElementById('card-details');
var cardInputs = card_details.getElementsByTagName('input');

card_details.onkeydown = function (e) {
  var keyCode = e.which ? e.which : e.keyCode
  var result = (keyCode >= 8 && keyCode <= 57);

  if (!result) {
    return false;
  }
};

var updateResponseHandler = function(status, response) {
  if (response.error) {
    // Show the errors on the form
    updateErrors.innerHTML = response.error.message;
    updateBtn.removeAttribute("disabled");
  } else {
    // token contains id, last4, and card type
    var token = response.id;

    // Insert the token into the form so it gets submitted to the server
    var input = document.createElement("input");
    input.type = "hidden";
    input.name = "stripeToken";
    input.value = token;

    updateFrm.appendChild(input);

    // and submit
    updateFrm.submit();
  }
};

updateFrm.onsubmit = function () {
  // Disable the submit button to prevent repeated clicks
  updateBtn.setAttribute("disabled", "disabled");

  Stripe.card.createToken(updateFrm, updateResponseHandler);

  // Prevent the form from submitting with the default action
  return false;
};
