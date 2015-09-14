module RSpec
  module Trailblazer
    module Matchers
      extend ::RSpec::Matchers::DSL

      matcher :use_model do |model_class|
        attr_reader :actual
        attr_reader :object

        description { "have model #{model_class.name}" }
        match do |object|
          @object = object
          @actual = object.class.model_class
          values_match? actual, model_class
        end
        failure_message { |actual| "expect #{object} to have model #{model_class}" }
        diffable
      end

      matcher :present_model do
        description { "present model with params #{params} from model #{model_class} wich receive #{model_receive} with #{model_receive_args}" }

        match do |actual|
          model = double(:collection)
          with_args = model_receive_args ? model_receive_args : no_args
          expect(model_class).to receive(model_receive).with(with_args).and_return(model)
          actual.present(params || {})
          expect(actual.model).to eq model
        end

        chain :from_model, :model_class
        chain :with_params, :params
        chain :wich_receive, :model_receive
        chain :with, :model_receive_args
      end
    end
  end
end
