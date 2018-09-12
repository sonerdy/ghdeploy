RSpec.describe RepoFactFinder do
  let(:remote_name) { 'origin' }
  let(:remote_url) { 'git@github.com:sonerdy/fake-repo.git' }
  let(:other_remote_url) { 'git@github.com:sonerdy/other-repo.git' }
  let(:remotes) do
    [
      double(name: 'origin', url: remote_url),
      double(name: 'other', url: other_remote_url),
    ]
  end
  let(:stub_git) do
    double(remotes: remotes)
  end

  before do
    allow(Git).to receive(:open).with('./').and_return(stub_git)
  end

  describe '#host' do
    subject { described_class.new(remote_name).host }

    specify { expect(subject).to eq 'https://api.github.com' }

    context 'when the url is https' do
      let(:remote_url) { 'https://github.com/sonerdy/fake-repo.git' }

      specify { expect(subject).to eq 'https://api.github.com' }
    end

    context 'when a non-github domain is used' do
      let(:remote_url) { 'git@my-enterprise-git.com:sonerdy/fake-repo' }
      specify { expect(subject).to eq 'https://api.my-enterprise-git.com' }
    end

    context 'when non-origin remote is used' do
      let(:remote_name) { 'other' }
      let(:other_remote_url) { 'git@other-github.com:sonerdy/other-repo' }

      specify { expect(subject).to eq('https://api.other-github.com') }
    end
  end

  describe '#repo' do
    subject { described_class.new(remote_name).repo }

    specify { expect(subject).to eq 'sonerdy/fake-repo' }

    context 'when remote is https' do
      let(:remote_url) { 'https://github.com/sonerdy/fake-repo.git' }
      specify { expect(subject).to eq 'sonerdy/fake-repo' }
    end
  end
end
