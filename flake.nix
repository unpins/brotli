{
  description = "Standalone build of brotli";

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
  # brotli.1. We ship only the tool, so drop man3 — otherwise withMan would
  # embed the header docs too.
  outputs = { self, unpins-lib }:
    let
      ulib = unpins-lib.lib;
      pkgsX = unpins-lib.inputs.nixpkgs.legacyPackages.x86_64-linux;
      # The Windows binary's man is grafted from nixpkgs' brotli (the mingw
      # cross can't run the man generator). That graft carries the man3 header
      # docs too, so curate a single-page tree — the native side already drops
      # man3 in postInstall below.
      winMan = pkgsX.runCommand "brotli-win-man" { } ''
        mkdir -p "$out/share/man/man1"
        zcat ${pkgsX.brotli}/share/man/man1/brotli.1.gz > "$out/share/man/man1/brotli.1"
      '';
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
      winManRoot = winMan;
      smoke = [ "--version" ];
      smokePattern = "brotli 1";
      build = pkgs: pkgs.pkgsStatic.brotli.overrideAttrs prune;
      windowsBuild = pkgs: (ulib.mingwStaticCross pkgs).brotli.overrideAttrs prune;
    };
}
