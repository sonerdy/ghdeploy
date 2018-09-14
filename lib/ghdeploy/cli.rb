require 'thor'
require 'ghdeploy'
require 'ghdeploy/repo_fact_finder'
require 'octokit'

module Ghdeploy
	class CLI < Thor

    option :description
    option :remote

		desc 'deploy', 'Creates a GitHub deployment.'
		def deploy(environment, ref)
		  remote_name = options[:remote] || 'origin'
			facts = RepoFactFinder.new(remote_name)
      Octokit.configure { |c| c.api_endpoint = facts.api_endpoint }
			client = Octokit::Client.new(access_token: facts.token)
			deployment = client.create_deployment(facts.repo, ref, environment: environment)
      puts "Deployment created: #{deployment.url}" if deployment.url
		end

		default_task :deploy
	end
end

