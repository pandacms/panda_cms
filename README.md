# Panda CMS

> [!CAUTION]
> This application is being developed in public. It is not ready for production use. If you'd like to try it out (or help with documentation), please contact [@jfi](https://github.com/jfi) by emailing [bamboo@pandacms.io](mailto:bamboo@pandacms.io).

## Panda CMS is the CMS we always wanted. 🐼

Better websites, on Rails.

[Read more about the project...](https://github.com/pandacms/.github/blob/main/profile/README.md) ✨

🐼 is grown from our work at [Otaina](https://www.otaina.co.uk), a small group of freelancers. We needed something that could handle websites large and small – but where we could expand it too. We sent our first websites live in March 2024.

![Gem Version](https://img.shields.io/gem/v/panda_cms) ![Build Status](https://img.shields.io/github/actions/workflow/status/pandacms/panda_cms/ci.yml)
![GitHub Last Commit](https://img.shields.io/github/last-commit/pandacms/panda_cms) [![Ruby Code Style](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/standardrb/standard)

## Usage

### New applications

To create a new Rails app, run the command below, replacing `demo` with the name of the application you want to create:

```
rails new demo $(curl -fsSL https://raw.githubusercontent.com/pandacms/generator/main/.railsrc) -m https://raw.githubusercontent.com/pandacms/generator/main/template.rb
```

`cd` into your directory (e.g. `demo`) and run `bin/dev`. You'll see a basic website has automatically been created for you at http://localhost:3000/

The easiest way for you to get started is to visit http://localhost:3000/admin and login with your GitHub credentials. As the first user, you'll automatically have an administrator account created.

When you're ready to configure further, you can set your own configuration in `config/initializers/panda_cms.rb`. Make sure to turn off the default `github` account creation options!

### Existing applications

Add the following to `Gemfile`:

```ruby
gem "panda_cms"
```

For initial setup, run:

```shell
bundle install
rails generate panda_cms:install
rails db:migrate
rails db:seed
```

You may want to check this does not re-run any of your existing seeds!

If you don't want to use GitHub to login (or are at a URL other than http://localhost:3000/), you'll need to configure a user provider (in `config/initializers/panda_cms.rb`), and then set your user's `admin` attribute to `true` once you've first tried to login.

## Gotchas

This is a non-exhuastive list (there will be many more):

* To date, this has only been tested with Rails 7.1 and 7.2.
* There may be conflicts if you're not using Tailwind CSS on the frontend. Please report this.

## Contributing

We welcome contributions.

See our [Contributing Guidelines](https://github.com/pandacms/panda_cms/blob/main/CONTRIBUTING.md).

See [Credits](https://github.com/pandacms/panda_cms/blob/main/CREDITS.md) for thanks, influences, libraries and other credits.

## License

The gem is available as open source under the terms of the [BSD-3-Clause License](https://opensource.org/licenses/bsd-3-clause).

Copyright © 2024, Panda Software Limited.
