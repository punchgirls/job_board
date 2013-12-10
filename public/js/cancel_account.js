var msg = "Are you sure you want to cancel your account?";
var link = document.getElementById('delete');

link.onclick = function () {
  var cancel = confirm(msg);

  if (cancel) {
    window.location = '/delete';
  }

  return false;
};
