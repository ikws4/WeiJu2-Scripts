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

-- Easy to import any java class and support for private field, method and constructor access
local Toast = import("android.widget.Toast")
local Activity = import("android.app.Activity")
local TextView = import("android.widget.TextView")

-- Make a toast after activity created
hook {
  method = Activity.onCreate,
	after = function(this, args)
		Toast:makeText(this, "Hello, WeiJu2!", Toast.LENGTH_SHORT):show()
		--              ^
		-- Note: `this` is the Activity instance
	end,
}

-- Change all the text to "WeiJu2"
hook {
  method = TextView.setText,
	before = function(self, args)
		-- Reset `text` value
		args[1] = "WeiJu2"
		--   ^
		-- Note: In lua, index is 1 based
	end,
}
