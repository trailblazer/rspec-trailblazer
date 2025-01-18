require 'spec_helper'


RSpec.configure do |c|
  c.include RSpec::Trailblazer::Helpers
end

describe "Basic assertions without any Suite behavior" do
  Memo = Trailblazer::Test::Testing::Memo

  # The default ctx passed into the tested operation.
  #:default-ctx
  # let(:default_ctx) do
  #   {
  #     params: {
  #       song: { # Note the {song} key here!
  #         band:  "Rancid",
  #         title: "Timebomb",
  #         # duration not present
  #       }
  #     }
  #   }
  # end
  # #:default-ctx end

  # #:expected-attrs
  # # What will the model look like after running the operation?
  # let(:expected_attributes) do
  #   {
  #     band:   "Rancid",
  #     title:  "Timebomb",
  #   }
  # end


  require "rspec/matchers/fail_matchers"
  include RSpec::Matchers::FailMatchers

  # describe "#pass" do
  #   it "passes with manual attributes" do
  #     expect(run(Memo::Operation::Create, {params: {memo: {title: "Reminder"}}})).to pass_with(title: "Reminder")
  #   end
  # end

  describe "#pass_with" do
    it "passes with manual attributes" do
      expect(run(Memo::Operation::Create, {params: {memo: {title: "Reminder", content: "Do not forget"}}})).to pass_with(title: "Reminder")
    end

    it "fails with error message" do
      skip "how to test failing assertions?"
      expect(run(Memo::Operation::Create, {params: {memo: {title: "", content: ""}}})).to pass_with(title: "Reminder")
    end

    it "fail_with" do
      expect(run(Memo::Operation::Create, {params: {memo: {title: "", content: ""}}})).to fail_with_errors([:title, :content])
    end

    # TODO: {#run?}
    #        Ctx()
  end

  describe "Suite" do
    include RSpec::Trailblazer::Helpers
    include RSpec::Trailblazer::Helpers::Suite # FIXME: abstract into RSpec::Trailblazer.module!(self, suite: true)

    let(:operation) { Memo::Operation::Create }
    let(:default_ctx) { {params: {memo: {title: "Reminder"}}} }
    let(:key_in_params) { :memo }

    it "provides #run that merges input automatically" do
      signal, result = run({content: "Almost out of beer"}) # DISCUSS: what to return?

      # raise result.inspect
      expect(result).to be_success
      expect(result[:captured]).to eq(%({:params=>{:memo=>{:title=>\"Reminder\", :content=>\"Almost out of beer\"}}}))
    end
  end
end
