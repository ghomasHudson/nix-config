{ pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    #inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/thomas
    #../common/users/layla

    #../common/optional/gamemode.nix
    #../common/optional/ckb-next.nix
    #../common/optional/greetd.nix
    #../common/optional/pipewire.nix
    #../common/optional/quietboot.nix
    #../common/optional/lol-acfix.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    binfmt.emulatedSystems = [ "aarch64-linux" "i686-linux" ];
  };

  networking = {
    hostName = "agnes";
    useDHCP = true;
    interfaces.enp2s0 = {
      useDHCP = true;
      wakeOnLan.enable = true;

      ipv4 = {
        addresses = [{
          address = "192.168.1.2";
          prefixLength = 24;
        }];
      };
      ipv6 = {
        addresses = [{
          address = "2804:14d:8084:a484::3";
          prefixLength = 64;
        }];
      };
    };
  };

  i18n.defaultLocale = "pt_BR.UTF-8";

  boot.kernelModules = [ "coretemp" ];
  services.thermald.enable = true;
  environment.etc."sysconfig/lm_sensors".text = ''
    HWMON_MODULES="coretemp"
  '';

  programs = {
    #adb.enable = true;
    #dconf.enable = true;
    #kdeconnect.enable = true;
  };

  #xdg.portal = {
  #  enable = true;
  #  wlr.enable = true;
  #};


  hardware = {
    #nvidia = {
    #  prime.offload.enable = false;
    #  modesetting.enable = true;
    #};
    #opengl = {
    #  enable = true;
    #  driSupport = true;
    #  driSupport32Bit = true;
    #};
  };

  system.stateVersion = "22.05";
}
