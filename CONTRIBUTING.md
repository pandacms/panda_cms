# Contributing

We welcome contributions!

## License

By contributing your code to Panda CMS you grant Panda Software Limited a non-exclusive, irrevocable, worldwide, royalty-free, sublicenseable, transferable license under all of Your relevant intellectual property rights (including copyright, patent, and any other rights), to use, copy, prepare derivative works of, distribute and publicly perform and display the Contributions on any licensing terms, including without limitation: (a) open source licenses like the MIT or BSD licenses; and (b) binary, proprietary, or commercial licenses. Except for the licenses granted herein, You reserve all right, title, and interest in and to the Contribution.

You confirm that you are able to grant us these rights. You represent that You are legally entitled to grant the above license. If Your employer has rights to intellectual property that You create, You represent that You have received permission to make the Contributions on behalf of that employer, or that Your employer has waived such rights for the Contributions.

You represent that the Contributions are Your original works of authorship, and to Your knowledge, no other person claims, or has the right to claim, any right in any invention or patent related to the Contributions. You also represent that You are not legally obligated, whether by entering into an agreement or otherwise, in any way that conflicts with the terms of this license.

Panda Software Limited acknowledges that, except as explicitly described in this Agreement, any Contribution which you provide is on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY, OR FITNESS FOR A PARTICULAR PURPOSE.

## Developing

Run the following command and ensure your Gemfile is setup as follows:

```
bundle config set panda_cms.local PATH_TO_PANDA_CMS_DIRECTORY
```

```ruby
gem "panda_cms", github: "pandacms/panda_cms", branch: "main"
```

Alternatively, you may want to use a path to a folder on disk in the `Gemfile` itself:

```ruby
gem "panda_cms", path: "../panda_cms"
```

## Assets

Whilst developing, you'll likely want to run the task `rake panda_cms:assets:watch_admin` to ensure your assets are updated. When you're done, run `rake panda_cms:assets:compile`.

## Branching

When creating new branches, please use the following format: `prefix/name-of-branch`. Prefixes we use are:

* `bugfix` - fixes to bugs
* `feature` - new features or functionality
* `hotfix` - quick fixes, such as text or UI changes, that aren't part of a larger bugfix
* `docs` - documentation improvements (that aren't part of another update)
* `config` - configuration changes
* `dep` – dependency updates, e.g. gem updates or similar
* `release` - a new release of the gem
* `ux` - frontend changes that do not fit into the categories above

If available, include the ID of the Github issue in the branch, e.g. `bugfix/123-correct-timezones-on-page-edit`

Here's an example of a PR which follows these guidelines: https://github.com/pandacms/panda_cms/pull/5

## Lefthook

We use [Lefthook](https://github.com/evilmartians/lefthook) for running pre-commit hooks. You can install this using:

```bash
lefthook install
```

## Tests

To setup tests, from the `panda_cms/spec/dummy` directory, run:

```bash
RAILS_ENV=test rails db:create
RAILS_ENV=test rails db:schema:load
```

Then, for test runs, from the `panda_cms` directory, run:

```bash
bundle exec rspec
```

System tests are run using `rack_test`, or for JavaScript, `selenium_chrome_headless`. This will run Chrome headlessly (without the browser window visible), and save failure screenshots to `spec/dummy/tmp/capybara`. If you want to see the browser (using the `selenium_chrome` driver), prefix your commands with `SHOW_BROWSER=1`, such as:

```bash
SHOW_BROWSER=1 bundle exec rspec spec/system/website_spec.rb
```

You can also use the `pause` command within a test to pause browser execution. Resume by returning to your console and pressing the enter key.

## Using the dummy application

Panda CMS includes a dummy application (which is mildly more advanced than the traditional Rails "dummy" application) we use to test the functionality of the CMS is available and working. This is using RSpec (so lives in `spec/dummy` rather than the traditional `test/dummy`).

In future, we may need different versions of dummy applications to test different asset pipelines or versions of Rails.

We don't recommend using the `dummy` app to develop in (see https://github.com/pandacms/demo_site for a real application you can use alongside the "Developing" section above). But, if needed, you can use this in development mode. To setup the `dummy` application for use in development mode, run the following from `spec/dummy`:

```
rails db:create
rails db:schema:load
rails db:seed
```

To run the `dummy` application in development mode, from the `spec/dummy` directory, run:

```
bin/dev
```

Set up your authentication provider and visit http://localhost:3000/admin to login.

<mark>We haven't yet added instructions on how to set up your authentication provider; you may have some luck signing in with GitHub in the meantime. If you're using the default configuration, try login for the first time then set your user to be `admin = true`. We'll sort some better setup steps soon. 🙂</mark>

This runs a Rails server, and watch tasks for both the engine's CSS and dummy application's CSS.
