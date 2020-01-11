let journalDaysDropdown = function() {
  return document.querySelector('#journal_days_dropdown');
};

$('.clickable').click(function() {
  window.location = $(this).data("href");
});

let handleJournalDaysChange = function(event) {
  var target = event.target;
  var selectedIndex = target.selectedIndex;
  var selectedOption = target.options[selectedIndex];

  window.location.href = selectedOption.value;
};

if(journalDaysDropdown()) {
  journalDaysDropdown().addEventListener('change', handleJournalDaysChange);
}

$('.js-toggle-actions').click(
  function(event) {
    var clickedElement = event.currentTarget.parentNode;

    var actionsElement = clickedElement.querySelector('.actions');
    actionsElement.classList.toggle('hidden');
  }
);
