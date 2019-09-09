require "rspec/trailblazer/support/reform"

module RSpec::Trailblazer::Reform
  module Matchers
    extend ::RSpec::Matchers::DSL
    include Support::Reform

    VALID_OPTIONS = %i[nested_property nested_collection].freeze

    matcher :validate_presence_of do |column, options = {}|
      match do |form|
        invalid_options = options.keys - VALID_OPTIONS
        raise "Incorrect options passed #{invalid_options.join(" - ")}" if invalid_options.any?

        @_column = column
        @_form = form
        @_options = options
        @_params = _params
        @_validate = _validate(@_form, @_params)
        @_error_keys = _find_error_key

        @_validate == false && @_error_keys.empty?
      end

      failure_message do |form|
        msg = "expected #{form.class.name} to validate presence of #{column}"
        msg += " in #{_nested_option}" if _nested_option
        msg += " using as params #{@_params}"
        msg += " but validations didn't fail" if @_validate
        msg += " but #{@_error_keys} were not found in the error message" if @_error_keys.any? && !@_validate
        msg
      end
    end
  end
end
