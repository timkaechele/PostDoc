import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "outlet" ]

  connect() {
  }

  load(event) {
    event.preventDefault();
    fetch(event.target.href)
      .then((response) => {
        return response.text();
      })
      .then((html) => {
        this.outletTarget.innerHTML = html;
      })
  }
}
