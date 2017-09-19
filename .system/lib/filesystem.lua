local filesystem = class:new({
	dir = love.filesystem.getSource()
})

function filesystem:exist(p)
	local ok, err, code = os.rename(self.dir.."/"..p , self.dir.."/"..p)
	if not ok and code == 13 then return true, err end
	return ok, err
end

function filesystem:isDirectory(path)
	return self:exist(path.."/")
end

function filesystem:getDirectory(file,ext,hidden)
	if type(ext) == "boolean" then hidden , ext = ext , hidden end
	local path , i , t = (self.dir.."/"..file):gsub(" ","\\ ") , 1 , {}
    local pfile = io.popen('ls -a '..path)
    for filename in pfile:lines() do
        if filename:sub(1,1) ~= "." or hidden then
            if not ext or filename:find(ext) then
                t[i] = filename
                i = i + 1
            end
        end
	end
    pfile:close()
    return t
end

return filesystem