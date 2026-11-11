local c = require("lcars.palette")
local function mode(accent)
  return {
    a = { fg = c.black, bg = accent, gui = "bold" },
    b = { fg = c.text, bg = c.selection },
    c = { fg = c.muted, bg = c.surface },
  }
end
return {
  normal = mode(c.orange), insert = mode(c.green), visual = mode(c.african_violet),
  replace = mode(c.error), command = mode(c.barley), inactive = mode(c.comment),
}
