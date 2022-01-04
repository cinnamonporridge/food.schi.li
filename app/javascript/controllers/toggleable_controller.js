import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggleable"]

  toggle() {
    if (this.hasToggleableTarget) {
      this.toggleableTarget.classList.toggle('hidden');
    }
  }
}
