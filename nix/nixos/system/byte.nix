{ cell, name, super, ... }@_haumeaArgs: {
  host = cell.host.${name};

  profiles = [
    super.profile.cosmic
    super.profile.desktop
    super.profile.development
    # super.profile.wazuh
  ];

  users = [
    cell.user.toil
  ];
}
