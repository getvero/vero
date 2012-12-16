require 'spec_helper'

describe Vero::Sender do
  subject { Vero::Sender }
  describe "self.senders" do
    it "should be a Hash" do
      subject.senders.should be_a(Hash)
    end

    # context "< Ruby 1.9" do
    #   before :all do
    #     Object.const_set :RUBY_VERSION, "1.8.7"
    #   end

    #   it "should have a default set of senders (true, false, none, thread)" do
    #     subject.senders.should == {
    #       true          => Vero::Senders::Invalid,
    #       false         => Vero::Senders::Base,
    #       :none         => Vero::Senders::Base,
    #       :thread       => Vero::Senders::Invalid,
    #     }
    #   end
    # end

    context "~> Ruby 1.9" do
      # before :all do
      #   Object.const_set :RUBY_VERSION, "1.9.3"
      # end

      it "should have a default set of senders (true, false, none, thread)" do
        subject.senders.should == {
          true          => Vero::Senders::Thread,
          false         => Vero::Senders::Base,
          :none         => Vero::Senders::Base,
          :thread       => Vero::Senders::Thread,
        }
      end
    end

    it "should automatically find senders that are not defined" do
      subject.senders[:delayed_job].should  == Vero::Senders::DelayedJob
      subject.senders[:invalid].should      == Vero::Senders::Invalid
      subject.senders[:none].should         == Vero::Senders::Base
    end
  end
end