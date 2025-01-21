module RSpec
  module Trailblazer
    module Matchers
      module Suite
        module PassAndPassWith
          # Override the {pass_with} matcher for Suite tests.
          def pass_with(args)
            pass.and _suite_pass_with(args) # TODO: abort when {pass} fails so we get only one error message. What is a simple thing in Minitest seems to be a lot of work here.
          end
        end

        # RSpec.configuration.include(PassAndPassWith)

        # pass_with()
        RSpec::Matchers.define :_suite_pass_with do |expected_attributes|
          match do |(signal, ctx)|
            test_suite = ::Trailblazer::Test::Assertion::Suite

            kws = test_suite::Assert.normalize_kws_for_model_assertion(test: self) # TODO: allow {:model_at} keyword.

            # merge expected model attributes.
            expected_attributes = test_suite::Assert.expected_attributes_for(expected_attributes, **kws) # compute "output", expected model attributes.

            # call the original assertion.
            outcome, @error_msg = Assertion::PassedWithAttributes.new.call(signal, ctx, expected_attributes: expected_attributes)
            outcome
          end

          # TODO: TEST failure_message
          failure_message do |(ctx, _, kws)|
            @error_msg
          end
        end
      end
    end
  end
end
