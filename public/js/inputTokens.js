var request;
var skills = getSkills();
var li;

var tokens = document.getElementById("tokens");
var searchInput = document.getElementById("search-field");
var queryInput = document.getElementById("query");
var autocomplete = document.getElementById("autocomplete");
var tags = document.getElementById("tags");
var errors = document.getElementById('notices');

var selectedToken = 0;
var list = autocomplete.childNodes;
var searchFrm = document.form;

if (tags != null) {
  tags = tags.value.split(",");

  for(var i = 0; i < tags.length; i++) {
    addToken(tags[i]);
  }
}

function getSkills() {
  if (window.XMLHttpRequest) {
    request = new XMLHttpRequest();
  } else {
    request = new ActiveXObject("Microsoft.XMLHTTP");
  }

  request.open("GET", "/js/skills.json");

  request.onreadystatechange = function() {
    if ((request.readyState===4) && (request.status===200)) {
      skills = JSON.parse(request.responseText);
    }
  }

  request.send();
}

function addToAutocomplete(value) {
  var li = document.createElement("li");
  li.appendChild(document.createTextNode(value));

  li.onclick = function() {
    addToken(value);
  };

  autocomplete.appendChild(li);
}

function addToken(value) {
  var listItems = tokens.getElementsByTagName("li");

   if (listItems.length < 6) {
    var lastChild = listItems[listItems.length - 1];

    var token = document.createElement("li");
    var token_span = document.createElement("span");
    var x = document.createElement("span");

    token_span.appendChild(document.createTextNode(value))
    x.appendChild(document.createTextNode(" x "));

    x.onclick = function() {
      deleteToken(token);
    };

    x.setAttribute("class", "delete-token");

    token.appendChild(token_span);
    token.appendChild(x);
    token.setAttribute("class", "token");

    tokens.insertBefore(token, lastChild);

    searchInput.focus();
    searchInput.value = "";
    searchInput.removeAttribute("placeholder");
    autocomplete.setAttribute("style", "display: none;");
  } else {
    errors.setAttribute("class", "error alert");
    errors.innerHTML = "You can add up to 5 skills";
  }
}

function deleteToken(token) {
  tokens.removeChild(token);

  if(tokens.childNodes.length == 3) {
    searchInput.setAttribute("placeholder", "Search: Ruby, Cuba, Redis");
    searchInput.setAttribute("style", "width: 200px;");
  }
}

tokens.onclick = function() {
  searchInput.focus();
};

document.onclick = function(e) {
  if (e.srcElement.id == "search-field") {
    autocomplete.setAttribute("style", "display: block;");

    for (var key in skills) {
      addToAutocomplete(skills[key].name);
    }

    list[selectedToken].id = "highlight";
  } else {
    autocomplete.style.display = "none";
    list[selectedToken].removeAttribute("id");
    selectedToken = 0;
  }
};

searchInput.onkeydown = function(e) {
  e = e || window.event;

  autocomplete.style.display = "block";
  searchInput.removeAttribute("placeholder");
  searchInput.style.width = "150px";

  switch (e.keyCode) {
    case 8:
      if (searchInput.value == "") {
        var skills = tokens.getElementsByTagName("li");
        var token = skills[skills.length - 2];

        deleteToken(token);
      }
      break;
    case 9:
      autocomplete.style.display = "none";
      break;
    case 13:
      if (selectedToken != -1) {
        addToken(list[selectedToken].innerHTML);
        selectedToken = -1;
      } else {
        return true;
      }
      return false;
      break;
    case 27:
      autocomplete.style.display = "none";
      searchInput.value = "";
      break;
    case 40:
      if (selectedToken < list.length - 1) {
        list[selectedToken].id = "highlight";
      } else {
        list[0].id = "highlight";
      }
      break;
  }
};

searchInput.onkeyup = function(e) {
  var input = searchInput.value;
  var regExp = new RegExp(input, "i");

  autocomplete.innerHTML = "";

  if (searchInput.value.length < 2) {
    autocomplete.style.height = "200px";
    autocomplete.style.overflowY = "scroll";
  } else {
    autocomplete.style.height = "auto";
    autocomplete.style.overflowY = "hidden";
  }

  for (var key in skills) {
    if (skills[key].name.search(regExp) != -1 ) {
      addToAutocomplete(skills[key].name);
    }
  }

  e = e || window.event;

  switch (e.keyCode) {
    case 38:
      if (selectedToken > 0) {
        list[--selectedToken].id = "highlight";
      } else if (selectedToken === 0) {
        selectedToken = -1;
        searchInput.value = "";
        list[--selectedToken].id = "highlight";
      } else {
        list[0].id = "highlight";
      }
      break;
    case 40:
      if (selectedToken < list.length - 1) {
        list[++selectedToken].id = "highlight";
      } else {
        list[0].id = "highlight";
      }
      break;
  }
};

postFrm.onsubmit = function() {
  var skills = tokens.querySelectorAll("li.token");
  var query = "";

  for (var i = 0; i < skills.length; i ++) {
    query = query + skills[i].firstChild.innerHTML + ",";
  }

  queryInput.value = query.slice(0, -1);
};
