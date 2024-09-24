local DAMN = DAMN or {};

-- arrays

function DAMN:itemIsInArray(array, searchItem)
    --for i, item in ipairs(array)
	for i=1,#array--lect
    do
	item = array[i]--lect
        if string.trim(tostring(item)) == string.trim(tostring(searchItem))
        then
            return true;
        end
    end

    return false;
end

function DAMN:getFileNameFallback(fileName)
	local fragments = DAMN:splitString(fileName, "/");
	local newFile = table.remove(fragments) or fileName;
	local badStuff = {
		"<", ">", ":", "'", "/", "\\", "|", "?", "*", "%", ".."
	};

	--for i, chr in ipairs(badStuff)
	for i=1,#badStuff--lect
	do
	chr = badStuff[i]--lect
		newFile = string.gsub(newFile, DAMN:escapeString(chr), chr == ".."
			and "."
			or "_"
		);
	end

	table.insert(fragments, newFile);

	return table.concat(fragments, "/");
end

function DAMN:appendLineToFile(fileName, line)
	local file = DAMN:getFileWriter(fileName, true, true);

	if not file
	then
		return;
	end

    --for i, line in ipairs(DAMN:tableIfNotTable(line))
	for i=1,#DAMN:tableIfNotTable(line)--lect
    do
	line = DAMN:tableIfNotTable(line)[i]--lect
        if type(line) ~= "function" and type(line) ~= "table"
        then
            file:write(tostring(line) .. "\n");
        end
    end

    file:close();
end

function DAMN:printList(list, tpl)
    --for i, item in ipairs(list)
	for i=1,#list--lect
    do
	item = list[i]--lect
        DAMN:log(string.format(tpl or "%s", tostring(item)));
    end
end