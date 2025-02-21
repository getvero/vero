# frozen_string_literal: true

require "spec_helper"

require "rails"
require "action_view"
require "active_support"
require "vero/view_helpers/javascript"

# rubocop:disable Style/MixinUsage
include Vero::ViewHelpers::Javascript
include ActionView::Helpers
include ActionView::Context
# rubocop:enable Style/MixinUsage

describe Vero::ViewHelpers::Javascript do
  before do
    Vero::App.reset!
  end

  subject { Vero::ViewHelpers::Javascript }
  describe :vero_javascript_tag do
    it "should return an empty string if Vero::App is not properly configured" do
      expect(subject.vero_javascript_tag).to eq("")

      Vero::App.init
      expect(subject.vero_javascript_tag).to eq("")
    end

    context "Vero::App has been properly configured" do
      before :each do
        @tracking_api_key = "abcd1234"

        Vero::App.init do |c|
          c.tracking_api_key = @tracking_api_key
        end
      end

      it "should return a properly formatted javascript snippet" do
        expect(subject.vero_javascript_tag).to eq(<<~HTML.strip)
          <script type="text/javascript">var _veroq = _veroq || [];setTimeout(function(){if(typeof window.Semblance=="undefined"){console.log("Vero did not load in time.");for(var i=0;i<_veroq.length;i++){a=_veroq[i];if(a.length==3&&typeof a[2]=="function")a[2](null,false);}}},3000);_veroq.push(['init', {"tracking_api_key": "#{@tracking_api_key}"}]);(function() {var ve = document.createElement('script'); ve.type = 'text/javascript'; ve.async = true; ve.src = '//getvero.com/assets/m.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ve, s);})();</script>
        HTML
      end
    end
  end
end
