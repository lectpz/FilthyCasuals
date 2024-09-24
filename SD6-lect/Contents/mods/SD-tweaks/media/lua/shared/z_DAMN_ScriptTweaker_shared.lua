local DAMN = DAMN or {};
DAMN.ScriptTools = DAMN.ScriptTools or {};

function DAMN.ScriptTools:loadScriptIfModEnabled(scriptModId, fileName, mod)
    local enabledMods = getActivatedMods();

    --for i, modId in ipairs(DAMN:tableIfNotTable(mod))
	for i=1,#DAMN:tableIfNotTable(mod)--lect
    do
	modId = DAMN:tableIfNotTable(mod)[i]--lect
        if enabledMods:contains(modId)
        then
            DAMN.ScriptTools:loadScriptInModFolder(scriptModId, fileName);

            return true;
        end
    end

    return false;
end