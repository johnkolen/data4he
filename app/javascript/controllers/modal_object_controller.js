import { Controller } from "@hotwired/stimulus"

console.log("modal_object loaded");

export default class extends Controller {
  static targets = ["frame"]
  static values = {
    formId: Number
  }
  connect() {
    console.log("connected modal object");
    let self = this
    this.element.addEventListener('hide.bs.modal',
				  function(event) {
				    self.close()})
  }
  set_path(action, id) {
    const attr = "data-" + action;
    console.log(this.frameTarget);
    console.log(attr);
    console.log(this.frameTarget.getAttribute(attr));
    const path = this.frameTarget.getAttribute(attr).
	  replace(/\/[0-9]+([/?])/, "/" + id + "$1");
    this.frameTarget.setAttribute(attr, path)
  }
  set_src(action) {
    const attr = "data-" + action;
    const frame = this.frameTarget;
    frame.setAttribute("src", frame.getAttribute(attr))
  }
  fill(event) {
    console.log("fill");
    const src = event.delegateTarget;
    console.log(src)
    const id = src.getAttribute("data-id");
    const action = src.getAttribute("data-object-action");
    console.log("action = ", action, "  id = ", id)
    this.set_path("edit", id)
    this.set_path("view", id)
    this.set_src(action)
    this.frameTarget.reload();
  }
  edit(){
    this.set_src("edit")
    this.frameTarget.reload();
  }
  view(){
    this.set_src("view")
    this.frameTarget.reload();
  }
  close() {
    console.log("disconnect");
    window.location.reload();
  }
}
