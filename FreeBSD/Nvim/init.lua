vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.smarttab = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"


local aug = vim.api.nvim_create_augroup("MyColors", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = aug,
  pattern = "lunaperche",
  callback = function()
    vim.api.nvim_set_hl(0, "Identifier", { fg = "#7AA2F7" })
    vim.api.nvim_set_hl(0, "Comment",    { fg = "#FF0000" })
    vim.api.nvim_set_hl(0, "String",     { fg = "#ff5fd7" })
    vim.api.nvim_set_hl(0, "Normal",     { fg = "#6B7280" })
    vim.api.nvim_set_hl(0, "Number",     { fg = "#FFFFFF" })
    vim.api.nvim_set_hl(0, "Statement",  { fg = "#FFFF00" })
		vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = "#6B7280" })
		vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = "#4B5563" })
		vim.api.nvim_set_hl(0, "@type", { fg = "#A3BFFA" })
		vim.api.nvim_set_hl(0, "@function", { fg = "#93C5FD" })
		--vim.api.nvim_set_hl(0, "Normal", { fg = "#E6E6E6" })
  end,
})

vim.cmd.colorscheme("lunaperche")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
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

require("lazy").setup({

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = {
          "c", "cpp", "lua", "go", "rust",
          "python", "javascript", "bash",
          "java", "haskell",
        },
        highlight = {
          enable = true,
        },
      })
    end,
  },

  -- Completion engine
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- UI
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-tree/nvim-tree.lua" },

  -- LSP config repo (still needed for server definitions)
  { "neovim/nvim-lspconfig" },
})

vim.cmd.colorscheme("lunaperche")

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  severity_sort = true,
})

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
    { name = "luasnip" },
  },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("clangd", { capabilities = capabilities })
vim.lsp.config("gopls", { capabilities = capabilities })
vim.lsp.config("rust_analyzer", { capabilities = capabilities })
vim.lsp.config("pyright", { capabilities = capabilities })
vim.lsp.config("hls", { capabilities = capabilities })
vim.lsp.config("ts_ls", { capabilities = capabilities }) -- IMPORTANT
vim.lsp.config("bashls", { capabilities = capabilities })

vim.lsp.config("jdtls", { capabilities = capabilities})



vim.lsp.enable({
  "clangd",
  "gopls",
  "rust_analyzer",
  "pyright",
  "jdtls",
  "hls",
  "ts_ls",
  "bashls",
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.c", "*.h" },
  callback = function()
    vim.fn.jobstart({ "clang-format", "-i", vim.fn.expand("%") }, {
      detach = true,
    })
  end,
})

vim.keymap.set("n", "<C-t>", ":NvimTreeToggle<CR>", { silent = true })
