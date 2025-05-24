----------------
--somewhatfrog--
----------------

local function OnInitGlobalModData()
    local items = ScriptManager.instance:getAllItems()
    for i = 0, items:size() - 1 do
        local item = items:get(i)
        if item:getAmmoType() and item:getTypeString() ~= "Weapon" then
            item:DoParam("AttachmentType = GunMagazine")
        end
    end
end

Events.OnInitGlobalModData.Add(OnInitGlobalModData)
