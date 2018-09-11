require 'thor'
require 'ghdeploy'

module Ghdeploy
	class CLI < Thor

		desc 'deploy', 'Creates a GitHub deployment.'
		def deploy
			puts 'test deploy'
		end
	end
end
