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
        var msgSpan = document.getElementById("msg-" + postId);
        msgSpan.removeAttribute("class");
      };

      postDetails.appendChild(li);
      postDetails.appendChild(appStatus);

      applicationsSize.innerHTML = applicationsLength + 1;
    }
  };

  request.send();
}

function showMsgForm (postId) {
  var msgSpan = document.getElementById("msg-" + postId);
  msgSpan.removeAttribute("class");
}

function sendMsg (postId) {
  var applyLink = document.getElementById("apply-link-" + postId);
  var msgSpan = document.getElementById("msg-" + postId);
  var msgForm = document.getElementById("msg-form-" + postId);
  var msg = msgForm.firstElementChild.value;
  var url = "/message/" + postId + "?message=" + msg;

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      msgSpan.remove();
      applyLink.remove();
    }
  };

  request.send();
}

function addNote (application_id) {
  var noteSpan = document.getElementById("note-" + application_id);
  noteSpan.removeAttribute("class");
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
  var url = "/note/" + id + "/?note=" + noteTxt;

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

function showMore (id) {
  var showMoreLink = document.getElementById("show-more-link-" + id);
  var showMoreSection = document.getElementById("show-more-" + id);

  if (showMoreLink.innerHTML == "Show more") {
    showMoreLink.innerHTML = "Show less";
    showMoreLink.style.marginTop = "-42px";
    showMoreSection.className = "less";
  } else {
    showMoreLink.innerHTML = "Show more";
    showMoreLink.style.marginTop = "10px";
    showMoreSection.className = "more";
  }
}
