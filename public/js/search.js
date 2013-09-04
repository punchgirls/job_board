$(document).ready(function () {
    $("#search-box").tokenInput(
      [
        {
          "name": "Ruby"
        },
        {
          "name": "JavaScript"
        },
        {
          "name": "Java"
        },
        {
          "name": "HTML"
        },
        {
          "name": "CSS"
        },
        {
          "name": "C"
        }
      ],
      {
        theme: "facebook"
      }
    );

    $('#search-form').submit(function(event) {
      var tokens = $('#search-box').tokenInput("get"),
          tags = [];

      $.each(tokens, function (index, value) {
        tags.push(value.name);
      });

      $('#tags').val(tags);
    });
});