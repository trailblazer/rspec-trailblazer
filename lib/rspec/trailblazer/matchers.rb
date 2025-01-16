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

    # Notes
    # * TODO: `let(:operation)` should probably default to {described_class}
    module Matchers
      RSpec::Matchers.define :_pass_with do |expected_attributes|

        match do |(signal, ctx)|
          actual_model        = ctx[:model]
          # expected_attributes = ::Trailblazer::Test::Assertion::Assert.expected_attributes_for(expected, deep_merge: false)

          # The {HaveAttributes} matcher's error message is not very readable.
          # RSpec::Matchers::BuiltIn::HaveAttributes.new(expected_attributes).matches?(actual_model)
          passed, _ = ::Trailblazer::Test::Assertion::AssertExposes::Assert.assert_attributes(actual_model, expected_attributes, reader: nil) do |_, last_failed|
            name, expected_value, actual_value, passed, is_eq, error_msg = last_failed

            @error_msg = %{#{error_msg}: Expected #{expected_value.inspect} but was #{actual_value.inspect}}
          end

          passed
        end

        # TODO: TEST failure_message
        failure_message do |(ctx, _, kws)|
          @error_msg
        end
      end

      # to pass()
      RSpec::Matchers.define :pass do |expected|
        match do |(signal, result)|
          required_outcome, actual_outcome = ::Trailblazer::Test::Assertion::AssertPass.arguments_for_assert_pass(signal)

          required_outcome == actual_outcome
        end

        # supports_block_expectations

        failure_message do |(signal, result)|
          ::Trailblazer::Test::Assertion::AssertPass.error_message_for_assert_pass(signal, result, operation: nil) # TODO: where do we get the operation from? Rspec makes it really hard.
        end
      end

      RSpec::Matchers.define :_fail do |expected|
        match do |(result, _)|
          required_outcome, actual_outcome = Assert.arguments_for_assert_fail(result)

          required_outcome == actual_outcome
        end

        failure_message do |(result, _, kws)|
          Assert.error_message_for_assert_fail_after_call(result, **kws)
        end
      end

      RSpec::Matchers.define :_fail_with_errors do |expected_errors|
        match do |(result, _, kws)|
          @expected_errors, @actual_errors = Assert.arguments_for_assert_contract_errors(result, expected_errors: expected_errors, **kws)

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
