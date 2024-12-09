import { Controller } from "@hotwired/stimulus"
import { EditorJSInitializer } from "panda/cms/editor/editor_js_initializer"

export default class extends Controller {
  static targets = ["content", "container"]

  initialize() {
    console.debug("[Panda CMS] EditorForm controller initialized")
  }

  connect() {
    console.debug("[Panda CMS] EditorForm controller connected")
    console.debug("[Panda CMS] Targets found:", {
      content: this.hasContentTarget,
      container: this.hasContainerTarget
    })

    let initialData = {}
    try {
      const content = this.contentTarget.dataset.initialContent
      console.debug("[Panda CMS] Initial content:", content)
      initialData = content ? JSON.parse(content) : {}
    } catch (e) {
      console.debug("[Panda CMS] Could not parse initial editor content", e)
    }

    this.initializeEditor(initialData)
  }

  initializeEditor(initialData) {
    console.debug("[Panda CMS] Initializing editor with data:", initialData)

    const initializer = new EditorJSInitializer(
      document
    )

    initializer.initialize(this.containerTarget)
  }
}
