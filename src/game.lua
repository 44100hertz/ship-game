-- Table of all game sprite
local sprites = {}

-- Functions for manipulating tables
sprite = {
   add = function (parent, newsprite, x, y)
      local index = table.getn(sprites) + 1
      sprites[index] = {} -- Fixes issue with :new calling sprites.add
      sprites[index] = newsprite:new(x, y, parent)
   end
}

sprite.add(nil, require "sprites/test", 80, 120)
sprite.add(nil, require "sprites/player", 40, 40)

-- Basic a^2 + b^2 = c^2 circle collision
local collideswith = function (send, recv)
   local sq = function(x) return x*x end
   local size = sq(send.size + recv.size)
   local dist = sq(send.x-recv.x) + sq(send.y-recv.y)
   return (size > dist)
end

return {
   update = function ()
      -- Update all sprite states
      for _,v in ipairs(sprites) do v:update() end

      -- Check all hitboxes
      for irecv,recv in ipairs(sprites) do
	 for isend,send in ipairs(sprites) do
	    if irecv ~= isend and
	       recv.recvbox and send.sendbox and
	    collideswith(recv.recvbox, send.sendbox) then
	       recv:collide(send)
	    end
	 end
      end
   end,

   draw = function ()
      -- Passes x and y to self for scrolling...todo
      table.sort(sprites,
		 function (o1, o2)
		    if o1.depth and o2.depth then
		       return (o1.depth > o2.depth)
		    else
		       return false
		    end
		 end
      )
      for _,v in ipairs(sprites) do v:draw(v.x,v.y) end
   end,
}
