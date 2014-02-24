var form = document.getElementsByClassName('payment-details')[0];
var paymentFrm = document.getElementById('paymentFrm');
var errors = document.getElementById('notices');
var button = document.getElementById('button');
var digits = document.getElementById('digits');
var errorMessages = document.getElementsByClassName("alert error");

if (digits) {
  var digitsInputs = digits.getElementsByTagName('input');

  digits.onkeydown = function (e) {
    var keyCode = e.which ? e.which : e.keyCode;
    var result = (keyCode >= 8 && keyCode <= 57);

    if (!result) {
      return false;
    }
  };
}

var stripeResponseHandler = function(status, response) {
  if (response.error) {
    // Show the errors on the form
    for (var i = 0; i < errorMessages.length; i++) {
      errorMessages[i].innerHTML = "";
    }
    errors.setAttribute("class", "alert error");
    errors.innerHTML = response.error.message;
    button.removeAttribute("disabled");
  } else {
    // token contains id, last4, and card type
    var token = response.id;

    // Insert the token into the form so it gets submitted to the server
    var input = document.createElement("input");
    input.type = "hidden";
    input.name = "stripe_token";
    input.value = token;

    form.appendChild(input);

    // and submit
    form.submit();
  }
};

if (form) {
  form.onsubmit = function () {
    // Disable the submit button to prevent repeated clicks
    button.setAttribute("disabled", "disabled");

    Stripe.card.createToken(form, stripeResponseHandler);

    // Prevent the form from submitting with the default action
    return false;
  };
}

if (paymentFrm) {
  paymentFrm.onsubmit = function () {
    // Disable the submit button to prevent repeated clicks
    button.setAttribute("disabled", "disabled");
  };
}
