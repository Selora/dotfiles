local keymaps = require("config.main_host_keymaps")

return {
	{
		"mattn/calendar-vim",
		-- lazy = false,
		config = function()
			--local diary_list = {
			--          {name = "Personal", path = os.getenv("HOME")..'/Documents/Vaults/Selora/dailies', ext = '.md'},
			--          {name = "Work", path = os.getenv("HOME")..'/Documents/Vaults/Work/dailies', ext = '.md'}
			--      }
			--vim.g.calendar_diary = diary_list

			function _G.IsObsidianNotePresent(day, month, year)
				-- Convert the date strings to numbers
				local selected_date = {
					year = tonumber(year),
					month = tonumber(month),
					day = tonumber(day),
					hour = 12,
					min = 0,
					sec = 0,
				}

				-- Convert dates to timestamps
				local selected_time = os.time(selected_date)

				-- Get the obsidian client
				local obsidian_client = require("obsidian").get_client()
				if obsidian_client == nil then
					print("Obsidian client is not initialized")
					return
				end

				-- Call the daily function with offset_days
				local note_path = obsidian_client:daily_note_path(selected_time)
				if note_path:exists() == true then
					return 1
				else
					return 0
				end
			end
			--
			-- Define a global Lua function accessible from Vimscript
			function _G.OpenObsidianDailyNoteFromCalendar(day, month, year, week, dir)
				-- Convert the date strings to numbers
				local selected_date = {
					year = tonumber(year),
					month = tonumber(month),
					day = tonumber(day),
					hour = 12,
					min = 0,
					sec = 0,
				}

				-- Convert dates to timestamps
				local selected_time = os.time(selected_date)

				-- Get the obsidian client
				local obsidian_client = require("obsidian").get_client()
				if obsidian_client == nil then
					print("Obsidian client is not initialized")
					return
				end

				-- Call the daily function with offset_days
				local note = obsidian_client:daily_note_path(selected_time, opts)

				-- Open the note in a different window
				if note then
					-- Check if there's more than one window
					if vim.fn.winnr("$") > 1 then
						-- Switch to the previous window
						vim.cmd("wincmd p")
					else
						-- Only one window (the calendar), so create a new vertical split
						vim.cmd("vsplit")
						-- Optionally, you can use 'split' for a horizontal split
					end
					obsidian_client:open_note(note)
				end
			end
			-- Set the calendar action to call the Lua function
			vim.g.calendar_action = "v:lua.OpenObsidianDailyNoteFromCalendar"
			vim.g.calendar_sign = "v:lua.IsObsidianNotePresent"
		end,
	},
}
