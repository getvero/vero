# vero

vero makes it easy to interact with Vero's REST API from your Rails 3.x app. Vero is a user lifecycle platform that allows you to engage and re-engage your customer base via email, based on the actions they perform in your software. For more information about the platform, visit [Vero](http://getvero.com).

## Installation

Include in your Gemfile:

    gem 'vero'
    gem 'delayed_job'

Or install the gem:

    gem install 'delayed_job'
    gem install 'vero'

__NOTE: vero uses delayed_job to asynchrously send events to the API__.

Create a [Vero account](http://getvero.com). Create an initializer in your config/initializers folder called vero.rb with the following:
    
    # config/initializers/vero.rb
    Vero::App.init do |config|
      config.api_key = "Your API key goes here"
      config.secret = "Your API secret goes here"
    end

You will be able to find your API key and secret by logging into Vero and clicking the 'Account' button at the top of the page.

To send events synchronously (i.e. avoid delayed_job), add the following to your initializer:

    config.async = false

## Setup tracking

You will need to define who should be tracked and what information about them you'd like to send to Vero. In this example we'll track users:
    
    # app/models/user.rb
    class User < ActiveRecord::Base
      include Vero::Trackable 
      trackable :email, :name, :age

      ...
    end

As you can see we're saying that a User is trackable and that we'd like to pass up their email address, name and age. 

Each symbol passed to trackable should reference either an instance method or an ActiveRecord field. Therefore it's perfectly legal to do something like:
    
    # app/models/user.rb
    class User < ActiveRecord::Base
      include Vero::Trackable 
      trackable :email, :contest_count

      has_many :contests

      def contest_count
        self.contests.count
      end
    end

__NOTE: 'email' is a required field__. 

If the user's email address is stored under a different field, you can do the following:
    
    # app/models/user.rb
    class User < ActiveRecord::Base
      include Vero::Trackable 
      trackable :email

      def email; self.email_address; end
    end

## Sending events

To send an event:
    
    # app/controllers/contests_controller.rb
    class ContestsController < ActionController::Base
      before_filter :authenticate_user!
      ...

      
      def create
        @contest = current_user.contests.build(params[:contest])

        if @contest.save
          # Tell Vero that a new contest has been created
          current_user.track('new_contest_created')
          
          flash[:notice] = "New contest saved successfully!"
          redirect_to contests_path
        else
          flash[:alert] = "Unable to create your contest. Please review your details and try again."
          render 'new'
        end
      end
    end

You can only send events on models which are trackable.

You may want to send additional data about an event:
    
    # app/controllers/contests_controller.rb
    class ContestsController < ActionController::Base
      before_filter :authenticate_user!
      ...

      
      def create
        @contest = current_user.contests.build(params[:contest])

        if @contest.save
          # Tell Vero that a new contest has been created, and the id and name
          current_user.track('new_contest_created', {id: @contest.id, name: @content.name})
          
          flash[:notice] = "New contest saved successfully!"
          redirect_to contests_path
        else
          flash[:alert] = "Unable to create your contest. Please review your details and try again."
          render 'new'
        end
      end
    end