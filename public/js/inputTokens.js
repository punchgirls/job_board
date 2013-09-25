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
  var x = document.createElement("li");

  x.onclick = function() {
    deleteToken(token, x);
  };

  token.appendChild(document.createTextNode(value));
  x.appendChild(document.createTextNode(" X "));

  var listItems = tokens.getElementsByTagName("li");
  var lastChild = listItems[listItems.length - 1];

  tokens.insertBefore(token, lastChild);
  tokens.insertBefore(x, lastChild);

  searchInput.focus();

  searchInput.value = "";
  autocomplete.style.display = "none";
}

function deleteToken(token, x) {
  tokens.removeChild(token);
  tokens.removeChild(x);
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

  if (e.keyCode == '13') {
    addToken(list[selectedToken].innerHTML);
    selectedToken = -1;
    return false;
  }
  if ((e.keyCode == '27') || (e.keyCode == '9')) {
    autocomplete.style.display = "none";
  }
};

searchInput.onkeyup = function(e) {
  var input = searchInput.value;
  var regExp = new RegExp(input, "i");

  autocomplete.innerHTML = "";

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

  for (var i = 0; i < (skills.length - 1) ; i+=2) {
    query += skills[i].innerHTML;

    if(i < skills.length - 3) {
      query += ", ";
    }
  };

  queryInput.value = query;
};
