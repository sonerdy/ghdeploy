# GitHub Deploy

This gem adds a command to git for publishing [GitHub deployments](https://developer.github.com/v3/repos/deployments/).

## Installation

```ruby
gem install 'ghdeploy'
ghdeploy init # creates a config file at ~/.ghdeploy
```

## Usage

From within a git repository run:

Basic deploy of master branch to production:
```
git deploy
```

More specific:
```
git deploy origin branch-name \
  --environment staging \
  --description "Short description"
```
