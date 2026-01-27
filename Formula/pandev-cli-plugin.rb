=begin

after release just update the versions with the new hashes. To get the new hashes you need to run (don't forget to change
the version):
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.1.6/pandev-cli-plugin_1.1.6_macOS_amd64.tar.gz | shasum -a 256
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.1.6/pandev-cli-plugin_1.1.6_macOS_arm64.tar.gz | shasum -a 256
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.1.6/pandev-cli-plugin_1.1.6_Linux_amd64.tar.gz | shasum -a 256

!!! YOU HAVE TO CHANGE THE VERSIONS IN 4 LINES !!!
=end

class PandevCliPlugin < Formula
  desc "Pandev CLI Plugin"
  homepage "https://github.com/pandev-metriks/homebrew-pandev-cli"
  version "1.1.6"

  if OS.mac?
  if Hardware::CPU.intel?
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.1.6/pandev-cli-plugin_1.1.6_macOS_amd64.tar.gz"
    sha256 "b63dc662dedfdc08cdeb469b14c7bb4d9589ed545e3e85e01b9ff1e80bf31a31"
  else
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.1.6/pandev-cli-plugin_1.1.6_macOS_arm64.tar.gz"
    sha256 "224907b41b31570e434404c3346e579a188ef1ceaee6046d3d43228b66ef2c8b"
    end
  elsif OS.linux?
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.1.6/pandev-cli-plugin_1.1.6_Linux_amd64.tar.gz"
    sha256 "LINUX_HASH_HERE"
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/pandev"
    bin.install_symlink libexec/"bin/pandev-cli-plugin"
  end

  def post_install
    system bin/"pandev-cli-plugin", "--install"
  end

  def uninstall
    system bin/"pandev-cli-plugin", "--uninstall"
  end

  test do
    assert_match "version", shell_output("#{bin}/pandev status")
  end
end
