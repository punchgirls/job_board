var request;
var skills;
var li;

var selectedToken = -1;

var searchInput = document.getElementById("search-field");
var tokenInput = document.getElementById("token-input");
var queryInput = document.getElementById("query");

var autocomplete = document.getElementById("autocomplete");
var tokens = document.getElementById("tokens");

var list = autocomplete.childNodes;
var searchFrm = document.form;

var tags = document.getElementById("tags");

if (tags != null) {
  tags = tags.value.split(",");

  for(var i in tags) {
    addToken(tags[i]);
  }
}

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

function addToAutocomplete(value) {
  var li = document.createElement("li");
  li.appendChild(document.createTextNode(value));

  li.onclick = function() {
    addToken(value);
  };

  autocomplete.appendChild(li);
}

function addToken(value) {
  var token = document.createElement("li");
  var token_span = document.createElement("span");
  var x = document.createElement("span");

  x.onclick = function() {
    deleteToken(token);
  };

  token_span.appendChild(document.createTextNode(value))
  token.appendChild(token_span);
  x.appendChild(document.createTextNode(" X "));
  token.appendChild(x);

  token.style.margin = "4px 0 4px 4px";

  var listItems = tokens.getElementsByTagName("li");
  var lastChild = listItems[listItems.length - 1];

  tokens.insertBefore(token, lastChild);

  searchInput.focus();

  searchInput.value = "";
  autocomplete.style.display = "none";
}

function deleteToken(token) {
  tokens.removeChild(token);
}

tokens.onclick = function() {
  searchInput.focus();
};

document.onclick = function(e) {
  if (e.srcElement.id == "search-field") {
    autocomplete.style.display = "block";

    for (var key in skills) {
      addToAutocomplete(skills[key].name);
    }
  } else {
    autocomplete.style.display = "none";
  }
};

searchInput.onkeydown = function(e) {
  e = e || window.event;

  autocomplete.style.display = "block";
  searchInput.removeAttribute("placeholder");
  searchInput.style.width = "130px";

  if (e.keyCode == '13') {
    addToken(list[selectedToken].innerHTML);
    selectedToken = -1;
    return false;
  }

  if ((e.keyCode == '27') || (e.keyCode == '9')) {
    autocomplete.style.display = "none";
  }

  if (e.keyCode == '8') {
    if (searchInput.value == "") {
      var skills = tokens.getElementsByTagName("li");
      var token = skills[skills.length - 2];

      deleteToken(token);
    }
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

  if (e.keyCode == '38') {
    if(selectedToken > 0) {
      list[--selectedToken].id = "highlight";
    }
  }
  else if (e.keyCode == '40') {
    if(selectedToken < list.length - 1) {
      list[++selectedToken].id = "highlight";
    }
  }
};

postFrm.onsubmit = function() {
  var skills = tokens.getElementsByTagName("li");
  var query = "";

  for (var i = 0; i < skills.length - 1 ; i++) {
    query += skills[i].childNodes[0].innerHTML;

    if(i < skills.length - 2) {
      query += ", ";
    }
  };

  queryInput.value = query;
};
