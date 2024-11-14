# commasemi.nvim

A Neovim plugin for smart toggling of comma and semicolon at the end of lines. Handles comments across multiple languages intelligently.

## ✨ Features

- Toggle between comma and semicolon at line endings
- Preserves inline comments
- Smart toggle behavior:
  - If no punctuation exists → adds the character
  - If same character exists → removes it
  - If different character exists → replaces it
- Works with multiple comment styles across languages
- Supports Visual mode for multiple line toggling
- Supports JavaScript, TypeScript, PHP, Python, Ruby, Rust, Go, C/C++, Lua, HTML, CSS, and more

## 📦 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):
```lua
{
  "saifulapm/commasemi.nvim",
  lazy = false, -- make sure to set this to false or set keys = { '<LocalLeader>,', '<LocalLeader>;' }
  opts = {
    leader = "<localleader>" -- optional, defaults to <localleader>
  }
}
```

## 🚀 Usage

After setup, you get two keymaps in both normal and visual modes:
- `<localleader>,` - Toggle comma
- `<localleader>;` - Toggle semicolon

### Examples

#### Basic Usage
```javascript
// Start with no punctuation
const foo = 'bar'

// After <localleader>,
const foo = 'bar',

// After <localleader>, again (removes comma)
const foo = 'bar'

// After <localleader>;
const foo = 'bar';

// After <localleader>, (replaces semicolon with comma)
const foo = 'bar',
```

#### Visual Mode
```javascript
// Select multiple lines and toggle
const foo = 'bar'
const baz = 'qux'
const data = { x: 1 }

// After visual select and <localleader>,
const foo = 'bar',
const baz = 'qux',
const data = { x: 1 },
```

#### With Comments
```javascript
// Works with inline comments
const foo = 'bar' // some comment
const foo = 'bar', // some comment

// Works with block comments
const data = { x: 1 } /* block comment */
const data = { x: 1 }, /* block comment */
```

#### Different Languages
```php
// PHP
$foo = 'bar' // comment
$foo = 'bar'; // comment

// With block comments
$data = array() /* comment */
$data = array(); /* comment */
```

```python
# Python
x = 42  # comment
x = 42,  # comment
```

## ⚙️ Configuration

```lua
require('commasemi').setup({
  leader = '<localleader>' -- optional, defaults to <localleader>
})
```

## 🔍 Supported Comment Styles

Works with various comment styles:
- `//` - JavaScript, TypeScript, PHP, C, C++, Go, Rust
- `#` - Python, Ruby, Shell scripts
- `--` - Lua, SQL
- `/**/` - CSS, C-style block comments
- `<!---->` - HTML, XML
- And more!

## 📄 License

MIT

## 🤝 Contributing

Contributions are welcome! Feel free to submit a Pull Request.
