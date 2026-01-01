{ lib
, makeWrapper
, vim-full
, vimPlugins
, flutter
, dart
, symlinkJoin

# For Flutter Linux desktop development.
, pkg-config
, gnumake
, ninja
, xdg-user-dirs
, mpv-unwrapped

# For Flutter web development.
# NOTE: The web browser is not provided by this package. It must already be installed.
, chromeExecutable ? "brave"
}: let
  runtimeDependencies = lib.makeBinPath [ flutter dart pkg-config gnumake ninja xdg-user-dirs ];

  vimPackage = vim-full.customize {
    name = "vim";
    vimrcConfig.packages.myVimPackage = with vimPlugins; {
      start = [ vim-solarized8 fugitive vim-wayland-clipboard dart-vim-plugin vim-lsc vim-flutter ];
    };

    vimrcConfig.customRC = ''
      set nocompatible
      set tabstop=2       " The width of a TAB is set to 2.
                          " Still it is a \t. It is just that
                          " Vim will interpret it to be having
                          " a width of 2.
      
      set shiftwidth=2    " Indents will have a width of 2
      
      set softtabstop=2   " Sets the number of columns for a TAB
      
      set expandtab       " Expand TABs to spaces
      
      set number          " Enable numbering
      set smartindent     " Enable C-style, yet unstrict, automatic identation.

      set path+=**        " Search in subfolders when finding files.
      set wildmenu        " Display matching files during tab completion.
      set complete+=kspell " Enable dictionary lookups when using omni completion.

      set background=dark " Solarized theme
      syntax enable
      colorscheme solarized8

      let g:termdebug_wide = 163 " Open a vertical split for GDB debugging
      let g:dart_style_guide = 2
      let g:dart_format_on_save = v:true
      let g:lsc_server_commands = {'dart': '${dart}/bin/dart ${dart}/bin/snapshots/analysis_server.dart.snapshot --lsp'}
      let g:lsc_enable_autocomplete = v:true
      let g:lsc_auto_map = v:true
      let g:flutter_show_log_on_run = 'tab'
      let g:flutter_close_on_quit = 1
      nnoremap <leader>fa :FlutterRun<cr>
      nnoremap <leader>fq :FlutterQuit<cr>
      nnoremap <leader>fr :FlutterHotReload<cr>
      nnoremap <leader>fR :FlutterHotRestart<cr>
      nnoremap <leader>fD :FlutterVisualDebug<cr>
    '';
  };
in symlinkJoin {
  name = "vim";
  buildInputs = [ makeWrapper ];
  paths = [ vimPackage ];
  postBuild = ''
    wrapProgram $out/bin/vim \
      --prefix PATH : ${runtimeDependencies} \
      --set CHROME_EXECUTABLE ${chromeExecutable} \
      --set LD_LIBRARY_PATH ${lib.strings.makeLibraryPath [ mpv-unwrapped ]}

    wrapProgram $out/bin/gvim \
      --prefix PATH : ${runtimeDependencies} \
      --set CHROME_EXECUTABLE ${chromeExecutable} \
      --set LD_LIBRARY_PATH ${lib.strings.makeLibraryPath [ mpv-unwrapped ]}
  '';

  meta = {
    description = "A VIM environment configured for a good Flutter development experience, including the dependencies needed to develop tiny audio player";
    longDescription = "Designed to be used with 'nix run'. Dev tools are made available within the VIM terminal. Includes the following VIM plugins: https://github.com/tpope/vim-fugitive, https://github.com/dart-lang/dart-vim-plugin/, https://github.com/natebosch/vim-lsc, https://github.com/thosakwe/vim-flutter";
    mainProgram = "gvim";
  };
}

