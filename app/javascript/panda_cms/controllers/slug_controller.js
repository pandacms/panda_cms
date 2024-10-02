<<<<<<<< HEAD:app/javascript/panda_cms/controllers/slug_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
========
import { Controller as PandaCmsController } from "@hotwired/stimulus";

export class TextFieldUpdateController extends PandaCmsController {
>>>>>>>> 051dfc5 (Improve rich text editor support):app/javascript/panda_cms/controllers/text_field_update_controller.js
  static targets = [
    "existing_root",
    "input_select",
    "input_text",
    "output_text",
  ];

  connect() {}

  generatePath() {
    this.output_textTarget.value = "/" + this.createSlug(this.input_textTarget.value);
  }

  setPrePath() {
    this.parent_slugs = this.input_selectTarget.options[this.input_selectTarget.selectedIndex].text.match(/.*\((.*)\)$/)[1];
    this.output_textTarget.previousSibling.innerHTML = (this.existing_rootTarget.value + this.parent_slugs).replace(/\/$/, "");
  }

  // TODO: Invoke a library or helper which can be shared with the backend
  // and check for uniqueness at the same time
  createSlug(input) {
    var str = input
      .toLowerCase()
      .trim()
      .replace(/[^\w\s-]/g, "-")
      .replace(/&/g, "and")
      .replace(/[\s_-]+/g, "-")
      .trim();

    return this.trimStartEnd(str, "-");
  }

  trimStartEnd(str, ch) {
    var start = 0;
    var end = str.length;

    while (start < end && str[start] === ch) ++start;
    while (end > start && str[end - 1] === ch) --end;
    return start > 0 || end < str.length ? str.substring(start, end) : str;
  }
}
