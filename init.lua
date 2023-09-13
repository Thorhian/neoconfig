vim.cmd [[
    syntax enable
    set autochdir
    set completeopt=menu,menuone,noselect
    set nocompatible
    set showmatch
    set ignorecase
    set mouse=v
    set incsearch
    set tabstop=3
    set expandtab
    set shiftwidth=3
    set autoindent
    set relativenumber
    set number
    filetype plugin indent on
    set ttyfast
    set nowrap
    tnoremap \\\ <C-\><C-n>
    
    let g:db_ui_use_nerd_fonts = 1
]]

-- Bootstrap Lazy.Nvim

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
   vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
   })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "

require("lazy").setup("plugins")
