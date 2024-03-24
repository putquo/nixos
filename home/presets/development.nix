{ config, lib, lib', pkgs, ... }: with lib'; templated.preset "development" {
  inherit config;
  whenEnabled = {
    programs.bat.enable = true;
    programs.bat.extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
    ];

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    programs.direnv.config.whitelist.prefix = [ 
      config.xdg.configHome
      "${config.home.homeDirectory}/projects"
    ];

    programs.eza.enable = true;

    programs.git.enable = true;
    programs.git.extraConfig = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      gpg.ssh.program = "${pkgs._1password-gui}/bin/op-ssh-sign";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
    programs.git.userEmail = lib.mkDefault "jan.justin.vtonder@gmail.com";
    programs.git.userName = "Jan-Justin van Tonder";
    
    programs.helix.enable = true;
    programs.helix.defaultEditor = true;

    programs.ssh.enable = true;
    programs.ssh.extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock 
    '';

    programs.starship.enable = true;

    programs.zoxide.enable = true;
    programs.zoxide.options = [ "--cmd" "cd" ];

    xdg.userDirs.extraConfig.XDG_PROJECTS_DIR = "$HOME/projects";
  };
}
