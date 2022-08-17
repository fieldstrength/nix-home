{ config, pkgs, ... }:

  let haskellSnippets  = import ./snippets/haskell.nix;
      mathSnippets     = import ./snippets/math.nix;
      markdownSnippets = import ./snippets/markdown.nix;

      mainPackages = with pkgs; [
        bat
        exa
        fzf
        gitAndTools.diff-so-fancy
        jq
        ripgrep
        silver-searcher
        tealdeer
        tree
        zathura
      ];

      workPackages = with pkgs; [
        awscli
        docker-compose
        git-crypt
        gnupg
        nodejs
        pgcli
        postgresql
      ];

      work = false;
      homePackages = if work
        then mainPackages ++ workPackages
        else mainPackages;

  in

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "eastwood";
    };
  };

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
  home.stateVersion = "22.05";

  home.packages = homePackages;

  programs.git = {
    enable = true;
    userName = "Cliff Harvey";
    userEmail = "cs.hbar@gmail.com";

    # signing = {
    #   key = "";
    #   signByDefault = true;
    # };

    aliases = {
      s = "status";
      d = "diff";
      dc = "diff --cached";
      l = "log --graph --stat";
      ll = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
      pop = "reset --soft HEAD^";
    };

    extraConfig = {
      core.pager = "diff-so-fancy | less --tabs=4 -RFX";

      push.default = "current";
      pull.default = "current";
      pull.ff = "only";

      diff.colorMoved = true;

      color.ui = true;
      color.branch.current = "green bold";
      color.branch.local = "yellow bold";
      color.branch.remote = "blue bold";
      color.diff = {
        new = "green bold";
        old = "red bold";
        meta = "yellow bold";
        frag = "blue reverse";
        moved = "true";
      };
      color.status = {
        added = "green bold";
        changed = "yellow bold";
        untracked = "black bold";
      };
    };

    ignores = [
      # Haskell
      "dist"
      "dist-newstyle/"
      "*.hi"
      "*.o"
      "*.dyn_hi"
      "*.dyn_o"
      ".stack-work"

      # Mac defaults from GitHub for Mac
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
    ];
  };

  programs.tmux = {
    enable = true;
    shortcut = "a";
    escapeTime = 0;
    extraConfig = ''
      # Use default shell
      set-option -g default-shell ''${SHELL}

      # More user-friendly pane-splitting
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Sometimes this setting helps, sometimes not.
      # Unfortunately I cant enable only the scroll-wheel instead of all mouse events
      set-option -g mouse on

      # Ease config reload
      bind r source-file ~/.config/tmux/tmux.conf
    '';
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = ''
      """"""""""""" Styling """""""""""""
      " set background=light
      " colorscheme 1989
      colorscheme gruvbox

      let g:airline_powerline_fonts = 1
      let g:airline_theme = 'kolor'

      let g:netrw_liststyle=3

      set number
      set mouse=nicr

      " Delete trailing whitespace on save
      autocmd BufWritePre * :%s/\s\+$//e


      """"""""""""" Mappings """""""""""""
      " easy access to system register
      nnoremap <Leader>y "*y
      vnoremap <Leader>y "*y
      nnoremap <Leader>p "*p
      vnoremap <Leader>p "*p
      nnoremap <Leader>P "*P
      vnoremap <Leader>P "*P
      nnoremap <Leader>d "*d
      vnoremap <Leader>d "*d


      " fuzzy search
      nnoremap <space><space> :Files<CR>
      let $FZF_DEFAULT_COMMAND = 'ag -g ""'

      " save file
      nnoremap zz :w<CR>


      """"""""""""" Visual mode bracket helpers """""""""""""
      " Press the corresponding opener to surround selected text
      "   Note: `[ means go to start of last text changed
      xnoremap { xi{}<Left><Esc>p`[v`]
      xnoremap [ xi[]<Left><Esc>p`[v`]
      xnoremap ( xi()<Left><Esc>p`[v`]


      """"""""""""" Indentation """""""""""""
      set expandtab
      set tabstop=2
      set softtabstop=2
      set shiftwidth=2


      """"""""""""" Tabs & Buffers """""""""""""
      nnoremap tn :tabnew<Space>
      nnoremap tk :tabnext<CR>
      nnoremap tj :tabprev<CR>
      nnoremap th :tabfirst<CR>
      nnoremap tl :tablast<CR>


      """"""""""""" latex config """""""""""""
      let g:tex_flavor='latex'
      let g:vimtex_view_method='zathura'
      let g:vimtex_quickfix_mode=1
      set conceallevel=2
      let g:tex_conceal='abdmg'


      """"""""""""" Table alignment """""""""""""
      " https://github.com/junegunn/vim-easy-align
      au FileType markdown vmap <Leader>t :EasyAlign*<Bar><Enter>


      """"""""""""" Snippets """""""""""""
      let g:UltiSnipsExpandTrigger = '<tab>'
      let g:UltiSnipsJumpForwardTrigger = '<tab>'
      let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

      let g:UltiSnipsSnippetDirectories=['~/.config/snips']


      """"""""""""" Conquer of Completion config """""""""""""
      " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
      nmap <silent> [[ <Plug>(coc-diagnostic-prev)
      nmap <silent> ]] <Plug>(coc-diagnostic-next)


      """"""""""""" NERDTree config """""""""""""
      map <C-n> :NERDTreeToggle<CR>


      """"""""""""" Prevent math from messing up syntax highlighting """""""""""""
      " block math region $$...$$
      syn region math start=/\$\$/ end=/\$\$/
      " inline math region $...$
      syn match math '\$[^$].\{-}\$'

      " highlight the region we defined as "math"
      hi link math Statement
    '';
    plugins = with pkgs.vimPlugins; [
      vim-colorschemes
      awesome-vim-colorschemes
      vim-colorstepper

      vim-airline
      vim-airline-themes

      ultisnips
      # auto-pairs

      nerdtree
      fzf-vim

      coc-nvim
      neuron-vim
      vimtex
      vim-nix
      haskell-vim
      dhall-vim
      vim-markdown
      idris-vim
      vim-easy-align
      lean-vim
    ];
  };

  home.file = {

    # Snippet configs. See https://github.com/SirVer/ultisnips/blob/master/doc/UltiSnips.txt

    # Haskell snippets
    ".config/snips/haskell.snippets".text = haskellSnippets;

    # Markdown snippets - Latex-specific snippets plus Markdown-specific
    ".config/snips/markdown.snippets".text = markdownSnippets + mathSnippets;

    # ghci
    ".ghci".text = ''
      :set prompt "\ESC[1;35m%s\n\ESC[0;34mλ> \ESC[m"
    '';

    # coc.vim
    ".config/nvim/coc-settings.json".text = ''
      {
       "languageserver": {
          "haskell": {
            "command": "haskell-language-server-wrapper",
            "args": ["--lsp"],
            "rootPatterns": ["*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml"],
            "filetypes": ["haskell", "lhaskell"]
          }
        }
      }
    '';
  };

}
