=begin
After release, update the version and hashes. To get the new hashes run:

after release just update the versions with the new hashes. To get the new hashes you need to run (don't forget to change
the version):
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.1.8/pandev-cli-plugin_1.1.8_macOS_amd64.tar.gz | shasum -a 256
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.1.8/pandev-cli-plugin_1.1.8_macOS_arm64.tar.gz | shasum -a 256
curl -sL https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v1.1.8/pandev-cli-plugin_1.1.8_Linux_amd64.tar.gz | shasum -a 256

!!! YOU HAVE TO CHANGE THE VERSIONS IN 4 LINES !!!
=end

class PandevCliPlugin < Formula
  desc "Pandev CLI Plugin"
  homepage "https://github.com/pandev-metriks/homebrew-pandev-cli"
  version "1.1.8"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v#{version}/pandev-cli-plugin_#{version}_macOS_amd64.tar.gz"
      sha256 "aab3ed512ed727eaf9a1466e3b1cbb90ab57b1837a3600c42817271f87859164"
    else
      url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v#{version}/pandev-cli-plugin_#{version}_macOS_arm64.tar.gz"
      sha256 "76e623bd08a4fbedc8c73695cd65a0985b2b371d1e408d2905b30bc1c5314803"
    end
  end

  on_linux do
    url "https://github.com/pandev-metriks/homebrew-pandev-cli/releases/download/v#{version}/pandev-cli-plugin_#{version}_Linux_amd64.tar.gz"
    sha256 "8e180ad6438e2b66382a3ed0c3d9a6b2bf3bdaf88474b5f9e1738dce9006c267"
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/pandev"
    bin.install_symlink libexec/"bin/pandev-cli-plugin"

    # On Linux, create symlinks in /usr/local/bin so sudo can find the commands
    if OS.linux?
      begin
        FileUtils.mkdir_p("/usr/local/bin")
        FileUtils.ln_sf("#{bin}/pandev", "/usr/local/bin/pandev")
        FileUtils.ln_sf("#{bin}/pandev-cli-plugin", "/usr/local/bin/pandev-cli-plugin")
      rescue Errno::EACCES
        opoo "Could not create symlinks in /usr/local/bin. You may need to run:"
        opoo "  sudo ln -sf #{bin}/pandev-cli-plugin /usr/local/bin/pandev-cli-plugin"
      end
    end
  end

  def caveats
    if OS.linux?
      <<~EOS
        To complete installation, run:
          sudo $(which pandev-cli-plugin) --install

        After installation, you can use 'sudo pandev' directly.

        To uninstall, run before `brew uninstall`:
          sudo pandev-cli-plugin --uninstall
      EOS
    else
      <<~EOS
        To complete installation, run:
          sudo pandev-cli-plugin --install

        To uninstall, run before `brew uninstall`:
          sudo pandev-cli-plugin --uninstall
      EOS
    end
  end

  test do
    assert_match "version", shell_output("#{bin}/pandev status")
  end
end
