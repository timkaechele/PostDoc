import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "query", "output" ]
  static values = { url: String }

  connect() {
    this.requests = [];
  }

  search() {
    this.resetTimeout();
    this.cancelPreviousRequests();
    this.searchTimeout = setTimeout(() => {

      let abortController = new AbortController();
      this.requests.push(abortController)

      let signal = abortController.signal;
      let url = this.urlValue + "&q=" + this.queryTarget.value;

      fetch(url, { signal })
        .then((response) => {
          return response.text();
        })
        .then((html) => {
          this.outputTarget.innerHTML = html;
        })
        .catch(e => {
          console.log(e)
        })
    }, 75)
  }

  resetTimeout() {
    if(this.searchTimeout) {
      clearTimeout(this.searchTimeout);
    }
  }

  cancelPreviousRequests() {
    this.requests.forEach(request => {
      request.abort();
    });
    this.requests = [];
  }
}
