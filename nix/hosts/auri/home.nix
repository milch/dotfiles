{ config, pkgs, lib, ... }:

let 
  mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  imports = [
    ../../shared/home.nix
  ];
  home.file = {
    ".config/nvim/lua/opt/ai/".source = ../../../.config/nvim/lua/opt/ai;
  };
}
