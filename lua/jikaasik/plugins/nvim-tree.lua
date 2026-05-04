-- ~/.config/nvim/lua/plugins/nvim-tree.lua
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings from nvim-tree docs
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      view = {
        width = 35,
        relativenumber = true,
      },
      actions = {
        open_file = {
          window_picker = { enable = false },
        },
      },
      filters = {
        custom = { ".DS_Store" },
      },
      git = {
        ignore = false,
        enable = false,
      },

      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        -- keep defaults
        api.config.mappings.default_on_attach(bufnr)

        local function km_opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- buffer-local flag tracking whether the tree is globally expanded
        local function get_flag()
          local ok, v = pcall(vim.api.nvim_buf_get_var, bufnr, "nvtree_expanded_all")
          return ok and v or false
        end
        local function set_flag(v)
          pcall(vim.api.nvim_buf_set_var, bufnr, "nvtree_expanded_all", v)
        end
        set_flag(false)

        -- Global toggle: expand everything <-> collapse everything
        local function toggle_global()
          if get_flag() then
            api.tree.collapse_all()
            set_flag(false)
          else
            api.tree.expand_all()
            set_flag(true)
          end
        end

        -- Shift+Tab = global fold/unfold (Emacs-style)
        vim.keymap.set("n", "<S-Tab>", toggle_global, km_opts("Toggle expand/collapse ALL (Shift+Tab)"))

        -- Optional: dedicated single-action bindings
        vim.keymap.set("n", "Z", api.tree.expand_all, km_opts("Expand ALL"))
        vim.keymap.set("n", "W", api.tree.collapse_all, km_opts("Collapse ALL"))

        -- (Optional) If your terminal doesn't send <S-Tab>, add a fallback:
        -- vim.keymap.set("n", "<Tab>", toggle_global, km_opts("Toggle expand/collapse ALL (Tab fallback)"))
      end,
    })

    -- Global keymap to toggle the tree
    vim.keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
  end,
}
