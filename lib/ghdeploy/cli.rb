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
      Octokit.configure { |c| c.api_endpoint = facts.host }
			client = Octokit::Client.new(access_token: ENV.fetch('GHDEPLOY_TOKEN'))
			deployment = client.create_deployment(facts.repo, ref, environment: environment)
      puts "Deployment created!" if deployment.url
		end

		default_task :deploy
	end
end

