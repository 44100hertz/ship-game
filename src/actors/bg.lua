local img = love.graphics.newImage("img/wall.png")
img:setWrap("repeat", "clampzero")
local quad = love.graphics.newQuad(0, 0, 256, 16, 16, 16)

local wall = {
   new = function (self, x, y)
      local o = {
	 class = "enemy",
	 x=x, y=y, depth=125,
	 sendbox = {
	    shape = "field",
	    width=240, height=4, skew=0,
	 }
      }
      setmetatable(o, self)
      self.__index = self
      return o
   end,

   update = function (self)
      self.x = game.scroll
   end,

   draw = function (self, x, y)
      love.graphics.draw(img, quad, game.scroll%16-16, y, 0, 1, 1, 0, 8)
   end,
}

return wall
