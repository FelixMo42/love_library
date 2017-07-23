local tab = class:new({
	layer = {}
})

local function add(self,item,i,name)
	if type(i) == "string" then
		self[i] = item
		i = name
	elseif name then
		self[name] = item
	end
	i = i or #self + 1
	table.insert(self,i,item)
end

function tab:addLayer(name , i)
	self.layer[name] = {add = add}
	_G[self.name][name] = self.layer[name]
	i = i or #self.layer  + 1
	table.insert(self.layer,i,self.layer[name])
end

function tab:load()
	self:addLayer("main")
	self.layer.main.tab = _G[self.name]
	function self.layer.main:dofunc(f,...)
		if self.tab[f] then
			return self.tab[f](...)
		end
	end
	self:addLayer("ui")
end

function tab:dofunc(f,...)
	local ret = {}
	for i , layer in ipairs(self.layer) do
		if layer.dofunc then
			ret[#ret + 1] = layer:dofunc(f,...)
		else
			for i , item in ipairs(layer) do
				if item.dofunc then
					ret[#ret + 1] = item:dofunc(f,...)
				elseif type(item[f]) == "function" then
					ret[#ret + 1] = item[f](item,...)
				end
			end
		end
	end
	return unpack(ret)
end

tabs = {}

package.preload["tab"] = function() return tab end

return tab