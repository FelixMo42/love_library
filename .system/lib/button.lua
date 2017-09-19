local button = object:new({
	width = 100, height = 20, b = 0,
	bodyColor = {0,0,0},
	lineColor = {255,255,255},
	textColor = {255,255,255},
	sx = 0, sy = 0,
	ex = 0, ey = 0,
	x = 0, y = 0,
	text = "button",
	getmode = "norm",
	over = false,
	pressed = false,
	b_over = 4,
	modes = {
		"pressed",
		"over"
	}
})

button:addCallback("draw","body",function(self)
	love.graphics.setColor(self.bodyColor)
	love.graphics.rectangle("fill",self.x,self.y,self.width,self.height,self.edge or 0)
end )

button:addCallback("draw","outline",function(self)
	love.graphics.setColor(self.lineColor)
	love.graphics.rectangle("line",self.x,self.y,self.width,self.height,self.edge or 0)
end )

button:addCallback("draw","text",function(self)
	love.graphics.prints(self.text,self.x,self.y,self.width,self.height,self.textMode,self.textAligne)
end )

button:addCallback("mousepressed","pressed",function(self)
	self.pressed = self.over
end )

button:addCallback("mousepressed","used",function(self)
	if not mouse.used and self.over then
		mouse.used = true
	end
end)

button:addCallback("mousereleased","callFunc",function(self)
	if self.over and self.func and not mouse.used then
		self:func()
	end
end )

button:addCallback("mousereleased","used",function(self)
	if not mouse.used and self.over then
		mouse.used = true
	end
end )

button:addCallback("mousereleased","released",function(self)
	self.pressed = false
end )

button:addCallback("mousemoved","over",function(self,x,y)
	if x > self.x and x < self.x + self.width and y > self.y and y < self.y + self.height then
		self.over = true
	else
		self.over = false
	end
end )

local mt = getmetatable(button)

mt.__get = function(self , key)
	return getmetatable(self).__values[key]
end

mt.__set = function(self , key , value)
	getmetatable(self).__values[key] = value
end

mt.__index = function(self,key)
	local mt = getmetatable(self)
	if mt.__getter[key] then return mt.__getter[key](self,key) end
	if type(key) == "string" then
		for i , mode in ipairs(get(self,"modes")) do
			if get(self,mode) and get(self,key.."_"..mode) then
				return get(self,key.."_"..mode)
			end
		end
	end
	return get(self,key)
end

mt.__getter.x = function(self)
	local x = get(self,"x") 
	for i , mode in ipairs(get(self,"modes")) do
		if get(self,mode) and get(self,"x_"..mode) then
			x = get(self,"x_"..mode)
			break
		end
	end
	return (screen.width * self.sx) + ( x - ( self.bl or ( (self.bw or self.b) / 2 ) ) )
end

mt.__getter.y = function(self)
	local y = get(self,"y")
	for i , mode in ipairs(get(self,"modes")) do
		if get(self,mode) and get(self,"y_"..mode) then
			y = get(self,"y_"..mode)
		end
	end
	return (screen.height * self.sy) + ( y - ( self.bu or ( (self.bh or self.b) / 2 ) ) )
end

mt.__getter.width = function(self)
	local w = get(self,"width")
	for i , mode in ipairs(get(self,"modes")) do
		if get(self,mode) and get(self,"width_"..mode) then
			w = get(self,"width_"..mode)
			break
		end
	end
	return (screen.width * self.ex) + ( w + (self.br or self.bw or self.b) + (self.bl or 0) )
end

mt.__getter.height = function(self)
	local h = get(self,"height")
	for i , mode in ipairs(get(self,"modes")) do
		if get(self,mode) and get(self,"height_"..mode) then
			h = get(self,"height_"..mode)
			break
		end
	end
	return (screen.height * self.ey) + ( h + (self.bd or self.bh or self.b) + (self.bu or 0) )
end

return button