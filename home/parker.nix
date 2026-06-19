{ config, pkgs, ... }:

{
  home = {
    username = "parker";
    homeDirectory = "/home/parker";
    stateVersion = "26.05";
    packages = with pkgs; [
      kitty
    ];
  };

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      initLua = ''
        vim.opt.expandtab = true
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.softtabstop = 2
      '';
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
    };

    bash = {
      enable = true;
      initExtra = ''
        ns() {
          sudo git -C /etc/nixos pull &&
          sudo nixos-rebuild switch --flake /etc/nixos#altruist
        }
      '';
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "ShadowKnight-13";
          email = "padrago@yahoo.com";
        };
        url = {
          "git@github.com:".insteadOf = [ "https://github.com/" ];
        };
        init.defaultBranch = "main";
      };
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
    };
  };
}
