$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "carapace/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "carapace"
  s.version     = Carapace::VERSION

  s.summary     = "RSA encryption for HTML form fields"
  s.description = "Allows field contents to be encrypted between broswer and webserver"  

  s.authors     = ["John Lane"]
  s.email       = ["carapace@jelmail.com"]
  s.homepage    = 'https://github.com/johnlane/carapace'
  s.license     = 'MIT'

  s.files = Dir["{lib,vendor}/**/*"] + ["CHANGELOG.md", "LICENSE", "LICENSE_JSBN", "Rakefile", "README.md" ]
  s.test_files = Dir["test/**/*"] + ["Gemfile", "carapace.gemspec"]

  s.add_dependency "rails", "~> 3.2.5"

  s.add_development_dependency "sqlite3"

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'capybara'

end
