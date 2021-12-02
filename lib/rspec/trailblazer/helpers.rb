module RSpec
  module Trailblazer
    module Helpers
      # Note that {run} currently returns **an array** of all involved data structures.
      def run(params_fragment, use_wtf=false, **kws)
        result, ctx, kws = Assert.call_operation_with(params_fragment, use_wtf, test: self, **kws)
      end

      def Ctx(*args, **kws)
        Assert.Ctx(*args, test: self, **kws)
      end
    end
  end
end
