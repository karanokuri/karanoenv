lua << EOF
local lspconfig = require('lspconfig')
local lspconfig_util = require('lspconfig/util')
local lsp_installer = require('nvim-lsp-installer')
local lsp_installer_servers = require('nvim-lsp-installer.servers')

lsp_installer.settings {
  install_root_dir = os.getenv('HOME')..'/.cache/lsp_servers'
}
lsp_installer.on_server_ready(function (server) server:setup {} end)

local ok, rust_analyzer = lsp_installer_servers.get_server('rust_analyzer')
if ok and not rust_analyzer:is_installed() then
    rust_analyzer:install()
end

local ok, tsserver = lsp_installer_servers.get_server('tsserver')
if ok and not tsserver:is_installed() then
    tsserver:install()
end

lspconfig.denols.setup{
  init_options = {
    enable = true,
    lint = false,
    unstable = false
  },
  root_dir = function(fname)
    if lspconfig_util.root_pattern('node_modules')(fname) then
      return
    end
    return lspconfig_util.root_pattern('deno.json', 'deno.jsonc', '.git')(fname)
  end,
}

lsp_installer.on_server_ready(function(server)
    local opts = {}

    if server.name == 'tsserver' then
        opts.root_dir = lspconfig_util.root_pattern('node_modules')
    end

    server:setup(opts)
end)
EOF
