import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['input', 'clear'];

  connect() {
    this.render();
  }

  render() {
    const inputEmpty = (this.inputTarget.value.length == 0);
    this.clearTarget.classList.toggle('hidden', inputEmpty)
  }

  search() {
    this.element.querySelector('form').submit();
  }

  clear() {
    this.inputTarget.value = '';
    this.search();
  }
}
