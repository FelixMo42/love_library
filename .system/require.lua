local inputs = {...}
local dir = love.filesystem.getSource().."/"..(...)

for i , ext in ipairs({"",".lua","/init.lua"}) do
	f , e = loadfile(dir..ext)
	if f then return f(inputs) end
	if os.rename(dir..ext , dir..ext) and not os.rename(dir..ext.."/" , dir..ext.."/") then
		love.errhand(e)
		return e
	end
end

love.errhand("could not find "..dir)