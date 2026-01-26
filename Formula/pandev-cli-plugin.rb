=begin

after release just update the versions with the new hashes. To get the new hashes you need to run (don't forget to change the version):
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.6/pandev-cli-plugin_1.0.6_macOS_amd64.tar.gz | shasum -a 256
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.6/pandev-cli-plugin_1.0.6_macOS_arm64.tar.gz | shasum -a 256

!!! YOU HAVE TO CHANGE THE VERSIONS IN 3 LINES !!!
=end

class PandevCliPlugin < Formula
  desc "Pandev CLI Plugin"
  homepage "https://github.com/pandev-metriks/homebrew-pandev-cli"
  version "1.0.6"

  if Hardware::CPU.intel?
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.6/pandev-cli-plugin_1.0.6_macOS_amd64.tar.gz"
    sha256 "a177a15191f4fed903d95e1830896234b1a1cdce45cd438486965072f2cf69fb"
  else
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.6/pandev-cli-plugin_1.0.6_macOS_arm64.tar.gz"
    sha256 "e0a882bb6025c8f283cab4c3bae934df42ef26c6b170a8728c752a709283c678"
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
