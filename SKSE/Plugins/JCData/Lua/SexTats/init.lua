local jc = jrequire 'jc'

local SexTats = {}

-- recreates slavetats_cache.json I think, it's pretty fucking close at least.
-- create flat array with all tatto objects in it, then split that into body area's, then convert to jmap with sections as key.
-- expects something like this:
--			int zDatabase = JValue.readFromDirectory("Data\\Textures\\Actors\\Character\\slavetats",".json")
--			zDatabase = JValue.evalLuaObj(zDatabase, "return SexTats.handleFiles(jobject)")
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
			JArray.insert(allBodyArray, allTattooArray[x], 1)
		elseif areaName == 'face' then
			JArray.insert(allFaceArray, allTattooArray[x], 1)
		elseif areaName == 'feet' then
			JArray.insert(allFeetArray, allTattooArray[x], 1)
		elseif areaName == 'hands' then
			JArray.insert(allHandsArray, allTattooArray[x], 1)
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

-- converts flat jarray into JMap with section as key.
function SexTats.sortArrayToMapSection(collection)
	local ret = JMap.object()

	for x = 1, #collection do
		local sectionName = collection[x].section
		if ret[sectionName] ~= nil then

			local temp = JArray.object()
			temp = jc.filter(ret[sectionName], function() return true end)
			-- weird hack to normalise JArray, otherwise we'd end up with a bunch of jarrays inside jarrays
			JArray.insert(temp, collection[x])
			
			ret[sectionName] = temp
		else
			local firstTemp = JArray.object()
			JArray.insert(firstTemp, collection[x])
			ret[sectionName] = firstTemp
		end
	end

	return ret
end

-- okay this is pretty gross code, but it works.
-- converts slavetats_cache.json into our own format that is easier to handle for parsing with lua, maybe.
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
					local section, area, name = 'empty','empty','empty'
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

-- returns all tattoo packs in a list, this was weirdly complex and can 100% be made simpler.
function SexTats.BuildTattooPage(collection)
	local temp = JArray.object()
	local ret = JArray.object()
	for k,v in pairs(collection) do
		JArray.insert(temp, v.section)
	end
	for k,v in ipairs(temp) do -- clear out dupes
		local found = false
		for x=0, #ret do
			if ret[x] == v then
				found = true
			end
		end
		if found ~= true then
			JArray.insert(ret, v)
		end
	end
	return ret
end

return SexTats