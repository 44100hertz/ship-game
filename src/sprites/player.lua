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
   idle = {1},
   shoot = {2,3,4,5,6,7},
   hurt = {1,2,3,4,5},
   blink = {1,2,3,4,5,6},
}

local white = {
   new = function (self, x, y, parent)
      local o = {
	 x=x, y=y,
	 parent = parent,
	 anim = anims.idle,
      }
      setmetatable(o, self)
      self.__index = self
      return o
   end,

   update = function (self)
   end,

   draw = function (self)
      local frame = sheet_white.shoot[1]
      love.graphics.draw(img, frame,
			 math.floor(self.x), math.floor(self.y),
			 0, 1, 1, 7, 7)
      self.x = self.parent.x
      self.y = self.parent.y
   end
}

yolk = {
   new = function (self, x, y)
      local o = {
	 x=x, y=y,
	 dx=0, dy=0,
	 anim = anims.idle,
	 statetime = 0,
	 sendbox = { size = 3, },
	 recvbox = { size = 4, },
      }
      setmetatable(o, self)
      self.__index = self

      sprite.add(o, white, x, y)

      return o
   end,

   update = function (self)
      -- Movement and hitbox positions
      self.dx = self.dx * 0.75
      self.dy = self.dy * 0.75
      self.x = self.x + self.dx
      self.y = self.y + self.dy

      -- Shooting
      if input.b == 1 then
	 self.statetime = 0
	 self.anim = anims_yolk.shoot
      end
      -- Movement
      if input.dd > 0 then self.dy = self.dy + 0.5 end
      if input.du > 0 then self.dy = self.dy - 0.5 end
      if input.dl > 0 then self.dx = self.dx - 0.5 end
      if input.dr > 0 then self.dx = self.dx + 0.5 end

      -- Hitboxes
      self.sendbox.x = self.x
      self.sendbox.y = self.y
      self.recvbox.x = self.x
      self.recvbox.y = self.y

      self.statetime = self.statetime + 1
   end,

   draw = function (self,x,y)
      local frame = sheet_yolk.shoot[1]

      if not frame then
	 self.anim = anims_yolk.idle
	 frame = anims_yolk.idle[1]
      end

      love.graphics.draw(
	 img, frame, math.floor(self.x), math.floor(self.y),
	 0, 1, 1, 7, 7)
   end,

   collide = function (self, with)
   end
}

return yolk
