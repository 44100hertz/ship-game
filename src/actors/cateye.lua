local img = love.graphics.newImage("img/cateye.png")
img:setFilter("nearest", "nearest")
local iwidth, iheight = img:getDimensions()
local sheet = animation.sheet(0,0,16,16,iwidth,iheight,4)

local anim = {
   idle = {1, speed=0},
   blink = {2, 3, 4, speed=0.5}
}
local cateye = {
   new = function (self, x, y)
      local o = {
	 x=x, y=y,
	 anim = anim.idle,
	 statetime = 0,
	 beamtime = 0,
	 depth = 105,
	 enemy = true,
      }
      setmetatable(o, self)
      self.__index = self

      return o
   end,

   -- recvbox = function (self, recv)
   --    if type(recv) ~= "table" then return false end

   --    print("aoeu")
   --    local dist = math.abs(self.x-recv.x)
   --    return (dist <= recv.size)
   -- end,

   update = function (self)
      if math.random() < 0.01 then
	 self.anim = anim.blink
	 self.statetime = 0
      end

      self.statetime = self.statetime + self.anim.speed

      self.beamtime = (self.beamtime + 1) % 5
   end,

   draw = function (self, x, y)
      local frame = sheet[self.anim[math.ceil(self.statetime)]]

      if not frame then frame = sheet[1] end

      love.graphics.setColor(0, 0, 0)
      local beamwidth = self.beamtime+3
      local beamx = x - beamwidth/2 + 1.5
      love.graphics.rectangle(
	 "fill", beamx, 0, beamwidth, 160
      )
      love.graphics.setColor(255, 255, 255)
      love.graphics.draw(
	 img, frame, x, y,
	 0, 1, 1, 7, 7)
   end,

   collide = function (self, with)
      
   end,
}

return cateye
