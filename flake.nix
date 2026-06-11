{
  description = "brotli as a single self-contained binary";

  nixConfig = {
    extra-substituters = [ "https://unpins.cachix.org" ];
    extra-trusted-public-keys = [ "unpins.cachix.org-1:DDaShjbZ8VvcqxeTcAU3kV9vxZQBlyb7V/uLBHfTynI=" ];
  };

  inputs.unpins-lib.url = "github:unpins/nix-lib";

  # brotli ships a single CLI (`brotli`, which compresses and — with -d —
  # decompresses), so this is a plain single-binary build, no multicall.
  # Unlike the Info-ZIP/GNU archive tools, brotli is portable CMake C with no
  # Unix-only headers, so Windows goes through mingw (not Cosmopolitan).
  #
  # The nixpkgs brotli installs library reference pages under man3
  # (constants.h.3, decode.h.3, encode.h.3, types.h.3) alongside the CLI's
  # brotli.1. We ship only the tool, so drop man3 on every target — otherwise
  # withMan would embed the header docs too. The same `prune` runs on native
  # AND windows, so each build harvests its OWN curated man (just brotli.1):
  # the mingw cross installs brotli.1 like every other target, no graft needed.
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
      build = pkgs: pkgs.pkgsStatic.brotli.overrideAttrs prune;
      windowsBuild = pkgs: (ulib.mingwStaticCross pkgs).brotli.overrideAttrs prune;
    };
}
