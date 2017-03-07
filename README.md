# Equifax Ruby

Equifax Ruby provides ruby bindings to the Equifax VOE/VOI services

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'equifax-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install equifax-ruby

## Usage

#### Authentication

**VIA Initializer**

Set Equifax Credentials in your applications initializer

```ruby
Equifax::Client.account_number
Equifax::Client.password
```

**VIA environment variable**

Set Equifax Credentials via environment variables

```bash
export EQUIFAX_ACCOUNT_NUMBER="123456"
export EQUIFAX_PASSWORD="123456"
```

**VIA request `opts` hash**

```ruby
opts = { account_number: "123456", password: "password" }
response = Equifax::Worknumber::VOE::Instant.call(opts)
```

#### Instant VOE


```ruby
# middle_name and either employer_code or employer_name are optional

opts = {
          first_name: 'Example',
          middle_name: 'Example',
          last_name: 'Example',
          ssn: '123456789',
          street_address: '1234 Main St.',
          city: 'Denver',
          state: 'CO',
          postal_code: '90206',
          residency_type: 'Current',
          report_type: 'Other',
          report_description: 'VOE',
          lender_case_id: 'LOANFILE123456',
          employer_code: '',
          employer_name: '',

}
response = Equifax::Worknumber::VOE::Instant.call(opts)
=>


```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/equifax-ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

