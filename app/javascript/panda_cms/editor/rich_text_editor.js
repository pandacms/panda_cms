import { ResourceLoader } from "panda_cms_editor/resource_loader"

export class RichTextEditor {
  constructor(frame, options) {
    this.frame = frame
    this.frameDocument = frame.contentDocument || frame.contentWindow.document
    this.head = this.frameDocument.head
    this.options = options
    this.loadDependencies()
  }

  loadDependencies() {

    // ResourceLoader.loadStylesheet(
      // this.frameDocument,
      // this.head,
      // "/panda-cms-assets/rich_text.css?ver=1.0.0"
    // )

    Promise.all([
      // ResourceLoader.loadScript(this.frameDocument, this.head, "https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"),
      // ResourceLoader.loadScript(this.frameDocument, this.head, "https://unpkg.com/quill-image-compress@1.2.11/dist/quill.imageCompressor.min.js"),
      // ResourceLoader.loadScript(this.frameDocument, this.head, "https://unpkg.com/quill-magic-url@3.0.0/dist/index.js")
    ]).then(() => {
      this.setupEditor()
      this.frameDocument.dispatchEvent(new Event("pandaCmsRichTextEditorLoaded"))
      this.bindSaveHandlers()
      this.options.onLoad()
    })
  }

  setupEditor() {
    const elements = this.frameDocument.querySelectorAll(".ql-editor")
    elements.forEach(element => {
      if (this.options.autosave) {
        element.addEventListener("blur", event => this.save(event.target))
      }
    })
  }

  bindSaveHandlers() {
    document.getElementById('saveEditableButton').addEventListener('click', () => {
      const elements = this.frameDocument.querySelectorAll(".ql-editor")
      elements.forEach(element => {
        this.save(element)
      })
    })
  }

  save(element) {
    const blockContentId = element.parentElement.getAttribute("data-block-content-id")

    fetch(`/${this.options.adminPath}/pages/${this.options.pageId}/block_contents/${blockContentId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.options.csrfToken
      },
      body: JSON.stringify({ content: element.innerHTML })
    })
    .then(response => response.json())
    .then(() => this.showSuccess(element))
    .catch(error => this.showError(error))
  }

  showSuccess(element) {
    element.classList.add("success")
    setTimeout(() => {
      element.classList.remove("success")
    }, 1500)
  }

  showError(error) {
    console.log(error)
    alert("Error updating. Please contact the support team!", error)
  }
}
