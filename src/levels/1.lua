local test = require "actors/test"
local wall = require "actors/bg"
local cateye = require "actors/cateye"
local player = require "actors/player"

local actors = {
   {test, 100, 100},
   {player, 40, 80},
   {wall, 0, 0},
   {wall, 0, 160},
   {cateye, 180, 40},
   {cateye, 200, 120},
   {cateye, 220, 40},
   {cateye, 240, 120},
   {cateye, 260, 40},
   {cateye, 280, 120},
}

local setup = {
   bgcolor = {85,45,65,255}
}

return {
   actors=actors,
   setup=setup,
}
