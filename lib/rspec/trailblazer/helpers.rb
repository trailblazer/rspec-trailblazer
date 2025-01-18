module RSpec
  module Trailblazer
    module Helpers
      # Note that {run} currently returns **an array** of all involved data structures.
      def run(operation, ctx, invoke: Test::Assert.method(:invoke_operation), **kws)
        signal, ctx = invoke.(operation, ctx) # TODO: in order to use the operation in the matcher block, this should be wrapped in a "result" [operation, ctx, signal, result]. Fuck RSpec.
      end

      def Ctx(*args, **kws)
        Assert.Ctx(*args, test: self, **kws)
      end

      module Suite
        # TODO: the {#run} method has to apply the same merge logic  that we do in trailblazer-test's Suite.
        #       we need to produce the input hash from default_ctx and the actual {ctx} argument.
        # This roughly mimics what happens in Trailblazer::Test:::Suite::Assert.assert_pass / assert_fail
        def run(params_fragment, invoke: Test::Assert.method(:invoke_operation), operation: self.operation, **options)
          kws = Test::Assert::Suite::Assert.normalize_kws_for_ctx(test: self)
          ctx = Test::Assert::Suite::Assert.ctx_for_params_fragment(params_fragment, **kws)

          super(operation, ctx, **options)
        end
      end
    end
  end
end
