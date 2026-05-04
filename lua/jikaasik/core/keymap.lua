vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- window management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- External open helper (non-blocking)
local function external_open(path)
	if not path or path == "" then
		vim.notify("No path to open", vim.log.levels.WARN)
		return
	end
	local cmd = (vim.fn.has("macunix") == 1) and "open" or "xdg-open"
	vim.fn.jobstart({ cmd, path }, { detach = true })
end

vim.keymap.set("n", "<leader>o", function()
	local ft = vim.bo.filetype

	-- NvimTree support
	if ft == "NvimTree" then
		local ok, api = pcall(require, "nvim-tree.api")
		if ok then
			local node = api.tree.get_node_under_cursor()
			if node and node.absolute_path then
				external_open(node.absolute_path)
				return
			end
		end
		vim.notify("No file under cursor in NvimTree", vim.log.levels.WARN)
		return
	end

	-- Neo-tree support
	if ft == "neo-tree" then
		local ok, manager = pcall(require, "neo-tree.sources.manager")
		if ok then
			local state = manager.get_state("filesystem")
			if state and state.tree then
				local node = state.tree:get_node()
				if node and node.get_id then
					external_open(node:get_id()) -- id is the absolute path
					return
				end
			end
		end
		vim.notify("No file under cursor in Neo-tree", vim.log.levels.WARN)
		return
	end

	-- Normal buffers: open the current file if it exists
	local file = vim.fn.expand("%:p")
	if file ~= "" and vim.fn.filereadable(file) == 1 then
		external_open(file)
	else
		vim.notify("Current buffer isn’t a readable file", vim.log.levels.WARN)
	end
end, { desc = "Open current file (or tree node) externally" })
