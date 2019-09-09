require "rspec/trailblazer/version"

module RSpec
  module Trailblazer
    module Operation
    end

    module Reform
    end

    Operation.autoload :Matchers, 'rspec/trailblazer/operation/matchers'
    Reform.autoload :Matchers, 'rspec/trailblazer/reform/matchers'
  end
end
