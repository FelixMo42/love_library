local dir = ""

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

local function update(p)
	dir = love.filesystem.getSource().."/"..p:gsub("/","-")
	local net_directory = gitfile("directory.lua")
	local loc_directory = read("directory.lua") or "{}"
	if net_directory == loc_directory then return end
	write("system/directory.lua" , net_directory)
	net_directory = loadfile( net_directory )()
	loc_directory = loadfile( loc_directory )()
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
	for path , v in pairs(loc_versions) do
		if not net_versions[path] then
			os.execute("rm "..dir:gsub(" ","\\ ").."/"..path:gsub(" ","\\ "))
		end
	end
end

for i , path in pairs(system.settings.includes) do
	if system.libraries.update and settings.connection then
		update(path)
	end
	require("system/" + path , "system/" + path)
end