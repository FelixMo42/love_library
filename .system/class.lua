local class = {}

--getter and setter meta functions

function getgetter(self , k , v) return getmetatable(self).__getter[k] end

function setgetter(self , k , v) getmetatable(self).__getter[k] = v end

function getsetter(self , k , v) return getmetatable(self).__setter[k] end

function setsetter(self , k , v) getmetatable(self).__setter[k] = v end

--class metatable

setmetatable( class , {
	__getter = {},
	__setter = {},
	__values = {},
	__index = function(self , k)
		local mt = getmetatable(self)
		if mt.__getter[k] then
			if type(mt.__getter[k]) == "function" then
				return mt.__getter[k](self)
			end
			return mt.__getter[k]
		end
		return mt.__values[k]
	end,
	__newindex = function(self , k , v)
		local mt = getmetatable(self)
		if not mt.__setter[k] or mt.__setter[k](self , v) == false then
			mt.__values[k] = v
		end
	end,
	__next = function(self,key)
		return next( getmetatable(self).__values , key )
	end,
	__type = function(self)
		return self.type or "table"
	end,
	__copy = function(self)
		return table.copy(self)
	end,
	__new = function(self , t)
		for k , v in pairs(t or {}) do
			self[k] = v
		end
	end
} )

--getter and setter values

setgetter( class , "new" , function(self)
	return function(self,...)
		local new = getmetatable(self).__copy(self)
		getmetatable(new).__new(new,...)
		if new.load then new:load() end
		return new
	end
end )

return class