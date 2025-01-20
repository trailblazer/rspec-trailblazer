module RSpec
  module Trailblazer
    # FIXME: this probably shouldn't be here?
    module PassAndPassWith
      def pass_with(args)
        pass.and _pass_with(args) # TODO: abort when {pass} fails so we get only one error message. What is a simple thing in Minitest seems to be a lot of work here.
      end

      def fail_with_errors(args)
        _fail.and _fail_with_errors(args)
      end
    end

    RSpec.configuration.include(PassAndPassWith)

    module Assertion
      class Passed < ::Trailblazer::Test::Assertion::AssertPass::Passed
        def assertion(expected, actual, *)
          expected == actual
        end
      end

      # alternatively, you could implement your own #assertion with Rspec's built-in matchers.
      # The {HaveAttributes} matcher's error message is not very readable.
      # RSpec::Matchers::BuiltIn::HaveAttributes.new(expected_attributes).matches?(actual_model)
      class PassedWithAttributes < ::Trailblazer::Test::Assertion::AssertPass::PassedWithAttributes
        def assertion(ctx, model:, expected_attributes:, **)
          Test::Assert::AssertExposes::Assert.assert_attributes(model, expected_attributes, reader: nil) do |_, last_failed|
            name, expected_value, actual_value, passed, is_eq, error_msg = last_failed

            error_msg = %{#{error_msg}: Expected #{expected_value.inspect} but was #{actual_value.inspect}}

            return false, error_msg
          end

          return true, ""
        end
      end
    end

    # Notes
    # * TODO: `let(:operation)` should probably default to {described_class}
    module Matchers
      RSpec::Matchers.define :_pass_with do |expected_attributes|

        match do |(signal, ctx)|
          # TODO: allow overriding the "AssertExposes" assertion, in case people want {matches}.
          outcome, @error_msg = Assertion::PassedWithAttributes.new.call(signal, ctx, expected_attributes: expected_attributes)
          outcome
        end

        # TODO: TEST failure_message
        failure_message do |(ctx, _, kws)|
          @error_msg
        end
      end


      # to pass()
      # supports_block_expectations
      RSpec::Matchers.define :pass do |expected|
        match do |(signal, ctx)|
          outcome, @error_msg = Assertion::Passed.new.call(signal, ctx, operation: nil) # TODO: where do we get the operation from? Rspec makes it really hard.
          outcome
        end

        failure_message do |(signal, ctx)|
          @error_msg
        end
      end

      RSpec::Matchers.define :_fail do |expected|
        match do |(signal, ctx)|
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
    end # Matchers
  end
end
