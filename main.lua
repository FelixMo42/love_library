local http = require("socket.http")
local socket = require("socket")
local dir = love.filesystem.getRealDirectory("")

package.path = package.path..";"..dir.."/.system/require.lua"
http.TIMOUT = 10

if love.filesystem.getSource():find(".love") then return require ".system" end

local test = socket.tcp()
test:settimeout(1000)
local testResult = test:connect("www.google.com", 80)
test:close()
test = nil
if testResult == nil then return require ".system" end

local function gitfile(file)
	return http.request("https://raw.githubusercontent.com/FelixMo42/love_library/master/"..file)
end

local f = loadfile(dir.."/.directory.lua")()
local loc_versions = f and f() or {}
local net_versions = loadstring( gitfile(".directory.lua") )()
if net_versions[".directory.lua"] == loc_versions[".directory.lua"] then return require ".system" end

for f , v in pairs(net_versions) do
	if loc_versions[f] ~= v then
		local file = io.open(dir.."/"..f , "w")
		file:write( gitfile(f) )
		file:close()
	end
end

return require ".system"