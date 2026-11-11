vim.opt.runtimepath:prepend(vim.fn.getcwd())
local function check()
  local lcars = require("lcars")
  local function hl(name) return vim.api.nvim_get_hl(0, { name = name, link = false }) end
  local function hex(s) return tonumber(s:sub(2), 16) end
  vim.cmd("syntax on")
  vim.cmd.colorscheme("lcars")
  assert(vim.g.colors_name == "lcars")
  assert(vim.o.background == "dark" and vim.o.termguicolors)
  assert(hl("Normal").bg == 0)
  assert(hl("Function").fg == hex("#EB943A"))
  assert(hl("@function").fg == hl("Function").fg)
  assert(hl("@lsp.type.method").fg == hl("Function").fg)
  assert(hl("DiagnosticUnderlineError").undercurl)
  assert(hl("DiagnosticSignError").fg == hl("DiagnosticError").fg)
  assert(hl("TelescopeBorder").fg == hl("FloatBorder").fg)
  assert(hl("Comment").italic)
  for i = 0, 15 do assert(vim.g["terminal_color_" .. i]:match("^#%x%x%x%x%x%x$")) end
  local palette = lcars.palette()
  palette.orange = "#FFFFFF"
  assert(lcars.palette().orange == "#EB943A")
  lcars.setup({ transparent = true, italic_comments = false,
    overrides = function(c) return { Function = { fg = c.green, bold = true } } end })
  vim.cmd.colorscheme("lcars")
  assert(hl("Normal").bg == nil and hl("SignColumn").bg == nil)
  assert(hl("NormalFloat").bg ~= nil)
  assert(not hl("Comment").italic)
  assert(hl("Function").bold and hl("Function").fg == hex("#A3C98C"))
  lcars.setup({ overrides = { Normal = { fg = "#FFFFFF", bg = "#123456" } } })
  vim.cmd.colorscheme("lcars")
  assert(hl("Normal").bg == hex("#123456"))
  lcars.setup()
  vim.cmd.colorscheme("default")
  vim.cmd.colorscheme("lcars")
  assert(hl("Normal").bg == 0 and hl("Comment").italic)
  assert(hl("Function").fg == hex("#EB943A") and not hl("Function").bold)
  local theme = require("lualine.themes.lcars")
  for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "inactive" }) do
    assert(theme[mode].a.fg and theme[mode].b.bg and theme[mode].c.bg)
  end
  vim.cmd("helptags doc")
  print("LCARS smoke tests passed")
end
local ok, err = pcall(check)
if not ok then
  vim.api.nvim_err_writeln(tostring(err))
  vim.cmd("cquit 1")
else
  vim.cmd("qa!")
end
