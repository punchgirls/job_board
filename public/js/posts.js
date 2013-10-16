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
  var message = document.getElementById("message_" + id);
  var addMsg = document.getElementById("addMsg_" + id);
  addMsg.style.display = "none";
  message.style.display = "block";
}

function sendMsg (post_id, developer_id) {
  var message = document.getElementById("message_" + post_id);
  var messageTxt = document.getElementById("messageTxt_" + post_id).value;
  var url = "/message/" + post_id + "/" + developer_id + "/?message=" + messageTxt;

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      message.style.display = "none";

      var table = document.getElementById("appTable_" + post_id);

      if (table) {
        updateTable(table, post_id)
      }

    }
  };

  request.send();
}

function updateTable(table, post_id) {

  var row = table.insertRow(5);
  var cell = row.insertCell(0);
  var messageTxt = document.getElementById("messageTxt_" + post_id).value;

  cell.innerHTML = "Message sent: " + messageTxt;
}

function note (id) {
  var note = document.getElementById("note_" + id);
  var addNote = document.getElementById("addNote_" + id);
  note.style.display = "none";
  addNote.style.display = "block";
}

function addNote (id) {
  var addNote = document.getElementById("addNote_" + id);
  var noteTxt = document.getElementById("noteTxt_" + id).value;
  var url = "/note/" + id + "/?note=" + noteTxt;
  var displayNote = document.getElementById("displayNote_" + id);

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      addNote.style.display = "none";
      displayNote.style.display = "block";
      displayNote.innerHTML = "Note: " + noteTxt;
    }
  };

  request.send();
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
