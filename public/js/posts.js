var notices = document.getElementById('notices');

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
  var appsSizeSidebar = document.getElementById("apps-size-sidebar");
  var request = ajax();
  request.open("POST", url);

  post.innerHTML = '<i class="fa fa-check post-control-icon applied-icon"></i><span class="applied-text">Applied</span>';
  post.removeAttribute("onclick");
  post.className = ("applied cursor");
  addMsgLink.innerHTML = "Send message to company";
  addMsgLink.className = "send-message-link";

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      appsSize.innerHTML = parseInt(appsSize.innerHTML) + 1;
      appsSizeSidebar.innerHTML = parseInt(appsSizeSidebar.innerHTML) + 1;
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
        message.innerHTML = '<h3 class="item-subtitle">Sent message:</h3><p class="item-text">' + messageTxt + '</p>';
      }

      if (sentOK) {
        sentOK.innerHTML = '<i class="fa fa-check post-control-icon message-sent-icon"></i>Message sent';
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
  var editNoteLink = document.getElementById("edit-note-link-" + id);

  if (editNoteLink) {
    editNoteLink.style.display = "inline-block";
  }

  noteLink.style.display = "block";
  note.style.display = "block";
  form.style.display = "none";
}

function displayNote (id) {
  var noteTxt = document.getElementById("note-txt-" + id).value;
  var note = document.getElementById("note-" + id);
  var noteLink = document.getElementById("note-link-" + id);
  var form = document.getElementById("note-form-" + id);
  var editNoteLink = document.getElementById("edit-note-link-" + id);
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
        note.innerHTML = '<h3 class="item-subtitle">Personal note <i id="edit-note-link-' + id + '" class="fa fa-pencil-square-o cursor" onclick="addNote(' + id + ')"></i></h3><p class="item-text">' + noteTxt + '</p>';
        note.style.display = "block";
      } else {
        form.style.display = "none";
        noteLink.innerHTML = "Add a personal note?";
        noteLink.style.display = "block";
        editNoteLink.style.display = "inline-block";
      }
    }
  };

  request.send();
}

function favorite (post) {
  if (post.className === "favorited cursor") {
    post.className = "cursor";
    post.innerHTML = '<i class="fa fa-star post-control-icon"></i><span class="underline">Favorite</span>';
  } else {
    post.className = "favorited cursor";
    post.innerHTML = '<i class="fa fa-star post-control-icon favorited-icon"></i><span class="favorited-text underline">Favorited</span>';
  }
}

function favoritePost (id) {
  var post = document.getElementById(id);
  var url = "/favorite/" + id;
  var favsSize = document.getElementById("favs-size");
  var favsSizeSidebar = document.getElementById("favs-size-sidebar");

  var request = ajax();
  request.open("POST", url);

  favorite(post);

  if (post.className === "favorited cursor") {
    favsSize.innerHTML = parseInt(favsSize.innerHTML) + 1;
    favsSizeSidebar.innerHTML = parseInt(favsSizeSidebar.innerHTML) + 1;
  } else {
    favsSize.innerHTML = parseInt(favsSize.innerHTML) - 1;
    favsSizeSidebar.innerHTML = parseInt(favsSizeSidebar.innerHTML) - 1;
  }

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      var favsSizeTitle = document.getElementById("favs-size-title");

      favsSizeTitle.innerHTML = favsSize.innerHTML;
    }
  };

  request.send();
}

function publishPost (id) {
  var publishLink = document.getElementById("publish-link-" + id);
  var icon = publishLink.childNodes[1];
  var span = publishLink.childNodes[3];
  var publishedPostsTitle = document.getElementById("published-posts-title");
  var publishedPostsSidebar = document.getElementById("published-posts-sidebar");
  var numberOfPosts = parseInt(publishedPostsTitle.innerHTML);
  var url = "/post/status/" + id;

  var request = ajax();
  request.open("POST", url);

  if (icon.className == "fa fa-check post-control-icon published-icon") {
    icon.className = "fa fa-check post-control-icon";
    span.innerHTML = "Publish";

  } else {
    icon.className = "fa fa-check post-control-icon published-icon";
    span.innerHTML = "Unpublish";
  }

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      if (icon.className == "fa fa-check post-control-icon published-icon") {
        publishedPostsTitle.innerHTML = numberOfPosts + 1;
        publishedPostsSidebar.innerHTML = numberOfPosts + 1;
      } else {
        publishedPostsTitle.innerHTML = numberOfPosts - 1;
        publishedPostsSidebar.innerHTML = numberOfPosts - 1;
      }
    }
  };

  request.send();
}

function favoriteApplicant (id) {
  var application = document.getElementById("application-" + id);
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
  var span = document.createElement("span");
  notices.appendChild(span);
  span.className = "alert success";

  if (cancel) {
    var request = ajax();
    request.open("POST", url);

    request.onreadystatechange = function () {
      if ((request.readyState===4) && (request.status===200)) {
        posts.removeChild(post);
        span.innerHTML = "Post successfully removed! The change will be updated within a few minutes.";
      }
    };

    request.send();
  }
}

function addApplicant (id) {
  var applications = document.getElementById("application-list");
  var application = document.getElementById("app-" + id);
  var numberOfApplicants = document.getElementById("number-of-applicants");
  var value = numberOfApplicants.innerHTML;
  var url = "/application/add/" + id;

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      console.log(request);
      applications.removeChild(application);
      numberOfApplicants.innerHTML = parseInt(value) - 1;
    }
  };

  request.send();
}

function discardApplicant (id) {
  var applications = document.getElementById("application-list");
  var application = document.getElementById("app-" + id);
  var numberOfApplicants = document.getElementById("number-of-applicants");
  var value = numberOfApplicants.innerHTML;
  var url = "/application/discard/" + id;

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      console.log(request);
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
  var appsSize = document.getElementById("apps-size");
  var appsSizeSidebar = document.getElementById("apps-size-sidebar");
  var msg = "Are you sure you want to delete the application? By performing this action the company will no longer be able to see your application.";
  var cancel = confirm(msg);
  var span = document.createElement("span");
  notices.appendChild(span);
  span.className = "alert success";

  if (cancel) {
    var request = ajax();
    request.open("POST", url);

    request.onreadystatechange = function() {
      if ((request.readyState===4) && (request.status===200)) {
        applications.removeChild(application);
        appsSize.innerHTML = parseInt(appsSize.innerHTML) - 1;
        appsSizeSidebar.innerHTML = parseInt(appsSizeSidebar.innerHTML) - 1;
        span.innerHTML = "Application successfully removed! The change will be updated within a few minutes.";
      }
    };

    request.send();
  }
}

function showMore (id) {
  var showMoreLink = document.getElementById("show-more-link-" + id);
  var showMoreSection = document.getElementById("show-more-" + id);

  if (showMoreLink.innerHTML == "Show more") {
    showMoreLink.innerHTML = "Show less";
    showMoreSection.className = "less";
  } else {
    showMoreLink.innerHTML = "Show more";
    showMoreSection.className = "more";
  }
}
