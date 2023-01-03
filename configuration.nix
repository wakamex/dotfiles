# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  nix = {
    settings.auto-optimise-store = true;
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  system.autoUpgrade.enable = true;
  security.sudo.wheelNeedsPassword = false;

  # Bootloader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      timeout = 1;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    variables = {
      TERMINAL = "alacritty";
      EDITOR = "code";
      VISUAL = "code";
    };
    systemPackages = with pkgs; [
      git
      gcc
      zsh
      lsof
      wget
      zlib
      htop
      steam
      mplayer
      blueman
      gnumake
      nix-tree
      neofetch
      starship
      # python310
      # python310Packages.numpy
      # python310Packages.pytest
      keepassxc
      librewolf
      alacritty
      vscode-fhs
      signal-desktop
    ];
  };
  programs = {
    steam.enable = true;
    gamemode.enable = true;
  };
  services = {
    blueman.enable = true;
    syncthing = {
      enable = true;
      user = "mihai";
      openDefaultPorts = true;
      dataDir = "/home/mihai";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mihai = {
    isNormalUser = true;
    description = "mihai";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # Enable automatic login for the user.
  services.getty.autologinUser = "mihai";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
      volumeStep = "5%";
    };
  };
  services.xserver = {
    enable = true;
    libinput.enable = true;
    desktopManager = {
      xterm.enable = false;
    };
    displayManager = {
      defaultSession = "none+i3";
      autoLogin = {
        enable = true;
        user = "mihai";
      };
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3lock
        rofi
      ];
    };
  };
  
  networking = {
    hostName = "hplaptop"; # Define your hostname.
    networkmanager = {
      enable = true;
      insertNameservers = [ "1.1.1.1" "8.8.8.8" ];
    };
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # networking.firewall = {
    # enable = true;
    # allowedTCPPorts = [ 22000 ];
    # allowedUDPPortRanges = [
    #   { from = 4000; to = 4007; }
    #   { from = 8000; to = 8010; }
    # ];
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
