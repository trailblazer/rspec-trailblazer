# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/trailblazer/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-trailblazer"
  spec.version       = RSpec::Trailblazer::VERSION
  spec.authors       = ["Timo Schilling"]
  spec.email         = ["timo@schilling.io"]

  spec.summary       = "RSpec Matchers for Trailblazer"
  spec.homepage      = "https://github.com/trailblazer/rspec-trailblazer"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
