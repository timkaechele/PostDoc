import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "iframe" ]

  connect() {
  }
  loaded(event) {
    this.iframeTarget.height = this.iframeTarget.contentWindow.document.body.scrollHeight
  }
}
