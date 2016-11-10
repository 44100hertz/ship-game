local img = love.graphics.newImage("img/wall.png")
img:setWrap("repeat", "clampzero")
local quad = love.graphics.newQuad(0, 0, 256, 16, 16, 16)

local wall_proto = {
   new = function (self, x, y)
      local o = {
	 class = "enemy",
	 x=x, y=y, depth=1000,
      }
      setmetatable(o, self)
      self.__index = self
      return o
   end,

   update = function (self)
      self.x = game.scroll
   end,

   draw = function (self, x, y)
      love.graphics.draw(img, quad, game.scroll%16-16, y, 0, 1, self.mirror)
   end,
}

local wall_top = wall_proto:new()
wall_top.sendbox = {
   shape = "field",
   xoff=-40, yoff=-16,
   width=300, height=2, skew=0,
}
wall_top.mirror = -1

local wall_bottom = wall_proto:new()
wall_bottom.sendbox = {
   shape = "field",
   xoff=-40, yoff=16,
   width=300, height=2, skew=0,
}
wall_bottom.mirror = 1

local wall = {
   new = function (self)
      game.addactor(nil, wall_top, 240, 16)
      game.addactor(nil, wall_bottom, 0, 144)
      return { despawn = true }
   end
}

return wall
