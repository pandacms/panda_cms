/**
 * Represents a controller for managing editable content within an iframe.
 * @class
 */
class PandaCmsEditableController {
  /**
   * Represents the constructor for the Editable class.
   * @param {HTMLIFrameElement} frame - The iFrame element to be used for editing.
   */
  constructor(pageId, frame) {
    this.pageId = pageId;
    this.frame = frame;
    this.frame.style.display = "none";
    this.csrfToken = document.querySelector('meta[name="csrf-token"]').content;
    this.autosave = false; // Scares everyone, even me. ;-)

    var pathNameArray = window.location.pathname.split("/");
    this.adminPath = pathNameArray[1];

    this.frame.addEventListener("load", () => {
      this.frameDocument = this.frame.contentDocument || this.frame.contentWindow.document;
      this.body = this.frameDocument.body;
      this.head = this.frameDocument.head;
      this.loadEvents();
    });
  }

  /**
   * Load events for the editable iFrame
   */
  loadEvents() {
    console.debug("[Panda CMS] iFrame loaded...");

    this.embedPlainTextEditors();
    this.embedRichTextEditor();
  }

  setFrameVisible() {
    console.debug("[Panda CMS] Setting iFrame to visible...");
    this.frame.style.display = "";
  }

  stylePlainTextEditor(element, status) {
    console.debug(
      `[Panda CMS] Styling editor ${element.id} as ${status}...`
    );

    if (status == "initial") {
      element.style.border = "1px dashed #ccc";
      element.style.outline = "none";
      element.style.cursor = "pointer";
      element.style.transition = "background 500ms linear";
      element.style.backgroundColor = "inherit";
    } else if (status == "success") {
      element.style.backgroundColor = "#66bd6a50";
    } else if (status == "error") {
      element.style.backgroundColor = "#dc354550";
    }

    if (element.getAttribute("data-editable-kind") == "html") {
      element.style.whiteSpace = "pre-wrap";
      element.style.fontFamily = "monospace";
    }
  }

  embedPlainTextEditors() {
    var elements = this.body.querySelectorAll('[data-editable-kind="plain_text"], [data-editable-kind="markdown"], [data-editable-kind="html"]');
    if (elements.length == 0) {
      return;
    }

    elements.forEach((element) => {
      this.stylePlainTextEditor(element, "initial");
      var currentElement = element;

      if (this.autosave) {
        // On blur, save this element
        currentElement.addEventListener("blur", () => {
          this.bindPlainTextSaveHandler(currentElement);
        });

        console.debug("[Panda CMS] Attached auto-save event handler to ${currentElement.id}");
      }

      // On save click, save this element
      document.getElementById('saveEditableButton').addEventListener('click', () => {
        this.bindPlainTextSaveHandler(currentElement);
      });

      console.debug("[Panda CMS] Attached button event handler to ${currentElement.id}");
    });

    console.debug(
      "[Panda CMS] Dispatching event: pandaCmsPlainTextEditorLoaded"
    );

    // Let the parent know that the external resources have been loaded
    this.frameDocument.dispatchEvent(new Event("pandaCmsPlainTextEditorLoaded"));
  }

  bindPlainTextSaveHandler(target) {
    var blockContentId = target.getAttribute(
      "data-editable-block-content-id"
    );

    if (target.getAttribute("data-editable-kind") == "html") { // Or markdown?
      var content = target.innerText;
    } else {
      var content = target.innerHTML;
    }

    fetch(`/${this.adminPath}/pages/${this.pageId}/block_contents/${blockContentId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      },
      body: JSON.stringify({ content: content }),
    })
      .then((response) => response.json())
      .then((data) => {
        this.stylePlainTextEditor(target, "success");
        setTimeout(() => {
          this.stylePlainTextEditor(target, "initial");
        }, 1000);
      })
      .catch((error) => {
        this.stylePlainTextEditor(target, "error");
        setTimeout(() => {
          this.stylePlainTextEditor(target, "initial");
        }, 1000);
        alert("Error:", error);
        console.log(error);
      });
  }

  embedRichTextEditor() {
    if (this.body.getElementsByClassName("content-rich-text").length == 0) {
      this.setFrameVisible();
      return;
    }

    console.debug("[Panda CMS] Loading Quill rich text editor...");

    this.addStylesheet(
      this.frameDocument,
      this.head,
      "/panda-cms-assets/rich_text.css?ver=1.0.0"
    );

    var style = this.frameDocument.createElement("style");
    // TODO: Base these on "default" set styles (e.g. initial, success, etc.)
    style.innerHTML = ``;
    this.head.append(style);

    this.loadScript(
      this.frameDocument,
      this.head,
      "https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"
    )
      .then(() => {
        return this.loadScript(
          this.frameDocument,
          this.head,
          "https://unpkg.com/quill-image-compress@1.2.11/dist/quill.imageCompressor.min.js"
        );
      })
      .then(() => {
        return this.loadScript(
          this.frameDocument,
          this.head,
          "https://unpkg.com/quill-magic-url@3.0.0/dist/index.js"
        );
      })
      // .then(() => {
      //   return this.loadScript(
      //     this.frameDocument,
      //     this.head,
      //     "https://cdn.jsdelivr.net/npm/quill-markdown-shortcuts@latest/dist/markdownShortcuts.js"
      //   );
      // })
      .then(() => {
        this.styleRichTextEditor();

        console.debug(
          "[Panda CMS] Dispatching event: pandaCmsRichTextEditorLoaded"
        );

        // Let the parent know that the external resources have been loaded
        this.frameDocument.dispatchEvent(
          new Event("pandaCmsRichTextEditorLoaded")
        );

        // Autosave the editable elements
        this.enableRichTextEditorAutoSave();

        document.getElementById('saveEditableButton').addEventListener('click', () => {
          // Grab each element that's editable and append a save handler to it
          var elements = this.frameDocument.querySelectorAll(".ql-editor");
          elements.forEach((element) => {
            var blockContentId = element.parentElement.getAttribute("data-block-content-id");
            this.bindSaveHandler(blockContentId, element.innerHTML);
          });
        });

        // This prevents the flash of content before the iFrame is ready
        this.setFrameVisible();
      });
  }

  /**
   * Autosave the editable elements in the iFrame
   */
  enableRichTextEditorAutoSave() {
    if (!this.autosave) {
      return false;
    }

    // Grab each element that's editable and append a save handler to it
    var elements = this.frameDocument.querySelectorAll(".ql-editor");
    elements.forEach((element) => {
      element.addEventListener("blur", (event) => {
        var target = event.target;
        var blockContentId = target.parentElement.getAttribute(
          "data-block-content-id"
        );

        this.bindSaveHandler(blockContentId, target.innerHTML);
      });
    });
  }

  /**
   * Styles the Quill rich text editor elements in the iFrame
   */
  styleRichTextEditor() {
    if (this.body.getElementsByClassName("ql-editor").length == 0) {
      return;
    }

    var style = this.frameDocument.createElement("style");
    style.innerHTML = ``;

    this.head.append(style);
    console.log("Appended styles to head");
  }

  bindSaveHandler(blockContentId, content) {
    console.debug(`[Panda CMS] Calling save handler for ${blockContentId}...`);
    fetch(`/${this.adminPath}/pages/${this.pageId}/block_contents/${blockContentId}`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": this.csrfToken,
      },
      body: JSON.stringify({ content: content }),
    })
      .then((response) => response.json())
      .then((data) => {
        var editableBlock = this.frameDocument.querySelector(
          `[data-block-content-id="${blockContentId}"] .ql-editor`
        );
        editableBlock.classList.add("success");
        setTimeout(() => {
          editableBlock.classList.remove("success");
        }, 1500);
      })
      .catch((error) => {
        console.log(error);
        alert("Error updating. Please contact the support team!", error);
      });
  }

  addStylesheet(frameDocument, head, href) {
    return new Promise(function (resolve, reject) {
      let link = frameDocument.createElement("link");
      link.rel = "stylesheet";
      link.href = href;
      link.media = "none";
      head.append(link);

      link.onload = () => {
        if (link.media != "all") {
          link.media = "all";
        }
        console.debug(`[Panda CMS] Stylesheet loaded: ${href}`);
        resolve(link);
      };
      link.onerror = () =>
        reject(new Error(`[Panda CMS] Stylesheet load error for ${href}`));
    });
  }

  loadScript(frameDocument, head, src) {
    return new Promise(function (resolve, reject) {
      let script = frameDocument.createElement("script");
      script.src = src;
      head.append(script);

      script.onload = () => {
        console.debug(`[Panda CMS] Script loaded: ${src}`);
        resolve(script);
      };
      script.onerror = () =>
        reject(new Error(`[Panda CMS] Script load error for ${src}`));
    });
  }
}
