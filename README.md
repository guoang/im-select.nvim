# im-select.nvim

Switch Input Method automatically depends on Neovim's edit mode.

Forked from [keaising/im-select.nvim](https://github.com/keaising/im-select.nvim), with the following improvements:

- Asynchronous IM switching via `jobstart`
- Per-filetype IM selection for both normal and insert modes
- Runtime toggle of auto IM selection per buffer
- FileType autocommands for filetype-specific IM setup

## Requirements

| Platform | IM Switcher | Default Normal IM |
|----------|-------------|-------------------|
| macOS | [macism](https://github.com/laishulu/macism) | `com.apple.keylayout.ABC` |
| Windows | [im-select](https://github.com/daipeihust/im-select) | `1033` |
| WSL | [im-select](https://github.com/daipeihust/im-select) (`.exe`) | `1033` |

> Linux is not supported yet. PR welcome.

Make sure the binary is in your `$PATH`. Verify in Neovim:

```vim
" macOS
:!which macism
" Windows / WSL
:!which im-select.exe
```

## Installation

[lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'guoang/im-select.nvim',
  config = function()
    require('im_select').setup()
  end,
}
```

[packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'guoang/im-select.nvim',
  config = function()
    require('im_select').setup()
  end,
}
```

[vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'guoang/im-select.nvim'
```

## Configuration

```lua
require('im_select').setup({
  -- IM for normal mode (platform default if omitted)
  im_normal = "com.apple.keylayout.ABC",

  -- IM for insert mode (leave empty to skip switching on InsertEnter)
  im_insert = "com.apple.keylayout.ABC",

  -- Per-filetype IM overrides for normal mode
  im_normal_ft = {
    TelescopePrompt = "com.apple.keylayout.ABC",
  },

  -- Per-filetype IM overrides for insert mode
  im_insert_ft = {
    markdown = "com.apple.inputmethod.SCIM.Shuangpin",
  },

  -- Auto-switch IM on InsertLeave (default: true)
  auto_select_normal = true,

  -- Auto-switch IM on InsertEnter (default: true)
  auto_select_insert = true,

  -- Keymaps to toggle auto-switching per buffer
  keymaps = {
    toggle_auto_select_normal = "",  -- e.g. "<leader>in"
    toggle_auto_select_insert = "",  -- e.g. "<leader>ii"
  },
})
```

## Plug Mappings

The plugin registers `<Plug>` mappings that can be used in custom keymaps:

- `<Plug>ImSelect_toggle_auto_normal` -- toggle auto IM selection on `InsertLeave` for the current buffer
- `<Plug>ImSelect_toggle_auto_insert` -- toggle auto IM selection on `InsertEnter` for the current buffer

## Autocommands

Use `:autocmd im-select` to inspect the autocommands created by this plugin.
