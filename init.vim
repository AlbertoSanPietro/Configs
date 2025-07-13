
:set number
":set relativenumber
:set autoindent
:set tabstop=2
:set shiftwidth=2
:set smarttab
:set softtabstop=2
:set mouse=a

:set modeline

"HERE
" Enable/disable true color (choose one)
" set termguicolors    " Uncomment for GUI colors
set notermguicolors    " Uncomment for terminal colors (ctermfg)

" Define highlight overrides
augroup MyColors
  autocmd!
  autocmd ColorScheme lunaperche highlight Identifier guifg=#00FFFF ctermfg=Cyan
  autocmd ColorScheme lunaperche highlight Comment    guifg=#FF0000 ctermfg=Red ctermbg=NONE
  autocmd ColorScheme lunaperche highlight String     guifg=#ff5fd7 ctermfg=206
  autocmd ColorScheme lunaperche highlight Normal     guifg=#0000FF ctermfg=Blue
  autocmd ColorScheme lunaperche highlight Number     guifg=#FFFFFF ctermfg=White
  autocmd ColorScheme lunaperche highlight Statement  guifg=#FFFF00 ctermfg=Yellow
augroup END

" Load the colorscheme
colorscheme lunaperche



call plug#begin()
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'junegunn/seoul256.vim'
Plug 'morhetz/gruvbox'
Plug 'vim-scripts/c.vim'
Plug 'https://github.com/preservim/nerdtree'

Plug 'http://github.com/tpope/vim-surround' " Surrounding ysw)
Plug 'https://github.com/tpope/vim-commentary' " For Commenting gcc & gc
Plug 'https://github.com/ryanoasis/vim-devicons' " Developer Icons

Plug 'https://github.com/mfussenegger/nvim-jdtls'

Plug 'sheerun/vim-polyglot' "Plyglot has support for multiple languages including C/C++, Rust, PHP and more, no Java :(
"https://github.com/sheerun/vim-polyglot it does syntax highlighting
Plug 'mfussenegger/nvim-lint'

"ASM:

"Some AI crap:
Plug 'hrsh7th/cmp-nvim-lsp'     " LSP source for nvim-cmp
Plug 'hrsh7th/nvim-cmp'         " Autocompletion

Plug 'hrsh7th/cmp-buffer'       " Buffer source for nvim-cmp
Plug 'hrsh7th/cmp-path'         " Path source for nvim-cmp
Plug 'L3MON4D3/LuaSnip'         " Snippet engine
Plug 'saadparwaiz1/cmp_luasnip' " Snippet source
"Plug 'jose-elias-alvarez/null-ls.nvim' " For linters/formatters deprecated!

Plug 'mfussenegger/nvim-dap'          " Debug Adapter Protocol
Plug 'rcarriga/nvim-dap-ui'           " UI for DAP
Plug 'theHamsta/nvim-dap-virtual-text' " Virtual text support

call plug#end()
"autocmd VimEnter * NERDTree

"REMAPS
"Ctrl+t toggles the tree
nnoremap <C-t> :NERDTreeToggle<CR>
"Ctrl+f focuses 
nnoremap <C-f> :NERDTreeFocus<CR>
"


"LETS
let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsibile="-"

"I dont fucking know tbh
" LSP and Autocompletion setup
lua << EOF

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  severity_sort = true,
  update_in_insert = false,
})


-- Setup Mason for LSP management
require("mason").setup({
    ensure_installed = {
        -- LSPs
        "arduino-language-server", "bash-language-server", "clangd", "gopls",
        "jdtls", "phpactor", "pyright", "rust-analyzer", "verible", "omnisharp",
        
        -- Debuggers
        "bash-debug-adapter", "java-debug-adapter", "php-debug-adapter",
        
        -- Linters/Formatters
        "checkstyle", "clang-format", "cpplint", "cspell", "sql-formatter",
        
        -- Tools
        "cpptools", "java-test", "sqls"
    }
})

require("mason-lspconfig").setup({
    ensure_installed = {"jdtls", "clangd", "gopls", "pyright", "phpactor", "rust_analyzer"}
})



-- Setup nvim-cmp
local cmp = require('cmp')
local luasnip = require('luasnip')

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-g>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true

				}),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
        { name = 'path' },
    })
})

-- LSP capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Java LSP
require('lspconfig').jdtls.setup{
    capabilities = capabilities,
}

-- C/C++ LSP
require('lspconfig').clangd.setup{
    capabilities = capabilities,
    cmd = { "clangd", "--fallback-style=llvm", "--header-insertion=never", "--query-driver=/usr/bin/g++" },
    filetypes  = {"c", "cpp", "objc", "objcpp"},
}

--Attempt for better C++ support
-- Enhanced Linting Configuration (clang-tidy)
require('lint').linters_by_ft = {
  c = {'clangtidy'},
  cpp = {'clangtidy'},
}

--[[ For C++: create a file in the project directory: 
  compile_commands.json
Example content: 

[
  {
    "directory": "/home/luce/C-Secrets",
    "command": "g++ -std=c++17 -I/usr/include/c++/11 -I/usr/include/x86_64-linux-gnu/c++/11 -Wall -Wextra -c test.cpp",
    "file": "/home/luce/C-Secrets/test.cpp"
  }
]

--]]


-- Rust
require('lspconfig').rust_analyzer.setup{
    capabilities = capabilities,
    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                enable = true,
            },
        }
    }
}

-- Bash
require('lspconfig').bashls.setup{
    capabilities = capabilities,
    filetypes = { 'sh', 'zsh', 'bash' }
}

-- ASM
require('lspconfig').asm_lsp.setup{
    capabilities = capabilities,
    cmd = {'asm-lsp'},
    filetypes = {'asm', 's', 'S'}
}

-- PHP (using phpactor)
require('lspconfig').phpactor.setup{
    capabilities = capabilities,
}

-- Python
require('lspconfig').pyright.setup{
    capabilities = capabilities,
}

-- Verilog (using verible)
require('lspconfig').verible.setup{
    capabilities = capabilities,
    filetypes = {'verilog', 'systemverilog'}
}

-- C# (OmniSharp)
--require('lspconfig').omnisharp.setup{
  --  capabilities = capabilities,
   -- cmd = { "omnisharp", "--languageserver" },
    -- Enable semantic highlighting
    --enable_roslyn_analyzers = true,
--}

-- Go
require('lspconfig').gopls.setup{
    capabilities = capabilities,
}

-- nvim-lint setup for C (fixed linter name)
require('lint').linters_by_ft = {
    c = {'clangtidy'},  -- Changed from 'clangtidy'
    cpp = {'clangtidy'}, -- Changed from 'clangtidy'
}

-- Create autocommand to lint on save (fixed comma)
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end
}) -- Removed trailing comma here
EOF


