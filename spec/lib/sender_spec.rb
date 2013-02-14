require 'spec_helper'

describe Vero::Sender do
  subject { Vero::Sender }
  describe "self.senders" do
    it "should be a Hash" do
      subject.senders.should be_a(Hash)
    end
    
    unless RUBY_VERSION =~ /1\.9\./
      context "< Ruby 1.9" do
        it "should have a default set of senders (true, false, none, thread)" do
          subject.senders.should == {
            true          => Vero::Senders::Invalid,
            false         => Vero::Senders::Base,
            :none         => Vero::Senders::Base,
            :thread       => Vero::Senders::Invalid,
          }
        end
      end
    end

    if RUBY_VERSION =~ /1\.9\./
      context "~> Ruby 1.9" do
        it "should have a default set of senders (true, false, none, thread)" do
          subject.senders.should == {
            true          => Vero::Senders::Thread,
            false         => Vero::Senders::Base,
            :none         => Vero::Senders::Base,
            :thread       => Vero::Senders::Thread,
          }
        end
      end
    end

    it "should automatically find senders that are not defined" do
      subject.senders[:delayed_job].should  == Vero::Senders::DelayedJob
      subject.senders[:resque].should       == Vero::Senders::Resque
      subject.senders[:invalid].should      == Vero::Senders::Invalid
      subject.senders[:none].should         == Vero::Senders::Base
    end
  end
end