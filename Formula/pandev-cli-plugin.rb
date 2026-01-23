class PandevCliPlugin < Formula
  desc "Pandev CLI Plugin"
  homepage "https://github.com/pandev-metriks/homebrew-pandev-cli"
  version "1.0.0"
  

  if Hardware::CPU.intel?
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.0/pandev-cli-plugin_1.0.0_macOS_amd64.tar.gz"
    sha256 "e4f9a30bf4f39e2469d6eee4571cfc349e06e8f268482f4944421f4abcfe9cbe"
  else
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.0/pandev-cli-plugin_1.0.0_macOS_arm64.tar.gz"
    sha256 "ff4d514ef960750ef4329a372c2d86d8d7ccff85d14dbdec961343597e32f1a5"
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