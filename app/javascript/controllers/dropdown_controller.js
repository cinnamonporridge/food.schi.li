import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['toggler', 'menu'];
  static values = { expanded: Boolean }

  connect() {
    this.handleClickOutsideBinding = this.handleClickOutside.bind(this)
    this.handleKeydownBinding = this.handleKeydown.bind(this)
    this.render();
  }

  render() {
    if (this.expandedValue) {
      this.menuTarget.classList.remove('hidden');
      window.addEventListener('click', this.handleClickOutsideBinding)
      window.addEventListener('keydown', this.handleKeydownBinding)
    } else {
      window.removeEventListener('keydown', this.handleKeydownBinding)
      window.removeEventListener('click', this.handleClickOutsideBinding)
      this.menuTarget.classList.add('hidden');
    }
  }

  handleKeydown(event) {
    if (event.keyCode == 27) {
      this.expand(false);
    }
  }

  handleClickOutside(event) {
    this.expand(false);
  }

  expand(boolean) {
    this.expandedValue = boolean;
    this.togglerTarget.setAttribute('aria-expanded', this.expandedValue);
    this.render();
  }

  toggle() {
    event.stopPropagation();
    this.expand(!this.expandedValue)
  }
}
