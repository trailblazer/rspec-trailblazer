module RSpec
  module Trailblazer
    module Helpers
      # Note that {run} currently returns **an array** of all involved data structures.
      def run(operation, ctx, invoke: ::Trailblazer::Test::Assertion.method(:invoke_operation), **kws)
        signal, ctx = invoke.(operation, ctx) # TODO: in order to use the operation in the matcher block, this should be wrapped in a "result" [operation, ctx, signal, result]. Fuck RSpec.
      end

      def Ctx(*args, **kws)
        Assert.Ctx(*args, test: self, **kws)
      end
    end
  end
end
