local jc = jrequire 'jc'

local SexTats = {}

function SexTats.getValidRandom(collection, last)
    local array = jc.filter(collection, function(x)
        return x.Enabled == 1 and x.Title ~= last
    end)
    --local random = math.random(#array)
    return array[math.random(#array)]
end

function SexTats.handleSlaveTats2(collection)
	local array = jc.filter(collection.Default, function(x) return x end) -- this is a weird hack
	array = array[1]
	local test = JMap.allKeys(array)
	--local ret = array[test[1]]
	--local ret = JArray.object()
	local test1 = test[5]
	return array[test1]
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
		JMap.__newindex(ret, k .. 'a', temp)
		local x = 1
		while x < #v do
			local tempx = temp[x]
			JMap.__newindex(tempx, 'enabled', 'true')
			x = x + 1
		end
	end
		--JArray.insert(ret, array[test[x]])
	return ret
end

function SexTats.handleSlaveTats3(collection)
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
		JMap.__newindex(ret, k .. 'a', temp[mylen])
	end
		--JArray.insert(ret, array[test[x]])
	return ret
end

function SexTats.b(collection)
	local array = jc.filter(collection.Default, function(x) return x end) -- this is a weird hack
	array = array[1]
	local test = JMap.allKeys(array)
	array = JValue.solvePath(array, '.' .. test[1])
	array = array[1]
	local test1 = JMap.object()
	local test2 = AnalThisAnusOpen
	--test1.AnalThisAnusOpen = array
	JArray.insert(test1, array, tostring(test2))
	
	-- works
	for k,v in pairs(array) do
		if true == true then JMap.__newindex(ret, k, v) end
	end
	
		for x,y in pairs(v) do
			JMap.__newindex(ret, k, v[x])
		end
	
	return test1
end

-- returns a jcontainers object containing all objects with key value pair
-- JValue.evalLuaObj(animations, "return ostim.getAnimationsKeyValuePair(jobject,'animclass', 'Sx', 1, 0)")
-- papyrus bool to lua bool is an absolute pita, so just gonna use 1 and 0. if somebody works out something neater feel free to change.
function SexTats.getAnimationsKeyValuePair(collection, key, value, allowPartialString, negativePartial)
    return jc.filter(collection, function(x)
        if allowPartialString == 1 then
            local ret = true
            if negativePartial == 1 then ret = false end
            if ((x[key]):lower()):find((value):lower(), 1, true) then return ret else return not ret end
        else
            return x[key] == value
        end
    end)
end

return SexTats