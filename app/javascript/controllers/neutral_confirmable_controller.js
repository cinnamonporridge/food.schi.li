import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["confirmable", "submit", "cancelButton", "information"]
  static values = { confirmationText: String, opened: Boolean }

  connect() {
    this.submitTarget.querySelector('button').querySelector('span').innerHTML = this.confirmationTextValue;
    this.render();
  }

  render() {
    this.confirmableTarget.classList.toggle('hidden', this.openedValue);
    this.submitTarget.classList.toggle('hidden', !this.openedValue);
    this.cancelButtonTarget.classList.toggle('hidden', !this.openedValue);
    this.informationTarget.classList.toggle('hidden', !this.openedValue);
  }

  open() {
    this.openedValue = true;
    this.render();
  }

  close() {
    this.openedValue = false;
    this.render();
  }
}
