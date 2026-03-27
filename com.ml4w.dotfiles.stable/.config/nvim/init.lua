-- 1. General Options
vim.g.mapleader = " "
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.shiftwidth = 4
opt.tabstop = 4
opt.termguicolors = true
opt.clipboard = "" -- Handled by custom OSC 52 logic
opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/site")
opt.signcolumn = "yes" 

vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Transparent Background
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- Copilot Icon Color
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

-- 2. Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 3. Unified Plugin Setup
require("lazy").setup({
  -- UI & Theme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, config = function() vim.cmd.colorscheme "catppuccin" end },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = function() require("lualine").setup() end },
  { "nvim-tree/nvim-tree.lua", config = function() require("nvim-tree").setup() end },
  { "nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Treesitter (Cross-Platform Safe)
  { 
	"nvim-treesitter/nvim-treesitter", 
    branch = "main", 
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- 1. Install your required parsers (This is safe/fast and skips if already installed)
      require("nvim-treesitter").install({ 
        "lua",
        "vim",
        "javascript",
        "typescript",
		"jsx",
        "tsx",
        "html",
        "css",
		"tailwindcss",
        "python",
        "markdown"
      })

      -- 2. The new v0.11 way to automatically start highlighting
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function(args)
          -- Gracefully start treesitter highlighting
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end
  },

  -- Native LSP (MERN & Python Focus)
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp" },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({ 
        ensure_installed = { "pyright", "ts_ls", "html", "cssls", "tailwindcss" },
        automatic_enable = true, 
      })
      vim.lsp.enable({ "pyright", "ts_ls", "html", "cssls", "lua_ls", "tailwindcss" })
    end
  },

  -- Formatting Engine
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
        },
      })
    end,
  },

  -- Copilot Core
  {
    "zbirenbaum/copilot.lua",
    config = function()
      require("copilot").setup({
        suggestion = { enabled = false }, 
        panel = { enabled = false },
      })
    end,
  },

  -- Copilot Completion Bridge
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require("copilot_cmp").setup()
    end
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      build = (function()
        if vim.uv.os_uname().sysname:find("Windows") then return nil end
        return "make install_jsregexp"
      end)(),
      dependencies = { "saadparwaiz1/cmp_luasnip", "onsails/lspkind.nvim" },
    },
    config = function()
      local cmp = require('cmp')
      local lspkind = require('lspkind')
      
      lspkind.init({ symbol_map = { Copilot = "" } })

      cmp.setup({
        snippet = { expand = function(args) require('luasnip').lsp_expand(args.body) end },
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol_text', 
            maxwidth = 50, 
            ellipsis_char = '...', 
            menu = { copilot = "[Copilot]", nvim_lsp = "[LSP]", luasnip = "[Snip]", buffer = "[Buf]" }
          })
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({ 
          { name = 'copilot', group_index = 1 },
          { name = 'nvim_lsp', group_index = 2 }, 
          { name = 'luasnip', group_index = 2 } 
        }, { 
          { name = 'buffer', group_index = 3 } 
        })
      })
    end
  },
}, { rocks = { enabled = false } })

-- 4. Keybindings
local key = vim.keymap.set
key('n', '<leader>e', ':NvimTreeToggle<CR>', { silent = true })
local builtin = require('telescope.builtin')
key('n', '<leader>ff', builtin.find_files, {})
key('n', '<leader>fg', builtin.live_grep, {})

-- Formatting Keybind
key({ 'n', 'v' }, '<leader>f', function()
  require("conform").format({ lsp_fallback = true, async = false, timeout_ms = 500 })
end, { desc = "Format file or range" })

-- LSP Power Moves
key('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename variable' })
key('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Error' })
key('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev Error' })
key('n', 'gd', vim.lsp.buf.definition, {})
key('n', 'K', vim.lsp.buf.hover, {})

-- 5. THE PERFECT CLIPBOARD (Native OSC 52)
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.v.event.regname == "" or vim.v.event.regname == "+" then
      local client = require('vim.ui.clipboard.osc52')
      client.copy('+')(vim.v.event.regcontents)
    end
  end
})

key('n', '<leader>p', '"+p', { desc = "Paste from System" })
