function openMenu () {
  var navHeaderResponsive = document.getElementById("nav_header_responsive");
  var arrow = document.getElementById("menu_arrow");

  if (navHeaderResponsive.style.display === "inline-block") {
    navHeaderResponsive.style.display = "none";
    arrow.className = "fa fa-caret-down";
  } else {
    navHeaderResponsive.style.display = "inline-block";
    arrow.className = "fa fa-caret-up";
  }
}
