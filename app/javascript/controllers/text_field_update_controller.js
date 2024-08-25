import { Controller as PandaCmsController } from "@hotwired/stimulus"
export default class extends PandaCmsController {
  static targets = [ "existing_root", "input_select", "input_text", "output_text" ]

  connect() {
  }

  generatePath() {
    this.output_textTarget.value = "/" + this.createSlug(this.input_textTarget.value);
  }

  setPrePath() {
    this.parent_slugs = this.input_selectTarget.options[this.input_selectTarget.selectedIndex].text.match(/.*\((.*)\)$/)[1];
    this.output_textTarget.previousSibling.innerHTML = (this.existing_rootTarget.value + this.parent_slugs).replace(/\/$/, '');;
  }

  createSlug(input) {
    return input.toLowerCase().trim()
      .replace(/[^\w\s-]/g, "-")
      .replace(/&/, "and")
      .replace(/[\s_-]+/g, "-");
  }
}
