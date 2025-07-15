local jdtls = require "jdtls"

local root_markers = { "pom.xml", "build.gradle", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == nil then
  return
end

local workspace_dir = vim.fn.stdpath "cache" .. "/jdtls/workspace/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
vim.fn.mkdir(workspace_dir, "p")

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
      vim.fn.glob("~/tools/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1),
    },
  },
  on_attach = function(client, bufnr)
    require("jdtls.setup").add_commands()
    require("nvchad.configs.lspconfig").on_attach(client, bufnr)
  end,
  capabilities = require("nvchad.configs.lspconfig").capabilities,
}

jdtls.start_or_attach(config)
