require 'spec_helper'

describe Vero::Api::Events do
  let (:subject) { Vero::Api::Events }

  describe :track! do
    it "should call the TrackAPI object via the configured sender" do
      input = {:event_name => "test_event", :identity => {:email => "james@getvero.com"}, :data => {:test => "test"}}
      expected = input.merge(:auth_token => "abc123", :development_mode => true)

      mock_context = Vero::Context.new
      allow(mock_context.config).to receive(:configured?).and_return(true)
      allow(mock_context.config).to receive(:auth_token).and_return("abc123")
      allow(mock_context.config).to receive(:development_mode).and_return(true)

      allow(Vero::App).to receive(:default_context).and_return(mock_context)

      expect(Vero::Sender).to receive(:send).with(Vero::Api::Workers::Events::TrackAPI, true, "https://api.getvero.com", expected)

      subject.track!(input)
    end
  end
end

describe Vero::Api::Users do
  let(:subject) { Vero::Api::Users }
  let(:mock_context) { Vero::Context.new }
  let(:expected) { input.merge(:auth_token => "abc123", :development_mode => true) }

  before :each do
    allow(mock_context.config).to receive(:configured?).and_return(true)
    allow(mock_context.config).to receive(:auth_token).and_return("abc123")
    allow(mock_context.config).to receive(:development_mode).and_return(true)
    allow(Vero::App).to receive(:default_context).and_return(mock_context)
  end

  describe :track! do
    context "should call the TrackAPI object via the configured sender" do
      let(:input) { {:email => "james@getvero.com", :data => {:age => 25}} }

      specify do
        expect(Vero::Sender).to receive(:send).with(Vero::Api::Workers::Users::TrackAPI, true, "https://api.getvero.com", expected)
        subject.track!(input)
      end
    end
  end

  describe :edit_user! do
    context "should call the TrackAPI object via the configured sender" do
      let(:input) { {:email => "james@getvero.com", :changes => {:age => 25}} }

      specify do
        expect(Vero::Sender).to receive(:send).with(Vero::Api::Workers::Users::EditAPI, true, "https://api.getvero.com", expected)
        subject.edit_user!(input)
      end
    end
  end

  describe :edit_user_tags! do
    context "should call the TrackAPI object via the configured sender" do
      let(:input) { {:add => ["boom"], :remove => ["tish"]} }

      specify do
        expect(Vero::Sender).to receive(:send).with(Vero::Api::Workers::Users::EditTagsAPI, true, "https://api.getvero.com", expected)
        subject.edit_user_tags!(input)
      end
    end
  end

  describe :unsubscribe! do
    context "should call the TrackAPI object via the configured sender" do
      let(:input) { {:email => "james@getvero"} }

      specify do
        expect(Vero::Sender).to receive(:send).with(Vero::Api::Workers::Users::UnsubscribeAPI, true, "https://api.getvero.com", expected)
        subject.unsubscribe!(input)
      end
    end
  end

  describe :resubscribe! do
    it "should call the TrackAPI object via the configured sender" do
      input = {:email => "james@getvero"}
      expected = input.merge(:auth_token => "abc123", :development_mode => false)

      mock_context = Vero::Context.new
      mock_context.config.stub(:configured?).and_return(true)
      mock_context.config.stub(:auth_token).and_return("abc123")

      Vero::App.stub(:default_context).and_return(mock_context)

      Vero::Sender.should_receive(:send).with(Vero::Api::Workers::Users::ResubscribeAPI, true, "https://api.getvero.com", expected)

      subject.resubscribe!(input)
    end
  end
end