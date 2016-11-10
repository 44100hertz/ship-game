love.graphics.setDefaultFilter("nearest", "nearest")

local effects = {}

effect = {}
effect.asplode = function (x, y, r, g, b, size, density)
   love.graphics.setColor(r, g, b)
   local particle = love.graphics.newCanvas(size,size)
   particle:renderTo(function () love.graphics.rectangle("fill",0,0,size,size) end)
   local splode = {
      x=x, y=y,
      particle = love.graphics.newParticleSystem(particle, 32),
      age = 0,
   }
   love.graphics.setColor(255,255,255)
   splode.drawable = splode.particle

   splode.particle:setBufferSize(density or 10)
   splode.particle:setParticleLifetime(10)
   splode.particle:setSpeed(size*4,size*8)
   splode.particle:setSpread(math.pi*2)
   splode.particle:setEmissionRate(100)
   effects[table.getn(effects)+1] = splode
end

effect.draw = function (scroll)
   for k,v in ipairs(effects) do
      if v.particle then v.particle:update(0.1) end
      love.graphics.draw(v.drawable, v.x-scroll, v.y)
      if v.age == 90 then table.remove(effects, k) end
      v.age = v.age + 1
   end
end

return effect
