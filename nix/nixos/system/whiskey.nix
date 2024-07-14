{ cell, name, super, ... }@_haumeaArgs: {
  host = cell.host.${name};

  profiles = [
    super.profile.kde
    super.profile.laptop
  ];

  users = [
    cell.user.uniform
  ];
}
