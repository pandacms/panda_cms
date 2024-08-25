import { Application as PandaCmsApplication } from "@hotwired/stimulus";

const panda_cms = PandaCmsApplication.start();

// Configure Stimulus development experience
panda_cms.debug = location.hostname === "localhost";
window.pandaStimulus = panda_cms;

export { panda_cms };

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading";
eagerLoadControllersFrom("panda_cms/controllers", panda_cms);

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
} from "panda_cms/vendor/tailwindcss-stimulus-components";
panda_cms.register("alert", Alert);
panda_cms.register("autosave", Autosave);
panda_cms.register("color-preview", ColorPreview);
panda_cms.register("dropdown", Dropdown);
panda_cms.register("modal", Modal);
panda_cms.register("popover", Popover);
panda_cms.register("slideover", Slideover);
panda_cms.register("tabs", Tabs);
panda_cms.register("toggle", Toggle);

import RailsNestedForm from "panda_cms/vendor/stimulus-components-rails-nested-form";
panda_cms.register("nested-form", RailsNestedForm);
