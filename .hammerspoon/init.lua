require('watcher')
wm = require('window-management')

hs.window.animationDuration = 0

local hyperBindings = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '`', '-', '=', '[', ']', '\\', ';', "'", ',', '.', '/' }

hyper = hs.hotkey.modal.new({}, 'f19')

for i, key in ipairs(hyperBindings) do
  hyper:bind({}, key, nil, function() hs.eventtap.keyStroke(hyper, key) end)
end

hs.hotkey.bind({}, 'f18',
              function()
                hyper.triggered = false
                hyper:enter()
              end,
              function()
                hyper:exit()
              end)

hyper:bind({}, 'left',  wm.leftHalf)
hyper:bind({}, 'right', wm.rightHalf)
hyper:bind({}, 'up',    wm.topHalf)
hyper:bind({}, 'down',  wm.bottomHalf)
hyper:bind({}, 'f',     wm.maximizeWindow)
hyper:bind({}, '[',     wm.throwLeft)
hyper:bind({}, ']',     wm.throwRight)
