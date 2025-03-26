-- PLUGINS
local plugin_keymaps = { wk = {} }

-- Calendar
vim.keymap.set("n", "<leader><C-d>", "<Cmd>Calendar<cr>", { desc = "Show calendar and personal notes" })

-- Obsidian
plugin_keymaps.obsidian = {
	-- Set global vim shortcut (ex: whatever requires a cmd, the rest can be passed to obsidian-nvim itself)
	set_obsidian_keymaps = function()
		-- Open obsidian
		--vim.keymap.set("n", "<leader>oo", "<cmd>ObsidianWorkspace Personal<CR>", { desc = "Obsidian: Open personal workspace"})
		vim.keymap.set("n", "<leader>oo", function()
			vim.cmd("ObsidianWorkspace Personal")
			vim.cmd("cd ~/Documents/Vaults/Selora")
			vim.cmd("edit notes/Selora.md")
		end, { desc = "Obsidian: Open personal workspace" })
		-- TODO function like the personal workspace
		vim.keymap.set("n", "<leader>ow", function()
			vim.cmd("ObsidianWorkspace Work")
			vim.cmd("cd ~/Documents/Vaults/Work")
			vim.cmd("edit RTVault.md")
		end, { desc = "Obsidian: Open work workspace" })
		vim.keymap.set("n", "<leader>ot", "<cmd>ObsidianToday<CR>", { desc = "Obsidian: Open today's daily note" })
		vim.keymap.set(
			"n",
			"<leader>oy",
			"<cmd>ObsidianYesterday<CR>",
			{ desc = "Obsidian: Open yesterday's daily note" }
		)
		vim.keymap.set(
			"n",
			"<leader>oT",
			"<cmd>ObsidianTomorrow<CR>",
			{ desc = "Obsidian: Open tomorrow's daily note" }
		)

		-- New note
		vim.keymap.set(
			"n",
			"<leader>on",
			"<cmd>ObsidianNew<cr>",
			{ desc = "Obsidian: Create new note, prompt for title" }
		)
		-- New note, title is visual selection
		vim.keymap.set(
			"n",
			"<leader>oL",
			"<cmd>ObsidianLinkNew<cr>",
			{ desc = "Obsidian: Create new link with selected text as title" }
		)

		-- Open note under cursor with enter
		vim.keymap.set(
			"n",
			"<CR>",
			"<cmd>ObsidianFollowLink<cr>",
			{ desc = "Obsidian: Go to note underneath the cursor" }
		)
		vim.keymap.set(
			"n",
			"<leader>ob",
			"<cmd>ObsidianBackLinks<cr>",
			{ desc = "Obsidian: List all ref link to current note" }
		)
		vim.keymap.set(
			"n",
			"<leader>os",
			"<cmd>ObsidianSearch<cr>",
			{ desc = "Obsidian: Fuzzy-Search notes (use Telescope)" }
		)
		-- Below, toggling checkbox is done with markdown-nvim
		--vim.keymap.set("n", "<C-Space>", '<cmd>lua require("obsidian").util.toggle_checkbox()<cr>', { desc = "Obsidian: Toggle checkbox"})
		--vim.keymap.set("n", "<leader>o", "<cmd>Obsidian<cr>", { desc = ""})

		-- Create a new note
	end,
}

plugin_keymaps.markdown = {
	mappings = {
		inline_surround_toggle = "gs", -- (string|boolean) toggle inline style
		inline_surround_toggle_line = "gss", -- (string|boolean) line-wise toggle inline style
		inline_surround_delete = "ds", -- (string|boolean) delete emphasis surrounding cursor
		inline_surround_change = "cs", -- (string|boolean) change emphasis surrounding cursor
		link_add = "gl", -- (string|boolean) add link
		link_follow = "gx", -- (string|boolean) follow link
		go_curr_heading = "]c", -- (string|boolean) set cursor to current section heading
		go_parent_heading = "]p", -- (string|boolean) set cursor to parent section heading
		go_next_heading = "]]", -- (string|boolean) set cursor to next section heading
		go_prev_heading = "[[", -- (string|boolean) set cursor to previous section heading
	},
	-- (fun(bufnr: integer)) callback when plugin attaches to a buffer
	-- IF cursor is in a list (numbered, *, -), adds indented item below or above with <CR> in insert mode, and o or O in normal mode
	-- on_attach = function(bufnr)
	--   local map = vim.keymap.set
	--   local opts = { buffer = bufnr }
	--
	--   -- Function to check if the current line is part of a list
	--   local function isListItem()
	--     local line = vim.api.nvim_get_current_line()
	--     return line:match("^%s*[%-%*]%s+") or line:match("^%s*%d+%.%s+")
	--   end
	--
	--   -- Function to insert a list item below or perform the default 'o' action
	--   local function customO()
	--     if isListItem() then
	--       vim.cmd('MDListItemBelow')
	--     else
	--       vim.cmd('normal! o')
	--     end
	--   end
	--
	--   -- Function to insert a list item above or perform the default 'O' action
	--   local function customOUpper()
	--     if isListItem() then
	--       vim.cmd('MDListItemAbove')
	--     else
	--       vim.cmd('normal! O')
	--     end
	--   end
	--
	--   -- Function to handle Enter in insert mode
	--   local function customEnter()
	--     if isListItem() then
	--       vim.cmd('MDListItemBelow')
	--     else
	--       -- Simulate pressing Enter in insert mode, directly feed the enter keypress
	--       vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), 'n', true)
	--       -- return vim.api.nvim_replace_termcodes("<CR>", true, true, true)
	--     end
	--   end
	--
	--   -- Mapping for normal mode 'o'
	--   map('n', 'o', customO, opts)
	--
	--   -- Mapping for normal mode 'O'
	--   map('n', 'O', customOUpper, opts)
	--
	--   -- Mapping for insert mode Enter
	--   map('i', '<CR>', customEnter, opts)
	--
	--     -- Your original mappings
	--   map('n', '<c-space>', '<Cmd>MDTaskToggle<CR>', opts)
	--   map('x', '<c-space>', ':MDTaskToggle<CR>', opts)
	-- end
}

local keymaps = plugin_keymaps
return keymaps
