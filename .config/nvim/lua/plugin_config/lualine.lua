local hasModule, module = pcall(require, 'lualine')

if not hasModule then
	return
end

module.setup {
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = {
			'mode',
			{
				'filename',
				symbols = {
					modified = '●', -- Text to show when the file is modified.
					readonly = '🔒', -- Text to show when the file is non-modifiable or readonly.
					unnamed = '', -- Text to show for unnamed buffers.
					newfile = '', -- Text to show for newly created file before first write
				},
			},
		},
		lualine_b = {
			'branch',
			'diff',
			{
				'diagnostics',
				update_in_insert = true, -- Update diagnostics in insert mode.
				always_visible = false, -- Show diagnostics even if there are none.
			},
		},
		lualine_c = {
			{
				'filename',
				path = 3, -- 0: Just the filename
							-- 1: Relative path
							-- 2: Absolute path
							-- 3: Absolute path, with tilde as the home directory
				symbols = {
					modified = '', -- Text to show when the file is modified.
					readonly = '', -- Text to show when the file is non-modifiable or readonly.
					unnamed = '', -- Text to show for unnamed buffers.
					newfile = '', -- Text to show for newly created file before first write
				},
			},
		},
		lualine_x = {
			'encoding',
			'fileformat',
			'filetype',
		},
		lualine_y = {
			{
				'windows',
				show_filename_only = true, -- Shows shortened relative path when set to false.
				show_modified_status = true, -- Shows indicator when the window is modified.
				mode = 0,       -- 0: Shows window name
								-- 1: Shows window index
								-- 2: Shows window name + window index

				max_length = vim.o.columns / 3, -- Maximum width of windows component,
													-- it can also be a function that returns
													-- the value of `max_length` dynamically.
				filetype_names = {
					TelescopePrompt = 'Telescope',
					dashboard = 'Dashboard',
					packer = 'Packer',
					fzf = 'FZF',
					alpha = 'Alpha',
				},                               -- Shows specific window name for that filetype ( { `filetype` = `window_name`, ... } )
				disabled_buftypes = { 'quickfix', 'prompt' }, -- Hide a window if its buffer's type is disabled
																-- Automatically updates active window color to match color of other components (will be overidden if buffers_color is set)
				use_mode_colors = true,
			},
		},
		lualine_z = {
			'selectioncount',
			'progress',
			'location',
		},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = {
			{
				'tabs',
				--max_length = vim.o.columns,
				max_length = vim.o.columns * 9 / 10, -- Maximum width of tabs component.
													-- Note:
													-- It can also be a function that returns
													-- the value of `max_length` dynamically.
				mode = 1, -- 0: Shows tab_nr
							-- 1: Shows tab_name
							-- 2: Shows tab_nr + tab_name

				-- Automatically updates active tab color to match color of other components (will be overidden if buffers_color is set)
				use_mode_colors = true,

				fmt = function(name, context)
					local fn = vim.fn
					local buflist = fn.tabpagebuflist(context.tabnr)
					local winnr = fn.tabpagewinnr(context.tabnr)
					local bufnr = buflist[winnr]
					local getbufvar = fn.getbufvar
					local mod = getbufvar(bufnr, '&mod')
					local readonly = getbufvar(bufnr, '&readonly')
					local modifiable = getbufvar(bufnr, '&modifiable')
					local filetype = getbufvar(bufnr, '&filetype')
					local buftype = getbufvar(bufnr, '&buftype')

					local dev
					local icon = ''
					local status, _ = pcall(require, 'nvim-web-devicons')
					if not status then
						dev, _ = '', ''
					elseif filetype == 'TelescopePrompt' then
						dev, _ = require('nvim-web-devicons').get_icon('telescope')
					elseif filetype == 'fugitive' then
						dev, _ = require('nvim-web-devicons').get_icon('git')
					elseif filetype == 'vimwiki' then
						dev, _ = require('nvim-web-devicons').get_icon('markdown')
					elseif buftype == 'terminal' then
						dev, _ = require('nvim-web-devicons').get_icon('zsh')
					elseif fn.isdirectory(name) == 1 then
						dev, _ = '', nil
					else
						dev, _ = require('nvim-web-devicons').get_icon(name, fn.expand('#' .. bufnr .. ':e'))
					end
					if dev then
						icon = dev .. ' '
					end

					return icon .. name .. (
						modifiable ~= 1 and ' 🔒' or (
							readonly == 1 and ' ○' or (
								mod == 1 and ' ●' or ''
							)
						)
					)
				end
			},
		},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = { --TODO: add something here
		},
		lualine_z = {},
	},
	winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	inactive_winbar = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	extensions = {},
}
