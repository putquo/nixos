{ config, lib, pkgs, ... }: {
  options = {
    presets.home.development.enable = lib.mkEnableOption {
      default = false;
      description = "Enable development home preset";
    };
  };

  config = lib.mkIf config.presets.home.development.enable {
    programs = {
      bat.enable = true;
      bat.extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
      ];

      direnv.enable = true;
      direnv.nix-direnv.enable = true;
      direnv.config.whitelist.prefix = [ "${config.home.homeDirectory}/projects" ];

      eza.enable = true;
      eza.enableAliases = true;

      git.enable = true;
      git.extraConfig = {
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg.ssh.program = "${pkgs._1password-gui}/bin/op-ssh-sign";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
      git.userEmail = lib.mkDefault "jan.justin.vtonder@gmail.com";
      git.userName = "Jan-Justin van Tonder";
      
      helix.enable = true;
      helix.defaultEditor = true;

      ssh.enable = true;
      ssh.extraConfig = ''
        Host *
          IdentityAgent ~/.1password/agent.sock 
      '';

      starship.enable = true;
      wezterm.enable = true;
      zoxide.enable = true;
    }; 

    xdg.userDirs.extraConfig.XDG_PROJECTS_DIR = "$HOME/projects";
  };
}
