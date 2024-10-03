pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/activestorage", to: "activestorage.min.js", preload: true

pin "stimulus-components-rails-nested-form", preload: true
pin "tailwindcss-stimulus-components", preload: true

pin "controllers/menu_controller", preload: false
pin "controllers/editable_controller", preload: false
pin "controllers/text_controller", preload: false
pin "controllers/text_field_update_controller", preload: false

pin "panda_cms_base", preload: true
