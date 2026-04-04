vim.api.nvim_command('set runtimepath^=~/.config/nvim')
vim.api.nvim_command('let &packpath = &runtimepath')
vim.api.nvim_command('source ~/.config/nvim/.vimrc')
-- load all nvim custom lua configuration variables
vim.api.nvim_command('source ~/.config/nvim/config.lua')

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- enable 24-bit colour
vim.opt.termguicolors = true

-- split new windows to right & below
vim.opt.splitright = true
vim.opt.splitbelow = true

-- we need bufdelete because neovim is a clownshow when it comes to closing buffers.
-- it would also close windows, causing neovim to quit prematurely when you have multiple buffers open!
vim.keymap.set("n", "bd", function()
	require('bufdelete').bufdelete(0)
end)
vim.keymap.set("n", "bD", function()
	require('bufdelete').bufdelete(0, true)
end)

require('nvim-treesitter.configs').setup({
	ensure_installed = { "lua", "markdown", "markdown_inline", "go", "gomod", "ruby", "yaml", "json", "bash", "dockerfile", "comment", "regex", "sql", "tmux" },
	sync_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

require('gitsigns').setup()
require('Comment').setup()

function _G.get_oil_winbar()
	local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
	local dir = require("oil").get_current_dir(bufnr)
	if dir then
		return vim.fn.fnamemodify(dir, ":~")
	else
		return vim.api.nvim_buf_get_name(0)
	end
end
local oil_winbar = config_oil_floating and "" or "%!v:lua.get_oil_winbar()"
local oil = require("oil")
oil.setup({
	default_file_explorer = config_oil_default_file_explorer,
	columns = {
		"icon",
		"permissions",
	},
	view_options = {
		show_hidden = config_oil_show_hidden,
		is_always_hidden = function(name, bufnr)
			local m = name:match("^.git$")
			return m ~= nil
		end,
		natural_order = "fast",
		case_insensitive = config_oil_case_insensitive,
		sort = {
			{ "name", "asc" },
			{ "type", "asc" },
		},
	},
	win_options = {
		winbar = oil_winbar,
	},
})

-- require("ibl").setup()
-- local highlight = {
--     "RainbowDelimiterRed",
--     "RainbowDelimiterYellow",
--     "RainbowDelimiterBlue",
--     "RainbowDelimiterOrange",
--     "RainbowDelimiterGreen",
--     "RainbowDelimiterViolet",
--     "RainbowDelimiterCyan",
-- }
local highlight = {
		"RainbowRed",
		"RainbowYellow",
		"RainbowBlue",
		"RainbowOrange",
		"RainbowGreen",
		"RainbowViolet",
		"RainbowCyan",
}
local hooks = require "ibl.hooks"
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
		vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
		vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
		vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
		vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
		vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
		vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
		vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)
require("ibl").setup { scope = { highlight = highlight } }

vim.g.neominimap = {
	auto_enable = config_minimap_show,
	layout = "split",
	split = {
		minimap_width = config_minimap_width,
		close_if_last_window = true,
	},
	search = {
		enabled = true,
	},
	treesitter = {
		enabled = true,
	},
}

local minimap_extension = require("neominimap.statusline").lualine_default
require('lualine').setup { extensions = { minimap_extension } }

require("bufferline").setup({
	options = {
		numbers = "none",
		indicator = {
			icon = '',
			style = 'underline',
		},
		buffer_close_icon = '',
		modified_icon = ' ',
		truncate_names = true,
		max_name_length = 22,
		tab_size = 10,
		show_buffer_close_icons = false,
		always_show_bufferline = true,
	},
})

require("nvim-tree").setup({
	hijack_cursor = true,
	view = {
		width = config_nvimtree_width,
		float = {
			enable = config_nvimtree_floating,
		},
	},
	filters = {
		git_ignored = false,
		dotfiles = false,
	},
	update_focused_file = {
		enable = true,
		update_root = {
			enable = true,
		},
	},
	diagnostics = {
		enable = true,
	},
	actions = {
		open_file = {
			quit_on_open = config_nvimtree_quit_on_open,
		},
	},
	modified = {
		enable = true,
	},
})

-- auto-open nvim-tree if no file parameter given
if vim.fn.argc(-1) == 0
	and config_oil_default_file_explorer == false
	then
	vim.cmd("NvimTreeOpen")
end
-- auto-open oil.nvim if no file parameter given
if vim.fn.argc(-1) == 0
	and config_oil_default_file_explorer == true
	and config_oil_auto_open_on_dir == true
	then
	vim.cmd("Oil")
end

require('spectre').setup({
	open_cmd = 'new',
	is_insert_mode = true,
	is_block_ui_break = true,
})

-- harpoon them files!
local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<leader>a", function()
	if(vim.v.count > 0)
	then
		harpoon:list():replace_at(vim.v.count)
	else
		harpoon:list():add()
	end
end, { silent = true })
vim.keymap.set("n", "<leader> ", "<leader>a", { remap = true, silent = true })
vim.keymap.set("n", "<leader>d", function()
	if(vim.v.count > 0)
	then
		harpoon:list():remove_at(vim.v.count)
	else
		harpoon:list():remove()
	end
end, { silent = true })
vim.keymap.set("n", "<leader>c", "<leader>d", { remap = true, silent = true })
vim.keymap.set("n", "<leader>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { silent = true })
vim.keymap.set("n", "<leader>e", "<leader>h", { remap = true, silent = true })
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { silent = true })
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { silent = true })
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { silent = true })
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { silent = true })
vim.keymap.set("n", "<leader>5", function() harpoon:list():select(5) end, { silent = true })
vim.keymap.set("n", "<leader>6", function() harpoon:list():select(6) end, { silent = true })
vim.keymap.set("n", "<leader>7", function() harpoon:list():select(7) end, { silent = true })
vim.keymap.set("n", "<leader>8", function() harpoon:list():select(8) end, { silent = true })
vim.keymap.set("n", "<leader>9", function() harpoon:list():select(9) end, { silent = true })
vim.keymap.set("n", "<leader>0", function() harpoon:list():select(10) end, { silent = true })

-- clean screen for copy selection
local clean_screen = false
vim.keymap.set("n", "<F4>", function()
	vim.cmd "set list! list?"
	vim.cmd "set invnumber! invnumber?"
	if(clean_screen)
	then
		vim.cmd "IBLEnable"
		if(config_minimap_show)
		then
			vim.cmd "Neominimap Enable"
		end
		clean_screen = false
	else
		vim.cmd "IBLDisable"
		vim.cmd "Neominimap Disable"
		clean_screen = true
	end
	vim.cmd "Gitsigns toggle_signs"
end)
vim.keymap.set("n", config_minimap_key, function()
	if(config_minimap_show)
	then
		vim.cmd "Neominimap Disable"
		config_minimap_show = false
	else
		vim.cmd "Neominimap Enable"
		config_minimap_show = true
	end
end)

-- toggle nvim-tree
vim.keymap.set("n", config_nvimtree_key, function()
	vim.cmd "NvimTreeToggle"
end)

-- toggle oil.nvim
vim.keymap.set("n", config_oil_key, function()
	if(config_oil_floating)
	then
		oil.toggle_float()
	else
		if oil.get_cursor_entry() == nil
		then
			vim.cmd "Oil"
		else
			oil.close()
		end
	end
end)

-- fix clipboard integration, we absolutely do NOT want it to overwrite the system clipboard!
vim.api.nvim_set_option("clipboard", "")

-- auto-reload files when switching to/from nvim
vim.cmd('autocmd VimResume * checktime')

