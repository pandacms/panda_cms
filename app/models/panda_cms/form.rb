module PandaCms
  class Form < ApplicationRecord
    self.table_name = "panda_cms_forms"

    has_many :form_submissions, class_name: "PandaCms::FormSubmission"
  end
end
