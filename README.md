# GitHub Deploy

This gem adds a command to git for publishing [GitHub deployments](https://developer.github.com/v3/repos/deployments/).

## Installation

```ruby
gem install 'ghdeploy'
```

# Setup
The only additional setup is to create a [personal access token](https://github.com/settings/tokens) in Github and set the environment variable.
```
export GHDEPLOY_TOKEN=<token-from-github>
```

## Usage

From within a git repository run:

Basic deploy of master branch to production:
```
git deploy production master
```
