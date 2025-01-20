module RSpec
  module Trailblazer
    module Matchers
      module Suite
        module PassAndPassWith
          def pass_with(args)
            pass.and _suite_pass_with(args) # TODO: abort when {pass} fails so we get only one error message. What is a simple thing in Minitest seems to be a lot of work here.
          end

          def fail_with_errors(args)
            _suite_fail.and _suite_fail_with_errors(args)
          end
        end

        # RSpec.configuration.include(PassAndPassWith)

        # pass_with()
        RSpec::Matchers.define :_suite_pass_with do |expected_attributes|
          match do |(signal, ctx)|
            kws = ::Trailblazer::Test::Assertion::Suite::Assert.normalize_kws_for_model_assertion(test: self) # TODO: allow {:model_at} keyword.

            expected_attributes = ::Trailblazer::Test::Assertion::Suite::Assert.expected_attributes_for(expected_attributes, **kws) # compute "output", expected model attributes.

            outcome, @error_msg = Assertion::PassedWithAttributes.new.call(signal, ctx, expected_attributes: expected_attributes)
            outcome
          end

          # TODO: TEST failure_message
          failure_message do |(ctx, _, kws)|
            @error_msg
          end
        end



        RSpec::Matchers.define :_fail do |expected|
          match do |(signal, ctx)|
            raise "implement me"
            required_outcome, actual_outcome = Test::Assert::AssertFail.arguments_for_assert_fail(signal)

            required_outcome == actual_outcome
          end

          failure_message do |(ctx, _, kws)|
            Assert.error_message_for_assert_fail_after_call(ctx, **kws)
          end
        end

        RSpec::Matchers.define :_fail_with_errors do |expected_errors|
          match do |(signal, ctx)|
            @expected_errors, @actual_errors = Test::Assert::AssertFail.arguments_for_assert_contract_errors(signal, ctx, contract_name: :default, expected_errors: expected_errors)

            @expected_errors == @actual_errors
          end

          failure_message do |*|
            %{Expected errors #{@expected_errors.inspect} but was #{@actual_errors.inspect}}
          end

          # TODO: failure_message
        end
      end
    end
  end
end
