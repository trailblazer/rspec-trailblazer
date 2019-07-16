require "rspec/trailblazer/version"

module RSpec
  module Trailblazer
    module Operation
    end

    Operation.autoload :Matchers, 'rspec/trailblazer/operation/matchers'
  end
end
