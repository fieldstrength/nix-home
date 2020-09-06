{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "cliff";
  home.homeDirectory = "/Users/cliff";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";

  home.packages = [
    pkgs.fzf
    pkgs.zathura
    pkgs.jq
    pkgs.tree
    pkgs.ripgrep
    (let neuronRev = "30c72026e094f22dba96af64b123cfc265141411";
         neuronSrc = builtins.fetchTarball "https://github.com/srid/neuron/archive/${neuronRev}.tar.gz";
    in import neuronSrc {})
  ];

  programs.git = {
      enable = true;
      userEmail = "cs.hbar@gmail.com";
  };

  programs.tmux = {
    enable = true;
    shortcut = "a";
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = ''
      colorscheme gruvbox
      let g:airline_powerline_fonts = 1

      let g:netrw_liststyle=3

      set number
      set relativenumber

      " Delete trailing whitespace on save
      autocmd BufWritePre * :%s/\s\+$//e

      """"""""""""" latex config """""""""""""
      let g:tex_flavor='latex'
      let g:vimtex_view_method='zathura'
      let g:vimtex_quickfix_mode=1
      set conceallevel=2
      let g:tex_conceal='abdmg'

      """"""""""""" Snippets """""""""""""
      let g:UltiSnipsExpandTrigger = '<tab>'
      let g:UltiSnipsJumpForwardTrigger = '<tab>'
      let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

      let g:UltiSnipsSnippetDirectories=["mathSnippets"]

    '';
    plugins = with pkgs.vimPlugins; [
      gruvbox
      zenburn

      vim-airline
      vim-airline-themes

      ultisnips

      neuron-vim
      vimtex
      vim-nix
      haskell-vim
      vim-markdown
      idris-vim
    ];
  };

}
