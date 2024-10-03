import { Application as PandaCmsApplication } from "@hotwired/stimulus";

const panda_cms = PandaCmsApplication.start();

// Configure Stimulus development experience
panda_cms.debug = false;
window.pandaStimulus = panda_cms;

// import { SlugController } from "./controllers/slug_controller";
// panda_cms.register("slug", SlugController);

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
} from "tailwindcss-stimulus-components";
panda_cms.register("alert", Alert);
panda_cms.register("autosave", Autosave);
panda_cms.register("color-preview", ColorPreview);
panda_cms.register("dropdown", Dropdown);
panda_cms.register("modal", Modal);
panda_cms.register("popover", Popover);
panda_cms.register("slideover", Slideover);
panda_cms.register("tabs", Tabs);
panda_cms.register("toggle", Toggle);

import RailsNestedForm from 'stimulus-components-rails-nested-form'
panda_cms.register("nested-form", RailsNestedForm);

export { panda_cms };
