{ config, lib', pkgs, ... }:
with lib';
templated.preset "hyprland" {
  inherit config;
  whenEnabled = {
    programs.anyrun.enable = true;
    programs.anyrun.package = pkgs.anyrun;
    programs.anyrun.config = {
      plugins = [
        "libapplications.so"
        "libdictionary.so"
        "libshell.so"
        "libsymbols.so"
        "libtranslate.so"
        "libwebsearch.so"
      ];

      closeOnClick = false;
      hideIcons = false;
      hidePluginInfo = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      maxEntries = null;
      showResultsImmediately = false;
      width = { fraction = 0.3; };
      x.fraction = 0.5;
      y.fraction = 0.3;
    };
    programs.anyrun.extraConfigFiles."applications.ron".text = ''
      Config(
        desktop_actions: false,
        max_entries: 5,
        terminal: Some("foot"),
      )
    '';
    programs.anyrun.extraCss = ''
      * {
        all: unset;
        font-size: 1.3rem;
      }

      #window,
      #match,
      #entry,
      #plugin,
      #main {
        background: transparent;
      }

      #match.activatable {
        border-radius: 16px;
        padding: 0.3rem 0.9rem;
        margin-top: 0.01rem;
      }
      #match.activatable:first-child {
        margin-top: 0.7rem;
      }
      #match.activatable:last-child {
        margin-bottom: 0.6rem;
      }

      #plugin:hover #match.activatable {
        border-radius: 10px;
        padding: 0.3rem;
        margin-top: 0.01rem;
        margin-bottom: 0;
      }

      #match:selected,
      #match:hover,
      #plugin:hover {
        background: rgba(255, 255, 255, 0.1);
      }

      #entry {
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid rgba(255, 255, 255, 0.1);
        border-radius: 16px;
        margin: 0.5rem;
        padding: 0.3rem 1rem;
      }

      list > #plugin {
        border-radius: 16px;
        margin: 0 0.3rem;
      }
      list > #plugin:first-child {
        margin-top: 0.3rem;
      }
      list > #plugin:last-child {
        margin-bottom: 0.3rem;
      }
      list > #plugin:hover {
        padding: 0.6rem;
      }

      box#main {
        background: rgba(0, 0, 0, 0.5);
        box-shadow:
          inset 0 0 0 1px rgba(255, 255, 255, 0.1),
          0 0 0 1px rgba(0, 0, 0, 0.5);
        border-radius: 24px;
        padding: 0.3rem;
      }
    '';

    programs.hyprlock.enable = true;
    programs.hyprlock.settings = {
      general = {
        grace = 5;
        hide_cursor = true;
      };

      background = [
        {
          path = "/tmp/.lockscreen.png";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          shadow_passes = 2;
        }
      ];
    };

    services.darkman =
      let
        inherit (lib'.theme.rose-pine) dawn moon;
        dark.activeBorder = "0xff${moon.love.hex} 0xff${moon.gold.hex} 45deg";
        dark.inactiveBorder = "0xff${moon.base.hex}";
        light.activeBorder = "0xff${dawn.rose.hex} 0xff${dawn.gold.hex} 45deg";
        light.inactiveBorder = "0xff${dawn.base.hex}";
      in
      {
        darkModeScripts.hyprland = ''
          hyprctl keyword general:col.active_border ${dark.activeBorder}
          hyprctl keyword general:col.inactive_border ${dark.inactiveBorder}
          hyprctl keyword plugin:hyprexpo:bg_col ${dark.activeBorder}
        '';
        lightModeScripts.hyprland = ''
          hyprctl keyword general:col.active_border ${light.activeBorder}
          hyprctl keyword general:col.inactive_border ${light.inactiveBorder}
          hyprctl keyword plugin:hyprexpo:bg_col ${light.activeBorder}
        '';
      };

    services.hypridle.enable = true;
    services.hypridle.settings =
      let
        minute = 60;
      in
      {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 5 * minute;
            on-timeout = "loginctl lock-session";
          }
        ];
      };

    services.swaync.enable = true;

    systemd.user.services.lockscreen-img = {
      Install = { WantedBy = [ "graphical-session.target" ]; };
      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "lockscreen-img";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.grimblast}/bin/grimblast save output /tmp/.lockscreen.png";
      };
    };

    systemd.user.services.wbg = {
      Install = { WantedBy = [ "graphical-session.target" ]; };
      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "wbg";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.wbg}/bin/wbg ${pkgs.wallpaper}";
        Restart = "always";
        RestartSec = "10";
      };
    };

    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.systemd.variables = [ "--all" ];
    wayland.windowManager.hyprland.settings = {
      "$annotate" = "satty --output-filename $XDG_PICTURES_DIR/satty-$(date '+%Y%m%d-%H:%M:%S').png --filename -";
      "$browser" = "firefox";
      "$hyper" = "SUPER ALT CTRL SHIFT";
      "$mod" = "SUPER";
      "$screenshot" = "grimblast save";
      "$terminal" = "foot";

      "$smIncr" = "10";
      "$mdIncr" = "20";
      "$lgIncr" = "35";

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
        ];
      };

      bind = [
        ", F1, exec, $terminal"
        ", F2, exec, $browser"

        "$mod, L, exec, loginctl lock-session"

        "$mod, A, fullscreen, 1"
        "$mod, K, killactive"
        "$mod, F, fullscreen"
        "$mod, S, togglesplit"
        "$mod, P, pseudo"
        "$mod, V, togglefloating"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

        "$mod SHIFT, left, movewindow, l"
        "$mod SHIFT, right, movewindow, r"
        "$mod SHIFT, up, movewindow, u"
        "$mod SHIFT, down, movewindow, d"

        "$hyper, left, workspace, -1"
        "$hyper, down, movetoworkspace, -1"
        "$hyper, page_down, movetoworkspacesilent, -1"

        "$hyper, right, workspace, +1"
        "$hyper, up, movetoworkspace, +1"
        "$hyper, page_up, movetoworkspacesilent, +1"

        ", print, exec, $screenshot active - | $annotate"
        "SHIFT, print, exec, $screenshot area - | $annotate"
        "$mod, print, exec, $screenshot screen - | $annotate"
      ];

      binde = [
        "$mod ALT, left, moveactive, -$lgIncr 0"
        "$mod ALT, right, moveactive, $lgIncr 0"
        "$mod ALT, up, moveactive, 0 -$lgIncr"
        "$mod ALT, down, moveactive, 0 $lgIncr"

        "$mod CTRL, left, resizeactive, -$mdIncr 0"
        "$mod CTRL, right, resizeactive, $mdIncr 0"
        "$mod CTRL, up, resizeactive, 0 -$mdIncr"
        "$mod CTRL, down, resizeactive, 0 $mdIncr"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindr = [
        "$mod, home, exec, pkill .anyrun-wrapped || exec anyrun"
      ];

      decoration = {
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };

        "col.shadow" = "rgba(1a1a1aee)";
        drop_shadow = true;
        rounding = 10;
        shadow_range = 4;
        shadow_render_power = 3;
      };

      dwindle = {
        preserve_split = true;
        pseudotile = true;
      };

      general = {
        allow_tearing = false;
        border_size = 2;
        gaps_in = 5;
        gaps_out = 20;
        layout = "dwindle";
      };

      misc = {
        disable_autoreload = true;
        force_default_wallpaper = 0;
        vrr = 1;
      };

      monitor =
        [
          "desc:LG Electronics LG TV SSCR2 0x01010101, 3840x2160@119.88Hz, auto, auto"
          ",highrr, auto, auto"
        ];
    };
  };
}
