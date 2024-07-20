{ inputs }: let
  custom = self: super : {
    _1password-gui = super._1password-gui.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        mkdir -p $out/etc/xdg/autostart
        cp $out/share/applications/${old.pname}.desktop $out/etc/xdg/autostart/${old.pname}.desktop
        substituteInPlace $out/etc/xdg/autostart/${old.pname}.desktop \
          --replace 'Exec=${old.pname} %U' 'Exec=${old.pname} --silent %U'
      '';
    });

    helix = inputs.helix.packages.${super.system}.default;
  };

  nur = inputs.nur.overlay;
in [ custom nur ]
