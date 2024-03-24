{ inputs }: let
  _1passAgentStart = self: super: {
    _1password-gui = super._1password-gui.overrideAttrs (prev: {
      postInstall = (prev.postInstall or "") + ''
        mkdir -p $out/etc/xdg/autostart
        cp $out/share/applications/${prev.pname}.desktop $out/etc/xdg/autostart/${prev.pname}.desktop
        substituteInPlace $out/etc/xdg/autostart/${prev.pname}.desktop \
          --replace 'Exec=${prev.pname} %U' 'Exec=${prev.pname} --silent %U'
      '';
    });
  };
  nur = inputs.nur.overlay;
  vault = self: super: {
    vault = inputs.nixpkgs-stable.legacyPackages.${super.system}.vault;
  };
in [ _1passAgentStart nur vault ]
