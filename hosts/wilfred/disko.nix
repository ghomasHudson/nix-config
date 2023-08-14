{...}: {
  disko.devices = {
    disk.nvme = {
      type = "disk";
      device = "/dev/disk/by-uuid/92da76c4-f099-4c45-a019-0f5224b49b32";
      content = {
        type = "table";
        format = "gpt";
        partitions = [
          {
            name = "bootcode";
            start = "0";
            end = "1M";
            part-type = "primary";
            flags = ["bios_grub"];
          }
          {
            name = "efiboot";
            fs-type = "fat32";
            start = "1MiB";
            end = "1GiB";
            bootable = true;
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          }
          {
            name = "swap";
            start = "1GiB";
            end = "2GiB";
            content = {
              type = "swap";
              randomEncryption = true;
            };
          }
          {
            name = "zroot";
            start = "2GiB";
            end = "100%";
            content = {
              type = "zfs";
              pool = "rpool";
            };
          }
        ];
      };
    };
    zpool = {
      rpool = {
        type = "zpool";
        rootFsOptions = {
          acltype = "posixacl";
          canmount = "off";
          checksum = "edonr";
          compression = "zstd";
          dnodesize = "auto";
          #encryption = "aes-256-gcm";
          #keyformat = "passphrase";
          # if you want to use the key for interactive login be sure there is no trailing newline
          # for example use `echo -n "password" > /tmp/secret.key`
          #keylocation = "file:///tmp/secret.key";
          mountpoint = "none";
          normalization = "formD";
          relatime = "on";
          xattr = "sa";
          "com.sun:auto-snapshot" = "false";
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };
        postCreateHook = ''
          zfs set keylocation="prompt" $name;
        '';

        datasets = {
          # zfs uses cow free space to delete files when the disk is completely filled
          reserved = {
            options = {
              canmount = "off";
              mountpoint = "none";
              reservation = "5GiB";
            };
            type = "zfs_fs";
          };
          home = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/home";
            options."com.sun:auto-snapshot" = "true";
            postCreateHook = "zfs snapshot rpool/home@empty";
          };
          persist = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/persist";
            options."com.sun:auto-snapshot" = "true";
            postCreateHook = "zfs snapshot rpool/persist@empty";
          };
          nix = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/nix";
            options = {
              atime = "off";
              canmount = "on";
              "com.sun:auto-snapshot" = "true";
            };
            postCreateHook = "zfs snapshot rpool/nix@empty";
          };
          root = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/";
            postCreateHook = ''
              zfs snapshot rpool/root@empty
              zfs snapshot rpool/root@lastboot
            '';
          };
        };
      };
    };
  };
}
