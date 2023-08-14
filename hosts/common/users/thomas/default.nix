{ pkgs, config, ... }:
let ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = false;
  users.users.thomas = {
    isNormalUser = true;
    shell = pkgs.bash;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ] ++ ifTheyExist [
      "network"
      "wireshark"
      "i2c"
      "mysql"
      "docker"
      "podman"
      "git"
      "libvirtd"
      "deluge"
    ];

    openssh.authorizedKeys.keys = [ (builtins.readFile ../../../../home/thomas/ssh.pub) ];
    passwordFile = config.sops.secrets.thomas-password.path;
    packages = [ pkgs.home-manager ];
  };

  sops.secrets.thomas-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.thomas = import ../../../../home/thomas/${config.networking.hostName}.nix;

  services.geoclue2.enable = true;
  security.pam.services = { swaylock = { }; };
}
