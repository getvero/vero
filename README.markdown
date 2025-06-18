# vero

[vero](https://github.com/getvero/vero) makes it easy to interact with Vero's
REST API from your Ruby app. Vero is a customer engagement platform that allows you to message your customers based on the actions they perform on your website or application.

For more information about the platform, [click here](http://www.getvero.com).

## Latest released version (0.10.0)

This document relates to version 1.0 that is currently in development. For documentation on the latest released version [(0.10.0)](https://rubygems.org/gems/vero/versions/0.10.0) please refer to the [v0.10.0 readme](https://github.com/getvero/vero/blob/babbb05ab9e3da05cbe83d37688889c7ee27514a/README.markdown)

## Installation

Include in your Gemfile:

```
gem 'vero'
```

Or install the gem:

```
gem install vero
```

To get started with a Ruby on Rails application, add the following initializer:

```ruby
# config/initializers/vero.rb
Vero::App.init do |config|
  config.tracking_api_key = ENV['VERO_TRACKING_API_KEY']

  config.http_timeout = 30 # default timeout per API request is set to 60 (seconds)
end
```

You will be able to find your Tracking API key by visiting the [Settings page](https://connect.getvero.com/settings/project/tracking-api-keys).

By default, events are sent synchronously.
We recommend that you select one of the supported background thread/queue-based alternatives and add their
respective gem to your Gemfile:

```ruby
config.async = :none            # Synchronously
config.async = :sucker_punch    # SuckerPunch
config.async = :delayed_job     # DelayedJob
config.async = :sidekiq         # Sidekiq
config.async = :resque          # Resque (recommended)
```

**Note:** If you're using Mongoid with DelayedJob, you must add
`gem "delayed_job_mongoid"` to your Gemfile.

Finally, if you wish to disable Vero requests when running your automated tests,
add the following line to your initializer:

```ruby
config.disabled = Rails.env.test?
```

If you have any additional questions, please contact support@getvero.com.

## Setup tracking

You will need to define who should be tracked and what information about them
you would like sent to Vero. In this example we'll track users:

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  include Vero::Trackable
  trackable :id, :email, :name

  # ...
end
```

As you can see we're saying that a User is trackable and that we'd like to pass
up their user id, email address, and name.

Each symbol passed to trackable should reference either an instance method or
field. Therefore it's perfectly legal to do something like:

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  include Vero::Trackable
  trackable :id, :email, :contest_count

  has_many :contests

  def contest_count
    self.contests.count
  end
end
```

There is one caveat: you must pass an "id" to the API in order to perform
requests. In many cases the user "id" will simply be their email address. The
API will assume that if an "id" is not present that it should use "email" as
the "id".

If the user's email address is stored under a different field, you can do the
following:

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  include Vero::Trackable
  trackable :id, :email

  def email; self.primary_contact; end
end
```

Finally, you can track multiple properties stored in a Hash by doing the
following:

```ruby
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
```

**Note:** You may choose to bypass extending the `User` model by calling the
API via [simple DSL](https://github.com/getvero/vero#simple-dsl) found below.

## Sending events

Events can be sent by any model which has been previously marked as trackable.

To send an event:

```ruby
# app/controllers/contests_controller.rb
class ContestsController < ActionController::Base
  before_filter :authenticate_user!
  # ...

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
```

You may want to send additional data about an event:

```ruby
# app/controllers/contests_controller.rb
class ContestsController < ActionController::Base
  before_filter :authenticate_user!
  # ...


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
```

## Simple DSL

To avoid having to extend the `User` model, we offer the option to call our API
using a simple DSL (thanks @jherdman) as you would from the Javascript library.

First, ensure you've correctly configured the gem following the instructions as
outlined in Installation. Now you can call the API using the following methods:

```ruby
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

    # Resubscribing a user
    vero.users.resubscribe!({:id => 123})
  end

  def destroy
    vero.users.unsubscribe!({:id => 123})
  end
end
```

## License Information

This gem is distributed under the MIT License.

Copyright (C) 2025 Vero (Invc Me Inc.)

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
