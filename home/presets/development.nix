{ config, lib, lib', pkgs, ... }: with lib'; templated.preset "development" {
  inherit config;
  whenEnabled = {
    programs.bat.enable = true;
    programs.bat.extraPackages = with pkgs.bat-extras; [ batdiff batman ];

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    programs.direnv.config.whitelist.prefix =
      [ config.xdg.configHome "${config.home.homeDirectory}/projects" ];

    programs.eza.enable = true;

    programs.git.enable = true;
    programs.git.difftastic.enable = true;
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
    programs.helix.languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = "nixpkgs-fmt";
      }
    ];
    programs.helix.settings = {
      theme = "rpine";
      editor = {
        color-modes = true;
        completion-trigger-len = 1;
        cursorline = true;
        line-number = "relative";
        true-color = true;
        undercurl = true;
      };
      editor.cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      editor.lsp = {
        display-inlay-hints = true;
        display-messages = true;
      };
      keys.normal = { X = "extend_line_above"; };
      keys.select = { X = "extend_line_above"; };
    };
    programs.helix.themes = { empty = { }; };

    programs.ssh.enable = true;
    programs.ssh.extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock 
    '';

    programs.starship.enable = true;

    programs.yazi.enable = true;

    programs.zoxide.enable = true;
    programs.zoxide.options = [ "--cmd" "cd" ];

    services.darkman =
      let
        hxRtThemesDir = "${pkgs.helix}/lib/runtime/themes";
        hxTheme = "${config.xdg.configHome}/helix/themes/rpine.toml";
      in
      {
        darkModeScripts.helix = ''
          /usr/bin/env -S ln -sf "${hxRtThemesDir}/rose_pine_moon.toml" "${hxTheme}"
          /usr/bin/env -S pkill -USR1 hx
        '';
        lightModeScripts.helix = ''
          /usr/bin/env -S ln -sf "${hxRtThemesDir}/rose_pine_dawn.toml" "${hxTheme}"
          /usr/bin/env -S pkill -USR1 hx
        '';
      };

    xdg.userDirs.extraConfig.XDG_PROJECTS_DIR = "$HOME/projects";
  };
}
