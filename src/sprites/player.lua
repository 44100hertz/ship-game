local img = love.graphics.newImage("img/player.png")
local iwidth, iheight = img:getDimensions()

local bullet = {
   new = function (self, x, y, parent)
      local o = {
	 sheet = animation.sheet(0, 80, 8, 8, iwidth, iheight, 3),
	 dx = parent.dx+1,
	 dy = parent.dy,
	 sendbox = {size = 3},
	 recvbox = {size = 3},
	 coordq = {head=0, [0]={x,y}}
      }
      setmetatable(o, self)
      self.__index = self
      return o
   end,

   update = function ()
      self.x = self.x + self.dx
      self.y = self.y + self.dy
      self.sendbox.x = self.x
      self.sendbox.y = self.y
      self.recvbox.x = self.x
      self.recvbox.y = self.y
   end,

   draw = function ()
      -- Keep a rotating queue of position history
      coordq.head = (coordq.head + 1) % 20
      coordq[coordq.head] = {x,y}
      -- Draw bullet and its tail based on history
      love.graphics.draw(
	 img, sheet_bullet[1], math.floor(self.x), math.floor(self.y),
	 0, 1, 1, 4, 4)
      local coordq10 = coordq[(coordq.head-20)%20]
      love.graphics.draw(
	 img, sheet_bullet[2], math.floor(coordq10.x), math.floor(coordq10.y),
	 0, 1, 1, 4, 4)
      local coordq20 = coordq[(coordq.head-20)%20]
      love.graphics.draw(
	 img, sheet_bullet[3], math.floor(coordq20.x), math.floor(coordq20.y),
	 0, 1, 1, 4, 4)
   end
}

local white = {
   new = function (self, x, y, parent)
      local o = {
	 depth=150,
	 x=x, y=y,
	 parent = parent,
	 sheet = animation.sheet(0, 0, 20, 16, iwidth, iheight, 10),
      }
      o.frame = o.sheet[1]
      setmetatable(o, self)
      self.__index = self
      return o
   end,

   update = function (self)
   end,

   draw = function (self)
      local frame = self.sheet[1]
      love.graphics.draw(img, frame,
			 math.floor(self.x), math.floor(self.y),
			 0, 1, 1, 7, 7)
      self.x = self.parent.x
      self.y = self.parent.y
   end
}

yolk = {
   anim = {
      idle = {1, speed=0},
      shoot = {2, 3, 4, 5, 6, 7, speed=0.25},
      hurt = {11, 12, 13, 14, 15, speed=0.25},
      blink = {16, 17, 18, 19, 20, 21, speed=0.25},
   },
   new = function (self, x, y)
      local o = {
	 depth=100,
	 x=x, y=y,
	 dx=0, dy=0,
	 sheet = animation.sheet(0, 16, 20, 16, iwidth, iheight, 10, 3),
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
      -- Movement and hitbox positions
      self.dx = self.dx * 0.75
      self.dy = self.dy * 0.75
      self.x = self.x + self.dx
      self.y = self.y + self.dy

      -- Shooting
      if input.b == 1 then
	 self.statetime = 0
	 self.anim = yolk.anim.shoot
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
      local frame = self.sheet[self.anim[self.statetime * self.anim.speed]]

      if not frame then
	 self.anim = yolk.anim.idle
	 frame = self.sheet[1]
      end

      love.graphics.draw(
	 img, frame, math.floor(self.x), math.floor(self.y),
	 0, 1, 1, 7, 7)
   end,

   collide = function (self, with)
   end
}

return yolk
