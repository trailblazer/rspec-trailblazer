module Support
  module Reform
    def _validate(form, params)
      form.validate(params)
    end

    def _params
      params = Hash[Array(@_column).map { |x| [x, nil] }]

      if _nested_option
        nested_params = {}
        nested_params[_nested_option] = (@_options[:nested_collection] ? [params] : params)
        params = nested_params
      end
      params
    end

    def _find_error_key
      keys = Array(@_column).map { |key| [_nested_option, key].compact.join(".").to_sym }

      keys - _errors_keys
    end

    def _errors_keys
      @_form.errors.messages.keys
    end

    def _nested_option
      @_options[:nested_property] || @_options[:nested_collection]
    end
  end
end
