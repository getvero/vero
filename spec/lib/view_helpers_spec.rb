require 'spec_helper'
require 'action_view'
require 'active_support'

include Vero::ViewHelpers
include ActionView::Helpers
include ActionView::Context

describe Vero::ViewHelpers do
  before :each do
    Vero::App.reset!
  end

  describe :vero_javascript_tag do
    it "should return an empty string if Vero::App is not properly configured" do
      Vero::ViewHelpers.vero_javascript_tag.should == ""

      Vero::App.init {}
      Vero::ViewHelpers.vero_javascript_tag.should == ""
    end

    context "Vero::App has been properly configured" do
      before :each do
        @api_key = "abcd1234"
        @api_secret = "secret"
        @api_dev_mode = false

        Vero::App.init do |c|
          c.api_key           = @api_key
          c.secret            = @api_secret
          c.development_mode  = @api_dev_mode
        end
      end

      it "should return a properly formatted javascript snippet" do
        result = "<script type=\"text/javascript\">var _veroq = _veroq || [];setTimeout(function(){if(typeof window.Semblance==\"undefined\"){console.log(\"Vero did not load in time.\");for(var i=0;i<_veroq.length;i++){a=_veroq[i];if(a.length==3&&typeof a[2]==\"function\")a[2](null,false);}}},3000);_veroq.push(['init', {api_key: \"#{@api_key}\", secret: \"#{@api_secret}\"}]);(function() {var ve = document.createElement('script'); ve.type = 'text/javascript'; ve.async = true; ve.src = '//getvero.com/assets/m.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ve, s);})();</script>"
        Vero::ViewHelpers.vero_javascript_tag.should == result
      end
    end
  end
end