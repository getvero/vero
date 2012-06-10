# vero

vero makes it easy to interact with Vero's REST API from your Rails 3.x app. Vero is a user lifecycle platform that allows you to engage and re-engage your customer base via email, based on the actions they perform in your software. 

For more information about the platform, [click here](http://getvero.com) to visit Vero.

## Installation

Include in your Gemfile:

    gem 'vero'

Or install the gem:

    gem install 'vero'

Create a [Vero account](http://getvero.com). Create an initializer in your config/initializers folder called vero.rb with the following:
    
    # config/initializers/vero.rb
    Vero::App.init do |config|
      config.api_key = "Your API key goes here"
      config.secret = "Your API secret goes here"
    end

You will be able to find your API key and secret by logging into Vero and clicking the 'Account' button at the top of the page.

By default, events are sent asynchronously using DelayedJob. To force all events to be sent synchronously, add the following line to your initializer:

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

There is one caveat, email (or email_address) is a required field. If the user's email address is stored under a different field, you can do the following:
    
    # app/models/user.rb
    class User < ActiveRecord::Base
      include Vero::Trackable 
      trackable :email

      def email; self.primary_contact; end
    end

## Sending events

Events can be sent by any model which has been previously marked as trackable.

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