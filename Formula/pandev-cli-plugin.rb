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
    sha256 "bfdcaa305e718765401729bd71f59096aa4718e618e80fa0bc21a6eccf16e492"
  else
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.5/pandev-cli-plugin_1.0.5_macOS_arm64.tar.gz"
    sha256 "5e2efe4d34ead45511fa9afc2ff7a5d5764cc116434f453003a318d5a7d194c3"
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
