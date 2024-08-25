module PandaCms
  class Version < ApplicationRecord
    include PaperTrail::VersionConcern
    self.abstract_class = true
  end
end
