local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
vim.keymap.set("n", "<C-p>", builtin.git_files, {})
vim.keymap.set("n", "<leader>ps", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
-- Telescope: open selection(s) externally via `open` / `xdg-open`
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local function external_open(path)
	if not path or path == "" then
		vim.notify("No path to open", vim.log.levels.WARN)
		return
	end
	local cmd = (vim.fn.has("macunix") == 1) and "open" or "xdg-open"
	-- non-blocking
	vim.fn.jobstart({ cmd, vim.fn.fnamemodify(path, ":p") }, { detach = true })
end

-- Try to resolve a usable filepath from different pickers (files, grep, buffers, oldfiles, etc.)
local function entry_path(entry)
	return entry.path or entry.filename or entry.value or (type(entry[1]) == "string" and entry[1])
end

local function open_current_or_multi(prompt_bufnr)
	local picker = action_state.get_current_picker(prompt_bufnr)
	local selections = picker:get_multi_selection()
	if #selections > 0 then
		for _, e in ipairs(selections) do
			local p = entry_path(e)
			if p then
				external_open(p)
			end
		end
	else
		local e = action_state.get_selected_entry()
		local p = e and entry_path(e)
		if p then
			external_open(p)
		end
	end
end

require("telescope").setup({
	defaults = {
		mappings = {
			-- insert mode mappings inside Telescope
			i = {
				["<C-o>"] = open_current_or_multi, -- open selection(s) externally
			},
			-- normal mode mappings inside Telescope
			n = {
				["<C-o>"] = open_current_or_multi,
				["o"] = open_current_or_multi, -- handy in normal-mode pickers
			},
		},
	},
})
