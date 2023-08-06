{ pkgs, ... }: {
  imports = [
    ./bash.nix
    #./bat.nix
    #./direnv.nix
    #./fish.nix
    #./gh.nix
    #./git.nix
    #./gpg.nix
    #./nix-index.nix
    #./pfetch.nix
    #./ranger.nix
    #./screen.nix
    #./shellcolor.nix
    #./ssh.nix
    #./starship.nix
    #./xpo.nix
  ];
  home.packages = with pkgs; [
    bc # Calculator
    bottom # System viewer
    ncdu # TUI disk usage
    exa # Better ls
    ripgrep # Better grep
    fd # Better find
    httpie # Better curl
    diffsitter # Better diff
    jq # JSON pretty printer and manipulator
    #trekscii # Cute startrek cli printer

    #nil # Nix LSP
    nixfmt # Nix formatter
    nix-inspect # See which pkgs are in your PATH

    ltex-ls # Spell checking LSP
  ];
}
