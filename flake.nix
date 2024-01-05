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
            '';
            inherit binaryPath;
          };
        
        apps.uploadDockerImage = {
          type = "app";
          program = let drv = self.packages.${system}.uploadDockerImage; in "${drv}/${drv.binaryPath}";
        };
      }
    );
}
