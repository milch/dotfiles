#!/bin/sh

style=$(fish -c 'echo $apple_interface_style')

delta --"$style" "$@"
