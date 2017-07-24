local http = require("socket.http")
local socket = require("socket")
local dir = love.filesystem.getRealDirectory("")

http.TIMOUT = 10
package.path = package.path..";"..dir.."/.system/require.lua"
if dir:find(".app") then return require ".system" end

local test = socket.tcp()
test:settimeout(1000)
local testResult = test:connect("www.google.com", 80)
test:close()
test = nil
if testResult == nil then return require ".system" end

local function gitfile(file)
	local data = "https://raw.githubusercontent.com/FelixMo42/love_library/master/"..file
	local d = http.request("http://www.mosegames.com/https.php",data)
	return d
end

local f = loadfile(dir.."/.directory.lua")
local loc_versions = f and f() or {}
local net_versions = loadstring( gitfile(".directory.lua") )()
if net_versions[".directory.lua"] == loc_versions[".directory.lua"] then return require ".system" end

for f , v in pairs(net_versions) do
	if loc_versions[f] >= v then
		local s = 1
		for i = 1 , #path do
			if path:sub(i,i) == "/" then
				os.execute("mkdir "..dir:gusb(" ","\\ ").."/"..path:sub(s,i-1):gusb(" ","\\ ") )
				s = i + 1
			end
		end
		local file = io.open(dir.."/"..path , "w")
		file:write( gitfile(path) )
		file:close()
	end
end

return require ".system"