local img = love.graphics.newImage("img/cateye.png")
local iwidth, iheight = img:getDimensions()
local sheet = animation.sheet(0,0,16,16,iwidth,iheight,2,2)

local sound_asplode = love.audio.newSource("sound/lilasplode.wav")

local drawbeam = function (x, width)
      love.graphics.setColor(0, 0, 0)
      local beamwidth = width
      local beamx = x - beamwidth/2 + 1.5
      love.graphics.rectangle(
	 "fill", beamx, 0, beamwidth, 160
      )
      love.graphics.setColor(255, 255, 255)
end

local dead_cateye = {
   new = function (self, x, y)
      local o = {
	 x=x, y=y,
	 statetime = 0,
	 depth = 105,
	 beamsize = 5,
      }
      setmetatable(o, self)
      self.__index = self

      return o
   end,

   update = function (self)
      self.statetime = self.statetime + 0.5
      if self.statetime == 5 then self.despawn = true end
   end,

   draw = function (self, x, y)
      drawbeam(x, 5-math.floor(self.statetime))
   end
}

local anim = {
   idle = {1, speed=0},
   blink = {2, 3, 4, speed=0.5}
}
local cateye = {
   new = function (self, x, y)
      local o = {
	 class="enemy",
	 x=x, y=y,
	 anim = anim.idle,
	 statetime = 0,
	 depth = 105,
	 hitbox = {
	    shape="field", width=4, height=160, skew=0,
	    send=true, recv=true,
	 },
	 beamtime = 0,
      }
      setmetatable(o, self)
      self.__index = self

      return o
   end,

   update = function (self)
      if math.random() < 0.01 then
	 self.anim = anim.blink
	 self.statetime = 0
      end

      self.statetime = self.statetime + self.anim.speed
      self.beamtime = (self.beamtime + 1) % 5
   end,

   draw = function (self, x, y)
      local frame = sheet[self.anim[math.floor(self.statetime)]] or sheet[1]

      love.graphics.setColor(0, 0, 0)
      drawbeam(x, self.beamtime+3)

      love.graphics.draw(
	 img, frame, x, y,
	 0, 1, 1, 7, 7)
   end,

   collide = function (self, with)
      local ydist = math.abs(self.y - with.y)
      if with.class == "player" and ydist < 10 then
	 love.audio.stop(sound_asplode)
	 love.audio.play(sound_asplode)
	 game.addactor(nil, dead_cateye, self.x, self.y)
	 effect.asplode(self.x, self.y, 213, 158, 130, 4)
	 self.despawn = true
      end
   end,
}

return cateye
