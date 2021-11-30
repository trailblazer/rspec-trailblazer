require "rspec/trailblazer/version"
require "rspec/trailblazer/matchers"
require "rspec/trailblazer/helpers"

module RSpec
  module Trailblazer
    module Test
      Assert = ::Trailblazer::Test::Operation::Assertions::Assert
    end
  end
end
