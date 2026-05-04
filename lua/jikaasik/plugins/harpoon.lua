-- ~/.config/nvim/lua/plugins/harpoon.lua
return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		-- Single shared instance for all Harpoon APIs (prevents "settings = nil" issue)
		local harpoon = require("harpoon")

		harpoon:setup({
			settings = {
				save_on_toggle = true,
				sync_on_ui_close = true,
				-- keep lists per project (CWD)
				key = function()
					return vim.loop.cwd()
				end,
			},
		})

		-- Use UI from the SAME harpoon instance
		local ui = harpoon.ui
		local function list()
			return harpoon:list()
		end

		---------------------------------------------------------------------------
		-- Telescope picker for Harpoon (works with Harpoon 2)
		---------------------------------------------------------------------------
		local has_telescope, telescope = pcall(require, "telescope")
		if has_telescope then
			local conf = require("telescope.config").values
			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			local function harpoon_picker()
				local l = list()
				pickers
					.new({}, {
						prompt_title = "Harpoon",
						finder = finders.new_table({
							results = l:display(), -- Harpoon 2 provides display() with { idx, value }
						}),
						sorter = conf.generic_sorter({}),
						attach_mappings = function(bufnr, map)
							local function select_current()
								local entry = action_state.get_selected_entry()
								actions.close(bufnr)
								if entry and entry.value and entry.value.idx then
									l:select(entry.value.idx)
								end
							end
							map("i", "<CR>", select_current)
							map("n", "<CR>", select_current)
							return true
						end,
					})
					:find()
			end

			vim.keymap.set("n", "<leader>hf", harpoon_picker, { desc = "Harpoon: Telescope picker", silent = true })
		end

		---------------------------------------------------------------------------
		-- Keymaps
		---------------------------------------------------------------------------
		local function map(lhs, rhs, desc)
			vim.keymap.set("n", lhs, rhs, { desc = desc, silent = true })
		end

		-- Add current file
		map("<leader>ha", function()
			list():add()
		end, "Harpoon: add file")

		-- Quick menu (use UI from same instance; pass SAME list)
		map("<leader>hh", function()
			ui:toggle_quick_menu(list())
		end, "Harpoon: toggle menu")

		-- Navigate between marks
		map("<leader>hn", function()
			list():next()
		end, "Harpoon: next mark")
		map("<leader>hp", function()
			list():prev()
		end, "Harpoon: previous mark")

		-- Direct jumps (1..5)
		map("<leader>h1", function()
			list():select(1)
		end, "Harpoon: select 1")
		map("<leader>h2", function()
			list():select(2)
		end, "Harpoon: select 2")
		map("<leader>h3", function()
			list():select(3)
		end, "Harpoon: select 3")
		map("<leader>h4", function()
			list():select(4)
		end, "Harpoon: select 4")
		map("<leader>h5", function()
			list():select(5)
		end, "Harpoon: select 5")

		-- Optional: remove current buffer from list
		map("<leader>hr", function()
			list():remove()
		end, "Harpoon: remove current")

		-- Optional: clear all for this project
		map("<leader>hc", function()
			list():clear()
		end, "Harpoon: clear list")
	end,
}
