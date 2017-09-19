local http = require("socket.http")
local socket = require("socket")
local dir = love.filesystem.getSource()

http.TIMOUT = 10
package.path = package.path..";"..dir.."/.system/require.lua"
if dir:find(".app") then return require ".system" end

local test = socket.tcp()
test:settimeout(1000)
local testResult = test:connect("www.google.com",80)
test:close()
test = nil
if testResult == nil then return require ".system" end

local function gitfile(file)
	local data = "https://raw.githubusercontent.com/FelixMo42/love_library/master/"..file
	local ret
	repeat
		ret = http.request("http://www.mosegames.com/https.php",data)
	until ret
	return ret
end

local f = loadfile(dir.."/.directory.lua")
local loc_versions = f and f() or {}
local net_versions = loadstring( gitfile(".directory.lua") )()
if net_versions[".directory.lua"] == loc_versions[".directory.lua"] then return require ".system" end

for path , v in pairs(net_versions) do
	if (loc_versions[path] or -1) < v then
		for i = #path , 1 , -1 do
			if path:sub(i,i) == "/" then
				os.execute("mkdir "..dir:gsub(" ","\\ ").."/"..path:sub(1,i-1):gsub(" ","\\ ") )
				break
			end
		end
		love.errhand(dir.."/"..path)
		local file = io.open(dir.."/"..path , "w")
		file:write( gitfile(path) )
		file:close()
	end
end

for path , v in pairs(loc_versions) do
	if not net_versions[path] then
		os.execute("rm "..dir:gsub(" ","\\ ").."/"..path:gsub(" ","\\ "))
	end
end

return require ".system"