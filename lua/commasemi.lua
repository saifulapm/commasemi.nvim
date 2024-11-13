-- lua/commasemi.lua
local M = {}

M.toggle = function(character)
  local api = vim.api
  local line = api.nvim_get_current_line()

  -- First find proper comment position
  local content, comment

  -- Look for comment patterns that are preceded by whitespace
  local comment_pos = line:find('%s+//') -- JavaScript/TypeScript, PHP, C, C++, Go, Rust
    or line:find('%s+#') -- Python, Ruby, Perl, Shell, YAML
    or line:find('%s+%-%-') -- Lua, SQL
    or line:find('%s+/%*') -- CSS, C-style multi-line
    or line:find('%s+<!%-%-') -- HTML, XML
    or line:find('%s+;') -- Assembly, Lisp, Clojure
    or line:find('%s+%%') -- LaTeX
    or line:find('%s+//') -- Swift
    or line:find('%s+"""') -- Python multi-line
    or line:find('%s+%%%') -- Erlang
    or line:find('%s+%*') -- Doc comments
    or line:find('%s+%<%!') -- JSP
    or line:find('%s+%<%%-') -- ERB
    or line:find('%s+///') -- Rust doc comments
    or line:find('%s+"""') -- Python docstring
    or line:find('%s+%[%[') -- Lua multi-line

  if comment_pos then
    content = line:sub(1, comment_pos - 1)
    comment = line:sub(comment_pos)
  else
    content = line
    comment = ''
  end

  -- Trim trailing spaces from content
  content = content:gsub('%s*$', '')

  -- Check for both semicolon and comma at the end
  local last_char = content:sub(-1)
  local new_content

  if last_char == ',' or last_char == ';' then
    -- If already has a punctuation
    if last_char == character then
      -- Remove if same character
      new_content = content:sub(1, -2)
    else
      -- Replace with new character
      new_content = content:sub(1, -2) .. character
    end
  else
    -- Add new character if no punctuation
    new_content = content .. character
  end

  -- Reconstruct the line
  local new_line
  if comment ~= '' then
    new_line = new_content .. comment -- Comment already includes leading space
  else
    new_line = new_content
  end

  return api.nvim_set_current_line(new_line)
end

M.setup = function(opts)
  opts = opts or {}
  local leader = opts.leader or '<localleader>'

  -- Set up mappings for comma and semicolon
  vim.keymap.set('n', leader .. ',', function() M.toggle(',') end, { desc = 'Toggle comma' })
  vim.keymap.set('n', leader .. ';', function() M.toggle(';') end, { desc = 'Toggle semicolon' })
end

return M
