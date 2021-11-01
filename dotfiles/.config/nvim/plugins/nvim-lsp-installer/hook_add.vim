lua << EOF
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

lsp_installer.on_server_ready(function(server)
    local opts = {}

    -- (optional) Customize the options passed to the server
    -- if server.name == 'tsserver' then
    --     opts.root_dir = function() ... end
    -- end

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/ADVANCED_README.md
    server:setup(opts)
end)
EOF
