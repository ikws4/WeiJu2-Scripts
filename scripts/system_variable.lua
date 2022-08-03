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

-- Build Info
local device = "coral"
local product = "coral"
local model = "Pixel 4 XL"
local brand = "google"
local android_version = "10"

-- Location
-- See https://www.latlong.net/
local longitude = 31.921279
local latitude = 620.157480

xp.set_field {
  class = "android.os.Build",
  field = "DEVICE",
  value = device,
}

xp.set_field {
  class = "android.os.Build",
  field = "PRODUCT",
  value = product,
}

xp.set_field {
  class = "android.os.Build",
  field = "MODEL",
  value = model,
}

xp.set_field {
  class = "android.os.Build",
  field = "BRAND",
  value = brand,
}

xp.set_field {
  class = "android.os.Build",
  field = "MANUFACTURER",
  value = brand,
}

xp.set_field {
  class = "android.os.Build$VERSION",
  field = "RELEASE",
  value = android_version,
}

local location_classes = { 
  "android.location.Location",        -- Android
  "com.baidu.location.BDLocation",    -- BaiDu
}

for _, calss in ipairs(location_classes) do
  xp.hook {
    class = class,
    method = "getLongitude",
    replace = function(this, args)
      return longitude
    end,
  }

  xp.hook {
    class = class,
    method = "getLatitude",
    replace = function(this, args)
      return latitude
    end,
  }
end
