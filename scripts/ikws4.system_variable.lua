--[[ 
@metadata
  return {
    name = "system_variable",
    author = "ikws4",
    version = "1.0.1",
    description = "Configing the variables, like phone model, location, default language etc..."
  }
@end
--]]

local config = {
	build = {
		device = nil,
		product = nil,
		model = nil,
		brand = nil,
		android_version = nil,
	},
	location = { 
    -- See https://www.latlong.net/
		longitude = nil,
		latitude = nil,
	},
}

local M = {}

M.setup = function(opts)
	config = table.extend(config, opts or {})

	local Build = import("android.os.Build")

	Build.DEVICE = config.build.device or Build.DEVICE
	Build.PRODUCT = config.build.product or Build.PRODUCT
	Build.MODEL = config.build.model or Build.MODEL
	Build.BRAND = config.build.brand or Build.BRAND
	Build.MANUFACTURER = config.build.brand or Build.MANUFACTURER
	Build.VERSION.RELEASE = config.build.android_version or Build.VERSION.RELEASE

	local location_classes = {
		"android.location.Location",     -- Android
		"com.baidu.location.BDLocation", -- Baidu
	}

	for _, class in ipairs(location_classes) do
		local ok, class = pcall(import, class)

		if ok then
      if config.location.longitude then
        hook {
          class = class,
          returns = double,
          method = "getLongitude",
          replace = function(this, params)
            return config.location.longitude
          end,
        }
      end

      if config.location.latitude then
        hook {
          class = class,
          returns = double,
          method = "getLatitude",
          replace = function(this, params)
            return config.location.latitude
          end,
        }
      end
		end
	end
end

return M
