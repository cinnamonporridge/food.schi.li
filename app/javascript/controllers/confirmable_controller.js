import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["confirmable", "submit", "cancel"]
  static values = { confirmationText: String }

  connect() {
    const submitButton = this.submitTarget.querySelector('button');
    submitButton.classList.remove('dangerous-button');
    submitButton.classList.add('confirmable-button')
    submitButton.querySelector('span').innerHTML = this.confirmationTextValue;
    this.cancelTarget.classList.remove('hidden');
    this.toggle();
  }

  toggle() {
    this.confirmableTargets.map(element => element.classList.toggle('hidden'));
  }
}
