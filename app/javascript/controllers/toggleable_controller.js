import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleable", "buttons", "openButton", "closeButton"]
  static values = { opened: Boolean }

  connect() {
    this.showButtons();
    this.render();
  }

  toggle() {
    this.openedValue = !this.openedValue;
    this.render();
  }

  render() {
    this.renderToggleable();
    this.renderTogglers();
  }

  renderToggleable() {
    if (this.hasToggleableTarget) {
      this.toggleableTarget.classList.toggle('hidden', !this.openedValue);
    }
  }

  renderTogglers() {
    if (this.hasOpenButtonTarget && this.hasCloseButtonTarget) {
      this.openButtonTarget.classList.toggle('hidden', this.openedValue);
      this.closeButtonTarget.classList.toggle('hidden', !this.openedValue);
    }
  }

  showButtons() {
    if (this.hasButtonsTarget) {
      this.buttonsTarget.classList.remove('hidden');
    }
  }
}
