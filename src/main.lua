input = require "input"

local quit = false
main = {
   loadstate = function (mod)
      state = mod
   end,
}

local canvas = love.graphics.newCanvas()
canvas:setFilter("nearest", "nearest")

love.run = function ()
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

      canvas:renderTo( function()
	    love.graphics.clear(187,240,212,255)
	    state.draw()
      end)

      love.graphics.draw( canvas, 0,0,0, 3 )
      love.graphics.present()
   end
end
