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
  version "2.1.1.1"

  depends_on "jq"
  depends_on "git"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v#{version}/pandev-cli-plugin_#{version}_macOS_amd64.tar.gz"
      sha256 "f15131fb86cc8304ea91ed6a93e3e60237b55f8494a3ea2f38087b5ade72a54c"
    else
      url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v#{version}/pandev-cli-plugin_#{version}_macOS_arm64.tar.gz"
      sha256 "10b46e504e263db421da0f2eb26811e9bc7d5fc0058d6fe6177a040caeae8812"
    end
  end

  on_linux do
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v#{version}/pandev-cli-plugin_#{version}_Linux_amd64.tar.gz"
    sha256 "290755dcf6d579448ecad3645b5da1a05688c864c34fe00330361145b23e0afd"
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