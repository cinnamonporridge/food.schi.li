// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

window.addEventListener('DOMContentLoaded', (event) => {
  // journal days dropdown
  let journalDaysDropdown = document.querySelector('#journal_days_dropdown');

  let handleJournalDaysChange = function(event) {
    var target = event.target;
    var selectedIndex = target.selectedIndex;
    var selectedOption = target.options[selectedIndex];

    window.location.href = selectedOption.value;
  };

  if(journalDaysDropdown !== null) {
    journalDaysDropdown.addEventListener('change', handleJournalDaysChange);
  }

  // .clickable
  let registerClickableEvent = function(element) {
    element.addEventListener('click', function() {
      window.location = element.dataset.href;
    });
  }

  Array.from(document.querySelectorAll('.clickable')).forEach(registerClickableEvent);


  // .js-toggle-actions
  let registerToggleActionsEvent = function(element) {
    element.addEventListener('click', function() {
      var clickedElement = element.parentNode;

      var actionsElement = clickedElement.querySelector('.actions');
      actionsElement.classList.toggle('hidden');
    });
  }

  Array.from(document.querySelectorAll('.js-toggle-actions')).forEach(registerToggleActionsEvent);
});
