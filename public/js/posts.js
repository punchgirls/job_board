function ajax () {
  if (window.XMLHttpRequest) {
    request = new XMLHttpRequest();
  } else {
    request = new ActiveXObject("Microsoft.XMLHTTP");
  }

  return request;
}

function apply (id) {
  var post = document.getElementById("post_" + id);
  var url = "/apply/" + id;
  var addMsgLink = document.getElementById("add-msg-link-" + id);
  var appsSize = document.getElementById("apps-size");
  var appsSizeAside = document.getElementById("apps-size-aside");

  var request = ajax();
  request.open("POST", url);

  post.innerHTML = '<i class="fa fa-check"></i><span>Applied</span>';
  post.removeAttribute("onclick");
  post.className = ("applied cursor");
  addMsgLink.innerHTML = "Send message to company";
  addMsgLink.className = "send_message";

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      appsSize.innerHTML = parseInt(appsSize.innerHTML) + 1;
      appsSizeAside.innerHTML = parseInt(appsSizeAside.innerHTML) + 1;
    }
  };

  request.send();
}

function addMsg (id) {
  var messageFrm = document.getElementById("message-form-" + id);
  var addMsgLink = document.getElementById("add-msg-link-" + id);
  addMsgLink.style.display = "none";
  messageFrm.style.display = "block";
}

function closeMsgFrm (id) {
  var messageFrm = document.getElementById("message-form-" + id);
  var addMsgLink = document.getElementById("add-msg-link-" + id);
  addMsgLink.style.display = "block";
  messageFrm.style.display = "none";
}

function sendMsg (postId, developerId) {
  var messageFrm = document.getElementById("message-form-" + postId);
  var messageTxt = document.getElementById("message-txt-" + postId).value;
  var url = "/message/" + postId + "/" + developerId + "/?message=" + messageTxt;
  var message = document.getElementById("message-" + postId);
  var sentOK = document.getElementById("sent-ok-" + postId);

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      messageFrm.style.display = "none";

      if (message) {
        message.innerHTML = '<span>Sent message</span><br>' + messageTxt;
      }

      if (sentOK) {
        sentOK.innerHTML = '<i class="fa fa-check"></i>Message sent';
      }
    }
  };

  request.send();
}

function addNote (id) {
  var noteLink = document.getElementById("note-link-" + id);
  var editNoteLink = document.getElementById("edit-note-link-" + id);
  var form = document.getElementById("note-form-" + id);
  var note = document.getElementById("note-" + id);

  noteLink.style.display = "none";

  if (editNoteLink) {
    editNoteLink.style.display = "none";
  }

  note.style.display = "none";
  form.style.display = "block";
}

function closeNoteFrm (id) {
  var noteLink = document.getElementById("note-link-" + id);
  var form = document.getElementById("note-form-" + id);
  var note = document.getElementById("note-" + id);

  noteLink.style.display = "block";
  note.style.display = "block";
  form.style.display = "none";
}

function displayNote (id) {
  var noteTxt = document.getElementById("note-txt-" + id).value;
  var note = document.getElementById("note-" + id);
  var noteLink = document.getElementById("note-link-" + id);
  var editNoteLink = document.getElementById("edit-note-link-" + id);
  var form = document.getElementById("note-form-" + id);
  var url;

  if (noteTxt != "") {
    url = "/note/" + id + "/?note=" + noteTxt;
  } else {
    url = "/note/" + id + "/?note=empty";
  }

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      if (noteTxt != "") {
        form.style.display = "none";
        note.innerHTML = '<span>Personal note</span><i class="fa fa-pencil-square-o cursor" id="edit-note-link-' + id + '" onclick="addNote(' + id + ')"></i><br>' + noteTxt;
        note.style.display = "block";
      } else {
        form.style.display = "none";
        noteLink.innerHTML = "Add a personal note?";
        noteLink.style.display = "block";
      }
    }
  };

  request.send();
}

function favorite (post) {
  if (post.className === "favorited cursor") {
    post.className = "favorite cursor";
    post.innerHTML = '<i class="fa fa-star"></i><span class="underline">Favorite</span>';
  } else {
    post.className = "favorited cursor";
    post.innerHTML = '<i class="fa fa-star"></i><span class="underline">Favorited</span>';
  }
}

function favoritePost (id) {
  var post = document.getElementById(id);
  var url = "/favorite/" + id;
  var favsSize = document.getElementById("favs-size");
  var favsSizeAside = document.getElementById("favs-size-aside");

  var request = ajax();
  request.open("POST", url);

  favorite(post);

  if (post.className === "favorited cursor") {
    favsSize.innerHTML = parseInt(favsSize.innerHTML) + 1;
    favsSizeAside.innerHTML = parseInt(favsSizeAside.innerHTML) + 1;
  } else {
    favsSize.innerHTML = parseInt(favsSize.innerHTML) - 1;
    favsSizeAside.innerHTML = parseInt(favsSizeAside.innerHTML) - 1;
  }

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      var favsSizeTitle = document.getElementById("favs-size-title");

      favsSizeTitle.innerHTML = favsSize.innerHTML;
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
  var msg = "Are you sure you want to delete the post?";
  var cancel = confirm(msg);

  if (cancel) {
    var request = ajax();
    request.open("POST", url);

    request.onreadystatechange = function () {
      if ((request.readyState===4) && (request.status===200)) {
        posts.removeChild(post);
      }
    };

    request.send();
  }
}

function removeApplicant (id) {
  var applications = document.getElementById("application-list");
  var application = document.getElementById("app-" + id);
  var numberOfApplicants = document.getElementById("number-of-applicants");
  var value = numberOfApplicants.innerHTML;
  var url = "/application/remove/" + id;
  var msg = "Are you sure you want to delete the post?";
  var cancel = confirm(msg);

  if (cancel) {
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
}

function removeApplication (id) {
  var application = document.getElementById(id);
  var applications = document.getElementById("applications-list");
  var url = "/remove/" + id;
  var appsSize = document.getElementById("apps-size");
  var appsSizeTitle = document.getElementById("apps-size-title");

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function() {
    if ((request.readyState===4) && (request.status===200)) {
      applications.removeChild(application);
      appsSize.innerHTML = parseInt(appsSize.innerHTML) - 1;
      appsSizeTitle.innerHTML = parseInt(appsSizeTitle.innerHTML) - 1;
    }
  };

  request.send();
}
