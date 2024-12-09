import { ResourceLoader } from "panda/cms/editor/resource_loader"
import { EDITOR_JS_RESOURCES, EDITOR_JS_CSS, getEditorConfig } from "panda/cms/editor/editor_js_config"

export class EditorJSInitializer {
  constructor(document) {
    this.document = document
  }

  /**
   * Initializes the EditorJS instance for a given element.
   * This method loads necessary resources and returns the JavaScript code for initializing the editor.
   *
   * @param {HTMLElement} element - The DOM element to initialize the editor on
   * @returns {string} The generated JavaScript code for initializing the editor
   */
  async initialize(element) {
    await this.loadResources()
    return this.initializeEditor(element)
  }

  async initializeEditor(element) {
    const elementAsId = element.id.replace(/-/g, "_")
    const previousData = element.getAttribute("data-editable-previous-data")
    const config = getEditorConfig(element.id, previousData)

    ResourceLoader.embedScript(
      `EditorJS configuration for ${element.id}`,
      this.document,
      this.document.head,
      `const ${elementAsId} = new EditorJS(${JSON.stringify(config)})`
    )

    // Method doesn't return anything but is used in Promise.all() in editor_controller.js
    // Should return the editor instance to be added to this.editors array
    return window[elementAsId]
  }

  /**
   * Loads the necessary resources for the EditorJS instance.
   * This method fetches the required scripts and stylesheets and embeds them into the document.
   */
  async loadResources() {
    const scriptLoads = EDITOR_JS_RESOURCES.map(url =>
      ResourceLoader.loadScript(this.document, this.document.head, url)
    )

    await Promise.all([
      ...scriptLoads,
      ResourceLoader.embedCSS(this.document, this.document.head, EDITOR_JS_CSS)
    ])
  }
}
