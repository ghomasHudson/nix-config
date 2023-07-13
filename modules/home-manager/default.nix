# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.

{
  fonts = import ./fonts.nix;
  monitors = import ./monitors.nix;
  pass-secret-service = import ./pass-secret-service.nix;
  rgbdaemon = import ./rgbdaemon.nix;
  shellcolor = import ./shellcolor.nix;
  wallpaper = import ./wallpaper.nix;
  xpo = import ./xpo.nix;
}
