local class = {}

getter = {}
setter = {}

setmetatable(class , {
	__getter = getter,
	__setter = setter,
	__newindex = function(self , key , value)
		local mt = getmetatable(self)
		if mt.__setter[key] then
			return mt.__setter[key](self , key , value)
		end
		return rawset(self , key , value)
	end,
	__index = function(self , key)
		local mt = getmetatable(self)
		if mt.__getter[key] then
			return mt.__getter[key](self , key)
		end
		return rawget(self , key)
	end,
	__copy = function(self)
		return table.copy(self)
	end,
	__new = function(self , table)
		for k , v in pairs(table or {}) do
			self[k] = v
		end
	end,
	__type = function(self)
		return self.type or "table"
	end
})

getter.new = function() return function(orig, ...)
	local mt = table.copy( getmetatable(orig) )
	local self = mt.__copy(orig)
	mt.__new(self , ...)
	setmetatable(self , mt)
	if self.load then
		self:load()
	end
	return setmetatable({},{
		__call = function(self,...)
			if mt.__call then
				return mt.__call(self,...)
			end
		end,
		__index = function(self,key)
			local mt = getmetatable(self)
			if mt.__index then
				return mt.__index(self,key)
			else
				return rawget(rawgetmetatable(self).__values,key)
			end
		end,
		__newindex = function(self,key,value)
			local mt = getmetatable(self)
			if mt and mt.__newindex then
				mt.__newindex(self,key,value)
			else
				rawset(rawgetmetatable(self).__values,key,value)
			end
		end,
		__copy = function(self)
			return getmetatable(self).__copy(self)
		end,
		__type = function(self)
			return getmetatable(self).__type(self)
		end,
		__new = function(self,new)
			return getmetatable(self).__new(self,new)
		end,
		__next = function(self,key)
			return next(rawgetmetatable(self).__values,key)
		end,
		__getmetatable = function(self)
			return getmetatable(rawgetmetatable(self).__values)
		end,
		__setmetatable = function(self,new)
			local curr = getmetatable(self)
			for k , v in pairs(new) do
				curr[k] = v
			end
		end,
		__rawget = function(self,key)
			return rawget(rawgetmetatable(self).__values,key)
		end,
		__rawset = function(self,key,value)
			return rawset(rawgetmetatable(self).__values,key,value)
		end,
		__tostring = function()
			local mt = getmetatable(self)
			if mt.__tostring then
				return mt.__tostring(self)
			end
			return rawtostring(mt.__values)
		end,
		__unm = function(self)
			local mt = getmetatable(self)
			if mt.__unm then
				return mt.__unm(self)
			end
		end,
		__add = function(a,b)
			if rawtype(a) == "table" then
				local mt = getmetatable(a)
				if mt.__add then return mt.__add(a,b) end
			else
				local mt = getmetatable(b)
				if mt.__add then return mt.__add(b,a) end
			end
		end,
		__sub = function(a,b)
			if rawtype(a) == "table" then
				local mt = getmetatable(a)
				if mt.__sub then return mt.__sub(a,b) end
			else
				local mt = getmetatable(b)
				if mt.__sub then return mt.__sub(b,a) end
			end
		end,
		__mul = function(a,b)
			if rawtype(a) == "table" then
				local mt = getmetatable(a)
				if mt.__mul then return mt.__mul(a,b) end
			else
				local mt = getmetatable(b)
				if mt.__mul then return mt.__mul(b,a) end
			end
		end,
		__div = function(a,b)
			if rawtype(a) == "table" then
				local mt = getmetatable(a)
				if mt.__div then return mt.__div(a,b) end
			else
				local mt = getmetatable(b)
				if mt.__div then return mt.__div(b,a) end
			end
		end,
		__mod = function(a,b)
			if rawtype(a) == "table" then
				local mt = getmetatable(a)
				if mt.__mod then return mt.__mod(a,b) end
			else
				local mt = getmetatable(b)
				if mt.__mod then return mt.__mod(b,a) end
			end
		end,
		__pow = function(a,b)
			if rawtype(a) == "table" then
				local mt = getmetatable(a)
				if mt.__pow then return mt.__pow(a,b) end
			else
				local mt = getmetatable(b)
				if mt.__pow then return mt.__pow(b,a) end
			end
		end,
		__concat = function(a,b)
			if rawtype(a) == "table" then
				local mt = getmetatable(a)
				if mt.__concat then return mt.__concat(a,b) end
			else
				local mt = getmetatable(b)
				if mt.__concat then return mt.__concat(b,a) end
			end
		end,
		__eq = function(a,b)
			if rawtype(a) == "table" then
				local mt = getmetatable(a)
				if mt.__eq then return mt.__eq(a,b) end
			else
				local mt = getmetatable(b)
				if mt.__eq then return mt.__eq(b,a) end
			end
		end,
		__lt = function(a,b)
			if rawtype(a) == "table" then
				local mt = getmetatable(a)
				if mt.__lt then return mt.__lt(a,b) end
			else
				local mt = getmetatable(b)
				if mt.__lt then return mt.__lt(b,a) end
			end
		end,
		__le = function(a,b)
			if rawtype(a) == "table" then
				local mt = getmetatable(a)
				if mt.__le then return mt.__le(a,b) end
			else
				local mt = getmetatable(b)
				if mt.__le then return mt.__le(b,a) end
			end
		end,
		__values = self
	})
end end

setter.new = function(self) return "value not setable" end

class = class:new()

return class