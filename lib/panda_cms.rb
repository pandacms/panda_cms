require "panda_cms/version"
require "panda_cms/engine"

module PandaCms
  mattr_accessor :admin_path
  mattr_accessor :authentication
  mattr_accessor :require_login_to_view
  mattr_accessor :title
  mattr_accessor :url
  mattr_accessor :posts

  def self.admin_path_symbol
    @@admin_path.delete_prefix("/")
  end
end
