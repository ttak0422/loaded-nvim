<h1 align="center">
    loaded-nvim
</h1>
<div align="center">
  <img alt="neovim" src="https://img.shields.io/badge/NeoVim-57A143.svg?&style=for-the-badge&logo=neovim&logoColor=white">
  <img alt="nix" src="https://img.shields.io/badge/nix-5277C3.svg?&style=for-the-badge&logo=NixOS&logoColor=white">
  <img alt="license" src="https://img.shields.io/github/license/ttak0422/loaded-nvim?style=for-the-badge">
  <p>reusable flake module for Nix users who want to optimize Neovim startup performance</p>
</div>

## options

```nix
# e.g. best performance
loaded-nvim = {
  package = pkgs.neovim-unwrapped; # (default)
  did_load_ftplugin = true;
  did_indent_on = true;
  did_install_default_menus = true;
  skip_loading_mswin = true;
  loaded_gzip = true;
  loaded_man = true;
  loaded_matchit = true;
  loaded_matchparen = true;
  loaded_netrwPlugin = true;
  loaded_remote_plugins = true;
  loaded_shada_plugin = true;
  loaded_spellfile_plugin = true;
  loaded_tarPlugin = true;
  loaded_2html_plugin = true;
  loaded_tutor_mode_plugin = true;
  loaded_zipPlugin = true;
};
```

## usage

```nix
imports = [ inputs.loaded-nvim.flakeModule ];

# set as you like (see options)
loaded-nvim = {
  # ...
};

# loaded-nvim provides a `loaded-nvim` package that you set up.
#
# └───packages
#     ├───aarch64-darwin
#     │   └───loaded-nvim: package 'neovim-unwrapped-loaded'
#     ├───aarch64-linux
#     │   └───loaded-nvim omitted (use '--all-systems' to show)
#     ├───x86_64-darwin
#     │   └───loaded-nvim omitted (use '--all-systems' to show)
#     └───x86_64-linux
#         └───loaded-nvim omitted (use '--all-systems' to show)
# 
# e.g. package = self.packages.${system}.loaded-nvim;
```
