{ pkgs, ... }:
  username: {
    config,
    extraConfig ? {},
    shell ? pkgs.fish,
    signingKey,
  }: let homeDirectory = "/home/${username}"; in pkgs.lib.mkMerge [
    {
      home-manager = {
        users.${username} = {
          imports = [
            ../presets/home
          ];

          home = {
            inherit username homeDirectory;
            inherit (config.system) stateVersion;
          };

          presets.home.base.enable = true;

          programs = {
            direnv.config.whitelist.prefix = [ "${homeDirectory}/projects" ];
            git.extraConfig.user.signingKey = signingKey;
          };
        };
      };

      programs = {
        _1password-gui.polkitPolicyOwners = [ username ];
      };

      users.users.${username} = {
        extraGroups = [ "networkmanager" "wheel" ];
        initialPassword = "initPass";
        isNormalUser = true;
        shell = shell;
      };
    }
    extraConfig
  ]
