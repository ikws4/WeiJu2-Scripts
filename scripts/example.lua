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

-- Easy to import any java class, remenger this just a syntax sugar, you desugar it with:
-- ```lua
--   local Toast = luajava.bindClass("android.widget.Toast")
-- ```
import "android.widget.Toast"

-- Make toast when activit created
xp.hook {
  class = "android.app.Activity",
  method = "onCreate",
  params = {
    "android.os.Bundle"    -- Bundle
  },
  after = function(this, args)
    Toast:makeText(this, "Hello, WeiJu2!", Toast.LENGTH_SHORT):show()
    --              ^
    -- Note: `this` is the Activity instance
  end
}

-- Change all the text to "WeiJu2"
xp.hook {
  class = "android.widget.TextView",
  method = "setText",
  params = {
    "java.lang.CharSequence",                -- text
    "android.widget.TextView$BufferType",    -- type
    "boolean",                               -- nofityBefore
    "int",                                   -- oldLen
  },
  before = function(self, args)
    -- Reset `text` value
    args[1] = "WeiJu2"
    --   ^
    -- Note: Lua index is 1 based
  end
}
