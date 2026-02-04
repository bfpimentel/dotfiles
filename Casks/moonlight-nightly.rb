cask "moonlight-nightly" do
  version :latest
  sha256 :no_check

  url "https://github.com/moonlight-stream/moonlight-qt.git",
      branch: "master"
  name "Moonlight Game Streaming (Nightly)"
  desc "GameStream client for PCs"
  homepage "https://moonlight-stream.org/"

  depends_on formula: "qt"
  depends_on formula: "create-dmg"

  preflight do
    Dir.chdir(staged_path) do
      system_command "git",
                     args: ["submodule", "update", "--init", "--recursive"]

      system_command "/usr/bin/sed",
                     args: ["-i", "", "s/QMAKE_APPLE_DEVICE_ARCHS=\"x86_64 arm64\"/QMAKE_APPLE_DEVICE_ARCHS=\"#{Hardware::CPU.arch}\"/", "scripts/generate-dmg.sh"]

      system_command "./scripts/generate-dmg.sh",
                     args: ["Release"],
                     env:  { "PATH" => "#{HOMEBREW_PREFIX}/bin:#{ENV["PATH"]}" }

      system_command "/usr/bin/codesign",
                     args: ["--force", "--deep", "-s", "-", "build/build-Release/app/Moonlight.app"]
    end
  end

  app "build/build-Release/app/Moonlight.app"
end
