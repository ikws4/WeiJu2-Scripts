--[=[
@metadata
  return {
    name = "system_variable",
    author = "ikws4",
    version = "1.1.1",
    description = "Configing the variables, like phone model, location, dpi etc...",
    example = [[
      require("ikws4.system_variable").setup {
        build = {
          device = "coral",
          product = "coral",
          model = "Pixel 4 XL",
          brand = "google",
          android_version = "13",
        },
        location = {
          longitude = 31.921279,
          latitude = 620.157480,
        },
        display = {
          dpi = 320,
          language = "en-US",
        },
      }
    ]]
  }
@end
--]=]

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
  display = {
    dpi = nil,
    -- See https://www.fincher.org/Utilities/CountryLanguageList.shtml
    language = nil,
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
    "android.location.Location", -- Android
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

  if config.display.dpi or config.display.language then
    local ContextWrapper = import("android.content.ContextWrapper")
    local Configuration = import("android.content.res.Configuration")
    local Context = import("android.content.Context")

    hook {
      class = ContextWrapper,
      returns = void,
      method = "attachBaseContext",
      params = {
        Context,
      },
      before = function(this, params)
        local context = params[1]

        -- Make a copy of the configuration, and then modify the dpi
        local new_configuration = Configuration(context:getResources():getConfiguration())

        if config.display.dpi then
          new_configuration.densityDpi = config.display.dpi
        end

        -- Change the language
        if config.display.language then
          local String = import("java.lang.String")
          local Locale = import("java.util.Locale")
          
          local country_city = config.display.language:split("-")
          local locale = Locale(country_city[1], country_city[2])
          Locale:setDefault(locale)
          new_configuration:setLocale(locale)
        end

        params[1] = context:createConfigurationContext(new_configuration)
      end,
    }
  end
end

return M
