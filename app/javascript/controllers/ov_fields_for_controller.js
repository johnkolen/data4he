import { Controller } from "@hotwired/stimulus"

console.log("ov_fields_for loaded");

export default class extends Controller {
  static targets = ["list", "template"]
  connect() {
    console.log("connect");
  }
  add() {
    console.log("add clicked");
    const template = this.templateTarget.content.cloneNode(true);
    this.listTarget.appendChild(template);
    console.log("add updated");
  }
}
