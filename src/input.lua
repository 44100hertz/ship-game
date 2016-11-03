-- keys should be "friendly" names
-- values must be valid scancodes
local keyBind = {
   a ="x", b="z",
   l="a", r="s",
   st="enter", sel="shift",
   du="i", dd="k",
   dl="j", dr="l"
}

-- fill buttons table with zeros
local buttons = {}
for k,_ in pairs(keyBind) do buttons[k] = 0 end

input = {
   update = function ()
      for k,v in pairs(keyBind) do
	 if love.keyboard.isScancodeDown(v) then
	    buttons[k] = buttons[k]+1
	 else
	    buttons[k] = 0
	 end
      end
   end,
}

input.mt = {
   __index = function (table, key)
      return buttons[key]
   end
}
setmetatable(input, input.mt)

return input
