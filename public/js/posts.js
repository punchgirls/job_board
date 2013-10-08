function ajax () {
  if (window.XMLHttpRequest) {
    request = new XMLHttpRequest();
  } else {
    request = new ActiveXObject("Microsoft.XMLHTTP");
  }

  return request;
}

function apply (id) {
  var post = document.getElementById("apply_" + id);
  var url = "/apply/" + id;
  var addMsg = document.getElementById("addMsg_" + id);

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      post.innerHTML = "APPLIED";
      post.removeAttribute("class");
      addMsg.innerHTML = "Add a message";
    }
  };

  request.send();
}

function addMsg (id) {
  var messageFrm = document.getElementById("messageFrm_" + id);
  var addMsg = document.getElementById("addMsg_" + id);
  addMsg.style.display = "none";
  messageFrm.style.display = "block";
}

function sendMsg (post_id, developer_id) {
  // var url = "/message/" + post_id + "/" + developer_id;
  // var messageFrm = document.getElementById("messageFrm_" + id);

  // var request = ajax();
  // request.open("POST", url);

  // request.onreadystatechange = function () {
  //   if ((request.readyState===4) && (request.status===200)) {
  //     messageFrm.style.display = "none";
  //   }
  // };

  // request.send();

  // return false;
}

function favorite (icon) {
  if (icon.className === "icon-heart red") {
    icon.className = "icon-heart";
  } else {
    icon.className = "icon-heart red";
  }
}

function favoritePost (id) {
  var post = document.getElementById(id);
  var url = "/favorite/" + id;

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      favorite(post);
    }
  };

  request.send();
}

function favoriteApplicant (id) {
  var application = document.getElementById(id);
  var url = "/application/favorite/" + id;

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      favorite(application);
    }
  };

  request.send();
}

function removePost (id) {
  var post = document.getElementById(id);
  var posts = document.getElementById("posts-list");
  var url = "post/remove/" + id;

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      posts.removeChild(post);
    }
  };

  request.send();
}

function removeApplicant (id) {
  var applications = document.getElementById("application-list");
  var application = document.getElementById("app_" + id);
  var numberOfApplicants = document.getElementById("numer-of-applicants");
  var value = numberOfApplicants.innerHTML
  var url = "/application/remove/" + id;

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      applications.removeChild(application);
      numberOfApplicants.innerHTML = parseInt(value) - 1;
    }
  };

  request.send();
}

function removeApplication (id) {
  var application = document.getElementById(id);
  var applications = document.getElementById("applications-list");
  var url = "/remove/" + id;

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function() {
    if ((request.readyState===4) && (request.status===200)) {
      applications.removeChild(application);
    }
  };

  request.send();
}
