{ ... }@_haumeaArgs:
{ config, lib, osConfig, pkgs, ... }@_hmModuleArgs: {
  home.stateVersion = osConfig.system.stateVersion;

  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    window.decorations = "None";
    window.dynamic_padding = true;
    window.padding.x = 8;
  };

  programs.btop.enable = true;

  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox-bin;
  programs.firefox.profiles.default = {
    id = 0;
    name = "default";
    isDefault = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      onepassword-password-manager
      ublock-origin
    ];
  };

  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    set fish_greeting
    fish_vi_key_bindings
  '';

  programs.home-manager.enable = true;

  xdg.configFile."1Password/ssh/agent.toml".text = ''
    [[ssh-keys]]
    vault = "${config.tag}"
  '';

  xdg.configFile."Yubico/u2f_keys".text =
    "justin:J10bEUa4W6n6a3EidpTZ3ip0ee48tbyY/0Fuu02W2NwPGzGtCn2UxjsGXYciNO3otL+YVu04cUfVP7iDbdwj1w=="
    + ",G285zaLYdUFaTMg2WlhWvSeRkV39fG3p6jFEjK8AEAvyQViziFCuUE31fdSCPT2P8vKx8fcaPEHuXTGMeIzCMA=="
    + ",es256,+presence";

  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;
  xdg.userDirs.desktop = "$HOME/desktop";
  xdg.userDirs.documents = "$HOME/documents";
  xdg.userDirs.download = "$HOME/downloads";
  xdg.userDirs.music = "$HOME/media/music";
  xdg.userDirs.pictures = "$HOME/media/images";
  xdg.userDirs.publicShare = "$HOME/public";
  xdg.userDirs.videos = "$HOME/media/videos";
  xdg.userDirs.templates = "$HOME/templates";
}
