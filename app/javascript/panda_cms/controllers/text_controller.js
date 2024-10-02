import { Controller as PandaCmsController } from "@hotwired/stimulus";

export class TextController extends PandaCmsController {
  static targets = ["source"];
  static values = { page: String, blockcontent: String };
  static classes = ["initial", "success", "error"];

  connect() {
    this.sourceTarget.classList.add(...this.initialClasses);
  }

  save() {
    this.cleanedContent = this.clean(this.sourceTarget.innerHTML);

    fetch(
      `/admin/pages/${this.pageValue}/block_contents/${this.blockcontentValue}`,
      {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document
            .querySelector('meta[name="csrf-token"]')
            .getAttribute("content"),
        },
        body: JSON.stringify({ content: this.cleanedContent }),
      }
    )
      .then((response) => response.json())
      .then((data) => {
        this.setSuccessClasses();
      })
      .catch((error) => {
        alert("Error:", error);
        console.log(error);
        this.element.classList.remove(
          ...this.initialClasses,
          ...this.successClasses
        );
        this.element.classList.add(...this.errorClasses);
      });
  }

  setInitialClasses() {
    this.element.classList.remove(...this.successClasses, ...this.errorClasses);
    this.element.classList.add(...this.initialClasses);
  }

  setSuccessClasses() {
    this.element.classList.remove(...this.initialClasses, ...this.errorClasses);
    this.element.classList.add(...this.successClasses);
    this.resetInitialClassesTimer();
  }

  setErrorClasses() {
    this.element.classList.remove(
      ...this.initialClasses,
      ...this.successClasses
    );
    this.element.classList.add(...this.errorClasses);
    this.resetInitialClassesTimer();
  }

  resetInitialClassesTimer() {
    setTimeout(
      function () {
        this.setInitialClasses();
      }.bind(this),
      1000
    );
  }

  clean(content) {
    // Replace horrible bullet points
    content = content.replace(/• /g, "* ");
    // TODO: More formatting
    return content;
  }
}
