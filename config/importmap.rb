pin "@hotwired/stimulus", to: "@hotwired--stimulus.js" # @3.2.2
pin "@hotwired/turbo", to: "@hotwired--turbo.js" # @8.0.10
pin "@rails/activestorage", to: "@rails--activestorage.js" # @7.2.100
pin "@rails/actioncable", to: "@rails--actioncable.js" # @7.2.100
pin "tailwindcss-stimulus-components" # @6.0.2

pin "controllers/slug_controller", preload: false

pin "panda_cms", preload: true
