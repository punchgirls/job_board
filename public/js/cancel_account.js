var msg = "Are you sure you want to cancel your account?";
var link = document.getElementsByClassName('cancel')[0];

link.onclick = function () {
  var cancel = confirm(msg);

  if (cancel) {
    var url = "/delete";
    var request = ajax();

    request.open("POST", url);

    request.onreadystatechange = function () {
      if ((request.readyState===4) && (request.status===200)) {
        location.reload();
      }
    };

    request.send();
  }

  return false;
};


