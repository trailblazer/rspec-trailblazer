lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec/trailblazer/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec-trailblazer"
  spec.version       = RSpec::Trailblazer::VERSION
  spec.authors       = ["Nick Sutterer"]
  spec.email         = ["apotonick@gmail.com"]

  spec.summary       = "RSpec Matchers for strong and non-verbose operation tests."
  spec.homepage      = "https://github.com/trailblazer/rspec-trailblazer"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rspec"
  spec.add_dependency "trailblazer-test", ">= 1.0.0", "< 1.1.0"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "trailblazer-operation"
  spec.add_development_dependency "trailblazer-macro"
  spec.add_development_dependency "trailblazer-macro-contract"
  spec.add_development_dependency "trailblazer-core-utils"
  spec.add_development_dependency "dry-validation"
end
