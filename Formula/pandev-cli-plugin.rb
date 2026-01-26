=begin

after release just update the versions with the new hashes. To get the new hashes you need to run (don't forget to change the version):
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.3/pandev-cli-plugin_1.0.3_macOS_amd64.tar.gz | shasum -a 256
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.3/pandev-cli-plugin_1.0.3_macOS_arm64.tar.gz | shasum -a 256

!!! YOU HAVE TO CHANGE THE VERSIONS IN 3 LINES !!!
=end

class PandevCliPlugin < Formula
  desc "Pandev CLI Plugin"
  homepage "https://github.com/pandev-metriks/homebrew-pandev-cli"
  version "1.0.3"

  if Hardware::CPU.intel?
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.3/pandev-cli-plugin_1.0.3_macOS_amd64.tar.gz"
    sha256 "6b9a41800fb38bef364abf5d81e1c972677c7a01ea1a05d3aa78cffbc8bf9844"
  else
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.3/pandev-cli-plugin_1.0.3_macOS_arm64.tar.gz"
    sha256 "c53af0c89a59f009af6e0dd340c3721c624e9098a62511178e01732c0a3b3165"
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
