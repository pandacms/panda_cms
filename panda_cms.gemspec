require_relative "lib/panda_cms/version"

Gem::Specification.new do |spec|
  spec.name = "panda_cms"
  spec.version = PandaCms::VERSION
  spec.author = ["Panda Software Limited"]
  spec.email = ["bamboo@pandacms.io"]
  spec.homepage = "https://pandacms.io"
  spec.summary = "Better websites on Rails."
  spec.license = "BSD-3-Clause"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/tastybamboo/panda_cms"
  spec.metadata["bug_tracker_uri"] = "https://github.com/tastybamboo/panda_cms/issues"
  spec.metadata["changelog_uri"] = "https://github.com/tastybamboo/panda_cms/releases"
  spec.metadata["github_repo"] = "ssh://github.com/tastybamboo/panda_cms.git"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib,public}/**/*", "Rakefile", "README.md"]
  end

  spec.required_ruby_version = ">= 3.0"

  spec.add_dependency "panda_core"
  spec.add_dependency "groupdate"

  spec.post_install_message = "🐼 💜"
end
