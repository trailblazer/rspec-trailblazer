require 'spec_helper'


RSpec.configure do |c|
  c.include RSpec::Trailblazer::Helpers
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
    expect(run({duration: "2.24"})).to pass_with({duration: 144})

    expect(run({title: ""})).to pass_with({duration: 144}) # fails
  end

  it "fail" do
    expect(run({title: "", duration: "2.24"})).to fail_with_errors([:title])

  end
  it "assertion fails" do
    expect(run({title: "Voice of the Moon", duration: "2.24"})).to fail_with_errors([:title]) # fails
  end

  it "Ctx" do
    expect(Ctx().inspect).to eq(%{{:params=>{:song=>{:band=>\"Rancid\", :title=>\"Timebomb\"}}}})
    expect(Ctx(exclude: [:title]).inspect).to eq(%{{:params=>{:song=>{:band=>\"Rancid\"}}}})
    expect(Ctx(exclude: [:title], default_ctx: {params: {song: {title: "Ruby Soho", band: "NOFX"}}, current_user: "Yogi"}).inspect).to eq(%{{:params=>{:song=>{:band=>\"NOFX\"}}, :current_user=>\"Yogi\"}})
    # expect(Ctx(exclude: [:title], key_in_params: false).inspect).to eq(%{{:params=>{:song=>{:band=>\"Rancid\"}}}})
    expect(Ctx({current_user: "Yogi"}).inspect).to eq(%{{:params=>{:song=>{:band=>\"Rancid\", :title=>\"Timebomb\"}}, :current_user=>\"Yogi\"}})
  end
end
