require('watcher')
-- wm = require('window-management')

hs.window.animationDuration = 0

-- local hyperBindings = {
--   'escape', 'f1', 'f2', 'f3', 'f4', 'f5', 'f6', 'f7', 'f8', 'f9', 'f10', 'f11', 'f12',
--   '`', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', 'delete',
--   'tab', 'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '\\',
--   'a', 's', 'd', 'g', 'h', 'j', 'k', 'l', ';', "'", 'return',
--   'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/',
--   'space'
-- }
--
-- hyper = hs.hotkey.modal.new({}, 'f19')
--
-- for i, key in ipairs(hyperBindings) do
--   hyper:bind({}, key, nil, function() hs.eventtap.keyStroke({'ctrl', 'option', 'command'}, key) end)
-- end
--
-- hs.hotkey.bind({}, 'f18',
--               function()
--                 hyper.triggered = false
--                 hyper:enter()
--               end,
--               function()
--                 hyper:exit()
--               end)
--
-- hyper:bind({}, 'left',  wm.leftHalf)
-- hyper:bind({}, 'right', wm.rightHalf)
-- hyper:bind({}, 'up',    wm.topHalf)
-- hyper:bind({}, 'down',  wm.bottomHalf)
-- hyper:bind({}, 'f',     wm.maximizeWindow)
-- hyper:bind({}, '[',     wm.throwLeft)
-- hyper:bind({}, ']',     wm.throwRight)
