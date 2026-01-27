=begin

after release just update the versions with the new hashes. To get the new hashes you need to run (don't forget to change
the version):
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.1.7/pandev-cli-plugin_1.1.7_macOS_amd64.tar.gz | shasum -a 256
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.1.7/pandev-cli-plugin_1.1.7_macOS_arm64.tar.gz | shasum -a 256
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.1.7/pandev-cli-plugin_1.1.7_Linux_amd64.tar.gz | shasum -a 256

!!! YOU HAVE TO CHANGE THE VERSIONS IN 4 LINES !!!
=end

class PandevCliPlugin < Formula
  desc "Pandev CLI Plugin"
  homepage "https://github.com/pandev-metriks/homebrew-pandev-cli"
  version "1.1.7"

  if OS.mac?
  if Hardware::CPU.intel?
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.1.7/pandev-cli-plugin_1.1.7_macOS_amd64.tar.gz"
    sha256 "2da62cafb315418fac1e5979538cc32add265944d92ca1c24c50bb8effc9de10"
  else
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.1.7/pandev-cli-plugin_1.1.7_macOS_arm64.tar.gz"
    sha256 "f89a31cc03a377c227198b89440eeb9ab8ad1e41b904c9782636c2cc0a1634bc"
    end
  elsif OS.linux?
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.1.7/pandev-cli-plugin_1.1.7_Linux_amd64.tar.gz"
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
