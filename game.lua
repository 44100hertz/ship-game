-- Table of all game sprites
local sprite = {}

-- Functions for manipulating tables
sprites = {
   add = function (self, sprite, x, y)
      index = table.getn(sprite)+1
      sprite[index] = spriteect.new()
      sprite[index].x = x
      sprite[index].y = y
      sprite[index].parent = self
   end
}

-- Basic a^2 + b^2 = c^2 circle collision
local collideswith = function (send, recv)
   local sq = function(x) return x*x end
   local size = sq(send.size + recv.size)
   local dist = sq(send.x-recv.x) + sq(send.y-recv.y)
   return (dist < size)
end

return {
   update = function ()
      -- Check all hitboxes
      for _,recv in ipairs(sprite) do
	 for _,send in ipairs(sprite) do
	    if recv.recvbox and send.sendbox and
	    collideswith(recv.recvbox, send.sendbox) then
	       recv.collide(send)
	    end
	 end
      end

      -- Update all spriteect states
      for _,v in ipairs(sprite) do v.update() end
   end,

   draw = function ()
      -- Passes x and y to self for scrolling...todo
      for _,v in ipairs(sprite) do v.draw(v.x,v.y) end
   end,
}
