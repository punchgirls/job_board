var msg = "Are you sure you want to cancel your account?";
var link = document.getElementById('delete');

link.onclick = function () {
  var cancel = confirm(msg);

  if (cancel) {
    var url = "/delete";
    var request = ajax();

    request.open("POST", url);

    request.onreadystatechange = function () {
      if ((request.readyState===4) && (request.status===200)) {
        window.location = '/';
      }
    };

    request.send();
  }

  return false;
};
