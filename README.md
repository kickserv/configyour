# Configyour

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'configyour'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install configyour

## Usage

In `config/application.rb`, add a `Configyour.configure` block right below the `Bundler.require(*Rails.groups)` line

The minimum required configuration is:

```ruby
Configyour.configure do |config|
  config.parameter_root = '<name of the root of your parameter tree>' # example, kickserv
end
```

If you set `parameter_root` to `your_app`, Configyour will grab all parameters under the `/your_app/<environment>/` tree.

The parameter names fetched from Parameter Store are upcased to produce `ENVIRONMENT_VARIABLE` style names. This is so they fit `ENV` naturally.

### Available options

* `parameter_root` - Root of the parameter tree to fetch. It can contain a deeper level if required (e.g. `your_app/next_level`). It should not begin or end with a /
* `environment` - The application's run environment (development, production, etc). It is appended to the end of the `parameter_root` option. When loaded in Rails, Configyour will use `Rails.env` if you do not manually specify an environment with this option.
* `file_path` - (**File mode only**) The file to write the fetched environment variable data. You can set this to another file path if you use something other than Figaro to load your generated environment variable file. Defaults to `config/application.yml`.
* `rebuild` - (**File mode only**) Configyour skips building the `config/application.yml` file if it already exists. This option allows you to rebuild this file on boot if you need to. Defaults to `false`
* `region` - The AWS region where your parameters are. Defaults to `us-east-1`
* `mode` - The mode that tells Configyour how to present the environment variable data. Defaults to `file`.
    * `file` - Writes to the file path defined by the `file_path` option
    * `direct` - Writes environment variables into ENV directly, bypassing the intermediary file.

## Development

TODO

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kickserv/configyour.
