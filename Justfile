update-everything: update-nix update-brew

update-nix:
				nix flake update
				sudo darwin-rebuild switch  --flake .

update-brew:
				brew update
				brew upgrade --no-ask

gc: gc-nix gc-brew gc-mise

gc-nix:
				sudo nix-collect-garbage --delete-older-than 90d

gc-brew:
				brew autoremove
				brew cleanup --prune=30

gc-mise:
				mise prune

preview-zap:
				nix eval --raw .#darwinConfigurations.Auri.config.homebrew.brewfile | HOMEBREW_NO_AUTO_UPDATE=1 brew bundle cleanup --zap --file=-
