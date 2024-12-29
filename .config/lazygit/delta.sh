#!/bin/bash

if defaults read -g AppleInterfaceStyle &>/dev/null; then
  style=dark
else
  style=light
fi

delta --$style "$@"
