=begin

after release just update the versions with the new hashes. To get the new hashes you need to run (don't forget to change the version):
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.4/pandev-cli-plugin_1.0.4_macOS_amd64.tar.gz | shasum -a 256
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.4/pandev-cli-plugin_1.0.4_macOS_arm64.tar.gz | shasum -a 256

!!! YOU HAVE TO CHANGE THE VERSIONS IN 3 LINES !!!
=end

class PandevCliPlugin < Formula
  desc "Pandev CLI Plugin"
  homepage "https://github.com/pandev-metriks/homebrew-pandev-cli"
  version "1.0.4"

  if Hardware::CPU.intel?
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.4/pandev-cli-plugin_1.0.4_macOS_amd64.tar.gz"
    sha256 "253aefa6f6560984e932083e8fb5d6f130b7b2d5ce37cbb70c5332ff529019ba"
  else
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.4/pandev-cli-plugin_1.0.4_macOS_arm64.tar.gz"
    sha256 "40a9e4c33f66241554a176658e819f8e96ad26d3f41b1dca55d2f82e94215576"
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
