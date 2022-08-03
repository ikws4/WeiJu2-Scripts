--[[ 
@metadata
  return {
    name = "System Variable",
    author = "ikws4",
    version = "1.0.0",
    description = "Configing the variables, like phone model, location, default language etc..."
  }
@end
--]]

local config = {
	build = {
		device = "coral",
		product = "coral",
		model = "Pixel 4 XL",
		brand = "google",
		android_version = "10",
	},
	location = { -- See https://www.latlong.net/
		longitude = 31.921279,
		latitude = 620.157480,
	},
}

import "android.os.Build"

Build.DEVICE = config.device
Build.PRODUCT = config.product
Build.MODEL = config.model
Build.BRAND = config.brand
Build.MANUFACTURER = config.brand
Build.VERSION.RELEASE = config.android_version

local location_classes = {
	"android.location.Location",     -- Android
	"com.baidu.location.BDLocation", -- Baidu
}

for _, class in ipairs(location_classes) do
	xp.hook({
		class = class,
		returns = "double",
		method = "getLongitude",
		replace = function(this, args)
			return config.location.longitude
		end,
	})

	xp.hook({
		class = class,
		returns = "double",
		method = "getLatitude",
		replace = function(this, args)
			return config.loation.latitude
		end,
	})
end
