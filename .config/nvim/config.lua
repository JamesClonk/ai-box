-- =====================================================================================================================
-- custom configuration variables
-- =====================================================================================================================

-- =====================================================================================================================
-- minimap
config_minimap_key = "<F8>"
config_minimap_show = false -- display minimap at startup (can also be toggled with keybind at runtime)
config_minimap_width = 16 -- minimap width

-- =====================================================================================================================
-- nvim-tree file explorer
config_nvimtree_key = "<F6>"
config_nvimtree_width = 50
config_nvimtree_floating = false -- display as a floating window?
config_nvimtree_quit_on_open = true -- hide again after opening a file?

-- =====================================================================================================================
-- oil.nvim file explorer
config_oil_key = "<F5>"
config_oil_default_file_explorer = true -- is oil the default file explorer? (instead of nvim-tree)
config_oil_auto_open_on_dir = true -- automatically open oil on empty "vim" during startup
config_oil_floating = true -- display as a floating window? (when opening by keybind)
config_oil_show_hidden = true -- show hidden "." files?
config_oil_case_insensitive = true -- sort files case insensitive?
