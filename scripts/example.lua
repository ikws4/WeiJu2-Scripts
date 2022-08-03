--[[ 
@metadata
  return {
    name = "Example",
    author = "ikws4",
    version = "1.0.0",
    description = "A complete example to introduce how to write your own scripts."
  }
@end
--]]

-- import primitives(void, int, ...), now you can use them in your script
require("java_primitive_types")

-- Easy to import any java class and support for private field, method and constructor access
local Toast = import("android.widget.Toast")
local Activity = import("android.app.Activity")
local TextView = import("android.widget.TextView")
local Bundle = import("android.os.Bundle")
local CharSequence = import("java.lang.CharSequence")
local BufferType = import("android.widget.TextView$BufferType")

-- Make a toast after activity created
hook {
  class = Activity,
  returns = void,
  method = "onCreate",
  params = {
    Bundle
  },
  after = function(this, params)
    Toast:makeText(this, "Hello, WeiJu2!", Toast.LENGTH_SHORT):show()
    --              ^
    -- Note: `this` is the Activity instance
  end,
}

-- Change all the text to "WeiJu2"
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
    params[1] = "WeiJu2"
    --     ^
    -- Note: In lua, index is 1 based
  end,
}
