{ config, lib, lib', osConfig, pkgs, ... }:
with lib';
templated.preset "desktop" {
  inherit config;
  whenEnabled = {
    home.stateVersion = osConfig.system.stateVersion;

    programs.firefox.enable = true;
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
    programs.fish.interactiveShellInit =
      let theme-sh = "${pkgs.theme-sh}/bin/theme.sh";
      in ''
        set fish_greeting
        fish_vi_key_bindings

        function __set_dark_appearance --on-signal USR1
          set -gx BAT_THEME base16
          set -gx FZF_DEFAULT_OPTS "
            --cycle
            --layout=reverse
            --border
            --height=90%
            --preview-window=wrap
            --marker='*'
            --color=fg:#908caa,bg:#232136,hl:#ea9a97
            --color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97
            --color=border:#44415a,header:#3e8fb0,gutter:#232136
            --color=spinner:#f6c177,info:#9ccfd8,separator:#44415a
            --color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

          ${theme-sh} rose-pine-moon
        end

        function __set_light_appearance --on-signal USR2
          set -gx BAT_THEME base16-256
          set -gx FZF_DEFAULT_OPTS "
              --cycle
              --layout=reverse
              --border
              --height=90%
              --preview-window=wrap
              --marker='*'
              --color=fg:#797593,bg:#faf4ed,hl:#d7827e
              --color=fg+:#575279,bg+:#f2e9e1,hl+:#d7827e
              --color=border:#dfdad9,header:#286983,gutter:#faf4ed
              --color=spinner:#ea9d34,info:#56949f,separator:#dfdad9
              --color=pointer:#907aa9,marker:#b4637a,prompt:#797593"

          ${theme-sh} rose-pine-dawn
        end

        if test -e ~/.theme_history
          ${theme-sh} (${theme-sh} -l | tail -n1)
        end
      '';

    programs.foot.enable = true;
    programs.foot.settings = {
      main = {
        font = "MonaspiceNe Nerd Font Mono:size=11";
        initial-window-size-pixels = "1200x700";
        pad = "8x4";
      };
    };

    programs.home-manager.enable = true;

    services.darkman.enable = true;
    services.darkman.darkModeScripts.fish = ''
      /usr/bin/env -S pkill -USR1 fish
    '';
    services.darkman.lightModeScripts.fish = ''
      /usr/bin/env -S pkill -USR2 fish
    '';
    services.darkman.settings = {
      lat = 52.3;
      lng = 4.8;
      usegeoclue = false;
    };

    xdg.configFile."1Password/ssh/agent.toml".text = ''
      [[ssh-keys]]
      vault = "${config.tag}"
    '';

    xdg.configFile."Yubico/u2f_keys".text =
      "justin:J10bEUa4W6n6a3EidpTZ3ip0ee48tbyY/0Fuu02W2NwPGzGtCn2UxjsGXYciNO3otL+YVu04cUfVP7iDbdwj1w=="
      + ",G285zaLYdUFaTMg2WlhWvSeRkV39fG3p6jFEjK8AEAvyQViziFCuUE31fdSCPT2P8vKx8fcaPEHuXTGMeIzCMA=="
      + ",es256,+presence";

    xdg.desktopEntries = lib.mkIf
      (osConfig.presets.gaming.enable && !config.presets.gaming.enable) {
        steam.exec = "";
        steam.name = "Steam";
        steam.noDisplay = true;
      };

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
  };
}
