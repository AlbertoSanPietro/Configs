"=====================================================================
" Basic Editor Settings
"=====================================================================
set number
set relativenumber
set autoindent
set tabstop=2
set shiftwidth=2
set smarttab
set softtabstop=2
set mouse=a
set modeline
set encoding=utf-8

" GUI / Terminal colors
" NOTE: To use the Hex colors (guifg) defined below, you must uncomment 
" 'set termguicolors'. Otherwise, vim uses the 'cterm' colors.
set notermguicolors
" set termguicolors

"=====================================================================
" Colorscheme & Highlight Overrides
"=====================================================================
augroup MyColors
  autocmd!
  autocmd ColorScheme lunaperche highlight Identifier guifg=#00FFFF ctermfg=Cyan
  autocmd ColorScheme lunaperche highlight Comment    guifg=#FF0000 ctermfg=Red  ctermbg=NONE
  autocmd ColorScheme lunaperche highlight String     guifg=#ff5fd7 ctermfg=206
  autocmd ColorScheme lunaperche highlight Normal     guifg=#0000FF ctermfg=Blue
  autocmd ColorScheme lunaperche highlight Number     guifg=#FFFFFF ctermfg=White
  autocmd ColorScheme lunaperche highlight Statement  guifg=#FFFF00 ctermfg=Yellow
augroup END

try
  colorscheme lunaperche
catch
  colorscheme default
endtry

"=====================================================================
" Plugins
"=====================================================================
call plug#begin('~/.config/nvim/plugged')

" --- LSP and Tooling ---
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-lint'

" --- UI / Navigation ---
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'

" --- Colors ---
Plug 'junegunn/seoul256.vim'
Plug 'morhetz/gruvbox'

" --- Syntax and Language Packs ---
Plug 'sheerun/vim-polyglot'
" Note: vim-scripts/c.vim is very old; polyglot handles C/C++ better usually.

" --- LaTeX ---
Plug 'lervag/vimtex'

" --- Java Specific ---
Plug 'mfussenegger/nvim-jdtls'

" --- Completion ---
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" --- Surround / Comment ---
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'

" --- Debugging ---
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'

" --- Formatter(s) ---
Plug 'stevearc/conform.nvim'


call plug#end()

"=====================================================================
" C/C++ filetype detection (override vim-polyglot when necessary)
"=====================================================================
" Neovim's builtin detector will use these extensions first.
lua << EOF
vim.filetype.add({
    extension = {
        c = "c",
        h = "c",
        cpp = "cpp",
        hpp = "cpp",
    },
})
EOF

" Explicitly override later filetype decisions from language plugins.
augroup CCppFiletypes
  autocmd!
  autocmd BufReadPost,BufNewFile *.c,*.h setlocal filetype=c
  autocmd BufReadPost,BufNewFile *.cpp,*.cc,*.cxx,*.hpp,*.hh,*.hxx setlocal filetype=cpp
augroup END

"=====================================================================
" Keybindings
"=====================================================================
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFocus<CR>

let g:NERDTreeDirArrowExpandable = "+"
let g:NERDTreeDirArrowCollapsible = "-"

"=====================================================================
" Modern Neovim LSP + Mason + CMP + Lint Configuration
"=====================================================================
lua << EOF
-- 1. Mason package management
require("mason").setup()

-- 2. Shared LSP completion capabilities
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
    capabilities = capabilities,
})

-- 3. LSP server settings (Neovim 0.11+ / mason-lspconfig 2.x)
vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--fallback-style=llvm",
        "--header-insertion=never",
        "--query-driver=/usr/bin/gcc,/usr/bin/g++",
    },
    filetypes = { "c", "cpp", "objc", "objcpp" },
})

vim.lsp.config("rust_analyzer", {
    settings = {
        ["rust-analyzer"] = { diagnostics = { enable = true } },
    },
})

vim.lsp.config("verible", {
    filetypes = { "verilog", "systemverilog" },
})

-- Mason now automatically enables installed language servers.
-- jdtls is excluded because it is started separately below.
require("mason-lspconfig").setup({
    ensure_installed = {
        "arduino_language_server",
        "bashls",
        "clangd",
        "gopls",
        "jdtls",
        "phpactor",
        "pyright",
        "rust_analyzer",
        "verible",
        "omnisharp",
    },
    automatic_enable = { exclude = { "jdtls" } },
})

-- 4. Setup Completion (CMP)
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    },
})

-- 5. Setup Linting (nvim-lint)
local lint = require("lint")
lint.linters_by_ft = {
    c = { "clangtidy" },
    cpp = { "clangtidy" },
}

vim.api.nvim_create_autocmd("BufWritePost", {
    callback = function() 
        -- Wrap in pcall to avoid errors if linter is missing
        pcall(function() lint.try_lint() end) 
    end,
})
EOF

"=====================================================================
" Java LSP (jdtls) — load per Java file
"=====================================================================
lua << EOF
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function(args)
        local jdtls = require("jdtls")
        local file = vim.api.nvim_buf_get_name(args.buf)
        if file == "" then return end

        -- Prefer the root of a Maven/Gradle project. For exercises consisting
        -- of standalone .java files, use the containing folder as the root.
        local root = vim.fs.root(args.buf, {
            "pom.xml", "build.gradle", "build.gradle.kts",
            "settings.gradle", "settings.gradle.kts", "mvnw", "gradlew",
        }) or vim.fs.dirname(file)

        -- Avoid workspace collisions between directories with the same name.
        local project_name = vim.fn.fnamemodify(root, ":t")
        local project_id = vim.fn.sha256(root):sub(1, 8)
        local workspace_dir = vim.fn.stdpath("data")
            .. "/jdtls-workspace/" .. project_name .. "-" .. project_id
        vim.fn.mkdir(workspace_dir, "p")

        jdtls.start_or_attach({
            cmd = { "jdtls", "-data", workspace_dir },
            root_dir = root,
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
        })
    end,
})
EOF


"=====================================================================
" UI & Diagnostic Tweaks (Fix for missing errors)
"=====================================================================
" 1. Make the UI update faster (Default is 4000ms, which is too slow)
set updatetime=250

" 2. Configure how diagnostics are displayed
lua << EOF
vim.diagnostic.config({
    -- Show text beside the code (Virtual Text)
    virtual_text = {
        prefix = '■', -- Could be '■', '●', 'x'
        source = "always",  -- Show where the error comes from (e.g., [clang-tidy])
    },
    -- Show signs in the gutter (the left column)
    signs = true,
    -- Underline the error in the code
    underline = true,
    -- Don't update while typing (wait until you stop)
    update_in_insert = false,
    -- Sort errors by severity (Error > Warning)
    severity_sort = true,
})

-- 3. Auto-show the floating window when cursor hovers over an error
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
    callback = function()
        vim.diagnostic.open_float(nil, {
            focusable = false, 
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            source = "always",
            prefix = " ",
            scope = "cursor",
        })
    end
})
EOF

" 4. Keybinding to force-show the error (Press <Space> + e)
nnoremap <leader>e <cmd>lua vim.diagnostic.open_float()<CR>

" 5. Navigation to jump to next/prev error (Press [d or ]d)
nnoremap ]d <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap [d <cmd>lua vim.diagnostic.goto_prev()<CR>

"=====================================================================
" Auto-Formatting (Conform.nvim) - Strict "Clean C" Mode
"=====================================================================
lua << EOF
require("conform").setup({
    formatters_by_ft = {
        c = { "clang-format" },
    },

    formatters = {
        ["clang-format"] = {
            prepend_args = { 
                "--style={" ..
                    "BasedOnStyle: Google, " .. -- Defaults to 2 spaces, K&R braces
                    "IndentWidth: 2, " ..
                    "TabWidth: 2, " ..
                    "UseTab: Never, " ..
                    
                    -- STRICT RULES START HERE
                    
                    -- 1. Kill the one-liners. Force logic to be visible.
                    "AllowShortBlocksOnASingleLine: Never, " .. 
                    "AllowShortLoopsOnASingleLine: false, " ..
                    "AllowShortIfStatementsOnASingleLine: Never, " ..
                    "AllowShortFunctionsOnASingleLine: Empty, " .. -- Only allow {} for empty funcs
                    
                    -- 2. Enforce standard spacing (fix 'if(x)' -> 'if (x)')
                    "SpaceBeforeParens: ControlStatements, " .. 
                    
                    -- 3. Align pointers to the variable (char *ptr) not type (char* ptr)
                    -- This matches your current style but keeps it consistent.
                    "PointerAlignment: Right, " ..
                    
                    -- 4. Keep headers clean
                    "SortIncludes: true, " ..
                    
                    -- 5. Stop lines from running off the screen (Standard is 80, we give you 100)
                    "ColumnLimit: 100" .. 
                "}"
            },
        },
    },

    format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
    },
})
EOF
