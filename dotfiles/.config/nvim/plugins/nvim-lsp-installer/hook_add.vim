lua << EOF
local lspconfig = require('lspconfig')
local lspconfig_util = require('lspconfig/util')
local lsp_installer = require('nvim-lsp-installer')
local lsp_installer_servers = require('nvim-lsp-installer.servers')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local opts = { noremap=true, silent=true }

  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', 'r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
end

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
  on_attach = on_attach,
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
  local opts = {
    on_attach = on_attach,
  }

  if server.name == 'tsserver' then
    opts.root_dir = lspconfig_util.root_pattern('node_modules')
  end

  server:setup(opts)
end)
EOF
