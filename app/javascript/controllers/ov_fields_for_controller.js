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
    console.log(template);
    console.log(template.children[0].id);
    const parts = template.children[0].id.split("-");
    const newId = parts[0] + "-" +
	  parts[1] + "-" +
	  (this.listTarget.children.length + 1);
    template.children[0].id = newId;
    const button = template.children[0].querySelector('button');
    console.log(template.children[0]);
    console.log("button " + button.tagName);
    button.setAttribute("data-bs-target", "#"+newId);
    console.log(template.id);
    this.listTarget.appendChild(template);
    console.log("add updated");
  }
  remove(event) {
    console.log("remove clicked");
    console.log(event.delegateTarget);
    const tgt = event.delegateTarget.getAttribute("data-bs-target");
    const hidden = this.listTarget.querySelector(tgt).
	  querySelector('.hdestroy');
    hidden.setAttribute('name',
			hidden.getAttribute('name').replace('DESTROY',
							    '_destroy'));
    hidden.setAttribute('id',
			hidden.getAttribute('id').replace('DESTROY',
							  '_destroy'));
    console.log(hidden);
  }
}
