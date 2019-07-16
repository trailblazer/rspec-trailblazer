require 'rspec/trailblazer/extensions/hash'
require 'rspec/trailblazer/support/operation'

module RSpec::Trailblazer::Operation
  module Matchers
    extend ::RSpec::Matchers::DSL
    include ::Support::Operation

    matcher :be_successful do
      match do |operation|
        result = _call(operation, _run_params)

        block_arg.call(result) if block_arg && result.success?
        result.success?
      end

      chain :with, :_run_params

      failure_message do |operation|
        "expected #{operation} to be successful"
      end
    end


    matcher :be_failure do
      match do |operation|
        result = _call(operation, _run_params)

        block_arg.call(result) if block_arg && result.failure?
        result.failure?
      end

      chain :with, :_run_params

      failure_message do |operation|
        "expected #{operation} to be failure"
      end
    end


    matcher :have_properties do |args|
      match do |operation|
        @_result = _call(operation, @_run_params)
        return false unless @_result[:model]

        expect(@_result[:model]).have_attributes(args)
      end

      chain :with, :_run_params

      failure_message do |operation|
        "expected #{operation} to have model" unless @_result[:model]
      end
    end


    matcher :have_invalid_properties do |*args|
      match do |operation|
        @_form = _form_for(operation, _run_params)
        return false unless @_form

        @_valid_properties = args.map(&:to_s) - @_form.errors.keys.map(&:to_s)
        @_valid_properties.blank?
      end

      chain :with, :_run_params

      failure_message do |operation|
        return "expected that #{operation} to build form" unless @_form

        "expected #{operation} to have invalid #{@_valid_properties.join(', ')}"
      end
    end
  end
end
