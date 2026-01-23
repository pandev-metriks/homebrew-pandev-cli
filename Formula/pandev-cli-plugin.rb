class PandevCliPlugin < Formula
  desc "Pandev CLI Plugin"
  homepage "https://github.com/pandev-metriks/homebrew-pandev-cli"
  version "1.0.0"
  

  if Hardware::CPU.intel?
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.0/pandev-cli-plugin_1.0.0_macOS_amd64.tar.gz"
    sha256 "05909755402ba74e126a603474960a998cb908963badc17cb69f77ce8f35edee"
  else
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.0/pandev-cli-plugin_1.0.0_macOS_arm64.tar.gz"
    sha256 "9f032bdf9813fb48d13cf616641f23704b5c522addf88172e4db6a76e9dc4223"
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