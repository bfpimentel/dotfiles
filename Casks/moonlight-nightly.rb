cask "moonlight-nightly" do
  version :latest
  sha256 :no_check

  url "https://github.com/moonlight-stream/moonlight-qt.git",
      branch: "master"
  name "Moonlight Game Streaming (Nightly)"
  desc "GameStream client for PCs"
  homepage "https://moonlight-stream.org/"

  depends_on formula: "qt"
  depends_on formula: "qtvirtualkeyboard"
  depends_on formula: "create-dmg"

  preflight do
    Dir.chdir(staged_path) do
      # 1. Update submodules
      system_command "git",
                     args: ["submodule", "update", "--init", "--recursive"]

      # 2. Patch build script to target only the current architecture
      # The script defaults to a universal build (x86_64 arm64), which fails if dependencies (Qt)
      # are only available for the current architecture (standard Homebrew behavior).
      system_command "/usr/bin/sed",
                     args: ["-i", "", "s/QMAKE_APPLE_DEVICE_ARCHS=\"x86_64 arm64\"/QMAKE_APPLE_DEVICE_ARCHS=\"#{Hardware::CPU.arch}\"/", "scripts/generate-dmg.sh"]

      # 3. Build the application
      # We use the generate-dmg.sh script as it handles the full build process including deployment
      system_command "./scripts/generate-dmg.sh",
                     args: ["Release"],
                     env:  { "PATH" => "#{HOMEBREW_PREFIX}/bin:#{ENV["PATH"]}" }

      # 4. Ad-hoc sign the application to run on Apple Silicon
      # The script skips signing if no identity is provided, so we do it manually here.
      system_command "/usr/bin/codesign",
                     args: ["--force", "--deep", "-s", "-", "build/build-Release/app/Moonlight.app"]
    end
  end

  app "build/build-Release/app/Moonlight.app"
end
