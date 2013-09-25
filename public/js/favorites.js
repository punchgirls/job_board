function favorite (id) {
  var post = document.getElementById(id);
  var url = "/favorite/" + id;

  if (window.XMLHttpRequest) {
    request = new XMLHttpRequest();
  } else {
    request = new ActiveXObject("Microsoft.XMLHTTP");
  }

  request.open("POST", url);

  request.onreadystatechange = function() {
    console.log(request.readyState + " " + request.status );
    if ((request.readyState===4) && (request.status===200)) {
      if (post.className === "icon-heart red") {
        post.className = "icon-heart";
      } else {
        post.className = "icon-heart red";
      }
    }
  };

  request.send();
}
