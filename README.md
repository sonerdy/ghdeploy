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
If you're using an internal github server, you'll want to specify a host-specific token.
For example, if you're internal host is `https://my-enterprise-github.com`, then specify a token like so:
```
export GHDEPLOY_MY_ENTERPRISE_GITHUB_COM_TOKEN=<token-from-internal-github>
```

## Usage

From within a git repository run:

Basic deploy of master branch to production:
```
git deploy production master
```

**Note** *If you are using RVM and are the following error 

```
git: 'deploy' is not a git command. See 'git --help'.
```
while trying to run the above command, run this first:
```
rvm use 2.3.6
```