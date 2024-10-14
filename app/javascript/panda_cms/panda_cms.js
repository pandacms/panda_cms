import { Application as PandaCmsApplication } from "@hotwired/stimulus"

const pandaCmsApplication = PandaCmsApplication.start()

// Configure Stimulus development experience
pandaCmsApplication.debug = false
window.pandaStimulus = pandaCmsApplication

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", pandaCmsApplication)

import {
  Alert,
  Autosave,
  ColorPreview,
  Dropdown,
  Modal,
  Tabs,
  Popover,
  Toggle,
  Slideover,
} from "tailwindcss-stimulus-components"

pandaCmsApplication.register("alert", Alert)
pandaCmsApplication.register("autosave", Autosave)
pandaCmsApplication.register("color-preview", ColorPreview)
pandaCmsApplication.register("dropdown", Dropdown)
pandaCmsApplication.register("modal", Modal)
pandaCmsApplication.register("popover", Popover)
pandaCmsApplication.register("slideover", Slideover)
pandaCmsApplication.register("tabs", Tabs)
pandaCmsApplication.register("toggle", Toggle)

export { pandaCmsApplication }
