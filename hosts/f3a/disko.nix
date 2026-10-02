{
  # Prefer /dev/disk/by-id/... paths: nvmeXn1 enumeration order is not guaranteed.
  disko.devices.disk = {
    # 2TB: OS
    os = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };

    # 4TB: persistent data only
    data = {
      type = "disk";
      device = "/dev/nvme1n1";
      content = {
        type = "gpt";
        partitions.persist = {
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/persist";
          };
        };
      };
    };
  };
}
