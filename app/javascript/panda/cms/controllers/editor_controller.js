import { Controller } from "@hotwired/stimulus"
import { PlainTextEditor } from "panda/cms/editor/plain_text_editor";
import { ResourceLoader } from "panda/cms/editor/resource_loader";
import { EditorJSInitializer } from "panda/cms/editor/editor_js_initializer";

export default class extends Controller {
  /**
   * Defines the static values that can be set on the EditorController.
   *
   * @property {number} pageId - The ID of the page being edited.
   * @property {string} adminPath - The path to the admin section of the application.
   * @property {boolean} autosave - Whether the editor should automatically save changes.
   */
  static values = {
    pageId: Number,
    adminPath: String,
    autosave: Boolean
  }

  /**
   * Connects the EditorController to the DOM and initializes the editors.
   * This method is called when the EditorController is connected to the DOM.
   * It sets up the necessary properties and event listeners to manage the editors,
   * and then calls the `initializeEditors()` method to start the initialization process.
   */
  connect() {
    console.debug("[Panda CMS] Editor controller connected")
    this.frame = this.element

    // Create editor controls if they don't exist
    if (!parent.document.querySelector('.editor-controls')) {
      const controls = parent.document.createElement('div')
      controls.className = 'editor-controls'
      parent.document.body.appendChild(controls)
    }

    // In CI, show what's going on, otherwise hide the frame
    if (!window.location.href.includes("0.0.0.0:3001")) {
      this.frame.style.display = "none"
    }

    if (document.querySelector('meta[name="csrf-token"]')) {
      this.csrfToken = document.querySelector('meta[name="csrf-token"]').content
    } else {
      this.csrfToken = ""
    }

    this.editors = []
    this.editorsInitialized = {
      plain: false,
      rich: false
    }

    this.frame.addEventListener("load", () => {
      console.debug("[Panda CMS] Frame loaded")
      this.frameDocument = this.frame.contentDocument || this.frame.contentWindow.document
      this.body = this.frameDocument.body
      this.head = this.frameDocument.head
      this.initializeEditors()
    })
  }

  /**
   * Initializes the plain text and rich text editors for the page.
   * This method is responsible for finding all editable elements on the page and initializing the appropriate editor instances for them.
   * It sets the editorsInitialized flags to true once the initialization is complete and calls the checkAllEditorsInitialized method.
   */
  initializeEditors() {
    console.debug("[Panda CMS] Starting editor initialization")
    this.initializePlainTextEditors()
    this.initializeRichTextEditors()
  }

  /**
   * Initializes the plain text editors for the page.
   * This method is responsible for finding all elements on the page that have the "plain_text", "markdown", or "html" data-editable-kind attributes,
   * and initializing a PlainTextEditor instance for each of them. It also sets the editorsInitialized.plain flag to true
   * and calls the checkAllEditorsInitialized method to notify that the plain text editors have been initialized.
   */
  initializePlainTextEditors() {
    const plainTextElements = this.body.querySelectorAll('[data-editable-kind="plain_text"], [data-editable-kind="markdown"], [data-editable-kind="html"]')
    console.debug(`[Panda CMS] Found ${plainTextElements.length} plain text elements`)

    plainTextElements.forEach(element => {

      const editor = new PlainTextEditor(element, this.frameDocument, {
        autosave: this.autosaveValue,
        adminPath: this.adminPathValue,
        csrfToken: this.csrfToken
      })
      this.editors.push(editor)
    })

    this.editorsInitialized.plain = true
    this.checkAllEditorsInitialized()
  }

  /**
   * Initializes the rich text editors for the page.
   * This method is responsible for finding all elements on the page that have the "rich_text" data-editable-kind attribute,
   * and initializing a RichTextEditor instance for each of them. It also sets the editorsInitialized.rich flag to true
   * and calls the checkAllEditorsInitialized method to notify that the rich text editors have been initialized.
   */
  initializeRichTextEditors() {
    const richTextElements = this.body.querySelectorAll('[data-editable-kind="rich_text"]')
    console.debug(`[Panda CMS] Found ${richTextElements.length} rich text elements`)

    if (richTextElements.length > 0) {
      if (!parent.document.getElementById('saveEditableButton')) {
        const saveButton = parent.document.createElement('a')
        saveButton.id = 'saveEditableButton'
        saveButton.href = '#'
        saveButton.textContent = 'Save Changes'
        saveButton.className = 'btn btn-primary'
        parent.document.querySelector('.editor-controls').appendChild(saveButton)
      }

      const initializer = new EditorJSInitializer(
        this.frameDocument
      )

      Promise.all(
        Array.from(richTextElements).map(element => initializer.initialize(element))
      ).then(editors => {
        this.editors.push(...editors)
        this.editorsInitialized.rich = true
        this.checkAllEditorsInitialized()
      })
    } else {
      this.editorsInitialized.rich = true
      this.checkAllEditorsInitialized()
    }
  }

  /**
   * Checks if all editors have been initialized and sets the iFrame to visible if so.
   * This is called after the plain text and rich text editors have been initialized.
   */
  checkAllEditorsInitialized() {
    console.debug("[Panda CMS] Editor initialization status:", this.editorsInitialized)
    if (this.editorsInitialized.plain && this.editorsInitialized.rich) {
      console.debug("[Panda CMS] All editors initialized, showing iFrame")
      this.setiFrameVisible()
    }
  }

  /**
   * Sets the visibility of the iFrame to visible.
   * This is called after all editors have been initialized to show the iFrame.
   */
  setiFrameVisible() {
    console.debug("[Panda CMS] Setting iFrame to visible")
    this.frame.style.display = ""
  }

  /**
   * Initializes an individual editor instance for a given element.
   * This method creates a unique identifier for the editor, retrieves necessary data attributes,
   * and embeds the editor configuration script into the document.
   *
   * @param {HTMLElement} element - The DOM element to initialize the editor on
   * @returns {string} The generated element ID used for the editor instance
   */
  initializeEditor(element) {
    const pageId = element.getAttribute("data-editable-page-id")
    const blockContentId = element.getAttribute("data-editable-block-content-id")

    ResourceLoader.embedScript(
      `EditorJS AJAX save button for ${element.id}`,
      this.frameDocument,
      this.head,
      this.generateEditorScript(elementAsId, element.id, previousData, pageId, blockContentId)
    )

    return elementAsId
  }

  /**
   * Generates the JavaScript code for initializing an editor instance.
   * This method constructs the JavaScript code that initializes an EditorJS instance for a given element.
   * It includes the editor configuration, event listeners for saving changes, and error handling.
   *
   * @param {string} elementAsId - The unique identifier for the editor element
   * @param {string} elementId - The ID of the element being initialized
   * @param {string} previousData - The previous data stored in the element
   * @param {number} pageId - The ID of the page being edited
   * @param {number} blockContentId - The ID of the block content being edited
   * @returns {string} The generated JavaScript code for initializing the editor
   */
  generateEditorScript(elementAsId, elementId, previousData, pageId, blockContentId) {
    const saveButton = parent.document.getElementById('saveEditableButton')
    saveButton.addEventListener('click', async () => {
      try {
        const outputData = await window[elementAsId].save()
        outputData.source = "editorJS"

        const response = await fetch(`${this.adminPath}/pages/${pageId}/block_contents/${blockContentId}`, {
          method: "PATCH",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": this.csrfToken
          },
          body: JSON.stringify({ content: outputData })
        })

        console.debug("[Panda CMS] Response:", response)

        const successMessage = parent.document.getElementById("successMessage")
        successMessage.classList.remove("hidden")
        setTimeout(() => successMessage.classList.add("hidden"), 3000)
      } catch (error) {
        this.handleError(error)
      }
    })

    console.debug(`[Panda CMS] Initialized rich text editor for element: ${elementAsId}`)
    return elementAsId
  }

  /**
   * Handles errors that occur during editor operations.
   * This method displays an error message to the user in a flash message,
   * automatically hides it after 3 seconds, and logs the error to the console.
   *
   * @param {Error} error - The error object to handle
   */
  handleError(error) {
    parent.document.getElementById("errorMessage").getElementsByClassName('flash-message-text')[0].textContent = error
    parent.document.getElementById("errorMessage").classList.remove("hidden")
    setTimeout(() => {
      parent.document.getElementById("errorMessage").classList.add("hidden")
    }, 3000)
    console.error(error)
  }
}
