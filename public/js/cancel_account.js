var link = document.getElementById('delete');
var cancelLink = document.getElementById('cancel');

if (link) {
  link.onclick = function () {
    return confirm("Are you sure you want to cancel your account?");
  };
}

if (cancelLink) {
  cancelLink.onclick = function () {
    return confirm("Are you sure you want to cancel your subscription?");
  };
}

