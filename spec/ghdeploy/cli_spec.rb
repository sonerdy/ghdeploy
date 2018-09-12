RSpec.describe Ghdeploy::CLI do
  describe '#deploy' do
    subject { described_class.new.deploy(environment, branch) }

    before do
      allow(RepoFactFinder).to receive(:new).with(remote_name).and_return(repo_fact_stub)
      allow(Octokit::Client).to receive(:new).with(access_token: access_token).and_return(stub_client)
      allow(ENV).to receive(:fetch).with('GHDEPLOY_TOKEN').and_return(access_token)
    end

    let(:remote_name) { 'origin' }
    let(:branch) { 'master' }
    let(:stub_client) { double }
    let(:repo_fact_stub) { double(host: 'https://api.github.com', repo: 'sonerdy/fake-repo') }
    let(:access_token) { 'random-token' }
    let(:environment) { 'production' }

    it 'creates a deployment' do
      expect(stub_client).to receive(:create_deployment)
        .with('sonerdy/fake-repo', branch, environment: 'production')
        .and_return(double(url: 'stub-url'))
      subject
    end
  end
end
