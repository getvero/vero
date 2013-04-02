require "spec_helper"

describe Vero::Api::Workers::BaseAPI do
  let (:subject) { Vero::Api::Workers::BaseAPI.new("http://www.getvero.com", {}) }

  describe :options_with_symbolized_keys do
    it "should create a new options Hash with symbol keys (much like Hash#symbolize_keys in rails)" do
      subject.options.should == {}

      subject.options = {:abc => 123}
      subject.options.should == {:abc => 123}

      subject.options = {"abc" => 123}
      subject.options.should == {:abc => 123}
    end
  end
end