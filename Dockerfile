FROM nixos/nix

RUN mkdir -p ~/.config/nixpkgs
RUN echo "{ allowUnsupportedSystem = true; boot.binfmt.emulatedSystems = [ \"aarch64-linux\" ]; }" >> ~/.config/nixpkgs/config.nix

RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
RUN nix-channel --add https://nixos.org/channels/nixos-unstable nixos
RUN nix-channel --update

#ADD raspberry-pi-4.nix /tmp/raspberry-pi-4.nix
ADD rpi4.nix /tmp/raspberry-pi-4.nix

#RUN nix-env -iA 
RUN echo "extra-platforms = aarch64-linux arm-linux" >> /etc/nix/nix.conf
#RUN /root/.nix-profile/bin/nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I nixos-config=/tmp/raspberry-pi-4.nix
#RUN nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage --argstr system aarch64-linux -I nixos-config=/tmp/raspberry-pi-4.nix
RUN nix-build '<nixpkgs/nixos>' -A config.system.build.sdImage -I nixos-config=/tmp/raspberry-pi-4.nix
