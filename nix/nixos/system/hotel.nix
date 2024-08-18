{ cell, name, super, ... }@_haumeaArgs: {
  host = cell.host.${name};

  profiles = [
    super.profile.cosmic
    super.profile.desktop
    super.profile.gaming
    super.profile.nvidia
    super.profile.wayland
  ];

  users = [
    cell.user.justin
    cell.user.uniform
  ];
}
