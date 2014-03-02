var link = document.getElementById('delete');
var cancelLink = document.getElementById('cancel');

if (link) {
  link.onclick = function () {
    var cancel = confirm(msg);
    var msg = "Are you sure you want to cancel your account?";

    if (cancel) {
      window.location = '/delete';
    }

    return false;
  };
}

if (cancelLink) {
  cancelLink.onclick = function () {
    var cancel = confirm(cancelMsg);
    var cancelMsg = "Are you sure you want to cancel your subscription?";

    if (cancel) {
      window.location = '/cancel_subscription';
    }

    return false;
  };
}

