function updateCountdown() {
    // 600 is the max message length
    var remaining = 600 - jQuery('#description').val().length;
    jQuery('#countdown').text(remaining + ' characters remaining.');
}

jQuery(document).ready(function($) {
    updateCountdown();
    $('#description').change(updateCountdown);
    $('#description').keyup(updateCountdown);
});
