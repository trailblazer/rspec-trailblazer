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

    # DISCUSS: coloring of expected/actual in error msg?
    it "fails) with non-matching manual expected attributes." do
      expect {
        expect(run({title: ""})).to pass_with({duration: 144}) # fails
      }.to fail_with(%{   {Trailblazer::Test::Testing::Song::Operation::Create} failed: \e[33m{:title=>["must be filled"]}\e[0m

...and:

   Property [band] mismatch: Expected "Rancid" but was nil})
    end

    it "fails) operation passes but expected != actual" do
      expect {
        expect(run({title: "Rancid"})).to pass_with({duration: 144}) # fails
      }.to fail_with(%{Property [title] mismatch: Expected "Timebomb" but was "Rancid"})
    end
  end

  describe "#fail_with_errors" do
    it "fails) because operation passes" do
      expect {
        expect(run({title: "Voice of the Moon", duration: "2.24"})).to fail_with_errors([:title])
      }.to fail_with(%{   {Trailblazer::Test::Testing::Song::Operation::Create} didn't fail, it passed

...and:

   Expected errors [:title] but was []})
    end

    it "passes" do
      expect(run({title: "", duration: "2.24"})).to fail_with_errors([:title])
    end
  end

it "fails because Rspec doesn't like me" do
  skip "TODO"
    expect { run({duration: "2.24"}) }
      .to pass
      .and change { "yo" }.by(1)

  end

  it "allows {class} and other weirdo attributes" do
    expect(run({duration: "2.24"})).to pass_with({duration: 144, class: Trailblazer::Test::Testing::Song})
  end

  it "Ctx" do
    expect(Ctx().inspect).to eq(%{{:params=>{:song=>{:band=>\"Rancid\", :title=>\"Timebomb\"}}}})
    expect(Ctx(exclude: [:title]).inspect).to eq(%{{:params=>{:song=>{:band=>\"Rancid\"}}}})
    expect(Ctx(exclude: [:title], default_ctx: {params: {song: {title: "Ruby Soho", band: "NOFX"}}, current_user: "Yogi"}).inspect).to eq(%{{:params=>{:song=>{:band=>\"NOFX\"}}, :current_user=>\"Yogi\"}})
    # expect(Ctx(exclude: [:title], key_in_params: false).inspect).to eq(%{{:params=>{:song=>{:band=>\"Rancid\"}}}})
    expect(Ctx({current_user: "Yogi"}).inspect).to eq(%{{:params=>{:song=>{:band=>\"Rancid\", :title=>\"Timebomb\"}}, :current_user=>\"Yogi\"}})
  end
end
