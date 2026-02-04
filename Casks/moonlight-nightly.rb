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
      # 1. Update submodules
      system_command "git",
                     args: ["submodule", "update", "--init", "--recursive"]

      # 2. Build the application
      # We use the generate-dmg.sh script as it handles the full build process including deployment
      system_command "./scripts/generate-dmg.sh",
                     args: ["Release"],
                     env:  { "PATH" => "#{HOMEBREW_PREFIX}/bin:#{ENV["PATH"]}" }

      # 3. Ad-hoc sign the application to run on Apple Silicon
      # The script skips signing if no identity is provided, so we do it manually here.
      system_command "/usr/bin/codesign",
                     args: ["--force", "--deep", "-s", "-", "build/build-Release/app/Moonlight.app"]
    end
  end

  app "build/build-Release/app/Moonlight.app"
end
