function ajax () {
  if (window.XMLHttpRequest) {
    request = new XMLHttpRequest();
  } else {
    request = new ActiveXObject("Microsoft.XMLHTTP");
  }

  return request;
}

function chosenPlan(plan) {
  var chosenPlan = document.getElementById("chosen_plan");
  var url = "/signup?plan_id=" + plan;

  var request = ajax();
  request.open("POST", url);

  request.onreadystatechange = function () {
    if ((request.readyState===4) && (request.status===200)) {
      chosenPlan.innerHTML = plan;
    }
  };

  request.send();
}
