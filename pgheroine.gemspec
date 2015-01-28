$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pgheroine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pgheroine"
  s.version     = PGHeroine::VERSION
  s.authors     = ["NCC Group Domain Services"]
  s.email       = ["ds-development@nccgroup.com"]
  s.homepage    = ""
  s.summary     = ""
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"

  if RUBY_PLATFORM == "java"
    s.add_development_dependecy "activerecord-jdbcpostgresql-adapter"
  else
    s.add_development_dependency "pg"
  end
end
