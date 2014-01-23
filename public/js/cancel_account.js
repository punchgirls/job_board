var msg = "Are you sure you want to cancel your account?";
var cancelMsg = "Are you sure you want to cancel your subscription?";
var link = document.getElementById('delete');
var cancelLink = document.getElementById('cancel');

link.onclick = function () {
  var cancel = confirm(msg);

  if (cancel) {
    window.location = '/delete';
  }

  return false;
};

cancelLink.onclick = function () {
  var cancel = confirm(cancelMsg);

  if (cancel) {
    window.location = '/cancel_subscription';
  }

  return false;
};
