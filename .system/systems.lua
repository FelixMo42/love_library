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

systems = {
	mouse = mouse,
	screen = screen
}

return systems