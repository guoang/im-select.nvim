# im-select.nvim

Switch Input Method automatically depends on Neovim's edit mode.

This repo is forked from
[keaising/im-select.nvim](https://github.com/keaising/im-select.nvim),
but has been refactored. New features:

- use `jobstart` to select IM asynchronously.
- auto select IM by both vim mode and file type.
- toggle auto IM selection at runtime.

## 1. Install binary

Please install the executable
[im-select](https://github.com/daipeihust/im-select) first.

_Note_: Putting binary into some path which Neovim can read from,
you can detect it in Neovim by:

```bash
# Windows / WSL
:!which im-select.exe
# macOS
:!which im-select
```

## 2. Install plugin

Packer

```lua
use 'guoang/im-select.nvim'
```

Plug

```vim
Plug 'guoang/im-select.nvim'
```

## 3. Config

```lua
require("im_select").setup({
 -- IM will be used in `normal` mode
 -- For Windows/WSL, default: "1033", aka: English US Keyboard
 -- For macOS, default: "com.apple.keylayout.ABC", aka: US
 -- You can use `im-select` in cli to get the IM name of you preferred
 im_normal = "com.apple.keylayout.ABC",
 -- IM will be used in `normal` mode depend on **file type**
 im_normal_ft = {
   TelescopePrompt = "com.apple.keylayout.ABC",
 },
 -- IM will be used in `insert` mode
 im_insert = "com.apple.keylayout.ABC",
 -- IM will be used in `insert` mode depend on **file type**
 im_insert_ft = {
   TelescopePrompt = "com.apple.keylayout.ABC",
   markdown = "com.apple.inputmethod.SCIM.Shuangpin",
 },
 -- Create auto command to select `im_normal` when `InsertLeave`
 auto_select_normal = true,
 -- Create auto command to select `im_insert` when `InsertEnter`
 auto_select_insert = true,
 -- keymaps to toggle auto selection
   keymaps = {
     toggle_auto_select_normal = "",
     toggle_auto_select_insert = "",
   },
})
```

_Im-select_ creates some auto-commands, use `:autocmd im-select` to inspect.
