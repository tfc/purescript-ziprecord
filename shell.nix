let
  sources = import ./nix/sources.nix { };
  pkgs = import sources.nixpkgs { };

in

pkgs.mkShell {
  buildInputs = with pkgs; [
    nodePackages_latest.purescript-language-server
    nodePackages_latest.purs-tidy
    nodejs
    purescript
    spago
  ];
}
