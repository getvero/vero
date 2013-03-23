# vero

vero makes it easy to interact with Vero's REST API from your Ruby app. Vero is a user lifecycle platform that allows you to engage and re-engage your customer base via email, based on the actions they perform in your software. 

For more information about the platform, [click here](http://getvero.com) to visit Vero.

## Installation

Include in your Gemfile:

    gem 'vero'

Or install the gem:

    gem install vero

Create a [Vero account](http://getvero.com). Create an initializer in your config/initializers folder called vero.rb with the following:
    
    # config/initializers/vero.rb
    Vero::App.init do |config|
      config.api_key = "Your API key goes here"
      config.secret = "Your API secret goes here"
    end

You will be able to find your API key and secret by logging into Vero and clicking the 'Account' button at the top of the page.

By default, events are sent asynchronously using a background thread. We do however offer a few alternatives:

    config.async = :none            # Synchronously
    config.async = :thread          # Background thread (default)
    config.async = :delayed_job     # DelayedJob
    config.async = :resque          # Resque

**Note:** Background threads are not supported by Ruby 1.8.7 or earlier. You must explicitly set `config.async` to either `:none`, `:delayed_job` or `:resque`.

**Note:** If you're using DelayedJob and Mongoid, you must add `gem "delayed_job_mongoid"` to your Gemfile.

Finally, vero will automatcially choose whether to send requests to your **development** or **live** environment if you are using Rails 3.x. You can override this in your initializer:

    config.development_mode = true # or false

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

Finally, you can track multiple properties stored in a Hash by doing the following:

    # app/models/user.rb
    class User < ActiveRecord::Base
      include Vero::Trackable 
      trackable :email, {:extras => :properties}

      def email; self.primary_contact; end

      def properties
        {
          :first_name => "James",
          :last_name => "Lamont"
        }
      end
    end
    
**Note:** You may choose to bypass extending the `User` model by calling the API directly. More information can be found below.

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
          current_user.track('new_contest_created', {:id => @contest.id, :name => @content.name})
          
          flash[:notice] = "New contest saved successfully!"
          redirect_to contests_path
        else
          flash[:alert] = "Unable to create your contest. Please review your details and try again."
          render 'new'
        end
      end
    end

## Simple DSL

To avoid having to extend the `User` model, we offer the option to call our API using a simple DSL (thanks @jherdman) as you would from the Javascript library.

First, ensure you've correctly configured the gem following the instructions as outlined in Installation. Now you can call the API using the following methods:

    class UsersController < ApplicationController
      include Vero::DSL

      def perform_action
        # Tracking an event
        vero.events.track!({
          :event_name => "test_event", 
          :data => {:date => "2013-02-12 16:17"}, 
          :identity => {:email => "james@getvero.com"}
        })
      end

      def create
        # Identifying a user
        vero.users.track!({:email => "james@getvero.com", :data => {}})
      end

      def update
        # Editing a user
        vero.users.edit_user!({:email => "james@getvero.com", :changes => {:age => 25}})

        # Editing a user's tags
        vero.users.edit_user_tags!({:email => "james@getvero.com", :add => [], :remove => ["awesome"]})
      end

      def destroy
        vero.users.unsubscribe!({:email => "james@getvero.com"})
      end
    end
