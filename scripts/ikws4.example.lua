--[[ 
@metadata
  return {
    name = "example",
    author = "ikws4",
    version = "1.0.0",
    description = "A complete example to introduce how to write your own scripts."
  }
@end
--]]

local config = {
  toast_msg = nil,
  text = nil,
}

local M = {}

M.setup = function(opts)
  config = table.extend(config, opts or {})

  -- Easy to import any java class and support for private field, method and constructor access
  local Toast = import("android.widget.Toast")
  local Activity = import("android.app.Activity")
  local TextView = import("android.widget.TextView")
  local Bundle = import("android.os.Bundle")
  local CharSequence = import("java.lang.CharSequence")
  local BufferType = import("android.widget.TextView$BufferType")

  if config.toast_msg then
    -- Make a toast after activity created
    hook {
      class = Activity,
      returns = void,
      method = "onCreate",
      params = {
        Bundle
      },
      after = function(this, params)
        Toast:makeText(this, config.toast_msg, Toast.LENGTH_SHORT):show()
        --              ^
        -- Note: `this` is the Activity instance
      end,
    }
  end

  if config.text then
    -- Change all the text to `config.text`
    hook {
      class = TextView,
      returns = void,
      method = "setText",
      params = {
        CharSequence, -- text
        BufferType,   -- type
        boolean,      -- nofityBefore
        int,          -- oldLen
      },
      before = function(this, params)
        -- Reset `text` value
        params[1] = config.text
        --     ^
        -- Note: In lua, index is 1 based
      end,
    }
  end
end

return M
