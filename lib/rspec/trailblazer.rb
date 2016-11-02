require "rspec"

module RSpec
  module Trailblazer
    module Testing # TODO: move to core gem.
      require "delegate"
      class Result < SimpleDelegator
        def initialize(result)
          super(result)
          raise "Policy breach: #{result["policy.result"]}" unless result["policy.result"]["success?"]
          raise "Validation failure: #{result["errors.contract"]}" if result["errors.contract"]
        end
      end
    end

    module Rspec
      module Helpers
        def factory(name, method_name=nil, &block)
          # TODO: make rspec raise the exception from the method using the factory, not just the line, `because Association::Archive.({ id: model.id })` won't tell you what went wrong.
          let(name) {
            result = Testing::Result.new( instance_exec(&block) )

            return result[method_name] if method_name
            result
          }
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
