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
  var addMsgLink = document.getElementById("add_msg_link_" + id);
  var appsSize = document.getElementById("apps_size");

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      post.innerHTML = "APPLIED";
      post.setAttribute("class", "button_applied");
      addMsgLink.innerHTML = "Send a message?";
      addMsgLink.setAttribute("class", "add_message cursor");
      appsSize.innerHTML = parseInt(appsSize.innerHTML) + 1;
    }
  };

  request.send();
}

function addMsg (id) {
  var messageFrm = document.getElementById("message_form_" + id);
  var addMsgLink = document.getElementById("add_msg_link_" + id);
  addMsgLink.style.display = "none";
  messageFrm.style.display = "block";
}

function closeMsgFrm (id) {
  var messageFrm = document.getElementById("message_form_" + id);
  var addMsgLink = document.getElementById("add_msg_link_" + id);
  addMsgLink.style.display = "block";
  messageFrm.style.display = "none";
}

function sendMsg (postId, developerId) {
  var messageFrm = document.getElementById("message_form_" + postId);
  var messageTxt = document.getElementById("messageTxt_" + postId).value;
  var url = "/message/" + postId + "/" + developerId + "/?message=" + messageTxt;
  var message = document.getElementById("message_" + postId);
  var sentOK = document.getElementById("sent_ok_" + postId);

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      messageFrm.style.display = "none";

      if (message) {
        message.innerHTML = '<span class="info_box_title">Sent message</span><br>' + messageTxt;
        message.setAttribute("class", "info_box");
      }

      if (sentOK) {
        sentOK.innerHTML = '<i class="fa fa-check"></i> Message sent';
      }
    }
  };

  request.send();
}

function addNote (id) {
  var noteLink = document.getElementById("note_link_" + id);
  var editNoteLink = document.getElementById("edit_note_link_" + id);
  var form = document.getElementById("note_form_" + id);
  var note = document.getElementById("note_" + id);

  noteLink.style.display = "none";

  if (editNoteLink) {
    editNoteLink.style.display = "none";
  }

  note.style.display = "none";
  form.style.display = "block";
}

function closeNoteFrm (id) {
  var noteLink = document.getElementById("note_link_" + id);
  var form = document.getElementById("note_form_" + id);
  var note = document.getElementById("note_" + id);

  noteLink.style.display = "block";
  note.style.display = "block";
  form.style.display = "none";
}

function displayNote (id) {
  var noteTxt = document.getElementById("noteTxt_" + id).value;
  var note = document.getElementById("note_" + id);
  var noteLink = document.getElementById("note_link_" + id);
  var editNoteLink = document.getElementById("edit_note_link_" + id);
  var form = document.getElementById("note_form_" + id);
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
        note.innerHTML = '<span class="info_box_title">Personal note</span><i class="fa fa-pencil-square-o cursor" id="edit_note_link_' + id + '" onclick="addNote(' + id + ')"></i><br>' + noteTxt;
        note.style.display = "block";
        note.setAttribute("class", "info_box");
      } else {
        form.style.display = "none";
        noteLink.innerHTML = "Add a personal note?";
        noteLink.style.display = "block";
      }
    }
  };

  request.send();
}

function favorite (icon) {
  var favsSize = document.getElementById("favs_size");
  var favsSizeTitle = document.getElementById("favs_size_title");

  if (icon.className === "fa fa-star favorited cursor") {
    icon.className = "fa fa-star favorite cursor";
    favsSize.innerHTML = parseInt(favsSize.innerHTML) - 1;
    favsSizeTitle.innerHTML = parseInt(favsSizeTitle.innerHTML) - 1;
  } else {
    icon.className = "fa fa-star favorited cursor";
    favsSize.innerHTML = parseInt(favsSize.innerHTML) + 1;
    favsSizeTitle.innerHTML = parseInt(favsSizeTitle.innerHTML) + 1;
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
  var application = document.getElementById("app_" + id);
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
  var appsSize = document.getElementById("apps_size");
  var appsSizeTitle = document.getElementById("apps_size_title");

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
