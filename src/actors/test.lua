local img = love.graphics.newImage("img/testcirc.png")

test = {
   new = function (self, x, y)
      o = {
	 class = "enemy",
	 x=x, y=y,
	 hitbox = {shape="circle", size=24, send=true},
	 depth = 0,
      }
      setmetatable(o, self)
      self.__index = self
      return o
   end,

   draw = function (self,x,y)
      love.graphics.draw(
	 img, x, y,
	 0, 1, 1, 24, 24
      )
   end,
}

return test
