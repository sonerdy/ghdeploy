RSpec.describe Ghdeploy::CLI do
  describe '#deploy' do
    subject(:deploy) { described_class.new.deploy(environment, branch) }

    before do
      allow(RepoFactFinder).to receive(:new).with(remote_name).and_return(repo_fact_stub)
      allow(Octokit::Client).to receive(:new)
        .with(access_token: access_token).and_return(stub_client)
      allow(stub_client).to receive(:create_deployment)
        .with('sonerdy/fake-repo', branch, environment: 'production')
        .and_return(stub_deployment)
    end

    let(:remote_name) { 'origin' }
    let(:branch) { 'master' }
    let(:stub_client) { instance_double(Octokit::Client) }
    let(:repo_fact_stub) do
      instance_double(
        RepoFactFinder,
        api_endpoint: github_host,
        repo: 'sonerdy/fake-repo',
        token: access_token
      )
    end
    let(:github_host) { 'https://api.github.com' }
    let(:access_token) { 'random-token' }
    let(:environment) { 'production' }
    let(:stub_deployment) do
      # rubocop:disable Rspec/VerifiedDoubles
      # The deployment object has methods defined dynamically so we avoid instance_double
      double(url: 'stub-url')
      # rubocop:enable Rspec/VerifiedDoubles
    end

    it 'creates a deployment' do
      deploy
      expect(stub_client).to have_received(:create_deployment)
        .with('sonerdy/fake-repo', branch, environment: 'production')
    end
  end
end
