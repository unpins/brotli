{
  description = "brotli as a single self-contained binary";

  nixConfig = {
    extra-substituters = [ "https://unpins.cachix.org" ];
    extra-trusted-public-keys = [ "unpins.cachix.org-1:DDaShjbZ8VvcqxeTcAU3kV9vxZQBlyb7V/uLBHfTynI=" ];
  };

  inputs.unpins-lib.url = "github:unpins/nix-lib";

  # Single CLI (`brotli`, `-d` to decompress) — plain single-binary, no
  # multicall. Portable CMake C, no Unix-only headers, so Windows goes via
  # mingw, not Cosmopolitan.
  #
  # nixpkgs installs library man3 pages (constants/decode/encode/types.h.3)
  # beside brotli.1; ship only the tool, so `prune` drops man3 on every target
  # (else withMan embeds them). Same prune native + windows → the mingw cross
  # harvests its own brotli.1, no graft.
  outputs = { self, unpins-lib }:
    let
      ulib = unpins-lib.lib;
      prune = old: {
        postInstall = (old.postInstall or "") + "\n" + ''
          for o in $outputs; do
            d="''${!o}"
            rm -rf "$d/share/man/man3"
          done
        '';
      };
    in
    ulib.mkStandaloneFlake {
      inherit self;
      name = "brotli";
      smoke = [ "--version" ];
      smokePattern = "brotli 1";

      engine = "unpin-llvm";
      multicall = {
        programs = [{ name = "brotli"; }];
      };

      build = pkgs: pkgs.pkgsStatic.brotli.overrideAttrs prune;
      windowsBuild = pkgs: (ulib.mingwStaticCross pkgs).brotli.overrideAttrs prune;
    };
}
