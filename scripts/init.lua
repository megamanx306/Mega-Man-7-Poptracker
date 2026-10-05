Tracker:AddItems("items/items.json")
ScriptHost:LoadScript("scripts/mappings.lua")
seed_locations = nil
function seed_has(id)
    return seed_locations == nil or seed_locations[tonumber(id)] == true
end
ScriptHost:LoadScript("scripts/logic-data.lua")
ScriptHost:LoadScript("scripts/logic.lua")
Tracker:AddMaps("maps/maps.json")
Tracker:AddLocations("locations/locations.json")
Tracker:AddLayouts("layouts/layouts.json")
ScriptHost:LoadScript("scripts/autotracking.lua")

ScriptHost:LoadScript("scripts/shop-data.lua")
ScriptHost:LoadScript("scripts/stage-shop.lua")

ScriptHost:LoadScript("scripts/stage-display.lua")
