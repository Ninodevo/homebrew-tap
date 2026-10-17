class Aitext < Formula
  desc "AI text transforms on a keyboard shortcut, anywhere in macOS"
  homepage "https://github.com/Ninodevo/aitext"
  url "https://github.com/Ninodevo/aitext/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "8c31e4d8fee824501e8091910252aa23b9a2c28860ac186783aae97fd0c9c633"
  license "MIT"

  depends_on "jq"
  depends_on :macos

  def install
    libexec.install Dir["*"]
    # The self-contained installer writes into the user's HOME (Quick Actions,
    # prompts, shortcuts), which is a runtime action, not an install action —
    # so brew installs a setup command rather than running it.
    (bin/"aitext-setup").write <<~SCRIPT
      #!/bin/bash
      exec "#{libexec}/install.sh" "$@"
    SCRIPT
  end

  def caveats
    <<~EOS
      To install the hotkeys, prompts and commands into your account, run:

        aitext-setup

      Everything it creates is removed with:

        aitext-setup --uninstall
    EOS
  end

  test do
    system "bash", "-n", libexec/"install.sh"
    assert_match "aitext", shell_output("bash #{libexec}/install.sh --help")
  end
end
