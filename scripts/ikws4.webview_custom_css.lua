--[==[
@metadata
  return {
    name = "webview_custom_css",
    author = "ikws4",
    version = "1.0.0",
    description = "Inject custom css into WebView",
    example = [=[
      require("ikws4.webview_custom_css").setup {
        css = [[ 
          body {
            color: white;
            background: black;
          }
        ]],
      }
    ]=]
  }
@end
--]==]

local config = {
  css = nil,
}

local M = {}

M.setup = function(opts)
  config = table.extend(config, opts or {})

  local WebViewClient = import("android.webkit.WebViewClient")
  local WebView = import("android.webkit.WebView")
  local String = import("java.lang.String")
  local Bitmap = import("android.graphics.Bitmap")

  if config.css then
    hook {
      class = WebViewClient,
      returns = void,
      method = "onPageStarted",
      params = {
        WebView,
        String,
        Bitmap,
      },
      after = function(this, params)
        local view = params[1]
        local settings = view:getSettings()

        if not settings:getJavaScriptEnabled() then
          settings:setJavaScriptEnabled(true)
        end
      end,
    }

    hook {
      class = WebViewClient,
      returns = void,
      method = "onPageFinished",
      params = {
        WebView,
        String,
      },
      after = function(this, params)
        local view = params[1]
        local css = string.gsub(config.css, "\n", "\\n")

        -- inject custom css
        local injection = string.format(
          [[
            (function() {
              var style = document.createElement('style');
              style.type = 'text/css';
              style.innerHTML = '%s';
              document.head.appendChild(style);
            })()
          ]],
          css
        )

        view:evaluateJavascript(injection, nil)
      end,
    }
  end
end

return M
