#!/usr/bin/env bash

source ./external/shell-lib/cosmonautic.sh

cosmonautic_os_detect
cosmonautic_macos_ensure_brew
cosmonautic_macos_ensure_brew_cask    "docker"
cosmonautic_macos_ensure_brew_formula "docker"
cosmonautic_macos_ensure_brew_formula "docker-compose"

docker run --rm --privileged multiarch/qemu-user-static:register --reset


