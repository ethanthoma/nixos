{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vulkan-tools
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [ pkgs.nvidia-vaapi-driver ];
    };

    nvidia = {
      modesetting.enable = true;
      nvidiaPersistenced = true;

      powerManagement.enable = false;
      powerManagement.finegrained = false;

      forceFullCompositionPipeline = true;

      open = true;

      nvidiaSettings = true;

      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  boot = {
    kernelParams = [
      "video=DP-1:2560x1440@60"
      "video=DP-2:2560x1440@60"
      "nvidia-drm.modeset=1"
      "nvidia-drm.fbdev=1"
    ];

    initrd.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
    ];
  };

  environment = {
    variables = {
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "0"; # Controls if Adaptive Sync should be used. Recommended to set as “0” to avoid having problems on some games.
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    };
    shellAliases = {
      nvidia-settings = "nvidia-settings --config='$XDG_CONFIG_HOME'/nvidia/settings";
    };
  };
}
