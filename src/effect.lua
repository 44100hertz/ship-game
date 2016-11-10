love.graphics.setDefaultFilter("nearest", "nearest")

local effects = {}

local explod = love.graphics.newImage("img/particle.png")

effect = {}
effect.asplode = function (x, y, color, size)
   local splode = {
      x=x, y=y,
      particle = love.graphics.newParticleSystem(explod, 32),
      age = 0,
   }
   splode.drawable = splode.particle

   splode.particle:setBufferSize(10)
   splode.particle:setParticleLifetime(5)
   splode.particle:setSpeed(20,40)
   splode.particle:setSpread(math.pi*2)
   splode.particle:setEmissionRate(100)
   effects[table.getn(effects)+1] = splode
end

effect.draw = function ()
   for k,v in ipairs(effects) do
      if v.particle then v.particle:update(0.1) end
      love.graphics.draw(v.drawable, v.x, v.y)
      if v.age == 50 then table.remove(effects, k) end
      v.age = v.age + 1
   end
end

return effect
