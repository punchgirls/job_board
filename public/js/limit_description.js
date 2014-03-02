var countdown = document.getElementById("countdown");
var description = document.getElementById("description");

function updateCountdown() {
  // 600 is the max message length
  var remaining = 600 - description.value.length;
  countdown.innerHTML = remaining + " characters remaining.";
}

function updateCountdownMsg(id) {
  var messageTxt = document.getElementById("message-txt-" + id);
  var countdownMsg = document.getElementById("countdown-msg-" + id);

  var remaining = 200 - messageTxt.value.length;
  countdownMsg.innerHTML = remaining + " characters remaining.";
}

function updateCountdownBio() {
  var bioTxt = document.getElementById("developer-bio");
  var countdownBio = document.getElementById("countdown-bio");

  var remaining = 200 - bioTxt.value.length;
  countdownBio.innerHTML = remaining + " characters remaining.";
}

description.onkeyup = function() {
  updateCountdown();
};

window.onload = function() {
  updateCountdown();
};
