require 'securerandom'

RSpec.describe RepoFactFinder do
  let(:remote_name) { 'origin' }
  let(:remote_url) { 'git@github.com:sonerdy/fake-repo.git' }
  let(:other_remote_url) { 'git@github.com:sonerdy/other-repo.git' }
  let(:remotes) do
    [
      instance_double(Git::Remote, name: 'origin', url: remote_url),
      instance_double(Git::Remote, name: 'other', url: other_remote_url)
    ]
  end
  let(:stub_git) do
    instance_double(Git::Base, remotes: remotes)
  end

  before do
    allow(Git).to receive(:open).with('./').and_return(stub_git)
  end

  describe '#api_endpoint' do
    subject(:api_endpoint) { described_class.new(remote_name).api_endpoint }

    specify { expect(api_endpoint).to eq 'https://api.github.com' }

    context 'when the url is https' do
      let(:remote_url) { 'https://github.com/sonerdy/fake-repo.git' }

      specify { expect(api_endpoint).to eq 'https://api.github.com' }
    end

    context 'when a non-github domain is used' do
      let(:remote_url) { 'git@my-enterprise-git.com:sonerdy/fake-repo' }

      specify { expect(api_endpoint).to eq 'https://my-enterprise-git.com/api/v3/' }
    end

    context 'when non-origin remote is used' do
      let(:remote_name) { 'other' }
      let(:other_remote_url) { 'git@other-github.com:sonerdy/other-repo' }

      specify { expect(api_endpoint).to eq('https://other-github.com/api/v3/') }
    end
  end

  describe '#repo' do
    subject(:repo) { described_class.new(remote_name).repo }

    specify { expect(repo).to eq 'sonerdy/fake-repo' }

    context 'when remote is https' do
      let(:remote_url) { 'https://github.com/sonerdy/fake-repo.git' }

      specify { expect(repo).to eq 'sonerdy/fake-repo' }
    end
  end

  describe '#token' do
    subject(:token) { described_class.new(remote_name).token }

    let(:access_token) { SecureRandom.uuid }

    context 'when remote is github.com' do
      let(:remote_url) { 'git@github.com:sonerdy/fake-repo' }

      before do
        allow(ENV).to receive(:fetch).with('GHDEPLOY_TOKEN').and_return(access_token)
      end

      it 'uses token from GHDEPLOY_TOKEN environment variable' do
        expect(token).to eq access_token
      end
    end

    context 'when remote is not github.com' do
      let(:remote_url) { 'git@internal-github.com:sonerdy/fake-repo' }

      before do
        allow(ENV).to receive(:fetch)
          .with('GHDEPLOY_INTERNAL_GITHUB_COM_TOKEN').and_return(access_token)
      end

      it 'uses token from host-specific environment variable' do
        expect(token).to eq access_token
      end
    end
  end
end
