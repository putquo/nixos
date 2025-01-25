{ ... }@_haumeaArgs:
{ config, lib, pkgs, ... }@_hmModuleArgs: {
  programs.bat.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.config.hide_env_diff = true;
  programs.direnv.config.whitelist.prefix =
    [ config.xdg.configHome "${config.home.homeDirectory}/projects" ];

  programs.eza.enable = true;

  programs.fish.shellAbbrs.ga = "git add";
  programs.fish.shellAbbrs.gaa = "git add -A";
  programs.fish.shellAbbrs.gb = "git branch";
  programs.fish.shellAbbrs.gbm = "git branch -m";
  programs.fish.shellAbbrs.gco = "git checkout";
  programs.fish.shellAbbrs.gcb = "git checkout -b";
  programs.fish.shellAbbrs.gc = "git commit";
  programs.fish.shellAbbrs.gcm = "git commit -m";
  programs.fish.shellAbbrs.gca = "git commit --amend";
  programs.fish.shellAbbrs.gcf = "git commit --amend --no-edit";
  programs.fish.shellAbbrs.gp = "git push";
  programs.fish.shellAbbrs.gpf = "git push --force-with-lease --force-if-includes";
  programs.fish.shellAbbrs.gpl = "git pull";
  programs.fish.shellAbbrs.grs = "git restore";
  programs.fish.shellAbbrs.grst = "git restore --staged";
  programs.fish.shellAbbrs.gst = "git status";
  programs.fish.shellAliases.g = "git";

  programs.git.enable = true;
  programs.git.difftastic.enable = true;
  programs.git.extraConfig = {
    commit.gpgsign = true;
    gpg.format = "ssh";
    gpg.ssh.program = "${pkgs._1password-gui}/bin/op-ssh-sign";
    init.defaultBranch = "main";
    pull.rebase = true;
  };
  programs.git.userEmail = lib.mkDefault "46090392+putquo@users.noreply.github.com";
  programs.git.userName = "Preston van Tonder";

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
    theme = "dracula";
  };
  programs.helix.themes = { empty = { }; };

  programs.ssh.enable = true;
  programs.ssh.extraConfig = ''
    Host *
      IdentityAgent ~/.1password/agent.sock 
  '';

  programs.starship.enable = true;

  programs.zoxide.enable = true;
  programs.zoxide.options = [ "--cmd" "cd" ];

  xdg.userDirs.extraConfig.XDG_PROJECTS_DIR = "$HOME/projects";
}
