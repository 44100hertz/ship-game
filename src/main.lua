local state = {
   init = function () end,
   update = function () end,
   draw = function () end,
}

main = {
   loadstate = function (mod)
      state = mod
   end
}

love.run = function ()
   love.math.setRandomSeed(os.time())

   while true do
      state.update()

      -- love.graphics.clear(love.graphics.getBackgroundColor())
      -- love.graphics.origin()
      state.draw()
      love.graphics.present()
   end
end
