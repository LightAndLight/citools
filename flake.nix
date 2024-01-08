{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
    ipso.url = "github:LightAndLight/ipso";
  };
  outputs = { self, nixpkgs, flake-utils, nix-filter, ipso }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        ipsoPackage = ipso.defaultPackage.${system};
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            ipsoPackage
          ];
        };

        devShells.digitalOcean = pkgs.mkShell {
          buildInputs = with pkgs; [
            doctl
            s3cmd
          ];
        };

        packages.uploadDockerImage =
          let binaryPath = "bin/uploadDockerImage"; in
          pkgs.stdenv.mkDerivation {
            name = "citools-uploadDockerImage";
            src = nix-filter {
              root = ./.;
              include = [ ./src/uploadDockerImage ];
            };
            buildInputs = [
              ipsoPackage
            ];
            installPhase = ''
              mkdir -p $out/bin
              cp src/uploadDockerImage $out/${binaryPath}
              chmod +x $out/${binaryPath}
            '';
            inherit binaryPath;
          };

        packages.uploadToCache =
          let binaryPath = "bin/uploadToCache"; in
          pkgs.stdenv.mkDerivation {
            name = "citools-uploadToCache";
            src = nix-filter {
              root = ./.;
              include = [ ./src/uploadToCache ];
            };
            buildInputs = [
              ipsoPackage
            ];
            installPhase = ''
              mkdir -p $out/bin
              cp src/uploadToCache $out/${binaryPath}
              chmod +x $out/${binaryPath}
            '';
            inherit binaryPath;
          };
        
        packages.testPackage =
          pkgs.stdenv.mkDerivation {
            name = "citools-testPackage";
            src = nix-filter {
              root = ./.;
              include = [ ./src/testScript ];
            };
            buildInputs = [
              pkgs.bashInteractive
            ];
            installPhase = ''
              mkdir -p $out/bin
              cp src/testScript $out/bin/testScript
              chmod +x $out/bin/testScript
            '';
          };

        packages.digitalOceanImage =
          (pkgs.nixos {
            imports = [
              "${pkgs.path}/nixos/modules/virtualisation/digital-ocean-image.nix"
            ];

            virtualisation.digitalOceanImage.compressionMethod = "bzip2";

            nix = {
              package = pkgs.nixFlakes;
              extraOptions = ''
                experimental-features = nix-command flakes
              '';
            };
          }).digitalOceanImage;

        apps.uploadDockerImage = {
          type = "app";
          program = let drv = self.packages.${system}.uploadDockerImage; in "${drv}/${drv.binaryPath}";
        };

        apps.uploadToCache = {
          type = "app";
          program = let drv = self.packages.${system}.uploadToCache; in "${drv}/${drv.binaryPath}";
        };
      }
    );
}
