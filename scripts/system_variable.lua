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

require("java_primitive_types")

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

local Build = import("android.os.Build")
Build.DEVICE = config.build.device
Build.PRODUCT = config.build.product
Build.MODEL = config.build.model
Build.BRAND = config.build.brand
Build.MANUFACTURER = config.build.brand
Build.VERSION.RELEASE = config.build.android_version

local location_classes = {
	"android.location.Location",     -- Android
	"com.baidu.location.BDLocation", -- Baidu
}


for _, class in ipairs(location_classes) do
	local ok, class = pcall(import, class)

	if ok then
		hook {
			class = class,
			returns = double,
			method = "getLongitude",
			replace = function(this, args)
				return config.location.longitude
			end,
		}

		hook {
			class = class,
			returns = double,
			method = "getLatitude",
			replace = function(this, args)
				return config.location.latitude
			end,
		}
	end
end
