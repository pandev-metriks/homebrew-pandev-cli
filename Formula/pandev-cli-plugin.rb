# Formula: pandev-cli-plugin.rb
=begin
After release, update the version and hashes. To get the new hashes run:

after release just update the versions with the new hashes. To get the new hashes you need to run (don't forget to change
the version):
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.2.5/pandev-cli-plugin_1.2.5_macOS_amd64.tar.gz | shasum -a 256
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.2.5/pandev-cli-plugin_1.2.5_macOS_arm64.tar.gz | shasum -a 256
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.2.5/pandev-cli-plugin_1.2.5_Linux_amd64.tar.gz | shasum -a 256
!!! YOU HAVE TO CHANGE THE VERSIONS IN 4 LINES !!!
=end

class PandevCliPlugin < Formula
  desc "Pandev CLI Plugin"
  homepage "https://github.com/pandev-metriks/homebrew-pandev-cli"
  version "1.2.5"

  depends_on "jq"
  depends_on "git"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v#{version}/pandev-cli-plugin_#{version}_macOS_amd64.tar.gz"
      sha256 "9c3e8990dc93e28f418bad97e266bfddc39d352b0364778acb0a21bc61b32e85"
    else
      url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v#{version}/pandev-cli-plugin_#{version}_macOS_arm64.tar.gz"
      sha256 "316f3052d377a685fe774f649ce528b50f1236d6215911875976775dce4c4eb5"
    end
  end

  on_linux do
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v#{version}/pandev-cli-plugin_#{version}_Linux_amd64.tar.gz"
    sha256 "2dcf993fe7e348ab9b50c38468ffd36a600841ef29289975144fa237d470e247"
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