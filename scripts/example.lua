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
    "android.os.Bundle"  
  },
  after = function(self, bundle)
    -- Here, `self` is the Activity instance
    Toast:makeText(self, "Hello, WeiJu2!", Toast.LENGTH_SHORT):show()
  end
}

-- Remove all the text
xp.hook {
  class = "android.widget.TextView",
  method = "setText",
  params = {
    "java.lang.CharSequence",
    "android.widget.TextView$BufferType",
    "boolean",
    "int",
  },
  replace = function(self, text, type, notify_before, old_len)
    -- Replace `setText` with empty implementation
  end
}
