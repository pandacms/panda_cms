import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="hello"
export class HelloController extends Controller {
  connect() {
    // Except div#hello-injected-content to have the content "Hello, Stimulus!"
    this.element.textContent = "Hello, Stimulus!"
  }
}
