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

function removePost (id) {
  var post = document.getElementById(id);
  var posts = document.getElementById("posts-list");
  var url = "post/remove/" + id;

  if (window.XMLHttpRequest) {
    request = new XMLHttpRequest();
  } else {
    request = new ActiveXObject("Microsoft.XMLHTTP");
  }

  request.open("POST", url);

  request.onreadystatechange = function() {
    if ((request.readyState===4) && (request.status===200)) {
      posts.removeChild(post);
    }
  };

  request.send();
}
