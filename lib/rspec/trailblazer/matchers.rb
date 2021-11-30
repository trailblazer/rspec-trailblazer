require "trailblazer/test" # FIXME: do we want all of this?
require "trailblazer/test/assertions"
require "trailblazer/test/operation/assertions"

module RSpec
  module Trailblazer::Test
    module Matchers
      RSpec::Matchers.define :pass_with do |expected|
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

        failure_message do |(result, _)|
          Assert.error_message_for_assert_pass(result)
        end
      end
    end # Matchers
  end
end
