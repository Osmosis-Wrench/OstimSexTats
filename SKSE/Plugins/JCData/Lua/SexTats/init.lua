local jc = jrequire 'jc'

local SexTats = {}

function SexTats.getValidRandom(collection, last)
    local array = jc.filter(collection, function(x)
        return x.Enabled == 1 and x.Title ~= last
    end)
    --local random = math.random(#array)
    return array[math.random(#array)]
end

function SexTats.handleSlaveTats(collection)
	local array = jc.filter(collection.Default, function(x) return x end) -- this is a weird hack
	array = array[1]
	local test = JMap.allKeys(array)
	local test1 = test[5]
	local ret = JMap.object()
	
	for k,v in pairs(array) do
		local temp = v
		local extra = JMap.object()
		local mylen = #v
		JMap.__newindex(extra, 'len', mylen)
		JArray.insert(temp, extra)
		--JMap.__newindex(ret, k, temp)
		local x = 1
		while x < #v do
			local tempx = temp[x]
			JMap.__newindex(tempx, 'enabled', 1)
			local section = JValue.solvePath(tempx, '.section'):gsub('%W','')
			local area = JValue.solvePath(tempx, '.area'):gsub('%W','')
			local name = JValue.solvePath(tempx, '.name'):gsub('%W','')
			JMap.__newindex(ret, area .. '_' .. section .. '_' .. name .. '_' .. x, tempx)
			x = x + 1
		end
	end
		--JArray.insert(ret, array[test[x]])
	return ret
end


return SexTats