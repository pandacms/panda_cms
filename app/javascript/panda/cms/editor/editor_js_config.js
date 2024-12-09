export const EDITOR_JS_RESOURCES = [
  "https://cdn.jsdelivr.net/npm/@editorjs/editorjs@latest",
  "https://cdn.jsdelivr.net/npm/@editorjs/header@latest",
  "https://cdn.jsdelivr.net/npm/@editorjs/list@latest",
  "https://cdn.jsdelivr.net/npm/@editorjs/quote@latest",
  "https://cdn.jsdelivr.net/npm/@editorjs/nested-list@latest",
  "https://cdn.jsdelivr.net/npm/@editorjs/simple-image@latest",
  "https://cdn.jsdelivr.net/npm/@editorjs/table@latest",
  "https://cdn.jsdelivr.net/npm/@editorjs/embed@latest",
  "https://cdn.jsdelivr.net/npm/editorjs-alert@latest"
]

export const EDITOR_JS_CSS = `.ce-toolbar__content {
  margin: 0 !important;
  margin-left: 40px;
  max-width: 100% !important;
  width: 100% !important;
}

.ce-block__content {
  max-width: 100%;
  margin: 0 !important;
  margin-left: 10px !important;
}`

export const getEditorConfig = (elementId, previousData) => ({
  holder: elementId,
  data: previousData,
  tools: {
    header: {
      class: Header,
      config: {
        placeholder: 'Enter a header',
        levels: [2, 3],
        defaultLevel: 2
      }
    },
    list: {
      class: NestedList,
      inlineToolbar: true,
      config: {
        defaultStyle: 'unordered'
      },
    },
    alert: {
      class: Alert,
      inlineToolbar: true,
      config: {
        defaultType: 'primary',
        messagePlaceholder: 'Enter something',
        types: {
          primary: 'Primary',
          secondary: 'Secondary',
          success: 'Success',
          danger: 'Danger',
          warning: 'Warning',
          info: 'Info'
        }
      }
    },
    quote: Quote,
    table: {
      class: Table,
      inlineToolbar: true,
      config: {
        rows: 2,
        cols: 3
      }
    },
    image: SimpleImage,
    embed: {
      class: Embed,
      config: {
        services: {
          youtube: true,
          instagram: true,
          miro: true,
          vimeo: true,
          pinterest: true,
          github: true
        }
      }
    },
  }
})
