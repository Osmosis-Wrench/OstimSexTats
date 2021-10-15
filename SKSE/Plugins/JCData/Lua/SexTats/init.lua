local jc = jrequire 'jc'

local SexTats = {}

-- recreates slavetats_cache.json I think, it's pretty fucking close at least.
function SexTats.handleFiles(collection)
	local ret = JMap.object()
	local groupedByArea = JMap.object()
	local allTattooArray = JArray.object()

	for k,v in pairs(collection) do
		for x = 1, #v do
			JArray.insert(allTattooArray, v[x])
		end
	end

	local allBodyArray = JArray.object()
	local allFaceArray = JArray.object()
	local allFeetArray = JArray.object()
	local allHandsArray = JArray.object()

	for x = 1, #allTattooArray do
		local areaName = allTattooArray[x].area:lower()
		if areaName == 'body' then
			JArray.insert(allBodyArray, allTattooArray[x])
		elseif areaName == 'face' then
			JArray.insert(allFaceArray, allTattooArray[x])
		elseif areaName == 'feet' then
			JArray.insert(allFeetArray, allTattooArray[x])
		elseif areaName == 'hands' then
			JArray.insert(allHandsArray, allTattooArray[x])
		end
	end

	local allBodyMap = SexTats.sortArrayToMapSection(allBodyArray)
	local allFaceMap = SexTats.sortArrayToMapSection(allFaceArray)
	local allFeetMap = SexTats.sortArrayToMapSection(allFeetArray)
	local allHandsMap = SexTats.sortArrayToMapSection(allHandsArray)

	groupedByArea['BODY'] = allBodyMap
	groupedByArea['face'] = allFaceMap
	groupedByArea['Feet'] = allFeetMap
	groupedByArea['Hands'] = allHandsMap
	ret['Default'] = groupedByArea
	return ret
end

function SexTats.sortArrayToMapSection(collection)
	local ret = JMap.object()

	for x = 1, #collection do
		local sectionName = collection[x].section
		if ret[sectionName] ~= nil then

			local temp = JArray.object()
			temp = jc.filter(ret[sectionName], function() return true end)
			-- weird hack to normalise JArray, otherwise we'd end up with a bunch of jarrays inside jarrays
			-- I really don't understand why this works, but it does. If you know, please fucking tell me.
			JArray.insert(temp, collection[x])
			
			ret[sectionName] = temp
		else
			local firstTemp = JArray.object()
			--collection[x].number = x
			JArray.insert(firstTemp, collection[x])
			ret[sectionName] = firstTemp
		end
	end

	return ret
end

-- okay this is pretty gross code, but it works.
function SexTats.handleSlaveTats(collection)
	local ret = JMap.object()
	collection = jc.filter(collection.Default, function(x) return x end) -- this is a weird hack
	for b = 0, #collection do
		local sectionArray = collection[b]
	    for k,v in pairs(sectionArray) do
	    	local packArray = v
			for x = 0, #v do
	    		local tattooArray = packArray[x]
				if tattooArray.texture ~= nil and tattooArray.section ~= nil and tattooArray.area ~= nil and tattooArray.name ~= nil then --if any important stuff is missing, don't append or process any more. skip to next
					local section, area, name = 'empty'
					-- this is where we can add in custom data, like tags, enabled state etc.
					JMap.__newindex(tattooArray, 'enabled', 1)
					-- build key name
					section = (tattooArray.section):gsub('%W','')
					area = (tattooArray.area):gsub('%W','')
					name = (tattooArray.name):gsub('%W','')
					JMap.__newindex(ret, area .. '_' .. section.. '_' .. name, tattooArray)
				end
	    		x = x + 1
	    	end
	    end
		b = b + 1
	end
	return ret
end

return SexTats