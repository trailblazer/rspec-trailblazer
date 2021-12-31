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

  # todo:
  # test run()

  require "rspec/matchers/fail_matchers"
  include RSpec::Matchers::FailMatchers

  describe "#pass_with" do
    it "passes with manual attributes" do
      expect(run({duration: "2.24"})).to pass_with({duration: 144})
    end

    it "fails with non-matching manual expected attributes" do
      expect {
        expect(run({title: ""})).to pass_with({duration: 144}) # fails
      }.to fail_with("e;lkjasdf")
    end
  end

  it "what" do
    expect {
          expect(4).to be_zero
        }.to fail_with("expected `4.zero?` to be truthy, got false")
  end

it "fails because Rspec doesn't like me" do
    expect { run({duration: "2.24"}) }
      .to pass
      .and change { "yo" }.by(1)

  end

  it "allows {class} and other weirdo attributes" do
    expect(run({duration: "2.24"})).to pass_with({duration: 144, class: Trailblazer::Test::Testing::Song})
  end

  it "FAILS" do
    expect(run({duration: "2.24"})).to pass_with({duration: 44})
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
