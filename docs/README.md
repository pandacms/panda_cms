# Documentation

This documentation is created using [Just the Docs].

Before building locally, add a `.env` file with the following content:

```
JEKYLL_GITHUB_TOKEN=xxx
```

This should be a [GitHub token] created with scope `public_repo`.

Build locally using `bundle exec jekyll serve`.

Deployment uses the file at `../.github/workflows/docs.yml`.

[Just the Docs]: https://just-the-docs.github.io/just-the-docs/
[GitHub token]: https://github.com/settings/tokens/new
