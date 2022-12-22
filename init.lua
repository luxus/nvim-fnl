local function prerequisites(name, url)
  -- To manage the version of repo, the path should be where your plugin manager will download it.
  -- In this example, I use lazy.nvim because it specifies its default download path,
  -- and it manages plugins without 'packpath'. Adjust `dir` if you prefer another plugin manager.
	local dir = vim.fn.stdpath("data") .. "/lazy"
	local path = dir .. "/" .. name
	if not vim.loop.fs_stat(path) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"--single-branch",
			url,
			path,
		})
	end
	vim.opt.runtimepath:prepend(path)
end

-- Install your favorite plugin manager.
prerequisites("lazy.nvim", "https://github.com/folke/lazy.nvim")
-- prerequisites("packer.nvim", "https://github.com/wbthomason/packer.nvim")
-- prerequisites("dein.vim", "https://github.com/Shougo/dein.vim")

-- Install macros like nvim-laurel
prerequisites("nvim-laurel", "https://github.com/aileot/nvim-laurel")

-- Install a runtime compiler if you feel like
prerequisites("hotpot.nvim", "https://github.com/rktjmp/hotpot.nvim")

require("hotpot").setup({
	compiler = {
		macros = {
			env = "_COMPILER",
			allowedGlobals = false,
		},
	},
})

require("load-plugins.by-lazy")
