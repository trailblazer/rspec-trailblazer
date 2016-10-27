require "rspec/trailblazer/version"

module RSpec
  module Trailblazer
    module Testing # TODO: move to core gem.
      require "delegate"
      class Result < SimpleDelegator
        def initialize(result)
          super(result)

          raise "Policy breach: #{result["policy.result"]}" unless result["policy.result"][:valid]
        end
      end
    end

    module Rspec
      module Helpers
        def factory(name, method_name, &block)
          let(name) { Testing::Result.new( instance_exec(&block) ) }
        end
      end
    end
  end

  RSpec.configure do |c|
    # c.include RSpec::Cells::ExampleGroup, :file_path => /spec\/cells/
    # c.include RSpec::Cells::ExampleGroup, :type => :cell

    c.extend Trailblazer::Rspec::Helpers, :type => :operation
  end
end
