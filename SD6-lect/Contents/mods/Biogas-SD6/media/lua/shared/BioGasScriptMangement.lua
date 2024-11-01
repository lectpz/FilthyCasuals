local scriptManager = ScriptManager.instance

local item = scriptManager:getItem("Base.PropaneTank")
if item then
    item:DoParam("KeepOnDeplete = TRUE")
    item:DoParam("cantBeConsolided = FALSE")
end