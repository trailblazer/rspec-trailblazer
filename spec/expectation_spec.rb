require 'spec_helper'


RSpec.configure do |c|
  c.include RSpec::Trailblazer::Test::Helpers
end

describe RSpec::Trailblazer do
  Song = Trailblazer::Test::Testing::Song

  # The default ctx passed into the tested operation.
  #:default-ctx
  let(:default_ctx) do
    {
      params: {
        song: { # Note the {song} key here!
          band:  "Rancid",
          title: "Timebomb",
          # duration not present
        }
      }
    }
  end
  #:default-ctx end

  #:expected-attrs
  # What will the model look like after running the operation?
  let(:expected_attributes) do
    {
      band:   "Rancid",
      title:  "Timebomb",
    }
  end
  #:expected-attrs end

  #:let-operation
  let(:operation)     { Song::Operation::Create }
  #:let-operation end
  #:let-key-in-params
  let(:key_in_params) { :song }
  #:let-key-in-params end

  it do
    expect(run({duration: "2.24"})).to pass.and pass_with({duration: 144})
  end
end
