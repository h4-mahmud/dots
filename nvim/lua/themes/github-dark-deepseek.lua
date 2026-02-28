-- github_dark.lua
-- NvChad base46 theme based on GitHub's browser dark theme (primer dark)

local M = {}

M.base_30 = {
  white        = "#e6edf3",
  darker_black = "#010409",
  black        = "#0d1117",     -- editor background
  black2        = "#161b22",
  one_bg        = "#161b22",
  one_bg2       = "#1f252e",
  one_bg3       = "#2a313c",
  grey          = "#8b949e",     -- comments
  grey_fg       = "#8b949e",
  grey_fg2      = "#6e7681",
  light_grey    = "#b1bac4",
  red           = "#ff7b72",     -- keywords, operators
  baby_pink     = "#ffa198",
  pink          = "#ff7b72",
  line          = "#2d333b",     -- line numbers, cursor line
  green         = "#7ee05e",     -- strings (rarely used, but for ANSI)
  vibrant_green = "#7ee05e",
  blue          = "#79c0ff",     -- constants, numbers, attributes
  nord_blue     = "#79c0ff",
  yellow        = "#ffa657",     -- types, tags
  sun           = "#f0e68c",
  purple        = "#d2a8ff",     -- functions, classes
  dark_purple   = "#bc8cff",
  teal          = "#56d4dd",
  orange        = "#ffa657",
  cyan          = "#a5d6ff",     -- strings
  statusline_bg = "#161b22",
  lightbg       = "#21262d",
  pmenu_bg      = "#2d333b",
  folder_bg     = "#79c0ff",
}

M.base_16 = {
  base00 = "#0d1117", -- default background
  base01 = "#161b22", -- darker background (statusline, float)
  base02 = "#21262d", -- selection background
  base03 = "#2d333b", -- comments, line numbers
  base04 = "#6e7681", -- darker fg (inactive)
  base05 = "#e6edf3", -- default foreground
  base06 = "#b1bac4", -- light foreground (non-text)
  base07 = "#ffffff", -- bright white
  base08 = "#ff7b72", -- red (keywords)
  base09 = "#ffa657", -- orange (types)
  base0A = "#f0e68c", -- yellow (attributes, tags)
  base0B = "#7ee05e", -- green (strings, rarely used)
  base0C = "#a5d6ff", -- cyan (strings)
  base0D = "#79c0ff", -- blue (constants, numbers)
  base0E = "#d2a8ff", -- magenta (functions)
  base0F = "#bc8cff", -- dark purple (special)
}

-- Set the theme name
M.type = "dark"

M.polish_hl = {
  -- Additional syntax groups not covered by default base46
  ["@keyword"] = { fg = M.base_30.red },
  ["@keyword.operator"] = { fg = M.base_30.red },
  ["@operator"] = { fg = M.base_30.red },
  ["@punctuation.delimiter"] = { fg = M.base_30.white },
  ["@punctuation.bracket"] = { fg = M.base_30.white },
  ["@string"] = { fg = M.base_30.cyan },
  ["@string.regex"] = { fg = M.base_30.cyan },
  ["@number"] = { fg = M.base_30.blue },
  ["@boolean"] = { fg = M.base_30.blue },
  ["@function"] = { fg = M.base_30.purple },
  ["@function.builtin"] = { fg = M.base_30.purple, italic = true },
  ["@parameter"] = { fg = M.base_30.orange },
  ["@variable"] = { fg = M.base_30.white },
  ["@variable.builtin"] = { fg = M.base_30.white, italic = true },
  ["@type"] = { fg = M.base_30.orange },
  ["@type.builtin"] = { fg = M.base_30.orange, italic = true },
  ["@property"] = { fg = M.base_30.blue },
  ["@comment"] = { fg = M.base_30.grey, italic = true },
  ["@comment.todo"] = { fg = M.base_30.grey, bold = true },
  ["@markup.heading"] = { fg = M.base_30.blue, bold = true },
  ["@markup.strong"] = { bold = true },
  ["@markup.italic"] = { italic = true },
  ["@markup.strikethrough"] = { strikethrough = true },
  ["@markup.link"] = { fg = M.base_30.blue, underline = true },
  ["@markup.link.url"] = { fg = M.base_30.cyan, underline = true },
  ["@diff.plus"] = { fg = M.base_30.green },
  ["@diff.minus"] = { fg = M.base_30.red },
  ["@diff.delta"] = { fg = M.base_30.yellow },

  -- UI elements (statusline, tabs, etc.)
  StatusLine = { fg = M.base_30.white, bg = M.base_30.statusline_bg },
  StatusLineNC = { fg = M.base_30.grey_fg2, bg = M.base_30.black2 },
  TabLine = { fg = M.base_30.grey, bg = M.base_30.black2 },
  TabLineSel = { fg = M.base_30.white, bg = M.base_30.black },
  TabLineFill = { bg = M.base_30.black2 },
  Pmenu = { fg = M.base_30.white, bg = M.base_30.pmenu_bg },
  PmenuSel = { fg = M.base_30.white, bg = M.base_30.one_bg3 },
  PmenuSbar = { bg = M.base_30.one_bg2 },
  PmenuThumb = { bg = M.base_30.grey },
  CursorLine = { bg = M.base_30.line },
  CursorLineNr = { fg = M.base_30.white, bg = M.base_30.line },
  LineNr = { fg = M.base_30.grey },
  Visual = { bg = M.base_30.one_bg3 },
  Search = { bg = M.base_30.yellow, fg = M.base_30.black },
  IncSearch = { bg = M.base_30.orange, fg = M.base_30.black },
  Substitute = { bg = M.base_30.red, fg = M.base_30.white },
  MatchParen = { fg = M.base_30.red, bold = true, underline = true },
  ColorColumn = { bg = M.base_30.line },
  SignColumn = { bg = M.base_30.black },
  Folded = { fg = M.base_30.grey, bg = M.base_30.one_bg },
  FloatBorder = { fg = M.base_30.grey, bg = M.base_30.black2 },
  NormalFloat = { bg = M.base_30.black2 },
  DiagnosticError = { fg = M.base_30.red },
  DiagnosticWarn = { fg = M.base_30.yellow },
  DiagnosticInfo = { fg = M.base_30.blue },
  DiagnosticHint = { fg = M.base_30.purple },
  DiagnosticUnderlineError = { undercurl = true, sp = M.base_30.red },
  DiagnosticUnderlineWarn = { undercurl = true, sp = M.base_30.yellow },
  DiagnosticUnderlineInfo = { undercurl = true, sp = M.base_30.blue },
  DiagnosticUnderlineHint = { undercurl = true, sp = M.base_30.purple },
}

return M
