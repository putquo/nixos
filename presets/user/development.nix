{ config, lib, osConfig, pkgs, ... }: with lib; let
  wsl = osConfig.wsl.enable;
in
{
  options = {
    presets.user.development.enable = mkEnableOption "the development user preset";
  };

  config = mkIf config.presets.user.development.enable {
    home.packages = with pkgs; [
      bash-language-server
      dockerfile-language-server-nodejs
      docker-compose-language-service
      marksman
      nodePackages.vscode-json-languageserver
      shell-gpt
      taplo
      yaml-language-server
    ];

    programs = {
      alacritty.enable = true;
      alacritty.settings = {
        window.decorations = "None";
        window.padding.x = 10;

        colors = {
          primary.background = "#222436";
          primary.foreground = "#c8d3f5";

          normal.black = "#1bd12b";
          normal.red = "#ff757f";
          normal.green = "#c3e88d";
          normal.yellow = "#ffc777";
          normal.blue = "#82aaff";
          normal.magenta = "#c099ff";
          normal.cyan = "#86e1fc";
          normal.white = "#828bb8";

          bright.black = "#444a73";
          bright.red = "#ff757f";
          bright.green = "#c3e88d";
          bright.yellow = "#ffc777";
          bright.blue = "#82aaff";
          bright.magenta = "#c099ff";
          bright.cyan = "#86e1fc";
          bright.white = "#c8d3f5";

          indexed_colors = [
            { index = 16; color = "#ff966c"; }
            { index = 17; color = "#c53b53"; }
          ];
        };
      };

      bat.enable = true;

      btop.enable = true;

      direnv.enable = true;
      direnv.config.whitelist.prefix = [ "${config.home.homeDirectory}/workspace" "${config.xdg.configHome}/nixconf" ];
      direnv.config.hide_env_diff = true;
      direnv.nix-direnv.enable = true;

      fish.enable = true;
      fish.shellAliases = {
        docker = mkIf wsl "/run/current-system/sw/bin/docker";
        g = "git";
        ".." = "cd ../..";
      };
      fish.shellAbbrs = {
        # Git
        # add
        ga = "git add";
        gaa = "git add --all";
        # branch
        gb = "git branch";
        gba = "git branch --all";
        gbd = "git branch --delete";
        gbds = "delete_squashed_branches";
        gbD = "git branch --delete --force";
        gbm = "git branch --move";
        # checkout
        gco = "git checkout";
        gcb = "git checkout -b";
        # commit
        gc = "git commit";
        "gc!" = "git commit --amend";
        gcm = "git commit -m";
        "gcn!" = "git commit --amend --no-edit";
        # fetch
        gf = "git fetch";
        # pull
        gpl = "git pull";
        gpr = "git pull --rebase";
        # push
        gp = "git push";
        gpf = "git push --force-with-lease --force-if-includes";
        # rebase
        grb = "git rebase";
        grba = "git rebase --abort";
        grbc = "git rebase --continue";
        grbs = "git rebase --skip";
        # restore
        grs = "git restore";
        grst = "git restore --staged";
        # status
        gst = "git status";
      };

      gh.enable = true;

      gh-dash.enable = true;

      git.enable = true;
      git.extraConfig = {
        commit.gpgsign = true;
        core.sshCommand = mkIf wsl "ssh.exe";
        gpg.format = "ssh";
        gpg.ssh.program = mkDefault "${pkgs._1password-gui}/bin/op-ssh-sign";
        init.defaultBranch = "main";
        pull.rebase = true;
      };
      git.userName = "Preston van Tonder";

      helix.enable = true;
      helix.defaultEditor = true;
      helix.settings.editor = {
        color-modes = true;
        line-number = "relative";
        true-color = true;
        undercurl = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };
      };
      helix.settings.keys = {
        normal = { X = "extend_line_above"; };
        select = { X = "extend_line_above"; };
      };
      helix.settings.theme = "tokyonight_moon";

      ssh.enable = true;
      ssh.extraConfig = "IdentityAgent ~/.1password/agent.sock";

      starship.enable = true;
      starship.enableIonIntegration = false;
      starship.enableNushellIntegration = false;
      starship.enableZshIntegration = false;
      starship.settings = {
        add_newline = true;

        nix_shell = {
          format = "via [$symbol $name]($style) ";
          symbol = "󱄅";
        };

        username = {
          disabled = false;
          show_always = true;
          style_user = "white bold";
        };
      };

      vim.enable = true;

      zoxide.enable = true;
      zoxide.enableNushellIntegration = false;
      zoxide.enableZshIntegration = false;
      zoxide.options = [ "--cmd" "cd" ];
    };
  };
}
