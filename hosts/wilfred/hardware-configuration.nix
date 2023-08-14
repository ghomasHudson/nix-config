{
  imports = [
    ../common/optional/encrypted-ephemeral-zfs.nix
  ];

  boot = {
    blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

    extraModulePackages = [ ];

    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ ];
    };

    loader = {
      # when installing toggle this to true
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
    };

    kernelModules = [ "kvm-intel" "intel_agp" "i915" ];
    kernelParams = [ "i915.enable_psr=0" "initcall_blacklist=acpi_cpufreq_init" ];
  };

  fileSystems."/persist".neededForBoot = true;

  hardware.cpu.intel.updateMicrocode = true;

  # Set your system kind (needed for flakes)
  nixpkgs.hostPlatform = "x86_64-linux";
}

