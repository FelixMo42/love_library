 --systems

mouse = {
	x = love.mouse.getX(), y = love.mouse.getY(),
	dx = 0, dy = 0, sx = 0, sy = 0, ex = 0, ey = 0,
	button = 0, drag = false, used = false,
	mousemoved = function(x,y,dx,dy)
		mouse.dx , mouse.dy = dx , dy
		mouse.x , mouse.y = x , y
		if mouse.drag == false then
			mouse.drag = true
		end
		mouse.sx , mouse.sy = mouse.x , mouse.y
		if mouse.drag == nil then
			mouse.ex , mouse.ey = mouse.x , mouse.y
		end
	end,
	mousepressed = function(x,y,button)
		mouse.used = false
		mouse.drag = false
		mouse.button = button
		mouse.ex = mouse.x
		mouse.ey = mouse.y
	end,
	mousereleased = function()
		mouse.used = false
	end,
	mousereleasedEnd = function()
		mouse.drag = nil
		mouse.ex = mouse.x
		mouse.ey = mouse.y
	end
}

screen = {
	width = love.graphics.getWidth(),
	height = love.graphics.getHeight(),
	resize = function(w,h)
		screen.width = w
		screen.height = h
	end
}

systems = {mouse = mouse,screen = screen}

--load files

tabs = {}

for i , f in ipairs({"system","_system","classes","_classes"}) do
	if filesystem:exist(f) then
		if filesystem:exist(f.."/init.lua") then
			require(f)
		else
			for i , file in pairs( filesystem:getDirectory(f,".lua") ) do
				if not filesystem:isDirectory(f.."/"..file) then
					require(f.."/"..file)
				end
			end
		end
	end
end

--tabs

local function loadtab(dir,file)
	file = file:gsub(".lua","")
	_G[file] = {}
	local tab = tab:new({name = file})
	tabs[#tabs + 1] = tab
	tabs[tab] = tab
	tabs[file] = tab
	tabs[ _G[file] ] = tab
	require(dir.."/"..file)
	tab:dofunc("load")
end

for i , f in ipairs({"tabs","_tabs"}) do
	if filesystem:exist(f) then
		if filesystem:exist(f.."/init.lua") then
			require(f)
		else
			for i , file in pairs( filesystem:getDirectory(f,".lua") ) do
				if not filesystem:isDirectory(f.."/"..file) then
					file = file:gsub(".lua","")
					_G[file] = {}
					local tab = tab:new({name = file})
					tabs[#tabs + 1] = tab
					tabs[tab] = tab
					tabs[file] = tab
					tabs[ _G[file] ] = tab
					require(f.."/"..file)
					tab:dofunc("load")
				end
			end
		end
	end
end

if not filesystem:exist("tabs") and not filesystem:exist("_tabs") then
	for i , file in pairs( filesystem:getDirectory("",".lua") ) do
		if not filesystem:isDirectory(file) and file ~= "main.lua" or file ~= "conf.lua" then
			file = file:gsub(".lua","")
			_G[file] = {}
			local tab = tab:new({name = file})
			tabs[#tabs + 1] = tab
			tabs[tab] = tab
			tabs[file] = tab
			tabs[ _G[file] ] = tab
			require(file)
			tab:dofunc("load")
		end
	end
end

if not tab.name then
	tab = tabs.def or tabs.menu or tabs[1] or console
end