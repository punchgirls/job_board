var countdown = document.getElementById("countdown");
var description = document.getElementById("description");

function updateCountdown() {
    // 600 is the max message length
    var remaining = 600 - description.value.length;
    countdown.innerHTML = remaining + " characters remaining.";
}

function updateCountdownMsg(id) {
    var messageTxt = document.getElementById("messageTxt_" + id);
    var countdownMsg = document.getElementById("countdownMsg_" + id);

    // 200 is the max message length
    var remaining = 200 - messageTxt.value.length;
    countdownMsg.innerHTML = remaining + " characters remaining.";
}

description.onkeyup = function() {
    updateCountdown();
};

window.onload = function() {
    updateCountdown();
};
