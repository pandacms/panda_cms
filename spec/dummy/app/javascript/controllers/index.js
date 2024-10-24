import { Application } from "@hotwired/stimulus";

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

import { HelloController } from "controllers/hello_controller";
application.register("hello", HelloController);

export { application };
