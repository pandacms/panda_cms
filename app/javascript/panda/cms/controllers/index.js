console.debug("[Panda CMS] Importing Panda CMS Stimulus Controller...")

import { Application as PandaCMSApplication } from "@hotwired/stimulus"

const pandaCmsApplication = PandaCMSApplication.start()

console.debug("[Panda CMS] Application started...")

// Configure Stimulus development experience
pandaCmsApplication.debug = false
window.pandaCmsStimulus = pandaCmsApplication

console.debug("[Panda CMS] window.pandaCmsStimulus available...")

console.debug("[Panda CMS] Registering controllers...")

// Grab our internal controllers manually, prefixed with panda/cms/controllers so not to conflict
import { DashboardController } from "panda/cms/controllers/dashboard_controller"
pandaCmsApplication.register("dashboard", DashboardController)

import { SlugController } from "panda/cms/controllers/slug_controller"
pandaCmsApplication.register("slug", SlugController)

import { EditorController } from "panda/cms/controllers/editor_controller"
pandaCmsApplication.register("editor", EditorController)

console.debug("[Panda CMS] Registering components...")

// Import and register all TailwindCSS Components or just the ones you need
import { Alert, Autosave, ColorPreview, Dropdown, Modal, Tabs, Popover, Toggle, Slideover } from "tailwindcss-stimulus-components"
pandaCmsApplication.register('alert', Alert)
pandaCmsApplication.register('autosave', Autosave)
pandaCmsApplication.register('color-preview', ColorPreview)
pandaCmsApplication.register('dropdown', Dropdown)
pandaCmsApplication.register('modal', Modal)
pandaCmsApplication.register('popover', Popover)
pandaCmsApplication.register('slideover', Slideover)
pandaCmsApplication.register('tabs', Tabs)
pandaCmsApplication.register('toggle', Toggle)

console.debug("[Panda CMS] Components registered...")

export { pandaCmsApplication }

console.debug("[Panda CMS] Application exported...")
