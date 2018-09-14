require 'git'

class RepoFactFinder
  URL_PATTERN = /^((http[s]?|ftp):\/)?\/?([^:\/\s]+)((\/\w+)*\/)([\w\-\.]+[^#?\s]+)(.*)?(#[\w\-]+)?/

  def initialize(remote_name)
    @remote_name = remote_name
  end

  attr_reader :remote_name

  def api_endpoint
    return @api_endpoint if @api_endpoint
    url = remote.url
    if url.start_with?('http')
      matches = URL_PATTERN.match(url)
      @api_endpoint = "#{matches[2]}://api.#{matches[3]}"
    else
      host = url.split('@').last.split(':').first
      @api_endpoint = "https://api.#{host}"
    end
    @api_endpoint = fix_enterprise_api_endpoint(@api_endpoint)
  end

  def repo
    return @repo if @repo
    repo = url.split(/\/|:/).last(2).join('/')
    @repo = repo.gsub(/(\.git)$/, '')
  end

  def token
    github_host = api_endpoint.gsub(/^http[s]?:\/\//, '')
    if github_host == 'api.github.com'
      ENV.fetch('GHDEPLOY_TOKEN')
    else
      key = github_host.gsub(/[\.\-]/, '_').upcase.gsub(/\/API\/V3\//, '')
      ENV.fetch("GHDEPLOY_#{key}_TOKEN")
    end
  end

  private

  def url
    remote.url
  end

  def remote
    @remote ||= Git.open('./').remotes.find { |r| r.name == remote_name }
  end

  def fix_enterprise_api_endpoint(host)
    return host if host == 'https://api.github.com'
    enterprise_domain = host.gsub(/^http[s]?:\/\/api\./, '')
    "https://#{enterprise_domain}/api/v3/"
  end
end
