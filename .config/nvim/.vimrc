set nocompatible

" ########################################## plugins
call plug#begin()
Plug 'tpope/vim-sensible'
Plug 'junegunn/fzf', { 'tag': '*' }
Plug 'junegunn/fzf.vim'
Plug 'nvim-treesitter/nvim-treesitter', { 'tag': '*', 'do': ':TSUpdate'}
Plug 'fatih/vim-go', { 'tag': '*', 'do': ':GoUpdateBinaries' }
Plug 'vim-ruby/vim-ruby', { 'tag': '*' }
Plug 'lewis6991/gitsigns.nvim', { 'as': 'gitsigns' }
Plug 'tpope/vim-fugitive'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'NLKNguyen/papercolor-theme'
Plug 'famiu/bufdelete.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua', { 'tag': '*' }
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-pack/nvim-spectre'
Plug 'Isrothy/neominimap.nvim', { 'as': 'neominimap', 'tag': '*' }
Plug 'JamesClonk/sops.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'lukas-reineke/indent-blankline.nvim', { 'tag': '*' }
Plug 'ThePrimeagen/harpoon', { 'branch': 'harpoon2' }
Plug 'stevearc/oil.nvim', { 'tag': '*' }
Plug 'dense-analysis/ale'
call plug#end()
syntax on
filetype plugin indent on
" ########################################## EOF plugins

" ########################################## theme
" themeing
"source ~/.bash/users/.vimrc_theme_light
set background=dark
silent! colorscheme catppuccin-mocha
" ########################################## EOF theme

" base config values
"set autoread
set mouse=
set wildmenu
"set laststatus=2
"set showtabline=2
set number
set showmatch
set showmode
set cursorline
"set colorcolumn=160
set scrolloff=7
set list
set shiftround
set tabstop=4
set shiftwidth=4
set softtabstop=4
set incsearch
set ignorecase
set smartcase
set hlsearch
set clipboard+=unnamedplus
set updatetime=1000
set signcolumn=number
set termguicolors
set maxmempattern=4000

"press F2 to toggle paste on/off
:noremap <silent> <F2> :set invpaste paste?<CR>
"set pastetoggle=<F2>
"press F3 to toggle highlighting on/off, and show current value
:noremap <silent> <F3> :set hlsearch! hlsearch?<CR>
"press F4 to toggle line numbers and indent characters on/off -> implemented as a lua function in neovim (see init.lua)
":noremap <silent> <F4> :Neominimap toggle<CR> :Neominimap refresh<CR> :set invnumber! invnumber?<CR> :set list! list?
":noremap <silent> <F5> :NvimTreeToggle<CR>
":noremap <silent> <F6> :Oil --float<CR>
":noremap <silent> <F8> :Neominimap toggle<CR>
":noremap Y yy
":noremap gn :bnext<CR>
":noremap gp :bprevious<CR>
":noremap gd :bdelete<CR>
"map some useful movements
":nnoremap <silent> <PageUp> <C-u>zz " see PageUp() function further down below
":nnoremap <silent> <PageDown> <C-d>zz " see PageDown() function further down below
:nnoremap <silent> G Gzz
:nnoremap <silent> <A-Up> 5k
:nnoremap <silent> <A-Down> 5j
"move forward/backwards between buffers (quick "tab"-switching)
:nnoremap <silent> + :bn<CR>
:nnoremap <silent> _ :bp<CR>
"search and replace with spectre, search file contents with FZF+Ripgrep
:noremap <C-f> :Rg<CR>
:noremap <C-h> :Spectre<CR>
"map leader key
let mapleader = ","
"open terminal
":map <leader>t :below :term<CR>:startinsert<CR>
"allow escaping terminal-mode via Esc
:tnoremap <Esc> <C-\><C-n>
"allow movement from terminal-mode
:tnoremap <C-w> <C-\><C-N><C-w>

" colorscheme switcher
function CycleColorscheme()
    if g:colors_name == "catppuccin-mocha"
        exec "set background=light"
        exec "colorscheme PaperColor"
        echom "Colorscheme set to [PaperColor:light] ..."
    elseif g:colors_name == "PaperColor" && &background == "light"
        exec "set background=dark"
        exec "colorscheme PaperColor"
        echom "Colorscheme set to [PaperColor:dark] ..."
    elseif g:colors_name == "PaperColor" && &background == "dark"
        exec "set background=light"
        exec "colorscheme catppuccin-latte"
        echom "Colorscheme set to [catppuccin-latte] ..."
    elseif g:colors_name == "catppuccin-latte"
        exec "set background=dark"
        exec "colorscheme catppuccin-frappe"
        echom "Colorscheme set to [catppuccin-frappe] ..."
    elseif g:colors_name == "catppuccin-frappe"
        exec "set background=dark"
        exec "colorscheme catppuccin-macchiato"
        echom "Colorscheme set to [catppuccin-macchiato] ..."
    else
        exec "set background=dark"
        exec "colorscheme catppuccin-mocha"
        echom "Colorscheme set to [catppuccin-mocha] ..."
    endif
endfunction
:nnoremap <silent> <F9> :call CycleColorscheme()<CR>

"dont forget to create ~/.tmp directory
set backupdir=~/.tmp,.
set directory=~/.tmp,.

" when reopening a file, jump to same position as last time
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" vim-go
let g:go_version_warning = 0
let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1

" yaml indention
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" unfold everything
set foldlevelstart=999

" ALE
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_text_changed = 'never'
let g:ale_completion_enabled = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_linters_explicit = 1
" linters/fmters needed:
" https://github.com/mvdan/sh/releases/download/v3.10.0/shfmt_v3.10.0_linux_amd64
" https://github.com/mrtazz/checkmake/releases/download/0.2.2/checkmake-0.2.2.linux.amd64
" pip install --user yamllint
" npm install -g prettier
" https://github.com/artempyanykh/marksman/releases/download/2024-12-18/marksman-linux-x64
" https://github.com/biomejs/biome/releases/download/cli%2Fv1.9.4/biome-linux-x64
" gem install standard
" go install golang.org/x/tools/gopls@latest
" https://github.com/google/yamlfmt/releases/download/v0.15.0/yamlfmt_0.15.0_Linux_x86_64.tar.gz
" go install golang.org/x/tools/cmd/goimports@latest
let g:ale_linters = {
\ 'sh':   		['shfmt'],
\ 'make':   	['checkmake'],
\ 'yaml': 		['yamllint'],
\ 'html': 		['prettier'],
\ 'htmlangular':['prettier'],
\ 'markdown': 	['marksman'],
\ 'javascript': ['biome', 'prettier'],
\ 'json': 		['biome', 'prettier'],
\ 'ruby': 		['standardrb'],
\ 'go':   		['gopls', 'gofmt']
\ }
let g:ale_fixers = {
\ 'sh':   		['shfmt'],
\ 'yaml': 		['yamlfmt'],
\ 'html': 		['prettier'],
\ 'htmlangular':['prettier'],
\ 'markdown': 	['prettier'],
\ 'javascript': ['prettier'],
\ 'json': 		['prettier'],
\ 'ruby': 		['standardrb'],
\ 'go':   		['goimports']
\ }
" move between linting errors/hints
:nmap <silent> <C-k> <Plug>(ale_previous_wrap)
:nmap <silent> <C-j> <Plug>(ale_next_wrap)

" vim-ruby to be compatible with standardrb
let g:ruby_indent_assignment_style = 'variable'
let g:ruby_indent_hanging_elements = 0

" automatically enter insert-mode when switching to a terminal
let g:previous_window = -1
function SmartInsert()
	if &buftype == 'terminal'
		if g:previous_window != winnr()
			startinsert
			"resize 15
		endif
		let g:previous_window = winnr()
	else
		let g:previous_window = -1
	endif
endfunction
au BufEnter * call SmartInsert()
au TermOpen * resize 15

" toggle terminal keybind
let g:term_buf = 0
let g:term_win = 0
let g:prev_height = 0
function! TermToggle(height)
   if win_gotoid(g:term_win) && a:height == g:prev_height
      let g:prev_height = 0
      hide
   elseif g:prev_height == 0
      let g:prev_height = a:height
      botright new
      exec "resize " . a:height
      try
         exec "buffer " . g:term_buf
      catch
         call termopen($SHELL, {"detach": 0})
         let g:term_buf = bufnr("")
         set nobuflisted
         set nohidden
         set nonumber
         set norelativenumber
         set signcolumn=no
      endtry
      startinsert!
      let g:term_win = win_getid()
   else
      let g:prev_height = a:height
      exec "resize " . a:height
      startinsert!
   endif
endfunction
:nnoremap <A-t> :call TermToggle(15)<CR>
:tnoremap <A-t> <C-\><C-n>:call TermToggle(15)<CR>
:nnoremap <A-z> :call TermToggle(50)<CR>
:tnoremap <A-z> <C-\><C-n>:call TermToggle(50)<CR>
:nnoremap <leader>t :call TermToggle(15)<CR>
:tnoremap <leader>t <C-\><C-n>:call TermToggle(15)<CR>
:nnoremap <leader>z :call TermToggle(50)<CR>
:tnoremap <leader>z <C-\><C-n>:call TermToggle(50)<CR>

" better pageup/down line jumping
function PageUp()
	let lines = line('w$') - line('w0') - 4
	exe "norm!" lines . "\<C-u>zz"
endfunction
function PageDown()
	let lines = line('w$') - line('w0') - 4
	exe "norm!" lines . "\<C-d>zz"
endfunction
:nnoremap <silent> <PageUp> :call PageUp()<CR>
:nnoremap <silent> <PageDown> :call PageDown()<CR>

" add hidden files to fzf-ripgrep
command! -bang -nargs=* Rg call fzf#vim#grep("rg --hidden --glob=!.git/ --column --line-number --no-heading --color=always --smart-case -- ".fzf#shellescape(<q-args>), fzf#vim#with_preview(), <bang>0)
command! -bang -nargs=* RG call fzf#vim#grep2("rg --hidden --glob=!.git/ --column --line-number --no-heading --color=always --smart-case -- ", <q-args>, fzf#vim#with_preview(), <bang>0)
