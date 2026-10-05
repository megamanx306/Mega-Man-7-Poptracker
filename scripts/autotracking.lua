local seen_items = {}
local function clear(slot_data)
    seen_items = {}
    mm7_apply_slot(slot_data)
    seed_locations = nil
    if Archipelago.MissingLocations ~= nil and Archipelago.CheckedLocations ~= nil then
        seed_locations = {}
        for _, id in ipairs(Archipelago.MissingLocations) do seed_locations[id] = true end
        for _, id in ipairs(Archipelago.CheckedLocations) do seed_locations[id] = true end
    end
    for _, code in pairs(ITEMS) do
        local obj = Tracker:FindObjectForCode(code)
        if obj then
            if obj.Type == "toggle" then obj.Active = false else obj.AcquiredCount = 0 end
        end
    end
    local checked = {}
    for _, id in ipairs(Archipelago.CheckedLocations or {}) do checked[id] = true end
    for id, code in pairs(LOCATIONS) do
        local obj = Tracker:FindObjectForCode(code)
        if obj then obj.AvailableChestCount = checked[id] and 0 or obj.ChestCount end
    end
mm7_refresh_stage_display()
if mm7_refresh_shop then mm7_refresh_shop() end
end
local function item(index, id, name, player)
    if seen_items[index] then return end
    seen_items[index] = true
    local code = ITEMS[id]
    if not code then print("Unmapped AP item: " .. tostring(name) .. " / " .. tostring(id)); return end
    local obj = Tracker:FindObjectForCode(code)
    if obj then
        if obj.Type == "toggle" then obj.Active = true;if mm7_refresh_shop then mm7_refresh_shop() end; return end
        local next_count = obj.AcquiredCount + 1
        if obj.MaxCount > 0 then next_count = math.min(next_count, obj.MaxCount) end
        obj.AcquiredCount = next_count
        if mm7_refresh_shop then mm7_refresh_shop() end
    end
end
local function location(id, name)
    mm7_checked[id] = true
    local refresh = Tracker:FindObjectForCode("logic_refresh")
    if refresh then refresh.Active = not refresh.Active end
    local code = LOCATIONS[id]
    if not code then print("Unmapped AP location: " .. tostring(name) .. " / " .. tostring(id)); return end
    if seed_locations then seed_locations[id] = true end
    local obj = Tracker:FindObjectForCode(code)
    if obj then obj.AvailableChestCount = 0 end
    if mm7_refresh_shop then mm7_refresh_shop() end
end
Archipelago:AddClearHandler("kirby_reset", clear)
Archipelago:AddItemHandler("kirby_item", item)
Archipelago:AddLocationHandler("kirby_location", location)
