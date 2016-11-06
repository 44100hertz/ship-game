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
}

return anim
