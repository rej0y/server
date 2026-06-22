{ pkgs }:

let
  geyser = {
    version = "2.10.1";
    build = "1174";
    hash = "sha256-rwF1i84cgpUBw4XP/DKSkigNDCxkDJ0VsKvthE/txkw=";
  };

  floodgate = {
    version = "2.2.5";
    build = "133";
    hash = "sha256-RrTrLVa9zxvI+hs+O1OOPQ0ZzMDKb+plaZP0wu1HJcY=";
  };

  blockLocker = {
    version = "1.14.1";
    hash = "sha256-430jmDW0e5GkkQP9kNcREJb6KwD/Dqg1smQaORxkvrk=";
  };
in
[
  {
    fileName = "Geyser-Spigot.jar";
    jar = pkgs.fetchurl {
      name = "Geyser-Spigot-${geyser.version}-${geyser.build}.jar";
      url = "https://download.geysermc.org/v2/projects/geyser/versions/${geyser.version}/builds/${geyser.build}/downloads/spigot";
      hash = geyser.hash;
    };
  }
  {
    fileName = "floodgate-spigot.jar";
    jar = pkgs.fetchurl {
      name = "floodgate-spigot-${floodgate.version}-${floodgate.build}.jar";
      url = "https://download.geysermc.org/v2/projects/floodgate/versions/${floodgate.version}/builds/${floodgate.build}/downloads/spigot";
      hash = floodgate.hash;
    };
  }
  {
    fileName = "blocklocker.jar";
    jar = pkgs.fetchurl {
      name = "blocklocker-${blockLocker.version}.jar";
      url = "https://hangarcdn.papermc.io/plugins/Rutger/BlockLocker/versions/${blockLocker.version}/PAPER/blocklocker-${blockLocker.version}.jar";
      hash = blockLocker.hash;
    };
  }
]
