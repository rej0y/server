{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/atm10.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 0;
  };

  networking = {
    hostName = "altruist";
    networkmanager.enable = true;
  };

  users.users.rej0y = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINpkmA0Ako1CSQTj2grWHPC55etVCaepAIs+qv9ljbAF rej0y@charity"
    ];
  };

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
  ];

  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    frp.instances = {
      ssh = {
        enable = true;
        role = "client";

        settings = {
          serverAddr = "66.112.209.106";
          serverPort = 7000;
        
          proxies = [
            {
              name = "ssh";
              type = "tcp";
              localIP = "127.0.0.1";
              localPort = 22;
              remotePort = 2222;
            }
          ];
        };
      };
    };
  };

  time.timeZone = "America/Boise";
  
  system.stateVersion = "26.05";
}

