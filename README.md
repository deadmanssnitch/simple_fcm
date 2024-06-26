# SimpleFCM

SimpleFCM is a minimalist client for Firebase Cloud Messaging to send Push
Notifications.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add simple_fcm

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install simple_fcm

## Usage

```ruby
# Initialize a new client for talking to Firebase Cloud Messaging. Client.new
# takes an optional parameter which is either the path to a service account
# config file or the raw config JSON. Not passing a config or passing nil will
# pull the configuration from environment variables.
client = SimpleFCM::Client.new("path/to/service_account.json")

# See https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages/send
client.push({
  message: {
    token: device.token,
    data: {
      message: "Jinkies! Something happened",
      id: snitch.id,
    }
  }
})
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/deadmanssnitch/simple_fcm. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/deadmanssnitch/simple_fcm/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SimpleFCM project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/deadmanssnitch/simple_fcm/blob/main/CODE_OF_CONDUCT.md).
