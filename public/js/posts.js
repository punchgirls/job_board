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

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      post.innerHTML = "APPLIED";
      post.setAttribute("class", "button_applied");
      addMsgLink.innerHTML = "Add a message?";
      addMsgLink.setAttribute("class", "cursor");
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

function sendMsg (postId, developerId) {
  var messageFrm = document.getElementById("message_form_" + postId);
  var messageTxt = document.getElementById("messageTxt_" + postId).value;
  var url = "/message/" + postId + "/" + developerId + "/?message=" + messageTxt;
  var message = document.getElementById("message_" + postId);

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      messageFrm.style.display = "none"

      if (message) {
        message.innerHTML = "Sent message:<br/>" + messageTxt;
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
  editNoteLink.style.display = "none";
  note.style.display = "none";
  form.style.display = "block";
}

function displayNote (id) {
  var noteTxt = document.getElementById("noteTxt_" + id).value;
  var note = document.getElementById("note_" + id);
  var noteLink = document.getElementById("note_link_" + id);
  var editNoteLink = document.getElementById("edit_note_link_" + id);

    var form = document.getElementById("note_form_" + id);
    var url = "/note/" + id + "/?note=" + noteTxt;

    var request = ajax();
    request.open("POST", url);

    request.onreadystatechange = function () {
      if ((request.readyState===4) && (request.status===200)) {
        if (noteTxt != "") {
          form.style.display = "none";
          note.innerHTML = "Personal note:<br/>" + noteTxt;
          note.style.display = "block";
          editNoteLink.setAttribute("class", "fa fa-pencil-square-o cursor");
          editNoteLink.style.display = "block";
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
  if (icon.className === "fa fa-star favorited cursor") {
    icon.className = "fa fa-star favorite cursor";
  } else {
    icon.className = "fa fa-star favorited cursor";
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
