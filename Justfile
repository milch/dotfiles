update-everything: update-nix update-brew

update-nix:
				nix flake update
				sudo darwin-rebuild switch  --flake .

update-brew:
				brew update
				brew upgrade --no-ask

preview-zap:
				nix eval --raw .#darwinConfigurations.Auri.config.homebrew.brewfile | HOMEBREW_NO_AUTO_UPDATE=1 brew bundle cleanup --zap --file=-
