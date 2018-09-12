require 'git'

# Figures out an API host to use based on the remote for the Git repository
class RepoFactFinder
  URL_PATTERN = /^((http[s]?|ftp):\/)?\/?([^:\/\s]+)((\/\w+)*\/)([\w\-\.]+[^#?\s]+)(.*)?(#[\w\-]+)?/

  def initialize(remote_name)
    @remote_name = remote_name
  end

  attr_reader :remote_name

  def host
    return @host if @host
    url = remote.url
    if url.start_with?('http')
      matches = URL_PATTERN.match(url)
      @host = "#{matches[2]}://api.#{matches[3]}"
    else
      host = url.split('@').last.split(':').first
      @host = "https://api.#{host}"
    end
  end

  def repo
    return @repo if @repo
    repo = url.split(/\/|:/).last(2).join('/')
    @repo = repo.gsub(/(\.git)$/, '')
  end

  private

  def url
    remote.url
  end

  def remote
    @remote ||= Git.open('./').remotes.find { |r| r.name == remote_name }
  end
end
