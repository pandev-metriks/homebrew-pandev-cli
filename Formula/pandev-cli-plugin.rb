=begin

after release just update the versions with the new hashes. To get the new hashes you need to run (don't forget to change the version):
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.5/pandev-cli-plugin_1.0.5_macOS_amd64.tar.gz | shasum -a 256
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.5/pandev-cli-plugin_1.0.5_macOS_arm64.tar.gz | shasum -a 256

!!! YOU HAVE TO CHANGE THE VERSIONS IN 3 LINES !!!
=end

class PandevCliPlugin < Formula
  desc "Pandev CLI Plugin"
  homepage "https://github.com/pandev-metriks/homebrew-pandev-cli"
  version "1.0.5"

  if Hardware::CPU.intel?
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.5/pandev-cli-plugin_1.0.5_macOS_amd64.tar.gz"
    sha256 "dcd10f4215e326679a129bf48be989de6318c15a22d71db4a134cceead736c02"
  else
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.5/pandev-cli-plugin_1.0.5_macOS_arm64.tar.gz"
    sha256 "77201134037c0affa09c809748c5e400dbeeac8e3072daacd7c6e77cbd18f660"
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
