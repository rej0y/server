{ config, pkgs, ... }:

{
  home = {
    username = "rej0y";
    homeDirectory = "/home/rej0y";
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
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "rej0y";
          email = "zhoushengjian1@gmail.com";
        };
        
        url = {
          "git@github.com:".insteadOf = [ "https://github.com/" ];
        };

        init.defaultBranch = "main";
      };
    };

    ssh = {
      enable = true;
      programs.ssh.enableDefaultConfig = false;
      settings."*" = {
        addKeysToAgent = "yes";
      };
    };
  };
}
