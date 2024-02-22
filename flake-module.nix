_:
{ self, config, lib, flake-parts-lib, ... }:
let inherit (flake-parts-lib) mkPerSystemOption;
in {
  options = {
    perSystem = mkPerSystemOption ({ pkgs, ... }:
      let
        inherit (lib) mkOption mkEnableOption types;
        runtime = {
          did_load_filetypes = mkEnableOption "did_load_filetypes";
          did_load_ftplugin = mkEnableOption "did_load_ftplugin";
          did_indent_on = mkEnableOption "did_indent_on";
          did_install_default_menus =
            mkEnableOption "did_install_default_menus";
          skip_loading_mswin = mkEnableOption "skip_loading_mswin";
        };
        runtime-plugin = {
          loaded_gzip = mkEnableOption "loaded_gzip";
          loaded_man = mkEnableOption "loaded_man";
          loaded_matchit = mkEnableOption "loaded_matchit";
          loaded_matchparen = mkEnableOption "loaded_matchparen";
          loaded_netrwPlugin = mkEnableOption "loaded_netrwPlugin";
          loaded_remote_plugins = mkEnableOption "loaded_remote_plugins";
          loaded_shada_plugin = mkEnableOption "loaded_shada_plugin";
          loaded_spellfile_plugin = mkEnableOption "loaded_spellfile_plugin";
          loaded_tarPlugin = mkEnableOption "loaded_tarPlugin";
          loaded_2html_plugin = mkEnableOption "loaded_2html_plugin";
          loaded_tutor_mode_plugin = mkEnableOption "loaded_tutor_mode_plugin";
          loaded_zipPlugin = mkEnableOption "loaded_zipPlugin";
        };
      in {
        options.loaded-nvim = mkOption {
          description = "nvim loaded config";
          type = types.submodule {
            options = {
              package = mkOption {
                type = types.package;
                description = "neovim package";
                default = pkgs.neovim-unwrapped;
              };
            } // runtime // runtime-plugin;
          };
        };
      });
  };
  config = {
    perSystem = { config, lib, pkgs, ... }:
      let
        inherit (lib) flatten;
        inherit (lib.strings) concatStringsSep;

        cfg = config.loaded-nvim;

        excludeFiles = flatten
          ((if cfg.did_load_filetypes then [ "runtime/ftplugin.vim" ] else [ ])
            ++ (if cfg.did_load_ftplugin then
              [ "runtime/ftplugof.vim" ]
            else
              [ ])
            ++ (if cfg.did_indent_on then [ "runtime/indent.vim" ] else [ ])
            ++ (if cfg.did_install_default_menus then
              [ "runtime/menu.vim" ]
            else
              [ ])
            ++ (if cfg.skip_loading_mswin then [ "runtime/mswin.vim" ] else [ ])
            ++ (if cfg.loaded_gzip then [ "runtime/plugin/gzip.vim" ] else [ ])
            ++ (if cfg.loaded_man then [ "runtime/plugin/man.lua" ] else [ ])
            ++ (if cfg.loaded_matchit then
              [ "runtime/plugin/matchit.vim" ]
            else
              [ ]) ++ (if cfg.loaded_matchparen then
                [ "runtime/plugin/matchparen" ]
              else
                [ ]) ++ (if cfg.loaded_netrwPlugin then
                  [ "runtime/plugin/netrwPlugin.vim" ]
                else
                  [ ]) ++ (if cfg.loaded_remote_plugins then
                    [ "runtime/plugin/rplugin.vim" ]
                  else
                    [ ]) ++ (if cfg.loaded_shada_plugin then
                      [ "runtime/plugin/shada.vim" ]
                    else
                      [ ]) ++ (if cfg.loaded_spellfile_plugin then
                        [ "runtime/plugin/spellfile.vim" ]
                      else
                        [ ]) ++ (if cfg.loaded_tarPlugin then
                          [ "runtime/plugin/tarPlugin.vim" ]
                        else
                          [ ]) ++ (if cfg.loaded_2html_plugin then
                            [ "runtime/plugin/tohtml.vim" ]
                          else
                            [ ]) ++ (if cfg.loaded_tutor_mode_plugin then
                              [ "runtime/plugin/tutor.vim" ]
                            else
                              [ ]) ++ (if cfg.loaded_zipPlugin then
                                [ "runtime/plugin/zipPlugin.vim" ]
                              else
                                [ ]));
        fixupCommands =
          map (target: "rm $out/share/nvim/${target}") excludeFiles;
      in {
        packages.loaded-nvim = cfg.package.overrideAttrs (old: {
          version = "loaded";
          postInstall = ''
            ${if old ? postInstall then old.postInstall else ""}
            ${concatStringsSep "\n" fixupCommands}
          '';
        });
      };
  };
}
