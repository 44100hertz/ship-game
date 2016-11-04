local img = love.graphics.newImage("img/testcirc.png")

test = {
   new = function (self)
      o = {}
      setmetatable(o, self)
      self.__index = self

      o.dx, o.dy, o.ddx, o.ddy = 0,0,0,0
      o.sendbox = {
	 size = 24,
      }
      o.recvbox = {
	 size = 24,
      }

      return o
   end,

   update = function (self)
      self.dx = self.dx * 0.7
      self.dy = self.dy * 0.7
      self.x = self.x + self.dx
      self.y = self.y + self.dy
      if input.dd > 0 then self.dy = self.dy + 1 end
      if input.du > 0 then self.dy = self.dy - 1 end
      if input.dl > 0 then self.dx = self.dx - 1 end
      if input.dr > 0 then self.dx = self.dx + 1 end
      self.sendbox.x = self.x
      self.sendbox.y = self.y
      self.recvbox.x = self.x
      self.recvbox.y = self.y
   end,

   draw = function (self,x,y)
      love.graphics.draw(img, math.floor(x), math.floor(y))
   end,

   collide = function (self, with)
   end
}

return test
