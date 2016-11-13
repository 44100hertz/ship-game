require "effect"
require "collision"

love.graphics.setDefaultFilter("nearest","nearest")

local actors
local loaded_actors
local level = require "levels/1"
local game = {}

game.init = function ()
   actors = {}
   loaded_actors = {}
   game.scroll = 0
   game.shake = 0
end

game.reset = function ()
   game.init()
end

game.addactor = function (parent, newactor, x, y)
   local index = table.getn(actors) + 1
   actors[index] = {} -- Fixes issue with :new calling actors.add
   actors[index] = newactor:new(x, y, parent)
end

game.update = function ()
   -- Load in Actors --
   for k,v in ipairs(level.actors) do
      if not loaded_actors[k] and v and v[2]-360 < game.scroll then
	 game.addactor(nil, unpack(v))
	 loaded_actors[k] = true
      end
   end

   -- Collisions --
   collision.update(actors)

   -- Actor State --
   for k,v in ipairs(actors) do -- Despawn only after all collisions finish
      if v.despawn then table.remove(actors, k) end
   end
   for _,v in ipairs(actors) do -- Run actor update functions
      if v.update then v:update() end
   end

   game.scroll = game.scroll + 0.25 -- TODO: separate visual scroll rate
end

game.draw = function ()
   love.graphics.clear(level.setup.bgcolor)

   table.sort(actors, -- Depth Ordering
	      function (o1, o2)
		 -- Higher num = further back
		 return (o1.draw and o2.draw and o1.depth > o2.depth)
	      end
   )
   game.shake = (game.shake > 1) and game.shake-1 or 0
   local shake = game.shake * ((game.shake % 2) - 0.5)

   effect.draw(game.scroll) -- Draw visual effects on back layer
   for _,v in ipairs(actors) do
      if v.draw then
	 v:draw(math.floor(v.x - game.scroll + 0.5),
		math.floor(v.y + 0.5 + shake))
      end
   end
end

return game
