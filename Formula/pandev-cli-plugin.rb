=begin

after release just update the versions with the new hashes. To get the new hashes you need to run (don't forget to change the version):
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.8/pandev-cli-plugin_1.0.8_macOS_amd64.tar.gz | shasum -a 256
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.8/pandev-cli-plugin_1.0.8_macOS_arm64.tar.gz | shasum -a 256

!!! YOU HAVE TO CHANGE THE VERSIONS IN 3 LINES !!!
=end

class PandevCliPlugin < Formula
  desc "Pandev CLI Plugin"
  homepage "https://github.com/pandev-metriks/homebrew-pandev-cli"
  version "1.0.8"

  if Hardware::CPU.intel?
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.8/pandev-cli-plugin_1.0.8_macOS_amd64.tar.gz"
    sha256 "6e602962a4656c593110880c91c4ddf02c69c942b96b3e3b17361c5207264b44"
  else
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.8/pandev-cli-plugin_1.0.8_macOS_arm64.tar.gz"
    sha256 "d3179858e4989a059ad462f20e5ef45148705a42bc9f96fd8ff50b5214bcf3b5"
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
