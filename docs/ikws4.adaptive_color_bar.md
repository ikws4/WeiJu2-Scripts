### Usage

```lua
require("ikws4.adaptive_color_bar").setup {
  status_bar = true,
  navigation_bar = true,
  samples = 10,
  refresh_rate = 125,
}
```

### Change Log

#### [1.0.1] - 2023-2-15

##### Fixed

- A null pointer, this happens when the local variable canvas has been recycled by the GC.

### Preview

https://user-images.githubusercontent.com/47056144/190885640-ea7525ff-2de3-4637-88dd-8f6fb1352127.mp4

