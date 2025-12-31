{
  description = "ThingsBoard development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { nixpkgs, ... }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    java = pkgs.openjdk17;

  in {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        java
        maven
        nodejs_20
        git
        steam-run
        postgresql
      ];

      shellHook = ''
        export JAVA_HOME=${java.home}
        export PATH=$JAVA_HOME/bin:$PATH
        alias mvn='steam-run mvn'
      '';
    };
  };
}


