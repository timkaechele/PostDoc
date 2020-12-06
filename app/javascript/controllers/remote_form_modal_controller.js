import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "container", "form" ]

  connect() {
  }

  handleSuccess() {
  }

  handleError(event) {
    let [data, status, xhr] = event.detail;
    this.formTarget.innerHTML = xhr.responseText;
  }
}
