$(document).ready(function($) {
  $('.clickable-row').click(function() {
    window.location = $(this).data("href");
  });

  $('.selectable').select2({
    theme: 'bootstrap'
  });
});
