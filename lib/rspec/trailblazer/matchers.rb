require "trailblazer/test" # FIXME: do we want all of this?
require "trailblazer/test/assertions"
require "trailblazer/test/operation/assertions"

module RSpec
  module Trailblazer::Test
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
    # * In the Minitest implementation we use {assert_expose} to compare fields, here we can rely
    #   on {HaveAttributes}.
    # * TODO: `let(:operation)` should probably default to {described_class}
    module Matchers
      RSpec::Matchers.define :_pass_with do |expected|
        match do |(result, _, kws)|
          actual_model        = result[:"model"]
          expected_attributes = Assert.expected_attributes_for(expected, deep_merge: true, **kws)

          RSpec::Matchers::BuiltIn::HaveAttributes.new(expected_attributes).matches?(actual_model)
        end

        # TODO: failure_message
      end

      RSpec::Matchers.define :pass do |expected|
        match do |(result, _)|
          required_outcome, actual_outcome = Assert.arguments_for_assert_pass(result)

          required_outcome == actual_outcome
        end

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
