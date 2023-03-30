require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
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
    }
  },
  sections = {
    lualine_a = {
		{
			'filename',
			symbols = {
				modified = '●',      -- Text to show when the file is modified.
				readonly = '',      -- Text to show when the file is non-modifiable or readonly.
				unnamed = '', -- Text to show for unnamed buffers.
				newfile = '',     -- Text to show for newly created file before first write
			},
		},
	},
    lualine_b = {
		'branch',
		'diff',
		{
			'diagnostics',
			update_in_insert = true, -- Update diagnostics in insert mode.
        	always_visible = false,   -- Show diagnostics even if there are none.
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
				modified = '',      -- Text to show when the file is modified.
				readonly = '',      -- Text to show when the file is non-modifiable or readonly.
				unnamed = '', -- Text to show for unnamed buffers.
				newfile = '',     -- Text to show for newly created file before first write
			},
		},
	},
    lualine_x = {
		'encoding',
		'fileformat',
		'filetype',
	},
    lualine_y = {
		'progress',
	},
    lualine_z = {
		'location',
		'mode',
	}
  },
  --[[inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
		{
			'filename',
			symbols = {
				modified = '●',      -- Text to show when the file is modified.
				readonly = '',      -- Text to show when the file is non-modifiable or readonly.
				unnamed = '', -- Text to show for unnamed buffers.
				newfile = '',     -- Text to show for newly created file before first write
			},
		},
	},
    lualine_x = {
		'location',
	},
    lualine_y = {},
    lualine_z = {}
  },--]]
  --[[tabline = {
    lualine_a = {
		{
			'tabs',
			mode = 2, -- 0: Shows tab_nr
                	  -- 1: Shows tab_name
                	  -- 2: Shows tab_nr + tab_name
		},
	},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },--]]
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
