anim = {
   strip = function (x, y, width, height, iwidth, iheight, num)
      local quads = {}
      local offset = x

      for i=1,num do
	 quads[i] = love.graphics.newQuad(
	    offset, y, width, height, iwidth, iheight)
	 offset = offset + width
      end
      return quads
   end,

   frames = function (frames, lengths)
      local index = 1
      local anim = {}
      for k,v in ipairs(frames) do
	 for _ = 1,lengths[k] do
	    anim[index] = v
	    index = index + 1
	 end
      end
   end
}

return anim
