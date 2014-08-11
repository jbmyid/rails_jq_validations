$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_jq_validations/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_jq_validations"
  s.version     = RailsJqValidations::VERSION
  s.authors     = ["Jalendra Bhanarkar"]
  s.email       = ["jbmyid@gmail.com"]
  s.homepage    = "https://github.com/jbmyid/rails_jq_validations"
  s.summary     = "Perform client side validation for model forms"
  s.description = "A gem/plugin for rails 4+ that enables client side validation for basic model validators."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.2"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'simplecov'

  s.add_development_dependency "sqlite3"
end
