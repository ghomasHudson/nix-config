{ config, pkgs, lib, ... }:

# Other useful settings come from srvos's zfs module
{
  config = lib.mkIf config.boot.zfs.enabled {
    environment.systemPackages = [
      pkgs.zfs-prune-snapshots
    ];

    
    boot = {
      initrd = {
        postDeviceCommands =
          #wipe / and /var on boot
          lib.mkAfter ''
            zfs rollback -r rpool/root@empty
            zfs rollback -r rpool/home@empty
          '';
      };
      # Newest kernels might not be supported by ZFS
      kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
      
      # ZFS does not support swapfiles, disable hibernate and set cache max
      kernelParams = [
        "nohibernate"
        "zfs.zfs_arc_max=17179869184"
      ];
      
      supportedFilesystems = [ "vfat" "zfs" ];
      
      zfs = {
        devNodes = "/dev/disk/by-id/";
        forceImportAll = true;
        removeLinuxDRM = pkgs.hostPlatform.isAarch64;
        requestEncryptionCredentials = true;
      };
    };
    
    services.zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };
    # Don't let zfs mount the the datasets, because of legacy mounting
    systemd.services.zfs-mount.enable = false;
  };

}
