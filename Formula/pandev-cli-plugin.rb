# Formula: pandev-cli-plugin.rb
=begin
After release, update the version and hashes. To get the new hashes run:

after release just update the versions with the new hashes. To get the new hashes you need to run (don't forget to change
the version):
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v2.0.0/pandev-cli-plugin_2.0.0_macOS_amd64.tar.gz | shasum -a 256
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v2.0.0/pandev-cli-plugin_2.0.0_macOS_arm64.tar.gz | shasum -a 256
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v2.0.0/pandev-cli-plugin_2.0.0_Linux_amd64.tar.gz | shasum -a 256
!!! YOU HAVE TO CHANGE THE VERSIONS IN 4 LINES !!!
=end

class PandevCliPlugin < Formula
  desc "Pandev CLI Plugin"
  homepage "https://github.com/pandev-metriks/homebrew-pandev-cli"
  version "2.1.1"

  depends_on "jq"
  depends_on "git"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v#{version}/pandev-cli-plugin_#{version}_macOS_amd64.tar.gz"
      sha256 "1b57541a55bb6d1f9841534eea7ede8324364725169e34b0357e29565cff02a1"
    else
      url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v#{version}/pandev-cli-plugin_#{version}_macOS_arm64.tar.gz"
      sha256 "09e15927d783aec277e33629e3a032dcd0c9f18799f805f8ae97297e6f1ed693"
    end
  end

  on_linux do
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v#{version}/pandev-cli-plugin_#{version}_Linux_amd64.tar.gz"
    sha256 "abcf975cfe8bd21a3128d12f321168484e9649e2fb304cb8a2867d17d125658e"
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/pandev"
    bin.install_symlink libexec/"bin/pandev-cli-plugin"
  end

  def post_install
    # Create UPDATE_AVAILABLE marker to signal watcher.sh to update
    touch libexec/"UPDATE_AVAILABLE"
  end

  test do
    assert_match "version", shell_output("#{bin}/pandev status")
  end
end