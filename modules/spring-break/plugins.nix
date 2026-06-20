{ pkgs }:

let
  geyserVersion = "2.10.1";
  geyserBuild = "1172";
  geyserHash = "sha256-GpNsemqfisJBcY9RMcgRMKqf1IIiRwZFm/Mn+fyjlzU=";

  floodgateVersion = "2.2.5";
  floodgateBuild = "133";
  floodgateHash = "sha256-RrTrLVa9zxvI+hs+O1OOPQ0ZzMDKb+plaZP0wu1HJcY=";

  blockLockerVersion = "1.14.1";
  blockLockerHash = "sha256-430jmDW0e5GkkQP9kNcREJb6KwD/Dqg1smQaORxkvrk=";
in
[
  {
    fileName = "Geyser-Spigot.jar";
    jar = pkgs.fetchurl {
      name = "Geyser-Spigot-${geyserVersion}-${geyserBuild}.jar";
      url = "https://download.geysermc.org/v2/projects/geyser/versions/${geyserVersion}/builds/${geyserBuild}/downloads/spigot";
      hash = geyserHash;
    };
  }
  {
    fileName = "floodgate-spigot.jar";
    jar = pkgs.fetchurl {
      name = "floodgate-spigot-${floodgateVersion}-${floodgateBuild}.jar";
      url = "https://download.geysermc.org/v2/projects/floodgate/versions/${floodgateVersion}/builds/${floodgateBuild}/downloads/spigot";
      hash = floodgateHash;
    };
  }
  {
    fileName = "blocklocker.jar";
    jar = pkgs.fetchurl {
      name = "blocklocker-${blockLockerVersion}.jar";
      url = "https://hangarcdn.papermc.io/plugins/Rutger/BlockLocker/versions/${blockLockerVersion}/PAPER/blocklocker-${blockLockerVersion}.jar";
      hash = blockLockerHash;
    };
  }
]
