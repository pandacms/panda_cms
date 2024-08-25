module PandaCms
  class ApplicationMailer < ActionMailer::Base
    default from: "noreply@pandacms.io"
    layout "mailer"
  end
end
