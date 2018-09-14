
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ghdeploy/version'

Gem::Specification.new do |spec|
  spec.name          = 'ghdeploy'
  spec.version       = Ghdeploy::VERSION
  spec.authors       = ['Brandon Joyce']
  spec.email         = ['brandon@sonerdy.com']

  spec.summary       = 'Adds a deploy command to git that uses the GitHub deployments API'
  spec.description   = 'Run git deploy within a git repository to create a GitHub deployment.'
  spec.homepage      = 'https://github.com/sonerdy/ghdeploy'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'git', '~> 1.5'
  spec.add_runtime_dependency 'octokit', '~> 4.0'
  spec.add_runtime_dependency 'thor', '~> 0.20'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
end
