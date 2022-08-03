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


local build_fields = {
  DEVICE = device,
  PRODUCT = product,
  MODEL = model,
  BRAND = brand,
  MANUFACTURER = brand,
}

for k, v in pairs(build_fields) do
  xp.set_field {
    class = "android.os.Build",
    type = "java.lang.String",
    field = k,
    value = v
  }
end

xp.set_field {
  class = "android.os.Build$VERSION",
  type = "java.lang.String",
  field = "RELEASE",
  value = android_version,
}


local location_classes = {
  "android.location.Location",        -- Android
  "com.baidu.location.BDLocation",    -- Baidu
}

for _, class in ipairs(location_classes) do
  xp.hook {
    class = class,
    returns = "double",
    method = "getLongitude",
    replace = function(this, args)
      return longitude
    end,
  }

  xp.hook {
    class = class,
    returns = "double",
    method = "getLatitude",
    replace = function(this, args)
      return latitude
    end,
  }
end
