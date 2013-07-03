# km_everything

A simple gem to add KissMetrics logging to all your user clicks that hit your web server.
It logs all controller actions by default, but you can set up a whitelist to give them more meaningful 
and product-manager friendly names, or a ‘blacklist’ to prevent certain actions from being logged that
aren’t meaningful and would use too much of your KissMetrics event quota.

See http://pivotallabs.com/a-user-metric-is-a-terrible-thing-to-waste/

## Requirements
  * Ruby 1.9

## Installation

Add to gemfile:

    gem 'km_everything'

## Usage

In config/initializers/km\_everything\_.rb:

    KmEverything.event_names = YAML.load(File.open("path/to/file.yml"))
    KmEverything.record_every_controller_action = true

And/or:

    KmEverything.events_to_exclude = YAML.load(File.open("path/to/file.yml"))
    KmEverything.record_every_controller_action = true

In config/km\_everything\_to\_exclude.yml:

    notifications: [:show]

To only track signed in users, do the following in application_controller.rb:

    after_filter :queue_kissmetrics, if: :user_signed_in?

    def queue_kissmetrics
      event_name = KmEverything::KmEvent.new(controller_name, action_name).event
      KmResque.record(current_user.id, event_name, {}) unless event_name.nil?
    end

If you want to track users before and after sign in, do the following in application_controller.rb:

    after_filter :queue_kissmetrics

    #kissmetrics
    def generate_identifier
      now = Time.now.to_i
      Digest::MD5.hexdigest(
          (request.referrer || '') +
              rand(now).to_s +
              now.to_s +
              (request.user_agent || '')
      )
    end

    def km_identifier
      unless identity = cookies[:km_identity]
        identity = generate_identifier
        cookies[:km_identity] = {
          :value => identity, :expires => 5.years.from_now
        }
      end

      # This example assumes you have a current_user. You can use
      # property "email", or whatever makes sense for your app.

      if current_user
        unless cookies[:km_aliased]

          #KM.alias(identity, current_user.id)
          KmResque.alias(identity, current_user.id)

          cookies[:km_aliased] = {
            :value => true,
            :expires => 5.years.from_now
          }
        end
      end

      current_user ? current_user.id : identity
    end

    def queue_kissmetrics
      event_name = KmEverything::KmEvents.new(controller_name, action_name).event
      identifier = km_identifier
      KmResque.record(identifier, event_name, {}) unless event_name.nil?
    end
