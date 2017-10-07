local http = require("socket.http")
local socket = require("socket")
local dir = love.filesystem.getSource()
--set up
http.TIMOUT = 10
local settings = {}
if love.conf then love.conf(settings); settings.libraries = settings.libraries or {} end
if not settings.update or dir:find(".app") then return require("system",settings.libraries) end
--see if ther is internet accesse
local test = socket.tcp()
test:settimeout(1000)
settings.connection = test:connect("www.google.com",80)
test:close()
if settings.connection == nil then return require("system",settings.libraries) end
--local functons
local function gitfile(path)
	return http.request("http://www.mosegames.com/https.php","https://raw.githubusercontent.com/FelixMo42/love_library/master/"..path)
end
local function write(path,content)
	local file = io.open(dir.."/"..path , "w")
	file:write(content)
	file:close()
end
local function read(path)
	local file = io.open(dir.."/"..path , "w")
	local c = file:read("*l")
	file:close()
	return c
end
--get net directory
local net_directory = gitfile("system/directory.lua")
local loc_directory = read("system/directory.lua") or "return {}"
if net_versions == loc_versions then return require("system",settings.libraries) end
write("system/directory.lua" , net_directory)
net_directory = loadfile( net_directory )()
loc_directory = loadfile( loc_directory )()
--update files
for path , v in pairs(net_versions) do
	if (loc_versions[path] or -1) < v then
		for i = #path , 1 , -1 do
			if path:sub(i,i) == "/" then
				os.execute("mkdir "..dir:gsub(" ","\\ ").."/"..path:sub(1,i-1):gsub(" ","\\ ") )
				break
			end
		end
		write(path , gitfile(path))
	end
end
--remove old files
for path , v in pairs(loc_versions) do
	if not net_versions[path] then
		os.execute("rm "..dir:gsub(" ","\\ ").."/"..path:gsub(" ","\\ "))
	end
end
--return
return require("system",settings.libraries)