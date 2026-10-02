{
  # Prefer /dev/disk/by-id/... paths: nvmeXn1 enumeration order is not guaranteed.
  disko.devices.disk = {
    # 2TB: OS
    os = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_2TB_S464NB0M401375Z";
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
      device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_4TB_S7DPNF0Y615909E";
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
