import { Controller } from "@hotwired/stimulus"

console.log("modal_forms loaded");

export default class extends Controller {
  static targets = ["form"]
  connect() {
    console.log("connected modal form");
  }
  fill() {
    console.log("fill");
    const tgt = event.delegateTarget.getAttribute("data-form-id");
    this.formTarget.innerHTML = "Hello " + tgt
  }
}
