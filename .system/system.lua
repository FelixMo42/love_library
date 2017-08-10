--lua

function addmetamethod(k,p)
	p = p or "raw"
	if not _G[p..k] then
		_G[p..k] = _G[k]
	end
	_G[k] = function(i,...)
		local mt = getmetatable(i)
		if mt and mt["__"..k] then return mt["__"..k](i,...) end
		return _G[p..k](i,...)
	end
end

addmetamethod("type")
addmetamethod("tostring")
addmetamethod("get")
addmetamethod("set")

--math

math.clamp = function(val,min,max)
	return math.min( math.max(val + 0,min + 0) , max + 0)
end

math.loop = function(val,max,min)
	if min then
		local m = min
		min = max
		max = m
	else
		min = 1
	end
	if val > max then
		val = min + (val - max - 1)
	end
	while val < min do
		val = max - (min - val)
	end
	return val
end

math.sign = function(n)
	if n > 0 then
		return 1
	elseif n < 0 then
		return -1
	else
		return 0
	end
end

math.approach = function(c,t,s)
	return math.min(c + s , t)
end

--table

table.reverse = function(t)
	local n = {}
	for k , v in pairs(t) do n[k] = v end
	for i , v in ipairs(t) do n[#t - (i - 1)] = v end
	return n
end

table.count = function(t)
	local c = 0
	for k , v in pairs(t) do c = c + 1 end
	return c
end

table.isEmpty = function(t)
	for k , v in pairs(t) do return false end
	return true
end
 
table.copy = function(t , i , l)
	local n , i , l = {} , i or -1 , l or {}
	for k , v in pairs(t) do
		if type(v) == "table" then
			if not l[v] and i ~= 0 then
				l[v] = {}
				table.incert( l[v] , table.copy(v , i - 1 , l) )
			end
			n[k] = l[v]
		else
			n[k] = v
		end
	end
	local m = getmetatable(t)
	if m then
		if not l[m] then
			l[m] = {}
			table.incert( l[m] , table.copy(m , -1 , l) )
		end
		setmetatable(n , l[m])
	end
	return n
end

table.incert = function(t,n)
	for k , v in pairs(n) do
		t[k] = v
	end
end

--love

function love.graphics.prints(t,x,y,w,h,xa,ya)
	if not ya or ya == "center" then
		local l = #( ( {love.graphics.getFont():getWrap(t,w)} )[2] )
		y = y + h / 2 -  (l * love.graphics.getFont():getHeight())/2
	elseif ya == "bottom" then
		local l = #( ( {love.graphics.getFont():getWrap(t,w)} )[2] )
		y = y + h - (l * love.graphics.getFont():getHeight())
	end
	love.graphics.printf(t,x,y,w,xa or "center")
end