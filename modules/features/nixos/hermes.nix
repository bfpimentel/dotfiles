{ inputs, ... }:

{
  config.bfmp.nixos.hosts.cherubim.modules = [
    inputs.hermes-agent.nixosModules.default
    (
      { config, ... }:
      {
        services.hermes-agent = {
          enable = true;
          # settings.model.default = "openai-codex/claude-sonnet-4";
          environmentFiles = [ config.age.secrets.hermes-agent.path ];
          addToSystemPackages = true;
        };
      }
    )
  ];
}
