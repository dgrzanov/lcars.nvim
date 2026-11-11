local M = {}
local defaults = { transparent = false, italic_comments = true, overrides = {} }
local config = vim.deepcopy(defaults)

---Configure before calling :colorscheme lcars. Each call starts from defaults.
---@param opts? table
function M.setup(opts)
  config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts or {})
end

---Return an independent copy of the palette.
function M.palette()
  return vim.deepcopy(require("lcars.palette"))
end

function M.load()
  if vim.fn.has("nvim-0.9") == 0 then
    error("lcars.nvim requires Neovim 0.9 or newer")
  end
  vim.opt.termguicolors = true
  vim.opt.background = "dark"
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "lcars"
  local c = M.palette()
  local bg = config.transparent and "NONE" or c.black
  local h = {
    Normal = { fg = c.text, bg = bg },
    NormalNC = { fg = c.text, bg = bg },
    NormalFloat = { fg = c.text, bg = c.surface },
    FloatBorder = { fg = c.african_violet, bg = c.surface },
    FloatTitle = { fg = c.orange, bg = c.surface, bold = true },
    ColorColumn = { bg = c.surface },
    Cursor = { fg = c.black, bg = c.orange },
    CursorLine = { bg = c.surface },
    CursorColumn = { bg = c.surface },
    CursorLineNr = { fg = c.orange, bold = true },
    LineNr = { fg = c.comment },
    SignColumn = { fg = c.muted, bg = bg },
    FoldColumn = { fg = c.muted, bg = bg },
    Folded = { fg = c.muted, bg = c.surface },
    WinSeparator = { fg = c.border },
    EndOfBuffer = { fg = c.border },
    NonText = { fg = c.border },
    Whitespace = { fg = c.border },
    SpecialKey = { fg = c.lilac },
    Visual = { bg = c.selection },
    Search = { fg = c.black, bg = c.barley },
    IncSearch = { fg = c.black, bg = c.orange },
    CurSearch = { fg = c.black, bg = c.orange, bold = true },
    MatchParen = { fg = c.orange, bg = c.selection, bold = true },
    Pmenu = { fg = c.text, bg = c.raised },
    PmenuSel = { fg = c.black, bg = c.african_violet, bold = true },
    PmenuSbar = { bg = c.border },
    PmenuThumb = { bg = c.african_violet },
    StatusLine = { fg = c.black, bg = c.orange, bold = true },
    StatusLineNC = { fg = c.muted, bg = c.raised },
    TabLine = { fg = c.muted, bg = c.raised },
    TabLineFill = { bg = c.surface },
    TabLineSel = { fg = c.black, bg = c.african_violet, bold = true },
    WinBar = { fg = c.orange, bg = bg, bold = true },
    WinBarNC = { fg = c.muted, bg = bg },
    Title = { fg = c.orange, bold = true },
    Directory = { fg = c.barley },
    MoreMsg = { fg = c.green },
    Question = { fg = c.african_violet },
    ErrorMsg = { fg = c.error },
    WarningMsg = { fg = c.barley },
    ModeMsg = { fg = c.orange, bold = true },
    Conceal = { fg = c.muted },
    Comment = { fg = c.comment, italic = config.italic_comments },
    Constant = { fg = c.bluey },
    String = { fg = c.almond_creme },
    Character = { fg = c.almond_creme },
    Number = { fg = c.true_mauve },
    Boolean = { fg = c.bluey },
    Float = { fg = c.true_mauve },
    Identifier = { fg = c.text },
    Function = { fg = c.orange },
    Statement = { fg = c.african_violet },
    Operator = { fg = c.african_violet },
    PreProc = { fg = c.african_violet },
    Type = { fg = c.barley },
    Special = { fg = c.butterscotch },
    Delimiter = { fg = c.muted },
    Underlined = { fg = c.cyan, underline = true },
    Ignore = { fg = c.comment },
    Error = { fg = c.error, bold = true },
    Todo = { fg = c.black, bg = c.barley, bold = true },
    DiffAdd = { bg = "#19251B" },
    DiffChange = { bg = "#202039" },
    DiffDelete = { fg = c.error, bg = "#321B22" },
    DiffText = { bg = c.selection, bold = true },
    SpellBad = { sp = c.error, undercurl = true },
    SpellCap = { sp = c.barley, undercurl = true },
    SpellLocal = { sp = c.cyan, undercurl = true },
    SpellRare = { sp = c.african_violet, undercurl = true },
  }
  local links = {
    Conditional = "Statement", Repeat = "Statement", Label = "Statement",
    Keyword = "Statement", Exception = "Statement", Include = "PreProc",
    Define = "PreProc", Macro = "PreProc", PreCondit = "PreProc",
    StorageClass = "Type", Structure = "Type", Typedef = "Type",
    Tag = "Special", SpecialChar = "Special", SpecialComment = "Comment", Debug = "Special",
    ["@comment"] = "Comment", ["@string"] = "String", ["@character"] = "Character",
    ["@number"] = "Number", ["@number.float"] = "Float", ["@float"] = "Float",
    ["@boolean"] = "Boolean", ["@constant"] = "Constant", ["@constant.builtin"] = "Constant",
    ["@variable"] = "Identifier", ["@variable.builtin"] = "Special",
    ["@variable.parameter"] = "Identifier", ["@parameter"] = "Identifier",
    ["@variable.member"] = "Special", ["@field"] = "Special", ["@property"] = "Special",
    ["@function"] = "Function", ["@function.builtin"] = "Function",
    ["@function.method"] = "Function", ["@method"] = "Function", ["@constructor"] = "Type",
    ["@keyword"] = "Keyword", ["@conditional"] = "Conditional", ["@repeat"] = "Repeat",
    ["@exception"] = "Exception", ["@include"] = "Include", ["@operator"] = "Operator",
    ["@type"] = "Type", ["@type.builtin"] = "Type", ["@attribute"] = "Special",
    ["@module"] = "Type", ["@namespace"] = "Type", ["@label"] = "Label",
    ["@punctuation"] = "Delimiter", ["@tag"] = "Tag", ["@tag.attribute"] = "Special",
    ["@tag.delimiter"] = "Delimiter", ["@markup.heading"] = "Title",
    ["@markup.link"] = "Underlined", ["@markup.link.url"] = "Underlined",
    ["@markup.raw"] = "String", ["@markup.list"] = "Special",
    ["@text.title"] = "Title", ["@text.uri"] = "Underlined", ["@text.literal"] = "String",
    ["@lsp.type.class"] = "Type", ["@lsp.type.struct"] = "Type", ["@lsp.type.enum"] = "Type",
    ["@lsp.type.interface"] = "Type", ["@lsp.type.typeParameter"] = "Type",
    ["@lsp.type.function"] = "Function", ["@lsp.type.method"] = "Function",
    ["@lsp.type.variable"] = "Identifier", ["@lsp.type.parameter"] = "Identifier",
    ["@lsp.type.property"] = "Special", ["@lsp.type.enumMember"] = "Constant",
    ["@lsp.type.namespace"] = "Type", ["@lsp.type.macro"] = "PreProc",
    TelescopeNormal = "NormalFloat", TelescopeBorder = "FloatBorder",
    TelescopeTitle = "Title", TelescopeSelection = "Visual", TelescopeMatching = "Special",
    NvimTreeNormal = "Normal", NvimTreeFolderName = "Directory", NvimTreeRootFolder = "Title",
    NvimTreeWinSeparator = "WinSeparator", NeoTreeNormal = "Normal",
    NeoTreeDirectoryName = "Directory", NeoTreeRootName = "Title",
    NeoTreeFloatBorder = "FloatBorder", NeoTreeWinSeparator = "WinSeparator",
    CmpItemAbbr = "Identifier", CmpItemAbbrMatch = "Function", CmpItemKind = "Type",
    CmpItemMenu = "Comment", BlinkCmpMenu = "Pmenu", BlinkCmpMenuSelection = "PmenuSel",
    BlinkCmpLabel = "Identifier", BlinkCmpLabelMatch = "Function", BlinkCmpKind = "Type",
    LspReferenceText = "Visual", LspReferenceRead = "Visual", LspReferenceWrite = "Visual",
    LspSignatureActiveParameter = "IncSearch", LspInlayHint = "Comment",
    diffAdded = "DiagnosticOk", diffRemoved = "DiagnosticError", diffChanged = "DiagnosticInfo",
  }
  h["@markup.strong"] = { bold = true }
  h["@markup.italic"] = { italic = true }
  h["@markup.strikethrough"] = { strikethrough = true }
  h["@lsp.mod.deprecated"] = { strikethrough = true }
  for kind, color in pairs({ Error = c.error, Warn = c.barley, Info = c.bluey, Hint = c.cyan, Ok = c.green }) do
    h["Diagnostic" .. kind] = { fg = color }
    h["DiagnosticUnderline" .. kind] = { sp = color, undercurl = true }
    for _, prefix in ipairs({ "DiagnosticSign", "DiagnosticFloating", "DiagnosticVirtualText" }) do
      links[prefix .. kind] = "Diagnostic" .. kind
    end
  end
  for group, color in pairs({ GitSignsAdd = c.green, GitSignsChange = c.bluey, GitSignsDelete = c.error }) do
    h[group] = { fg = color }
  end
  for name, target in pairs(links) do h[name] = { link = target } end
  for name, value in pairs(h) do vim.api.nvim_set_hl(0, name, value) end
  local overrides = config.overrides
  if type(overrides) == "function" then overrides = overrides(c) end
  for name, value in pairs(overrides or {}) do vim.api.nvim_set_hl(0, name, value) end
  local terminal = {
    c.black, c.red, c.green, c.barley, c.bluey, c.african_violet, c.cyan, c.text,
    c.comment, c.error, c.green, c.almond_creme, c.bluey, c.true_mauve, c.cyan, "#FFFFFF",
  }
  for i, color in ipairs(terminal) do vim.g["terminal_color_" .. (i - 1)] = color end
end

return M
