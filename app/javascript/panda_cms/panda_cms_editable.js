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

    var pathNameArray = window.location.pathname.split("/");
    this.adminPath = pathNameArray[1];

    this.frame.addEventListener("load", () => {
      this.frameDocument = this.frame.contentDocument || this.frame.contentWindow.document;
      this.body = this.frameDocument.body;
      this.head = this.frameDocument.head;
      this.loadEvents();
    });
  }

  /* iFrame & Main Methods */

  /**
   * Load events for the editable iFrame
   */
  loadEvents() {
    console.debug("[Panda CMS] iFrame loaded...");

    this.embedPlainTextEditors();
    this.embedTrix();
  }

  setFrameVisible() {
    console.debug("[Panda CMS] Setting iFrame to visible...");
    this.frame.style.display = "";
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

  /* Plain Text Editor (inc. Code) Methods */

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

  /* Rich Text Editor Methods */

  embedTrix() {
    this.addStylesheet(this.frameDocument, this.head, "https://cdn.jsdelivr.net/npm/trix/dist/trix.css");
    this.addStylesheet(this.frameDocument, this.head, "/panda-cms-assets/rich_text_editor.css");
    this.loadScript(this.frameDocument, this.head, "https://cdn.jsdelivr.net/npm/trix/dist/trix.js");

    this.body.addEventListener("trix-before-initialize", () => {
      // Change Trix.config if you need
      console.debug("[Panda CMS] Trix before initialize");
    })

    document.getElementById('saveEditableButton').addEventListener('click', () => {
      console.debug("[Panda CMS] Handling click event on #saveEditableButton");
      // Grab each input element that's a rich text editor and append a save handler to the button
      var elements = this.frameDocument.querySelectorAll("input[data-editor-type='rich-text']");
      elements.forEach((element) => {
        var blockContentId = element.getAttribute("data-editor-block-content-id");
        this.bindTrixSaveHandler(blockContentId, element.value);
      });
    });

    // This prevents the flash of content before the iFrame is ready
    console.debug("[Panda CMS] Setting iFrame to visible");
    this.setFrameVisible();
  }

  bindTrixSaveHandler(blockContentId, content) {
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
        console.debug("[Panda CMS] Save successful for block content ID:", blockContentId);
        document.getElementById('saveEditableButton').classList.remove("bg-active");
        document.getElementById('saveEditableButton').classList.add("bg-mid");
        setTimeout(() => {
          document.getElementById('saveEditableButton').classList.remove("bg-mid");
          document.getElementById('saveEditableButton').classList.add("bg-active");
        }, 1500);
      })
      .catch((error) => {
        console.log(error);
        alert("Error updating. Please contact the support team!", error);
      });
  }
}
