{ inputs, ... }:

{
  config.bfmp.nixos.hosts.powers.modules = [
    inputs.hermes-agent.nixosModules.default
    (
      {
        config,
        pkgs,
        ...
      }:
      {
        users.users.bruno.extraGroups = [ "hermes" ];

        services.hermes-agent = {
          enable = true;
          environmentFiles = [ config.age.secrets.hermes-env.path ];
          authFile = config.age.secrets.hermes-auth.path;
          addToSystemPackages = true;
          container = {
            enable = true;
            backend = "podman";
            hostUsers = [ "bruno" ];
          };
          documents = {
            "USER.md" = ./documents/USER.md;
            "SOUL.md" = ./documents/SOUL.md;
          };
          settings = {
            model = {
              base_url = "https://chatgpt.com/backend-api/codex";
              default = "gpt-5.4";
            };
            toolsets = [ "all" ];
            max_turns = 100;
            terminal = {
              backend = "local";
              cwd = ".";
              timeout = 180;
            };
            compression = {
              enabled = true;
              threshold = 0.85;
              summary_model = "gpt-5.4";
            };
            memory = {
              memory_enabled = true;
              user_profile_enabled = true;
            };
            platforms = {
              telegram.enabled = true;
              whatsapp.enabled = true;
            };
            display = {
              compact = false;
              streaming = true;
              platforms = {
                whatsapp.tool_progress = "off";
              };
            };
            agent = {
              max_turns = 60;
              verbose = false;
            };
            whatsapp = {
              unauthorized_dm_behavior = "ignore";
            };
          };
          # mcpServers.filesystem = {
          #   command = "npx";
          #   args = [
          #     "-y"
          #     "@modelcontextprotocol/server-filesystem"
          #     "/data/workspace"
          #   ];
          # };
        };
      }
    )
  ];
}
