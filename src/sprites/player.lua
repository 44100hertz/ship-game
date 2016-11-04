local img = love.graphics.newImage("img/player.png")
local iwidth, iheight = img:getDimensions()

local sheet_white = {
   shoot = anim.strip(0, 0, 20, 16, iwidth, iheight, 7)
}
local sheet_yolk = {
   shoot = anim.strip(0, 16, 20, 16, iwidth, iheight, 7),
   hurt = anim.strip(0, 32, 20, 16, iwidth, iheight, 5),
   blink = anim.strip(0, 48, 20, 16, iwidth, iheight, 6),
}
local anims = {
   shoot = anim.frames({2,3,4,5,6,7}, {4,4,4,4,4,4}),
   hurt = anim.frames({1,2,3,4,5}, {4,4,4,4,4}),
   blink = anim.frames({1,2,3,4,5,6}, {4,4,4,4,4,4}),
}

player = {
   new = function (self, x, y)
      o = {}
      setmetatable(o, self)
      self.__index = self

      o.x, o.y = x,y
      self.lastx, self.lasty = x,y
      o.dx, o.dy = 0,0
      o.sendbox = {
	 size = 24,
      }
      o.recvbox = {
	 size = 24,
      }

      return o
   end,

   update = function (self)
      frame_yolk = sheet_yolk.shoot[1]
      frame_white = sheet_white.shoot[1]
      -- Movement and hitbox positions
      self.dx = self.dx * 0.75
      self.dy = self.dy * 0.75
      self.x = self.x + self.dx
      self.y = self.y + self.dy
      if input.dd > 0 then self.dy = self.dy + 0.5 end
      if input.du > 0 then self.dy = self.dy - 0.5 end
      if input.dl > 0 then self.dx = self.dx - 0.5 end
      if input.dr > 0 then self.dx = self.dx + 0.5 end
      self.sendbox.x = self.x
      self.sendbox.y = self.y
      self.recvbox.x = self.x
      self.recvbox.y = self.y
   end,

   draw = function (self,x,y)
      love.graphics.draw(img, frame_white,
			 math.floor(self.lastx), math.floor(self.lasty))
      love.graphics.draw(img, frame_yolk,
			 math.floor(x), math.floor(y))
      self.lastx, self.lasty = x,y
   end,

   collide = function (self, with)
   end
}

return player
