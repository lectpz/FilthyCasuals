function printSDZones()

	print("===============Zones================")

	for k,v in pairs(Zone.list) do
		local zone = "\"" .. k .. "\""
		local nested = "nil"
		local toxic = "nil"
		if v[6] then nested = "\"" .. v[6] .. "\"" end
		if v[7] then toxic = "\"" .. v[7] .. "\"" end
		print("[" .. zone .. "]={" .. v[1] .. "," .. v[2] .. "," .. v[3] .. "," .. v[4] .. "," .. v[5] .. ",".. nested .. ",".. toxic .. "," .. v[8] .. "," .. v[9] .. "," .. v[10] .. "," .. v[11] .. "},")
	end

	print("===============NestedZones================")
	for k,v in pairs(NestedZone.list) do
		local zone = "\"" .. k .. "\""
		local nested = "nil"
		local toxic = "nil"
		if v[6] then nested = "\"" .. v[6] .. "\"" end
		if v[7] then toxic = "\"" .. v[7] .. "\"" end
		print("[" .. zone .. "]={" .. v[1] .. "," .. v[2] .. "," .. v[3] .. "," .. v[4] .. "," .. v[5] .. ",".. nested .. ",".. toxic .. "," .. v[8] .. "," .. v[9] .. "," .. v[10] .. "," .. v[11] .. "},")
	end
end