import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["actionsMenu"]

  toggleActions() {
    this.actionsMenuTarget.classList.toggle('hidden');
  }
}
