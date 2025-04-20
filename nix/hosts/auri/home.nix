# This file contains shared home-manager configuration that can be imported by both personal and work machines
{ config, pkgs, lib, ... }:

{
  imports = [
    ../../shared/home.nix
  ];
  home.file = {
    ".config/nvim/lua/opt/ai/".source = ../../../.config/nvim/lua/opt/ai;
  };
}
