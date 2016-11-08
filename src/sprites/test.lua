local img = love.graphics.newImage("img/testcirc.png")

test = {
   new = function (self, x, y)
      o = {
	 x=x, y=y,
	 sendbox = {size = 24, x=x, y=y},
	 recvbox = {size = 24, x=x, y=y},
	 enemy = true,
	 depth = 0,
      }
      setmetatable(o, self)
      self.__index = self
      return o
   end,

   update = function (self)
   end,

   draw = function (self,x,y)
      love.graphics.draw(
	 img, math.floor(x), math.floor(y),
	 0, 1, 1, 24, 24
      )
   end,

   collide = function (self, with)
   end
}

return test
