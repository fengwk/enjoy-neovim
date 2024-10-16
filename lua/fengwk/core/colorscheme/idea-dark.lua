-- darcula-solid/init.lua
-- Mantainer: Briones Dos Santos Gabriel <@briones-gabriel>
-- last update: 2021-05-16
--
-- Built with,
--
--        ,gggg,
--       d8" "8I                         ,dPYb,
--       88  ,dP                         IP'`Yb
--    8888888P"                          I8  8I
--       88                              I8  8'
--       88        gg      gg    ,g,     I8 dPgg,
--  ,aa,_88        I8      8I   ,8'8,    I8dP" "8I
-- dP" "88P        I8,    ,8I  ,8'  Yb   I8P    I8
-- Yb,_,d88b,,_   ,d8b,  ,d8b,,8'_   8) ,d8     I8,
--  "Y8P"  "Y888888P'"Y88P"`Y8P' "YY8P8P88P     `Y8

local lush = require 'lush'
local hsl = lush.hsl

--------------------------------------------------

-- GUI options
local bf, it, un = 'bold', 'italic', 'underline'

-- Base colors
-- local c0 = hsl(240, 1, 15)
local c0 = hsl(225, 6, 13) -- 新版idea的背景色，对比度更高
local c1 = c0.lighten(5)
local c2 = c1.lighten(2)
local c3 = c2.lighten(20).sa(10)
local c4 = c3.lighten(10)
local c5 = c4.lighten(20)
local c6 = c5.lighten(70)
local c7 = c6.lighten(80)

-- Color palette
local red     = hsl(1, 77, 59)
local salmon  = hsl(10,  90, 70)
local orange  = hsl(27, 61, 50)
local yellow  = hsl(37, 100, 71)

local green   = hsl(101, 29, 47)
local teal    = hsl(150,  40, 50)
local cyan    = hsl(180, 58, 38)

local blue    = hsl(215, 80, 63).li(10)
local purple  = hsl(279, 30, 62)
local magenta = hsl(310, 40, 64)

-- Set base colors
local bg      = c0    -- base background
local overbg  = c1    -- other backgrounds
local subtle  = c2    -- out-of-buffer elements

local fg      = hsl(210, 7, 82)
local comment = green.darken(10)    -- comments
local folder  = hsl(202, 9, 57)
local treebg  = hsl(220, 3, 19)
local mid     = c2.lighten(10)   -- either foreground or background
local faded   = fg.darken(45)    -- non-important text elements
local pop     = c7

return lush(function(injected_functions) 
local sym = injected_functions.sym
return {
Normal       { fg=fg,      bg=bg };
NormalFloat  { fg=fg,      bg=overbg };
NormalNC     { fg=fg,      bg=bg.da(10) }; -- normal text in non-current windows

Comment      { fg=comment,  gui=it };
Whitespace   { fg=mid };                  -- 'listchars'
Conceal      { fg=hsl(0, 0, 25) };
NonText      { fg=treebg };              -- characters that don't exist in the text
SpecialKey   { Whitespace };              -- Unprintable characters: text displayed differently from what it really is


Cursor       { fg=bg,      bg=fg };
TermCursor   { fg=bg,      bg=fg };
ColorColumn  { bg=overbg };
CursorColumn { bg=subtle };
CursorLine   { CursorColumn };
MatchParen   { fg=pop,     bg=mid };

LineNr       { fg=faded };
CursorLineNr { fg=orange };
SignColumn   { LineNr };
VertSplit    { fg=overbg,  bg=bg };    -- column separating vertically split windows
Folded       { fg=comment, bg=overbg };
FoldColumn   { LineNr };

Pmenu        { bg=overbg };                -- Popup menu normal item
PmenuSel     { bg=mid };                   -- selected item
PmenuSbar    { Pmenu };                    -- scrollbar
PmenuThumb   { PmenuSel };                 -- Thumb of the scrollbar
WildMenu     { Pmenu };                    -- current match in 'wildmenu' completion
QuickFixLine { fg=pop };                   -- Current |quickfix| item in the quickfix window

StatusLine   { bg=subtle };
StatusLineNC { fg=faded,   bg=overbg };

TabLine      { bg=mid };                   -- not active tab page label
TabLineFill  { bg=overbg };                -- where there are no labels
TabLineSel   { bg=faded };                 -- active tab page label

Search       { fg=bg,      bg=yellow };    -- Last search pattern highlighting (see 'hlsearch')
IncSearch    { Search };                   -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
Substitute   { Search };                   -- |:substitute| replacement text highlighting

Visual       { bg=hsl(210, 52, 31) };                    -- Visual mode selection
VisualNOS    { bg=subtle };                -- Visual mode selection when Vim is "Not Owning the Selection".

ModeMsg      { fg=faded };                 -- 'showmode' message (e.g. "-- INSERT -- ")
MsgArea      { Normal };                   -- Area for messages and cmdline
MsgSeparator { fg=orange };                -- Separator for scrolled messages `msgsep` flag of 'display'
MoreMsg      { fg=green };                 -- |more-prompt|
Question     { fg=green };                 -- |hit-enter| prompt and yes/no questions
ErrorMsg     { fg=red };                   -- error messages on the command line
WarningMsg   { fg=red };                   -- warning messages

Directory    { fg=blue };                  -- directory names (and other special names in listings)
Title        { fg=blue };                  -- titles for output from ":set all" ":autocmd" etc.

DiffAdd      { fg=green.da(20) };
DiffDelete   { fg=red };
DiffChange   { fg=yellow.da(20) };
DiffText     { DiffChange, gui=un };
DiffAdded    { DiffAdd };
DiffRemoved  { DiffDelete };

SpellBad     { fg=red,     gui=un };
SpellCap     { fg=magenta, gui=un };
SpellLocal   { fg=orange,  gui=un };
SpellRare    { fg=yellow,  gui=un };



---- Language Server Protocol highlight groups ---------------------------------

LspReferenceText                  { bg=mid };    -- highlighting "text" references
LspReferenceRead                  { bg=mid };    -- highlighting "read" references
LspReferenceWrite                 { bg=mid };    -- highlighting "write" references

-- base highlight groups. Other LspDiagnostic highlights link to these by default (except Underline)
LspDiagnosticsDefaultError           { fg=red };
LspDiagnosticsDefaultWarning         { fg=yellow };
LspDiagnosticsDefaultInformation     { fg=fg };
LspDiagnosticsDefaultHint            { fg=teal };

--LspDiagnosticsVirtualTextError       { };    -- "Error" diagnostic virtual text
--LspDiagnosticsVirtualTextWarning     { };    -- "Warning" diagnostic virtual text
--LspDiagnosticsVirtualTextInformation { };    -- "Information" diagnostic virtual text
--LspDiagnosticsVirtualTextHint        { };    -- "Hint" diagnostic virtual text
LspDiagnosticsUnderlineError         { gui=un };    -- underline "Error" diagnostics
LspDiagnosticsUnderlineWarning       { gui=un };    -- underline "Warning" diagnostics
LspDiagnosticsUnderlineInformation   { gui=un };    -- underline "Information" diagnostics
LspDiagnosticsUnderlineHint          { gui=un };    -- underline "Hint" diagnostics
--LspDiagnosticsFloatingError          { };    -- color "Error" diagnostic messages in diagnostics float
--LspDiagnosticsFloatingWarning        { };    -- color "Warning" diagnostic messages in diagnostics float
--LspDiagnosticsFloatingInformation    { };    -- color "Information" diagnostic messages in diagnostics float
--LspDiagnosticsFloatingHint           { };    -- color "Hint" diagnostic messages in diagnostics float
--LspDiagnosticsSignError              { };    -- "Error" signs in sign column
--LspDiagnosticsSignWarning            { };    -- "Warning" signs in sign column
--LspDiagnosticsSignInformation        { };    -- "Information" signs in sign column
--LspDiagnosticsSignHint               { };    -- "Hint" signs in sign column



---- Standard highlight groups -------------------------------------------------
-- See :help group-name

Constant       { fg=magenta };
Number         { fg=blue };
Float          { Number };
Boolean        { Constant };
Character      { fg=orange };
String         { fg=green };

Identifier     { fg=fg };
Function       { fg=yellow };

Statement      { fg=orange }; -- (preferred) any statement
Conditional    { Statement };
Repeat         { Statement };
Label          { Statement };       -- case, default, etc.
Operator       { fg=fg };
Keyword        { Statement };    -- any other keyword
Exception      { fg=red };

-- PreProc        { fg=orange };    --  generic Preprocessor
PreProc        { fg=hsl(56, 35, 54) };    --  generic Preprocessor
Include        { PreProc };    -- preprocessor #include
Define         { PreProc };    -- preprocessor #define
Macro          { PreProc };    -- same as Define
PreCondit      { PreProc };    -- preprocessor #if, #else, #endif, etc.

Type           { fg=fg };
StorageClass   { fg=magenta };    -- static, register, volatile, etc.
-- Structure      { fg=magenta };    -- struct, union, enum, etc.
Structure      { fg=fg };    -- struct, union, enum, etc.
Typedef        { Type };

Special        { fg=orange };  -- (preferred) any special symbol
SpecialChar    { Special };    -- special character in a constant
Tag            { fg=yellow };  -- you can use CTRL-] on this
Delimiter      { Special };    -- character that needs attention
SpecialComment { Special };    -- special things inside a comment
Debug          { Special };    -- debugging statements

Underlined { gui = un };
Bold       { gui = bf };
Italic     { gui = it };
Ignore     { fg=faded };           --  left blank, hidden  |hl-Ignore|
Error      { fg=red };             --  any erroneous construct
Todo       { gui=bf };  --  anything that needs extra attention



---- TREESITTER ----------------------------------------------------------------

sym "@constant"                 { Constant };
sym "@constant.builtin"         { Constant,   gui=it };    -- constant that are built in the language: `nil` in Lua.
sym "@constant.macro"           { Constant,   gui=bf };    -- constants that are defined by macros: `NULL` in C.
sym "@number"                   { Number };
sym "@float"                    { Float };
sym "@boolean"                  { Boolean };
sym "@character"                { Character };
sym "@string"                   { String };
sym "@string.regex"             { Character };
sym "@string.escape"            { Character };             -- escape characters within a string
sym "@symbol"                   { fg=green, gui=it };      -- For identifiers referring to symbols or atoms.

sym "@field"                    { fg=purple };
sym "@property"                 { fg=purple };
sym "@parameter"                { fg=fg };
sym "@parameter.reference"      { fg=fg };
sym "@variable"                 { fg=fg };                 -- Any variable name that does not have another highlight
sym "@variable.builtin"         { Constant,      gui=it }; -- Variable names that are defined by the languages like `this` or `self`.

sym "@function"                 { Function };
sym "@function.builtin"         { Function };
sym "@function.macro"           { Function };              -- macro defined fuctions: each `macro_rules` in Rust
sym "@method"                   { Function };
sym "@constructor"              { fg=fg };                 -- For constructor: `{}` in Lua and Java constructors.
sym "@keyword.function"         { Keyword };

sym "@keyword"                  { Keyword };
sym "@conditional"              { Conditional };
sym "@repeat"                   { Repeat };
sym "@label"                    { Label };
sym "@operator"                 { Operator };
sym "@exception"                { Exception };

sym "@namespace"                { PreProc };               -- identifiers referring to modules and namespaces.
sym "@annotation"               { PreProc };               -- C++/Dart attributes annotations that can be attached to the code to denote some kind of meta information
sym "@attribute"                { PreProc };               -- Unstable
sym "@include"                  { PreProc };               -- includes: `#include` in C `use` or `extern crate` in Rust or `require` in Lua.

sym "@type"                     { Type };
sym "@type.builtin"             { Type,     gui=it };

sym "@punctuation.delimiter"    { Delimiter };             -- delimiters ie: `.`
sym "@punctuation.bracket"      { fg=fg };                 -- brackets and parens.
sym "@punctuation.special"      { Delimiter };             -- special punctutation that does not fall in the catagories before.

sym "@comment"                  { Comment };
sym "@tag"                      { Tag };                   -- Tags like html tag names.
sym "@tag.delimiter"            { Special };               -- Tag delimiter like < > /
sym "@text"                     { fg=fg };
sym "@text.emphasis"            { fg=fg,     gui=it };
sym "@text.underline"           { fg=fg,     gui=un };
sym "@text.strike"              { Comment,   gui=un };
sym "@text.strong"              { fg=fg,     gui=bf };
sym "@text.title"               { fg=orange };             -- Text that is part of a title
sym "@text.literal"             { String };                -- Literal text
sym "@text.uri"                 { fg=green, gui=it };      -- Any URI like a link or email

sym "@error"                    { fg=red };                -- syntax/parser errors.


-- Other stuff
HelpHyperTextJump {fg=yellow};
markdownLinkText {fg=fg};

-- NvimTree
NvimTreeNormal       { bg=treebg, fg=fg };
NvimTreeIndentMarker { fg=hsl(204, 3, 32) };
NvimTreeRootFolder   { fg=folder };
NvimTreeFolderIcon   { fg=folder };
}end)
