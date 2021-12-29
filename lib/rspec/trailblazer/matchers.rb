require "trailblazer/test" # FIXME: do we want all of this?
require "trailblazer/test/assertions"
require "trailblazer/test/operation/assertions"

module RSpec
  module Trailblazer
    # FIXME: this probably shouldn't be here?
    module PassAndPassWith
      def pass_with(args)
        pass.and _pass_with(args)
      end

      def fail_with_errors(args)
        _fail.and _fail_with_errors(args)
      end
    end

    RSpec.configuration.include(PassAndPassWith)

    # Notes
    # * TODO: `let(:operation)` should probably default to {described_class}
    module Matchers
      RSpec::Matchers.define :_pass_with do |expected|

        match do |(result, _, kws)|
          actual_model        = result[:model]
          expected_attributes = Assert.expected_attributes_for(expected, deep_merge: false, **kws)
        # puts ">>>>>>>>>@@@@@ #{expected_attributes.inspect}"

          # The {HaveAttributes} matcher's error message is not very readable.
          # RSpec::Matchers::BuiltIn::HaveAttributes.new(expected_attributes).matches?(actual_model)
          passed, _ = ::Trailblazer::Test::Assertions::Assert.assert_attributes(actual_model, expected_attributes, reader: nil) do |_, last_failed|
            name, expected_value, actual_value, passed, is_eq, error_msg = last_failed

            @error_msg = %{#{error_msg}: Expected \e[1;31m#{expected_value}\e[0;31m but was \e[1;31m#{actual_value}\e[0;31m}
          end

          passed
        end

        # TODO: TEST failure_message
        failure_message do |(result, _, kws)|
          @error_msg
        end
      end

      RSpec::Matchers.define :pass do |expected|
        match do |(result, _)|
          # puts result.inspect
          required_outcome, actual_outcome = Assert.arguments_for_assert_pass(result)

          required_outcome == actual_outcome
        end

        # supports_block_expectations

        failure_message do |(result, _, kws)|
          Assert.error_message_for_assert_pass(result, **kws)
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
          expected_errors, actual_errors = Assert.arguments_for_assert_contract_errors(result, expected_errors: expected_errors, **kws)

          expected_errors == actual_errors
        end

        # TODO: failure_message
      end
    end # Matchers
  end
end
