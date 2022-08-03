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

local device = "coral"
local product = "coral"
local model = "Pixel 4 XL"
local brand = "google"
local android_version = "10"

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
