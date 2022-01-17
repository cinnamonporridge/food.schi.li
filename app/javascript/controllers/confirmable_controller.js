import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["confirmable", "submit", "cancel"]
  static values = { confirmationText: String }

  connect() {
    this.submitTarget.classList.remove('dangerous-button');
    this.submitTarget.classList.add('confirmable-button')
    this.submitTarget.querySelector('span').innerHTML = this.confirmationTextValue;
    this.cancelTarget.classList.remove('hidden');
    this.toggle();
  }

  toggle() {
    this.confirmableTargets.map(element => element.classList.toggle('hidden'));
  }
}
