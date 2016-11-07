local img = love.graphics.newImage("img/player.png")
local iwidth, iheight = img:getDimensions()
local sound_shoot = love.audio.newSource("sound/playershot.wav", "static")

local bullet_sheet = animation.sheet(0, 80, 8, 8, iwidth, iheight, 3)
local bullet = {
   new = function (self, x, y, parent)
      love.audio.stop(sound_shoot)
      love.audio.play(sound_shoot)
      local o = {
	 depth = 125,
	 x=x, y=y,
	 dx = parent.dx + 3,
	 dy = parent.dy,
	 sendbox = {size = 3},
	 recvbox = {size = 3},
      }
      setmetatable(o, self)
      self.__index = self
      return o
   end,

   update = function (self)
      self.x = self.x + self.dx
      self.y = self.y + self.dy
      self.sendbox.x = self.x
      self.sendbox.y = self.y
      self.recvbox.x = self.x
      self.recvbox.y = self.y
      self.despawn = self.offscreen
   end,

   draw = function (self, x, y)
      love.graphics.draw(
	 img, bullet_sheet[1], math.floor(x), math.floor(y),
	 0, 1, 1, 4, 4)
      love.graphics.draw(
	 img, bullet_sheet[2],
	 math.floor(x-self.dx), math.floor(y-self.dy),
	 0, 1, 1, 4, 4)
      love.graphics.draw(
	 img, bullet_sheet[3],
	 math.floor(x-self.dx*2), math.floor(y-self.dy*2),
	 0, 1, 1, 4, 4)
   end,

   collide = function (self) end
}

local white_sheet = animation.sheet(0, 0, 20, 16, iwidth, iheight, 7)
local white = {
   new = function (self, x, y, parent)
      local o = {
	 depth=150,
	 x=x, y=y,
	 parent = parent,
      }

      setmetatable(o, self)
      self.__index = self
      return o
   end,

   update = function (self)
   end,

   draw = function (self, x, y)
      local frame = white_sheet[math.ceil(self.parent.statetime * 2)]
	 or white_sheet[1]
      love.graphics.draw(img, frame,
			 math.floor(x), math.floor(y),
			 0, 1, 1, 7, 7)
      self.x = self.parent.x
      self.y = self.parent.y
   end
}

local yolk_sheet = animation.sheet(0, 16, 20, 16, iwidth, iheight, 10, 3)
yolk = {
   anim = {
      idle = {1, speed=0},
      shoot = {2, 3, 4, 5, 6, 7, speed=0.33},
      hurt = {11, 12, 13, 14, 15, speed=0.5},
      blink = {25, 24, 23, 22, speed=0.25},
   },
   new = function (self, x, y)
      local o = {
	 depth=100,
	 x=x, y=y,
	 dx=0, dy=0,
	 anim = yolk.anim.idle,
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
      -- Shooting
      if input.b > 0 and self.anim == yolk.anim.idle then
	 sprite.add(self, bullet, self.x, self.y)
	 self.statetime = 0
	 self.anim = yolk.anim.shoot
      end

      -- Movement
      if input.dd > 0 then self.dy = self.dy + 0.5 end
      if input.du > 0 then self.dy = self.dy - 0.5 end
      if input.dl > 0 then self.dx = self.dx - 0.5 end
      if input.dr > 0 then self.dx = self.dx + 0.5 end

      -- Movement and hitbox positions
      self.dx = self.dx * 0.75
      self.dy = self.dy * 0.75
      self.x = self.x + self.dx
      self.y = self.y + self.dy

      -- Screen limits
      self.x = math.max(self.x, sprite.scroll)
      self.x = math.min(self.x, sprite.scroll+240)
      self.y = math.max(self.y, 0)
      self.y = math.min(self.y, 160)

      -- Hitboxes
      self.sendbox.x = self.x
      self.sendbox.y = self.y
      self.recvbox.x = self.x
      self.recvbox.y = self.y

      self.statetime = self.statetime + self.anim.speed
   end,

   draw = function (self,x,y)
      local frame = yolk_sheet[self.anim[math.ceil(self.statetime)]]

      if not frame then
	 self.anim = yolk.anim.idle
	 frame = yolk_sheet[1]
	 self.statetime = 0
      end

      love.graphics.draw(
	 img, frame, math.floor(x), math.floor(y),
	 0, 1, 1, 7, 7)
   end,

   collide = function (self, with)
   end
}

return yolk
