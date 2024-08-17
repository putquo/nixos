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
      bat.enable = true;
      bat.extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
      ];

      carapace.enable = true;
      carapace.enableFishIntegration = false;
      carapace.enableZshIntegration = false;

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
      helix.settings.theme = "tokyonight_storm";

      nushell.enable = true;
      nushell.extraConfig = ''
        let carapace_completer = {|spans|
          carapace $spans.0 nushell ...$spans
          | from json
          | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
        }

        let zoxide_completer = {|spans|
          $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
        }

        let external_completer = {|spans|
          let expanded_alias = scope aliases
          | where name == $spans.0
          | get -i 0.expansion

          let spans = if $expanded_alias != null {
            $spans
            | skip 1
            | prepend ($expanded_alias | split row ' ' | take 1)
          } else {
            $spans
          }

          match $spans.0 {
            __zoxide_z | __zoxide_zi => $zoxide_completer
            _                        => $carapace_completer
          } | do $in $spans
        }

        $env.config = {
          completions: {
            external: {
              enable: true
              completer: $external_completer
            }
          }
          edit_mode: vi
          show_banner: false
        }

        $env.PROMPT_INDICATOR = ""
        $env.PROMPT_INDICATOR_VI_INSERT = {|| [(ansi green) (char newline) "❯" (char space) (ansi reset)] | str join }
        $env.PROMPT_INDICATOR_VI_NORMAL = {|| [(ansi green) (char newline) "❮" (char space) (ansi reset)] | str join }
      '';

      ssh.enable = true;
      ssh.extraConfig = "IdentityAgent ~/.1password/agent.sock";

      starship.enable = true;
      starship.enableFishIntegration = false;
      starship.enableIonIntegration = false;
      starship.enableZshIntegration = false;
      starship.settings = {
        add_newline = true;

        character = {
          disabled = true;
        };

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
      zoxide.enableFishIntegration = false;
      zoxide.enableZshIntegration = false;
      zoxide.options = [ "--cmd" "cd" ];
    };
  };
}
