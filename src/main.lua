main = {
   loadstate = function (mod)
      state = mod
   end
}

local canvas = love.graphics.newCanvas()
canvas:setFilter("nearest", "nearest")

love.run = function ()
   love.math.setRandomSeed(os.time())
   main.loadstate(require "game")

   while true do
      state.update()

      canvas:renderTo( function()
	    love.graphics.clear(187,240,212,255)
	    state.draw()
      end)

      love.graphics.draw( canvas, 0,0,0, 3 )
      love.graphics.present()
   end
end
