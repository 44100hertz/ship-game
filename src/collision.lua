collision = {}

collision.test = function (send, recv)
   local sq = function(x) return x*x end

   -- a^2 + b^2 < c^2
   local circle_circle = function (c1, c2)
      local size = sq(c1.size + c2.size)
      local dist = sq(c1.x-c2.x) + sq(c1.y-c2.y)
      return (size > dist)
   end

   -- Rectangle collisions
   local field_field = function (f1, f2)
      local distx = f1.x - f2.x
      local sizex = f1.width + f2.width
      local skewdist = distx * (f1.skew + f2.skew)
      local disty = f1.y - f2.y
      local sizey = f1.height + f2.height
      return(math.abs(distx) < sizex and math.abs(disty)+skewdist < sizey)
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

   if send.shape == "circle" then
      if recv.shape == "circle" then return circle_circle(send, recv) end
      if recv.shape == "field"  then return circle_field(send, recv) end
   elseif send.shape == "field" then
      if recv.shape == "circle" then return circle_field(recv, send) end
      if recv.shape == "field"  then return field_field(send, recv) end
   end
end

collision.update = function (actors)
   for _,v in ipairs(actors) do -- Avoid collision movements stacking
      if v.hitbox then
	 v.hitbox.x = v.x
	 v.hitbox.y = v.y
      end
   end
   for irecv,recv in ipairs(actors) do -- Check for collisions
      if recv.hitbox and recv.hitbox.recv then
	 for irecv,send in ipairs(actors) do
	    if send.hitbox and send.hitbox.send and
	       send.class ~= recv.class and
	    collision.test(send.hitbox, recv.hitbox) then
	       recv:collide(send)
	    end
	 end
      end
   end
end
