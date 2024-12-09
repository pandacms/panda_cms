---
title: Cookies
layout: default
parent: Developer Documentation
---

# Customizing EditorJS in Panda CMS

Panda CMS uses [EditorJS](https://editorjs.io/) as its rich text editor. You can customize the editor in several ways to add new tools, modify existing ones, or extend its functionality.

## Default Configuration

By default, Panda CMS includes these EditorJS tools:

- Header (with levels 1-4)
- List (with inline toolbar)
- Paragraph

## Adding Custom Tools

There are two ways to customize EditorJS in your application:

### 1. Using Configuration (Ruby)

Create an initializer in your application to configure EditorJS tools:

```ruby
# config/initializers/panda_cms.rb
Panda::CMS.configure do |config|
  # Add additional EditorJS tools
  config.editor_js_tools = [
    { url: "https://cdn.jsdelivr.net/npm/@editorjs/image@latest" },
    { url: "https://cdn.jsdelivr.net/npm/@editorjs/embed@latest" }
  ]

  # Configure the tools
  config.editor_js_tool_config = {
    image: {
      class: 'ImageTool',
      config: {
        endpoints: {
          byFile: '/upload/image'
        }
      }
    },
    embed: {
      class: 'Embed',
      config: {
        services: {
          youtube: true,
          vimeo: true
        }
      }
    }
  }
end
```

### 2. Using JavaScript Hooks

You can also customize the editor using JavaScript hooks in your application:

```javascript
// app/javascript/panda_cms_customizations.js

// Customize editor configuration before initialization
window.customizeEditorJS = function(config) {
  // Add or modify tools
  config.tools.myCustomTool = {
    class: MyCustomTool,
    config: {
      // tool-specific configuration
    }
  };

  // Modify other editor settings
  config.placeholder = 'Start writing your content...';
  config.autofocus = true;
};

// Add functionality after editor initialization
window.onEditorJSReady = function(editor) {
  // Add custom event listeners
  editor.on('change', () => {
    console.log('Content changed');
  });

  // Add custom methods
  editor.customMethod = function() {
    // Custom functionality
  };
};
```

Make sure to include your customization file in your application's JavaScript bundle.

## Configuration Order

The editor configuration is built in this order:

1. Default tools (header, list, paragraph)
2. Tools from `editor_js_tools` configuration
3. Tool configurations from `editor_js_tool_config`
4. JavaScript modifications via `customizeEditorJS`
5. Post-initialization hooks via `onEditorJSReady`

Later configurations can override earlier ones.

## Common Examples

### Adding an Image Tool

```ruby
Panda::CMS.configure do |config|
  config.editor_js_tools = [
    { url: "https://cdn.jsdelivr.net/npm/@editorjs/image@latest" }
  ]

  config.editor_js_tool_config = {
    image: {
      class: 'ImageTool',
      config: {
        endpoints: {
          byFile: '/upload/image',
          byUrl: '/fetch/image'
        },
        types: '.jpg, .png, .gif, .webp'
      }
    }
  }
end
```

### Adding a Code Block Tool

```ruby
Panda::CMS.configure do |config|
  config.editor_js_tools = [
    { url: "https://cdn.jsdelivr.net/npm/@editorjs/code@latest" }
  ]

  config.editor_js_tool_config = {
    code: {
      class: 'CodeTool',
      config: {
        placeholder: 'Enter code here...'
      }
    }
  }
end
```

### Custom Save Handling

```javascript
window.onEditorJSReady = function(editor) {
  editor.on('save', async () => {
    const data = await editor.save();
    // Custom save handling
    console.log('Content saved:', data);
  });
};
```

## Available Tools

EditorJS has many official and community tools available. Here are some popular ones:

- [Image Tool](https://github.com/editor-js/image)
- [Embed Tool](https://github.com/editor-js/embed)
- [Table Tool](https://github.com/editor-js/table)
- [Code Tool](https://github.com/editor-js/code)
- [Link Tool](https://github.com/editor-js/link)
- [Raw HTML Tool](https://github.com/editor-js/raw)
- [Checklist Tool](https://github.com/editor-js/checklist)

For a complete list, visit the [EditorJS Tools Directory](https://github.com/editor-js/awesome-editorjs).
