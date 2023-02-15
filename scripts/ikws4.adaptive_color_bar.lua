--[==[
@metadata
  return {
    name = "adaptive_color_bar",
    author = "ikws4",
    version = "1.0.1",
    description = "Adaptive color for status and navigation bar",
    example = [=[
      require("ikws4.adaptive_color_bar").setup {
        status_bar = true,
        navigation_bar = true,
        samples = 10,
        refresh_rate = 125,
      }
    ]=]
  }
@end
--]==]

local config = {
  status_bar = true,
  navigation_bar = true,
  samples = 10,
  refresh_rate = 125,
}

local M = {}

M.setup = function(opts)
  config = table.extend(config, opts or {})

  local Activity = import("android.app.Activity")
  local Bundle = import("android.os.Bundle")
  local Canvas = import("android.graphics.Canvas")
  local Bitmap = import("android.graphics.Bitmap")
  local BitmapConfig = import("android.graphics.Bitmap.Config")
  local Runnable = import("java.lang.Runnable")
  local OnApplyWindowInsetsListener = import("android.view.View.OnApplyWindowInsetsListener")
  local Window = import("android.view.Window")
  local Rect = import("android.graphics.Rect")
  local ValueAnimator = import("android.animation.ValueAnimator")
  local ValueAnimatorAnimatorUpdateListener = import("android.animation.ValueAnimator.AnimatorUpdateListener")
  local AccelerateInterpolator = import("android.view.animation.AccelerateInterpolator")

  local decor_view_bitmap

  local function get_most_frequent_color(colors)
    local map = {}
    for _, color in ipairs(colors) do
      map[color] = map[color] and map[color] + 1 or 1
    end

    local max, res = 0, 0
    for k, v in pairs(map) do
      if v > max then
        max = v
        res = k
      end
    end

    return res
  end

  local function color_animator(old_color, new_color, duration, callback)
    local animator = ValueAnimator:ofArgb { old_color, new_color }
    animator:setDuration(duration)
    animator:addUpdateListener(object(ValueAnimatorAnimatorUpdateListener, {
      onAnimationUpdate = callback,
    }))
    animator:start()
  end

  hook {
    class = Activity,
    returns = void,
    method = "onCreate",
    params = {
      Bundle,
    },
    after = function(this, params)
      local window = this:getWindow()
      local decorView = window:getDecorView()

      local status_bar_height, navigation_bar_height
      local canvas

      decorView:post(object(Runnable, {
        run = function(this)
          if not status_bar_height or not navigation_bar_height then
            local visible_rect = Rect()
            decorView:getWindowVisibleDisplayFrame(visible_rect)
            status_bar_height = visible_rect.top
            navigation_bar_height = decorView:getHeight() - visible_rect.bottom
          end

          if not decor_view_bitmap or decor_view_bitmap:isRecycled() or not canvas then
            decor_view_bitmap = Bitmap:createBitmap(decorView:getWidth(), decorView:getHeight(), BitmapConfig.ARGB_8888)
            canvas = Canvas(decor_view_bitmap)
          end

          decorView:draw(canvas)

          local width = decorView:getWidth()
          local step = math.floor(width / config.samples)

          -- compute and set status bar color
          if config.status_bar then
            local colors = {}
            for x = 0, decorView:getWidth() - 1, step do
              colors[#colors + 1] = decor_view_bitmap:getPixel(x, status_bar_height + 1)
            end
            local old_color = window:getStatusBarColor()
            local new_color = get_most_frequent_color(colors)
            if old_color ~= new_color then
              color_animator(old_color, new_color, config.refresh_rate, function(this, animation)
                window:setStatusBarColor(animation:getAnimatedValue())
              end)
            end
          end

          -- compute and setnavigation bar color
          if config.navigation_bar then
            local colors = {}
            for x = 0, decorView:getWidth() - 1, step do
              colors[#colors + 1] = decor_view_bitmap:getPixel(x, decorView:getHeight() - (navigation_bar_height + 1))
            end
            local old_color = window:getNavigationBarColor()
            local new_color = get_most_frequent_color(colors)
            if old_color ~= new_color then
              color_animator(old_color, new_color, config.refresh_rate, function(this, animation)
                window:setNavigationBarColor(animation:getAnimatedValue())
              end)
            end
          end

          decorView:postDelayed(this, config.refresh_rate)
        end,
      }))
    end,
  }

  hook {
    class = Activity,
    returns = void,
    method = "onDestroy",
    after = function()
      if decor_view_bitmap and not decor_view_bitmap:isRecycled() then
        decor_view_bitmap:recycle()
      end
    end,
  }
end

return M
