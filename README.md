# Neovim

My daily Neovim configuration: a small core, lazy-loaded plugins, native LSP configuration, and direct integration with the tools I use around the editor.

## Startup

Median headless startup is **18.9 ms** across nine warm-cache runs on Neovim 0.12.4, NixOS, and a Ryzen 7 7800X3D:

```sh
NVIM_LOG_FILE=/dev/null nvim --headless -i NONE --startuptime startup.log +qa
```

The measurement loads this configuration and the installed plugin set. It is machine-specific and included as a reproducible reference rather than a portable guarantee.

## What is inside

- native Neovim LSP configuration for TypeScript, Rust, Zig, Lua, shell, JSON, YAML, and Biome;
- lazy-loaded completion, formatting, diagnostics, treesitter, navigation, and Git tooling;
- Oil for filesystem editing and Snacks for focused pickers;
- project-aware search and replace;
- Herdr integration for sending selections, files, diagnostics, and quickfix entries to coding agents;
- a restrained statusline, breadcrumbs, key hints, and Markdown support.

Optional workflows live under `lua/plugins/extras` instead of loading by default.

## Install

The complete Nix and Home Manager setup lives in [`rzssh/dotfiles`](https://github.com/rzssh/dotfiles). To use only this configuration:

```sh
git clone https://github.com/rzssh/nvim ~/.config/nvim
nvim
```

The first launch installs `lazy.nvim` and the pinned plugins from `lazy-lock.json`.

## Check

```sh
stylua --check .
NVIM_LOG_FILE=/dev/null nvim --headless -i NONE +qa
```
