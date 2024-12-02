module Panda
  module CMS
    class Version < ApplicationRecord
      include PaperTrail::VersionConcern
      self.abstract_class = true
    end
  end
end
