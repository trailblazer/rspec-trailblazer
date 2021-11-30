module RSpec
  module Trailblazer::Test
    module Helpers
      def run(params_fragment, use_wtf=false, **kws)
        result, ctx, kws = Assert.call_operation_with(params_fragment, use_wtf, test: self, **kws)
      end
    end
  end
end