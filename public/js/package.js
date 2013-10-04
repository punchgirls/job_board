var credits = document.getElementById("credits");

function setURL (value) {
  var url = "/customer/update?origin=payment&credits=" + value;
  credits.setAttribute("href", url);
}
