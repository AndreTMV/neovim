vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "configs.dart"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "java",
--   callback = function()
--     require "configs.jdtls"
--   end,
-- })
--
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  pattern = "*.java",
  callback = function()
    local jdtls = require "jdtls"

    local root_markers = { "pom.xml", "build.gradle", ".git" }
    local root_dir = require("jdtls.setup").find_root(root_markers)
    if root_dir == nil then
      return
    end

    local workspace_dir = vim.fn.stdpath "cache" .. "/jdtls/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
    vim.fn.mkdir(workspace_dir, "p")
    vim.bo.filetype = "java"

    local config = {
      cmd = { "/Users/andremejia/bin/jdtls-wrapper.sh", workspace_dir },
      root_dir = root_dir,
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-21",
                path = "/opt/homebrew/opt/openjdk@21",
              },
            },
          },
        },
      },
      init_options = {
        bundles = {
          vim.fn.glob(
            "~/tools/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
            1
          ),
        },
      },
      on_attach = function(client, bufnr)
        require("jdtls.setup").add_commands()
        require("nvchad.configs.lspconfig").on_attach(client, bufnr)
      end,
      capabilities = require("nvchad.configs.lspconfig").capabilities,
    }

    jdtls.start_or_attach(config)
  end,
})
