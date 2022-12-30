import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  /**  On Start */
  connect() {
    console.log("Connected")
    const messages = document.getElementById("messages");
    messages.addEventListener("DOMNodeInserted", this.resetScroll);
    this.resetScroll(messages);
  }

  /** On Stop  */
  disconnect() {
    console.log("Disconnected")
  /** Put delection of event listeners here */

  }

  /** Custom Function */
  resetScroll() {
    messages.scrollTop = messages.scrollHeight - messages.clientHeight;
  }
}
