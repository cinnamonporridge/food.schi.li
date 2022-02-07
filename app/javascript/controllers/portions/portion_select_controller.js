import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['radioButtons', 'measureAddOn']

  connect() {
    this.measureAddOnTarget.classList.remove('hidden');
    this.render();
  }

  render() {
    this.renderMeasureAddOn();
  }

  renderMeasureAddOn() {
    this.measureAddOnTarget.innerHTML = this.checkedPortionRadioButton().dataset.portionDisplayMeasure;
  };

  checkedPortionRadioButton() {
    return this.radioButtonsTarget.querySelector(':checked');
  }
}
