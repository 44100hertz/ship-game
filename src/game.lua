love.graphics.setDefaultFilter("nearest","nearest")

-- Table of all game actor
local actors = {}

local game = {
   scroll = 0
}

local cateye = require "actors/cateye"

game.init = function ()
   game.addactor(nil, cateye, 80, 40)
   game.addactor(nil, cateye, 100, 120)
   game.addactor(nil, cateye, 120, 40)
   game.addactor(nil, cateye, 140, 120)
   game.addactor(nil, cateye, 160, 40)
   game.addactor(nil, cateye, 180, 120)
   game.addactor(nil, require "actors/player", 40, 40)
end

game.addactor = function (parent, newactor, x, y)
   local index = table.getn(actors) + 1
   actors[index] = {} -- Fixes issue with :new calling actors.add
   actors[index] = newactor:new(x, y, parent)
end

local collideswith = function (send, recv)
   local sq = function(x) return x*x end

   -- a^2 + b^2 < c^2
   local circle_circle = function (c1, c2)
      local size = sq(c1.size + c2.size)
      local dist = sq(c1.x-c2.x) + sq(c1.y-c2.y)
      return (size > dist)
   end

   -- Rectangle collisions
   local field_field = function (f1, f2)
      -- Check x first, it's easier
      local distx = f1.x - f2.x
      local sizex = f1.width + f2.width
      if math.abs(distx) < sizex then return true end

      local skewdist = (f1.skew + f2.skew) * distx
      local disty = math.abs(f1.y - f2.y) + math.abs(skewdist)
      local sizey = f1.height + f2.height
      if disty < sizey then return true end

      return false
   end

   -- Treat a circle like a field.
   -- This makes corner collisions not work right. Avoid those.
   local circle_field = function (c, f)
      local circ2field = {
	 x = c.x, y = c.y,
	 width = c.size, height = c.size,
	 skew = 0,
      }
      return field_field(circ2field, f)
   end

   if send.type == "circle" and recv.type == "circle" then
      return cirrcle_circle(send, recv)
   elseif send.type == "field" and recv.type == "circle" then
      return field_circle(send, recv)
   elseif send.type == "circle" and recv.type == "field" then
      return field_circle(recv, send)
   elseif send.type == "field" and recv.type == "field" then
      return field_field(recv, send)
   end
end

game.update = function ()
   -- Update all actor states
   for _,v in ipairs(actors) do v:update() end

   -- Check all hitboxes
   for irecv,recv in ipairs(actors) do
      for isend,send in ipairs(actors) do
	 if recv.enemy ~= send.enemy and
	    recv.recvbox and send.sendbox and
	 collideswith(recv.recvbox, send.sendbox) then
	    recv:collide(send)
	 end
      end
   end

   for k,v in ipairs(actors) do
      if v.despawn then table.remove(actors, k) end
   end

   -- TODO: add visscroll for when video is separate
   -- game.scroll = game.scroll + 0.25
end

game.draw = function ()
   -- Passes x and y to self for scrolling...todo
   table.sort(actors,
	      function (o1, o2)
		 return (o1.depth > o2.depth)
	      end
   )
   for _,v in ipairs(actors) do v:draw(v.x - game.scroll, v.y) end
end

return game
