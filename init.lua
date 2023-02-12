require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use {
		'nvim-treesitter/nvim-treesitter',
		run = function()
			local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
			ts_update()
		end,
	}
	use 'neovim/nvim-lspconfig'
	use 'williamboman/nvim-lsp-installer'
	use {'dracula/vim', as = 'dracula'}
	use 'preservim/nerdtree'

	use {
		"windwp/nvim-autopairs",
		config = function() require("nvim-autopairs").setup() end
	}

end)

require("nvim-autopairs").setup()

require'nvim-treesitter.configs'.setup {
  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,
  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,
  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
  highlight = {
    -- `false` will disable the whole extension
    enable = true,
    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

local servers
require'lspconfig'.clangd.setup {
	cmd = {
		"clangd",
	     "--background-index",
	     "-j=12",
	     "--query-driver=/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++",
	     "--clang-tidy",
	     "--clang-tidy-checks=*",
	     "--all-scopes-completion",
	     "--cross-file-rename",
	     "--completion-style=detailed",
	     "--header-insertion-decorators",
	     "--header-insertion=iwyu",
	     "--pch-storage=memory",
	}
}

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }
local function nkeymap(key, map)
	keymap('n', key, map, opts)
end
nkeymap('rn', '<cmd>lua vim.lsp.buf.rename()<cr>')
nkeymap('I', '<cmd>lua vim.lsp.buf.implementation()<cr>')
nkeymap('H', '<cmd>lua vim.lsp.buf.hover()<cr>')

nkeymap('<c-l>', ':set relativenumber<cr>')
nkeymap('<c-q>', ':set tabstop=2')
nkeymap('<c-e>', ':NERDTreeToggle<cr>')

