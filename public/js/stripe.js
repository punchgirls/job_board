var paymentFrm = document.getElementById('payment-form');
var paymentErrors = document.getElementById('payment-errors');
var button = document.getElementById('button');

var stripeResponseHandler = function(status, response) {
  if (response.error) {
    // Show the errors on the form
    paymentErrors.innerHTML = response.error.message;
    button.removeAttribute("disabled");
  } else {
    // token contains id, last4, and card type
    var token = response.id;

    // Insert the token into the form so it gets submitted to the server
    var input = document.createElement("input");
    input.type = "hidden";
    input.name = "stripeToken";
    input.value = token;

    paymentFrm.appendChild(input);

    // and submit
    paymentFrm.submit();
  }
};

paymentFrm.onsubmit = function () {
  // Disable the submit button to prevent repeated clicks
  button.setAttribute("disabled", "disabled");

  Stripe.card.createToken(paymentFrm, stripeResponseHandler);

  // Prevent the form from submitting with the default action
  return false;
};
