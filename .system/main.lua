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