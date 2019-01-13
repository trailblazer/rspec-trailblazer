module Support
  module Operation
    def _call(operation, args)
      params = defined?(default_params) ?
        RSpec::Trailblazer::Hash[default_params].deep_merge(args || {}) : args

      operation.call(params)
    end

    def _form_for(operation, args)
      _call(operation, args)['contract.default']
    end
  end
end
