=begin

after release just update the versions with the new hashes. To get the new hashes you need to run (don't forget to change the version):
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.7/pandev-cli-plugin_1.0.7_macOS_amd64.tar.gz | shasum -a 256
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.7/pandev-cli-plugin_1.0.7_macOS_arm64.tar.gz | shasum -a 256

!!! YOU HAVE TO CHANGE THE VERSIONS IN 3 LINES !!!
=end

class PandevCliPlugin < Formula
  desc "Pandev CLI Plugin"
  homepage "https://github.com/pandev-metriks/homebrew-pandev-cli"
  version "1.0.6"

  if Hardware::CPU.intel?
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.7/pandev-cli-plugin_1.0.7_macOS_amd64.tar.gz"
    sha256 "98a49b6d6cf50b2a7f63362078414f917c49b32dc1bda1c970e4e35fc8a00949"
  else
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.7/pandev-cli-plugin_1.0.7_macOS_arm64.tar.gz"
    sha256 "73645c79833e378fd47bb347ccb232e170ead951f3d7d7af09257199cd6a504e"
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
