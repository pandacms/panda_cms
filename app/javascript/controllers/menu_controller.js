import { Controller as PandaCmsController } from "@hotwired/stimulus"

export default class extends PandaCmsController {
  static targets = ["pandaCmsMenu"]
  static values = {
    open: { type: Boolean, default: false }
  }

  toggle(event) {
    this.openValue = !this.openValue
    this.animate()
  }

  animate() {
    this.toggleableTargets.forEach(target => {
      transition(target, this.openValue)
    })
  }
}
