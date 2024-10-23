import { Application as PandaCmsApplication } from "@hotwired/stimulus"

const pandaCmsApplication = PandaCmsApplication.start()

// Configure Stimulus development experience
pandaCmsApplication.debug = false
window.pandaCmsStimulus = pandaCmsApplication

export { pandaCmsApplication }
