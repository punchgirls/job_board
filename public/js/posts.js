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

      applyLink.innerHTML = "<i class='fa fa-envelope'></i>send message</span>";

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
  msgForm.removeAttribute("class");
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
  noteForm.removeAttribute("class");
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
        applicationNote.innerHTML = "<span onclick='editNote(" + applicationId + ")' class='link'><i class='fa fa-pencil-square-o'></i>note:</span> " + note + "</p>";
      }

      noteForm.setAttribute("class", "note-hidden");

      if (noteLink) {
        noteLink.remove();
      }
    }
  };

  request.send();
}

function editNote (applicationId) {
  var note = document.getElementById("note-" + applicationId);

  note.setAttribute("class", "note-hidden");
  showNoteForm(applicationId);
  note.removeAttribute("class");
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

function removePost () {
 return confirm("Are you sure you want to delete this post?");
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
