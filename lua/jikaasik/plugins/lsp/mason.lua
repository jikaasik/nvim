-- ~/.config/nvim/lua/plugins/mason.lua
return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "neovim/nvim-lspconfig",
    "jose-elias-alvarez/null-ls.nvim", -- hook formatters/linters into LSP
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")
    local lspconfig = require("lspconfig")
    local null_ls = require("null-ls")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      ensure_installed = {
        "tsserver",
        "html",
        "cssls",
        "tailwindcss",
        "svelte",
        "lua_ls",
        "graphql",
        "emmet_ls",
        "prismals",
        "pyright",
        "pylsp",
      },
    })

    mason_tool_installer.setup({
      ensure_installed = {
        -- Python tooling
        "black",
        "isort",
        "flake8",
        -- Lua
        "stylua",
      },
      auto_update = false,
      run_on_start = true,
    })

    -- null-ls: formatters/linters with custom args
    null_ls.setup({
      sources = {
        -- Black with 93 cols
        null_ls.builtins.formatting.black.with({
          extra_args = { "--line-length", "93" },
        }),
        -- isort (not a linter, but can wrap imports; keep it aligned)
        null_ls.builtins.formatting.isort.with({
          extra_args = { "--line-length", "93" },
        }),
        -- Flake8 diagnostics at 93 cols (so it won't warn at 79)
        null_ls.builtins.diagnostics.flake8.with({
          extra_args = { "--max-line-length", "93" },
        }),
      },
    })

    ---------------------------------------------------------------------------
    -- LSP servers
    ---------------------------------------------------------------------------

    -- pyright: no line-length checks; safe default setup
    lspconfig.pyright.setup({})

    -- pylsp: disable pycodestyle to avoid duplicate E501 at 79
    -- (If you prefer to KEEP pycodestyle but change the limit, see alt config below)
    lspconfig.pylsp.setup({
      settings = {
        pylsp = {
          plugins = {
            pycodestyle = { enabled = false }, -- prevents the extra 79-col warning (E501)
            -- If you use other pylsp plugins you can manage them here too:
            -- pylsp_mypy = { enabled = false },
            -- pydocstyle = { enabled = false },
          },
        },
      },
    })

    --[[  ALTERNATIVE: keep pycodestyle but set to 93 (remove the block above and use this)
    lspconfig.pylsp.setup({
      settings = {
        pylsp = {
          plugins = {
            pycodestyle = {
              enabled = true,
              maxLineLength = 93,
            },
          },
        },
      },
    })
    --]]
  end,
}
