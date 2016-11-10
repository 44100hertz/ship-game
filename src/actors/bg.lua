local img = love.graphics.newImage("img/wall.png")
img:setWrap("repeat", "clampzero")
local quad = love.graphics.newQuad(0, 0, 256, 16, 16, 16)

local wall = {
   new = function (self, x, y)
      local o = {
	 class = "enemy",
	 x=x, y=y, depth=1000,
	 sendbox = {
	    shape = "field",
	    xoff=-20, yoff=0, width=300,
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
      love.graphics.draw(img, quad, game.scroll%16-16, y)
   end,
}

local wall = {
   new = function (self)
      game.addactor(nil, wall, 240, -8)
      game.addactor(nil, wall, 0, 144)
      return { despawn = true }
   end
}

return wall
