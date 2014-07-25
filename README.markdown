# vero
[![Build Status](https://travis-ci.org/getvero/vero.png?branch=master)](https://travis-ci.org/getvero/vero)

[vero](https://github.com/getvero/vero) makes it easy to interact with Vero's
REST API from your Ruby app. Vero is an email marketing platform that allows you
to engage and re-engage your customer base based on the actions they perform in
your software.

For more information about the platform, [click here](http://getvero.com).

## Installation

Include in your Gemfile:

    gem 'vero'

Or install the gem:

    gem install vero

Create an initializer in your config/initializers folder called vero.rb with the
following:

    # config/initializers/vero.rb
    Vero::App.init do |config|
      config.api_key = "Your API key goes here"
      config.secret = "Your API secret goes here"
    end

You will be able to find your API key and secret by logging into Vero
([sign up](http://getvero.com) if you haven't already) and clicking the
'Your Account' link at the top of the page then select 'API Keys'.

By default, events are sent asynchronously using a background thread.
We recommend that you select one of the supported queue-based alternatives:

    config.async = :none            # Synchronously
    config.async = :thread          # Background thread (default)
    config.async = :delayed_job     # DelayedJob
    config.async = :resque          # Resque (recommended)

**Note:** If you're using Mongoid with DelayedJob, you must add
`gem "delayed_job_mongoid"` to your Gemfile.

vero will automatically choose whether to send requests to your
**development** or **live** environment if you are using Rails 3.x. You can
override this in your initializer:

    config.development_mode = true # or false

Finally, if you wish to disable vero requests when running your automated tests,
add the following line to your initializer:

    config.disabled = Rails.env.test?

## Setup tracking

You will need to define who should be tracked and what information about them
you would like sent to Vero. In this example we'll track users:

    # app/models/user.rb
    class User < ActiveRecord::Base
      include Vero::Trackable
      trackable :id, :email, :name

      ...
    end

As you can see we're saying that a User is trackable and that we'd like to pass
up their user id, email address, and name.

Each symbol passed to trackable should reference either an instance method or
field. Therefore it's perfectly legal to do something like:

    # app/models/user.rb
    class User < ActiveRecord::Base
      include Vero::Trackable
      trackable :id, :email, :contest_count

      has_many :contests

      def contest_count
        self.contests.count
      end
    end

There is one caveat: you must pass an "id" to the API in order to perform
requests. In many cases the user "id" will simply be their email address. The
API will assume that if an "id" is not present that it should use "email" as
the "id".

If the user's email address is stored under a different field, you can do the
following:

    # app/models/user.rb
    class User < ActiveRecord::Base
      include Vero::Trackable
      trackable :id, :email

      def email; self.primary_contact; end
    end

Finally, you can track multiple properties stored in a Hash by doing the
following:

    # app/models/user.rb
    class User < ActiveRecord::Base
      include Vero::Trackable
      trackable :id, :email, {:extras => :properties}

      def email; self.primary_contact; end

      def properties
        {
          :first_name => "James",
          :last_name => "Lamont"
        }
      end
    end

**Note:** You may choose to bypass extending the `User` model by calling the
API via [simple DSL](https://github.com/getvero/vero#simple-dsl) found below.

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
          current_user.track!('new_contest_created')

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
          current_user.track!('new_contest_created', {:id => @contest.id, :name => @content.name})

          flash[:notice] = "New contest saved successfully!"
          redirect_to contests_path
        else
          flash[:alert] = "Unable to create your contest. Please review your details and try again."
          render 'new'
        end
      end
    end

## Simple DSL

To avoid having to extend the `User` model, we offer the option to call our API
using a simple DSL (thanks @jherdman) as you would from the Javascript library.

First, ensure you've correctly configured the gem following the instructions as
outlined in Installation. Now you can call the API using the following methods:

    class UsersController < ApplicationController
      include Vero::DSL

      def perform_action
        # Tracking an event
        vero.events.track!({
          :event_name => "test_event",
          :data => {:date => "2013-02-12 16:17"},
          :identity => {:id => 123, :email => "james@getvero.com"}
        })
      end

      def create
        # Identifying a user
        vero.users.track!({:id => 123, :data => {}})
      end

      def update
        # Editing a user
        vero.users.edit_user!({:id => 123, :changes => {:age => 25}})

        # Editing a user's tags
        vero.users.edit_user_tags!({:id => 123, :add => ["awesome"], :remove => []})

        # Changing a user's id
        vero.users.reidentify!({:id => 123, :new_id => "honeybadger@getvero.com"})
      end

      def destroy
        vero.users.unsubscribe!({:id => 123})
      end
    end

## License Information

This gem is distributed under the MIT License.

Copyright (C) 2014 Vero (Invc Me Inc.)

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
