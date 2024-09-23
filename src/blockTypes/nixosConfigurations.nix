{
  nixpkgs,
  root,
}: let
  inherit
    (root)
    mkCommand
    ;

  l = nixpkgs.lib // builtins;
  /*
  Use the nixosConfigurations Blocktype for
  final definitions of your NixOS hosts.
  */
  nixosConfigurations = {
    name = "nixosConfigurations";
    type = "nixosConfiguration";
    # nixosGenerator's actions?
    # microvm action?
    # nixos-rebuild action?
    actions = {
      currentSystem,
      fragment,
      fragmentRelPath,
      target,
      inputs,
    }: let
      getString = o: (l.elemAt (l.splitString ["/"] fragmentRelPath) o);
      host = (getString 0) + "-" + (getString 2);
      dc = getString 1;
      bin = ''
        bin=$(nix build .#${dc}.${host}.system --no-link --print-out-paths)/sw/bin
        export PATH=$bin:$PATH
      '';
    in [
      (mkCommand currentSystem {
        name = "switch";
        description = "switch the configuration";
        command =
          bin
          + ''
            nixos-rebuild switch --flake .#${host}
          '';
      })
    ];
  };
in
  nixosConfigurations
