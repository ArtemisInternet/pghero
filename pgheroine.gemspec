# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pgheroine/version'

Gem::Specification.new do |spec|
  spec.name          = "pgheroine"
  spec.version       = PGHeroine::VERSION
  spec.authors       = [%q|NCC Group Domain Services|]
  spec.email         = [%q|ds-development_nccgroup.com|]
  spec.summary       = %q|Database insights made easy-er|
  spec.description   = %q|Database insights made easy-er|
  spec.homepage      = "https://github.com/ArtemisInternet/pgheroine"
  spec.license       = "MIT"

  spec.files         = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  spec.test_files    = Dir["test/**/*"]

  spec.add_dependency "rails", "~> 4.2.0"

  if RUBY_PLATFORM == "java"
    spec.add_development_dependency "activerecord-jdbcpostgresql-adapter"
  else
    spec.add_development_dependency "pg"
  end
end
