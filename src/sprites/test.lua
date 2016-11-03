local img = love.graphics.newImage("img/testcirc.png")

test = {
   new = function (self)
      o = {}
      setmetatable(o, self)
      self.__index = self
      return o
   end,

   update = function ()
   end,

   draw = function (x,y)
      love.graphics.draw(img,x,y)
   end
}

return test
