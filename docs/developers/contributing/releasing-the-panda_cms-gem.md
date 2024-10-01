---
title: Releasing the panda_cms gem
layout: default
parent: Contributing
---

## Releasing

The **panda_cms** gem uses semantic versioning.

### Installing `gem-release`

Installing [gem-release](https://github.com/svenfuchs/gem-release) makes some parts of the release cycle easier:

```
gem install gem-release
```

### Releasing a new version of the `panda_cms` gem

With no staged changes, to set the next version number, run:

```
RELEASE_VERSION=$(gem bump --pretend --no-commit | awk '{ print $4 }' | tr -d '[:space:]')
echo $RELEASE_VERSION
```

This should output the next patch release version.

You can also set `RELEASE_VERSION` manually:

```
RELEASE_VERSION=0.6.2
```

To release the gem **to this version number**, run:

```
gem bump --version "$RELEASE_VERSION"
bundle install
git checkout -b release/v$RELEASE_VERSION
git add . && git commit --message "[RELEASE] v$RELEASE_VERSION"
git push
git checkout main
git merge release/v$RELEASE_VERSION
gem build panda_cms.gemspec
gem push panda_cms-$RELEASE_VERSION.gem
```

To release the gem to another version, set `RELEASE_VERSION` yourself first.
