-- Table of all game actor
local actors = {}

local game = {
   scroll = 0
}

game.init = function ()
   game.addactor(nil, require "actors/player", 40, 40)
   game.addactor(nil, require "actors/test", 200, 40)
end

game.addactor = function (parent, newactor, x, y)
   local index = table.getn(actors) + 1
   actors[index] = {} -- Fixes issue with :new calling actors.add
   actors[index] = newactor:new(x, y, parent)
end

-- Basic a^2 + b^2 = c^2 circle collision
local collideswith = function (send, recv)
   if type(send) == "table" and type(recv) == "table" then
      local sq = function(x) return x*x end
      local size = sq(send.size + recv.size)
      local dist = sq(send.x-recv.x) + sq(send.y-recv.y)
      return (size > dist)
   elseif type(send) == "function" then
      return send(recv)
   end
end

game.update = function ()
   -- Update all actor states
   for _,v in ipairs(actors) do v:update() end

   -- Check all hitboxes
   for irecv,recv in ipairs(actors) do
      for isend,send in ipairs(actors) do
	 if recv.enemy ~= send.enemy and
	    irecv ~= isend and
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
   game.scroll = game.scroll + 0.25
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
