# Term2

## Overview
Term2 is a Neovim plugin that opens a terminal window above the current buffer, similar to how fugitive's display.

## Features
- Opens terminal in a split window above the current buffer
- Toggles terminal visibility with a single command
- Preserves terminal state between toggles
- Automatically exits insert mode when leaving terminal

## Installation

### Using packer
```lua
use {
  'franpfeiffer/term2.nvim',
  config = function()
    require('term2').setup({
      keymap = '<leader>t'
    })
  end
}
```

### Using lazy
```lua
{
  'franpfeiffer/term2.nvim',
  config = function()
    require('term2').setup({
      keymap = '<leader>t'
    })
  end
}
```

## Configuration Options
```lua
require('term2').setup({
  shell = vim.o.shell,  -- Shell to use (defaults to Neovim's shell setting)
  keymap = '<leader>t'  -- Keymap to toggle terminal (optional)
})
```

## Usage
### After install
Restart your neovim

### Commands
- `:Term2` - Toggle the terminal window

### Default Keymaps
- `<leader>t` (if configured) - Toggle terminal window
- `q` (in normal mode within terminal) - Close terminal window
- `<C-q>` (in terminal mode) - Exit terminal mode and close terminal window
- `<Esc>` (in terminal mode) - Exit terminal mode

## Requirements
- Neovim 0.7+

## License
MIT
