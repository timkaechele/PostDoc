import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "modal" ]

  connect() {
  }

  closeClickedOutside(event) {
    if (this.mouseClickDownTarget != this.mouseClickUpTarget) {
      return;
    }

    if (event.srcElement == this.modalTarget) {
      this.close();
    }
  }

  close(event) {
    this.modalTarget.remove();
  }

  error() {
    this.modalTarget.classList.add("shake");
    setTimeout(() => {
      this.modalTarget.classList.remove("shake");
    }, 1000)
  }

  trackMouseDown(event) {
    this.mouseClickDownTarget = event.target
  }

  trackMouseUp(event) {
    this.mouseClickUpTarget = event.target
  }
}
