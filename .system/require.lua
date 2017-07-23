local inputs = {...}
local dir = "/"..(...)

f = loadfile(love.filesystem.getRealDirectory("")..dir)
if f then return f(inputs) end
f = loadfile(love.filesystem.getRealDirectory("")..dir..".lua")
if f then return f(inputs) end
f = loadfile(love.filesystem.getRealDirectory("")..dir.."/init.lua")
if f then return f(inputs) end

love.errhand("could not find "..dir)