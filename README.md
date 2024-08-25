# Panda CMS

> [!CAUTION]
> This application is being developed in public. It is not ready for production use. If you'd like to try it out (or help with documentation), please contact [@jfi](https://github.com/jfi).

## Panda CMS is the CMS we always wanted. 🐼

Better websites, on Rails.

[Read more about the project...](https://github.com/pandacms/.github/blob/main/profile/README.md) ✨

Panda is grown from our work at [Otaina](https://www.otaina.co.uk), a small group of freelancers. We needed something that could handle websites large and small – but where we could expand it too. We sent our first websites live in March 2024.

![GitHub Last Commit](https://img.shields.io/github/last-commit/pandacms/panda_cms) [![Ruby Code Style](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/standardrb/standard)

## Usage

To create a new Rails app[^1], run the command below, replacing `demo` with the name of the application you want to create:

```
rails new demo $(curl -fsSL https://raw.githubusercontent.com/pandacms/generator/main/.railsrc) -m https://raw.githubusercontent.com/pandacms/generator/main/template.rb
```

`cd` into your directory (e.g. `demo`) and run `bin/dev`. You'll see a basic website has automatically been created for you at http://localhost:3000/

The easiest way for you to get started is to visit http://localhost:3000/admin and login with your GitHub credentials. As the first user, you'll automatically have an administrator account created.

### Existing applications

Add the following to `Gemfile`:

```ruby
source "https://rubygems.pkg.github.com/pandacms" do
  gem "panda_cms"
end
```

For initial setup, run:

```shell
bundle install
rails generate panda_cms:install
rails db:migrate
rails db:seed
```

If you don't want to use GitHub to login, you'll need to configure a user provider (in `config/initializers/panda_cms.rb`), and then set your user's `admin` attribute to `true` once you've first tried to login. (And yes, there should be a better first-time setup experience than this. We're working on it!)

## Gotchas

This is a non-exhuastive list (there will be many more):

* To date, this has only been tested with Rails 7.1 and 7.2.
* This assumes you're using Tailwind CSS for your frontend. We'll attempt to relax this in future, but supporting Tailwind CSS is our current priority.
* If you change your login path from `/admin` the GitHub application we supply won't work on first login, so probably don't do that until you're setup!

## Contributing

We welcome contributions.

See our [Contributing Guidelines](https://github.com/pandacms/panda_cms/blob/main/CONTRIBUTING.md).

See [Credits](https://github.com/pandacms/panda_cms/blob/main/CREDITS.md) for thanks, influences, libraries and other credits.

## License

The gem is available as open source under the terms of the [BSD-3-Clause License](https://opensource.org/licenses/bsd-3-clause).

Copyright © 2024, Panda Software Limited.

[^1]: You can of course use an existing Rails app, but on your head be it – we haven't tested this at all yet!
