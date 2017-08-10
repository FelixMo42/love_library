--love functions

_FUNCTIONS = {
	"draw",
	"update",
	"keypressed",
	"keyreleased",
	"mousemoved",
	"mousepressed",
	"mousereleased",
	"wheelmoved",
	"mousefocus",
	"visible",
	"textinput",
	"resize"
}

local function lovefunction(f)
	return function(...)
		for name , system in pairs(systems) do
			if system.dofunc then system:dofunc(f,...) end
			if system[f] then system[f](system,...) end
		end
		tab:dofunc(f,...)
		for name , system in pairs(systems) do
			if system.dofunc then system:dofunc(f.."End",...) end
			if system[f.."End"] then system[f.."End"](system,...) end
		end
	end
end

for i , f in ipairs(_FUNCTIONS) do
	love[f] = lovefunction(f)
end

function love.open(t,...)
	tab:dofunc("close",...)
	if type(t) == "tab" then
		tab = t
		tab:dofunc("open",...)
	else
		tab = tabs[t]
		tab:dofunc("open",...)
	end
end

function love.load(...)
	tab:dofunc("open",...)
	for name , system in pairs(systems) do
		if system.dofunc then system:dofunc("load",...) end
		if system.load then system:load(...) end
	end
end

function love.quit(...)
	tab:dofunc("close",...)
	for i , t in ipairs(tabs) do
		t:dofunc("quit",...)
	end
	for name , system in pairs(systems) do
		if system.dofunc then system:dofunc("quit",...) end
		if system.quit then system:quit(...) end
	end
end

_FUNCTIONS[#_FUNCTIONS + 1] = "load"
_FUNCTIONS[#_FUNCTIONS + 1] = "quit"

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
		if not filesystem:isDirectory(file) and file ~= "main.lua" and file ~= "conf.lua" then
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