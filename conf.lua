function love.conf(t)
   local gamesize = {x=240,y=160}

   t.window.title = "ship"
   t.window.width = gamesize.x*3
   t.window.height = gamesize.y*3
   t.window.resizable = true
   t.window.minwidth = gamesize.x
   t.window.minheight = gamesize.y

   t.modules.event = nil
   t.modules.mouse = nil
   t.modules.physics = nil
   t.modules.system = nil
   t.modules.touch = nil
   t.modules.video = nil
end
