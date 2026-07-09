return {
  "justinmk/vim-sneak",
  lazy = false,
  event = { "BufReadPost", "BufNewFile" },
  keys = { -- not map in Select mode (to not break snippets expansion)
    { mode = { 'n', 'x', 'o' }, 's', '<Plug>Sneak_s', },
    { mode = { 'n', 'x', 'o' }, 'S', '<Plug>Sneak_S', },
    { mode = { 'n', 'x', 'o' }, 'f', '<Plug>Sneak_f', },
    { mode = { 'n', 'x', 'o' }, 'F', '<Plug>Sneak_F', },
    { mode = { 'n', 'x', 'o' }, 't', '<Plug>Sneak_t', },
    { mode = { 'n', 'x', 'o' }, 'T', '<Plug>Sneak_T', },
  },
}
