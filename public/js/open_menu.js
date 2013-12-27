function openMenu () {
  var navHeaderResponsive = document.getElementById("nav_header_responsive");
  var arrow = document.getElementById("menu_arrow");
  var content = document.getElementById("content");
  var footer = document.getElementsByTagName("footer");

  if (navHeaderResponsive.style.display === "inline-block") {
    navHeaderResponsive.style.display = "none";
    arrow.className = "fa fa-caret-down";
    content.style.paddingBottom = "10px";
    footer.height = "10px";
  } else {
    navHeaderResponsive.style.display = "inline-block";
    arrow.className = "fa fa-caret-up";
    content.style.paddingBottom = "50px";
    footer.height = "50px";
  }
}
