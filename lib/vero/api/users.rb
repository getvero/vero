class Vero::Api::Users < Vero::Api::Base
  def self.track!(options, context = Vero::App.default_context)
    new(context).track!(options)
  end

  def self.edit_user!(options, context = Vero::App.default_context)
    new(context).edit_user!(options)
  end

  def self.edit_user_tags!(options, context = Vero::App.default_context)
    new(context).edit_user_tags!(options)
  end

  def self.reidentify!(options, context = Vero::App.default_context)
    new(context).reidentify!(options)
  end

  def self.unsubscribe!(options, context = Vero::App.default_context)
    new(context).unsubscribe!(options)
  end

  def self.resubscribe!(options, context = Vero::App.default_context)
    new(context).resubscribe!(options)
  end

  def self.delete!(options, context = Vero::App.default_context)
    new(context).delete!(options)
  end

  def track!(options)
    run_api(Vero::Api::Workers::Users::TrackAPI, options)
  end

  def edit_user!(options)
    run_api(Vero::Api::Workers::Users::EditAPI, options)
  end

  def edit_user_tags!(options)
    run_api(Vero::Api::Workers::Users::EditTagsAPI, options)
  end

  def unsubscribe!(options)
    run_api(Vero::Api::Workers::Users::UnsubscribeAPI, options)
  end

  def resubscribe!(options)
    run_api(Vero::Api::Workers::Users::ResubscribeAPI, options)
  end

  def reidentify!(options)
    run_api(Vero::Api::Workers::Users::ReidentifyAPI, options)
  end

  def delete!(options)
    run_api(Vero::Api::Workers::Users::DeleteAPI, options)
  end
end
