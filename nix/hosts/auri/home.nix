{ config, pkgs, lib, ... }:

{
  imports = [
    ../../shared/home.nix
  ];
  home.file = {
    ".config/nvim/lua/opt/ai/".source = ../../../.config/nvim/lua/opt/ai;
  };
}
