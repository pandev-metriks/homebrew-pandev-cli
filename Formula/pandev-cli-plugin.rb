class PandevCliPlugin < Formula
  desc "Pandev CLI Plugin"
  homepage "https://github.com/pandev-metriks/homebrew-pandev-cli"
  version "1.0.2"
  

  if Hardware::CPU.intel?
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.2/pandev-cli-plugin_1.0.2_macOS_amd64.tar.gz"
    sha256 "98a9d1812c5811d23fb2954193f3df833636b8ae30c21665eb8b097bd57614b2"
  else
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.0.2/pandev-cli-plugin_1.0.2_macOS_arm64.tar.gz"
    sha256 "1d735fd5f896f128807840ed8f062e40db6e1bcad2807951f77ef831751c8d08"
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

