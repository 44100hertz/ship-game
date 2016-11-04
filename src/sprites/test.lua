local img = love.graphics.newImage("img/testcirc.png")

test = {
   new = function (self)
      o = {}
      setmetatable(o, self)
      self.__index = self

      o.sendbox = {
	 size = 23,
      }
      o.recvbox = {
	 size = 23,
      }
      o.rel_y = 0
      o.dx, o.dy, o.ddx, o.ddy = 0, 1, 0, 1
      return o
   end,

   update = function (self)
      self.rel_y = self.rel_y + self.dy
      self.dy = self.dy + self.ddy
      self.ddy = -self.rel_y * 0.01
      --if self.dy < -1 then self.dy = -1 end
      --if self.dy > 1 then self.dy = 1 end

      self.x = self.x + 1
      self.y = self.rel_y + 60

      self.sendbox.x = self.x
      self.sendbox.y = self.y
      self.recvbox.x = self.x
      self.recvbox.y = self.y
   end,

   draw = function (self,x,y)
      love.graphics.draw(img,math.floor(x),math.floor(y))
   end,

   collide = function (self, with)
   end
}

return test
