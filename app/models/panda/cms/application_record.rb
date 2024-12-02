module Panda
  module CMS
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
