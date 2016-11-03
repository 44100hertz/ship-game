local img = love.graphics.newImage("img/testcirc.png")

test = {
   new = function (self)
      o = {}
      setmetatable(o, self)
      self.__index = self

      o.dx = 1
      o.sendbox = {
	 size = 24,
      }
      o.recvbox = {
	 size = 24,
      }

      return o
   end,

   update = function (self)
      if self.x < 140 then self.x = self.x + self.dx end
      self.sendbox.x = self.x
      self.sendbox.y = self.y
      self.recvbox.x = self.x
      self.recvbox.y = self.y
   end,

   draw = function (self,x,y)
      love.graphics.draw(img,x,y)
   end,

   collide = function (self)
      self.dx = -self.dx
   end
}

return test
