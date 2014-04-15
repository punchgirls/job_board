var notices = document.getElementById('notices');

function ajax () {
  if (window.XMLHttpRequest) {
    request = new XMLHttpRequest();
  } else {
    request = new ActiveXObject("Microsoft.XMLHTTP");
  }

  return request;
}

function apply (postId) {
  var post = document.getElementById("post-" + postId);
  var applyLink = document.getElementById("apply-link-" + postId);
  var postDetails = document.getElementById("post-details-" + postId);
  var applicationsSize = document.getElementById("apps-size");
  var applicationsLength = parseInt(applicationsSize.innerHTML);
  var url = "/apply/" + postId;

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      var li = document.createElement("li");
      var appStatus = document.createElement("li");

      li.appendChild(document.createTextNode(" | "));

      appStatus.setAttribute("class", "application-status");
      appStatus.appendChild(document.createTextNode("Application status: active"));

      applyLink.innerHTML = "<i class='fa fa-envelope'></i>send message to company</span>";

      applyLink.onclick = function() {
        var msgForm = document.getElementById("msg-form-" + postId);
        msgForm.removeAttribute("class");
      };

      postDetails.appendChild(li);
      postDetails.appendChild(appStatus);

      applicationsSize.innerHTML = applicationsLength + 1;
    }
  };

  request.send();
}

function showMsgForm (postId) {
  var msgForm = document.getElementById("msg-form-" + postId);
  msgForm.setAttribute("class", "msg-form");
}

function hideMsgForm (postId) {
  var msgForm = document.getElementById("msg-form-" + postId);
  msgForm.setAttribute("class", "message-hidden msg-form");
}

function sendMsg (postId) {
  var applicationMsg = document.getElementById("msg-" + postId);
  var applyLink = document.getElementById("apply-link-" + postId);
  var msgForm = document.getElementById("msg-form-" + postId);
  var showMoreLink = document.getElementById("show-more-" + postId);
  var msg = msgForm.firstElementChild.value;
  var url = "/message/" + postId + "?message=" + msg;

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {

      if (showMoreLink) {
        showMoreLink.setAttribute("style", "display:block;");
      }

      if (applicationMsg) {
        applicationMsg.innerHTML = "<span class='application-msg'><i class='fa fa-envelope'></i>message:</span> " + msg + "</p>";
      }

      msgForm.remove();
      applyLink.remove();
    }
  };

  request.send();
}

function showNoteForm (applicationId) {
  var noteForm = document.getElementById("note-form-" + applicationId);
  noteForm.setAttribute("class", "note-form");
}

function hideNoteForm (applicationId) {
  var note = document.getElementById("note-" + applicationId);
  var noteForm = document.getElementById("note-form-" + applicationId);

  note.removeAttribute("class");
  noteForm.setAttribute("class", "message-hidden msg-form");
}

function addNote (postId, applicationId) {
  var applicationNote = document.getElementById("note-" + applicationId);
  var noteLink = document.getElementById("note-link-" + applicationId);
  var noteForm = document.getElementById("note-form-" + applicationId);
  var showMoreLink = document.getElementById("show-more-" + postId);
  var note = noteForm.firstElementChild.value;
  var url = "/note/" + applicationId + "?note=" + note;

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {

      if (showMoreLink) {
        showMoreLink.setAttribute("style", "display:block;");
      }

      if (applicationNote) {
        applicationNote.innerHTML = "<span onclick='editNote(" + applicationId + ")' class='link'><i class='fa fa-pencil-square-o'></i>note to self:</span> " + note + "</p>";
      }

      noteForm.setAttribute("class", "note-hidden note-form");

      if (noteLink) {
        noteLink.remove();
      }

      applicationNote.removeAttribute("class");
    }
  };

  request.send();
}

function editNote (applicationId) {
  var note = document.getElementById("note-" + applicationId);

  note.setAttribute("class", "note-hidden note-form");
  showNoteForm(applicationId);
}

function favorite (favoriteLink) {
  favoriteLink.innerHTML = "<i class='fa fa-star'></i>favorited";
  favoritesSize.innerHTML = favoritesLength + 1;
}

function unfavorite (favoriteLink) {
  favoriteLink.innerHTML = "<i class='fa fa-star-o'></i>favorite";
  favoritesSize.innerHTML = favoritesLength - 1;
}

function favoritePost (postId) {
  var post = document.getElementById("post-" + postId);
  var favoriteLink = document.getElementById("favorite-link-" + postId);
  var favoritesSize = document.getElementById("favs-size");
  var favoritesLength = parseInt(favoritesSize.innerHTML);
  var url = "/favorite/" + postId;

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      if (favoriteLink.firstElementChild.className == "fa fa-star") {
         favoritesSize.innerHTML = favoritesLength - 1;
         unfavorite(favoriteLink);
      } else {
        favoritesSize.innerHTML = favoritesLength + 1;
        favorite(favoriteLink);
      }
    }
  };

  request.send();
}

function publishPost (postId, planPosts) {
  var publishLink = document.getElementById("publish-link-" + postId);
  var publishedPostsSpan = document.getElementById("published-posts-size");
  var publishedPostsSize = parseInt(publishedPostsSpan.innerHTML);

  var url = "/post/status/" + postId;

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {

      if (publishLink.firstElementChild.className == "fa fa-check published") {
        publishLink.innerHTML = "<i class='fa fa-check unpublished'></i>publish";
        publishedPostsSpan.innerHTML = publishedPostsSize - 1;
        notices.innerHTML = "";
      } else {
        if (publishedPostsSize < planPosts) {
          publishLink.innerHTML = "<i class='fa fa-check published'></i>unpublish";
          publishedPostsSpan.innerHTML = publishedPostsSize + 1;
        } else {
          notices.innerHTML = "You can only have " + planPosts + " published post(s).";
        }
      }
    }
  };

  request.send();
}

function favoriteApplicant (applicationId) {
  var favoriteLink = document.getElementById("favorite-link-" + applicationId);
  var url = "/application/" + applicationId + "/favorite/";

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      if (favoriteLink.firstElementChild.className == "fa fa-star") {
        favoriteLink.innerHTML = "<i class='fa fa-star-o'></i>favorite";
      } else {
        favoriteLink.innerHTML = "<i class='fa fa-star'></i>favorited";
      }
    }
  };

  request.send();
}

function confirmDelete (item) {
 return confirm("Are you sure you want to remove this " + item + "?");
}

function addApplicant (applicationId) {
  var application = document.getElementById("application-" + applicationId);
  var activeApplications = document.getElementById("active-applications");
  var activeApplicationsSize = parseInt(activeApplications.innerHTML);

  var url = "/application/" + applicationId + "/add";

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      activeApplications.innerHTML = activeApplicationsSize + 1;
      application.remove();
    }
  };

  request.send();
}

function discardApplicant (applicationId) {
  var discard = confirm("When discarding an applicant, he/she will receive a notification. Continue?");

  if (discard) {
    var application = document.getElementById("application-" + applicationId);
    var activeApplications = document.getElementById("active-applications");
    var activeApplicationsSize = parseInt(activeApplications.innerHTML);

    var url = "/application/" + applicationId + "/discard";

    var request = ajax();
    request.open("POST", url);

    request.onreadystatechange = function () {
      if ((request.readyState===4) && (request.status===200)) {
        activeApplications.innerHTML = activeApplicationsSize - 1;
        application.remove();
      }
    };

    request.send();
  }
}

function toggle (postId) {
  var span = document.getElementById("hidden-" + postId);
  var showMoreLink = document.getElementById("show-more-" + postId);

  if (span.className == "hidden") {
    showMoreLink.innerHTML = "show less";
    span.removeAttribute("class");
  } else {
    showMoreLink.innerHTML = "show more";
    span.setAttribute("class", "hidden");
  }
}
