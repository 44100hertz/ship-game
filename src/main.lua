input = require "input"
animation = require "animation"
game = require "game"

love.graphics.setDefaultFilter("nearest", "nearest")

local quit = false
local state
main = {
   loadstate = function (mod)
      state = mod
      state.init()
   end,
}

love.run = function ()
   local canvas = love.graphics.newCanvas(240, 160)

   love.math.setRandomSeed(os.time())
   main.loadstate(require "game")

   while true do
      love.event.pump()
      for name, a,b,c,d,e,f in love.event.poll() do
	 if name == "quit" then
	    if not love.quit or not love.quit() then
	       return a
	    end
	 end
	 love.handlers[name](a,b,c,d,e,f)
      end

      input.update()
      state.update()

      love.graphics.setBlendMode("alpha", "alphamultiply")
      canvas:renderTo( function()
	    state.draw()
      end)

      love.graphics.setBlendMode("replace", "premultiplied")
      love.graphics.draw( canvas, 0,0,0, 3 )
      love.graphics.present()
   end
end
