-- Mega Man 7 access rules, based on the supplied APWorld rules.py.
-- Item IDs use the 0x770000 base; location IDs use the 0x770100 base.
-- Helpers below separate stage entry, boss requirements, and safe stage exit.

-- Named offsets retain the AP item/location IDs used by the tracker.
local ITEM = {
    FREEZE_CRACKER = 0,
    DANGER_WRAP = 1,
    THUNDER_BOLT = 2,
    JUNK_SHIELD = 3,
    SLASH_CLAW = 4,
    WILD_COIL = 5,
    NOISE_CRUSH = 6,
    SCORCH_WHEEL = 7,
    RUSH_COIL = 8,
    RUSH_SEARCH = 9,
    RUSH_JET = 10,
    RUSH_R_PLATE = 11,
    RUSH_U_PLATE = 12,
    RUSH_S_PLATE = 13,
    RUSH_H_PLATE = 14,
    HYPER_BOLT = 16,
    EXIT_UNIT = 17,
    PROTO_CLUE_1 = 21,
    PROTO_CLUE_2 = 22,
    WILY_1_ACCESS = 45,
    WILY_2_ACCESS = 46,
    WILY_3_ACCESS = 47,
    FREEZE_MAN_ACCESS = 48,
    CLOUD_MAN_ACCESS = 49,
    JUNK_MAN_ACCESS = 50,
    TURBO_MAN_ACCESS = 51,
    SLASH_MAN_ACCESS = 52,
    SHADE_MAN_ACCESS = 53,
    BURST_MAN_ACCESS = 54,
    SPRING_MAN_ACCESS = 55,
    BOSS_RUSH_ACCESS = 56,
}

local LOCATION = {
    FREEZE_MAN_WEAPON_GET = 8,
    CLOUD_MAN_WEAPON_GET = 9,
    JUNK_MAN_WEAPON_GET = 10,
    TURBO_MAN_WEAPON_GET = 11,
    SLASH_MAN_WEAPON_GET = 12,
    SHADE_MAN_WEAPON_GET = 13,
    BURST_MAN_WEAPON_GET = 14,
    SPRING_MAN_WEAPON_GET = 15,
    MASH_DEFEATED = 16,
    PROTO_MAN_S_CLUE_1_LOCATION = 20,
    PROTO_MAN_S_CLUE_2_LOCATION = 21,
    PROTO_SHIELD_LOCATION = 22,
    RUSH_R_PLATE_LOCATION = 32,
    RUSH_U_PLATE_LOCATION = 33,
    RUSH_S_PLATE_LOCATION = 34,
    RUSH_H_PLATE_LOCATION = 35,
    HYPER_BOLT_LOCATION = 36,
    EXIT_UNIT_LOCATION = 37,
    HYPER_ROCKET_BUSTER_LOCATION = 38,
    ENERGY_BALANCER_LOCATION = 39,
    BEAT_LOCATION = 40,
    INTRO_STAGE_CLEARED = 41,
    RUSH_SEARCH_LOCATION = 42,
    RUSH_JET_LOCATION = 43,
    CLOUD_MAN_S_MEGA_BOLT_LOCATION = 44,
    JUNK_MAN_S_MEGA_BOLT_LOCATION = 48,
    MEGA_HEALTH_CAPSULE_LOCATION = 49,
    GUTS_MAN_G_REWARD = 50,
    GAMERIZER_REWARD = 51,
    HANNYANED_2_REWARD = 52,
    BOSS_RUSH_FREEZE_MAN = 53,
    BOSS_RUSH_BURST_MAN = 60,
    SPRING_MAN_LARGE_BOLT = 64,
    SPRING_MAN_E_TANK = 69,
    BURST_MAN_1_UP_1 = 90,
    WILY_1_LARGE_WEAPON_ENERGY = 102,
    WILY_2_LARGE_WEAPON_ENERGY = 115,
    WILY_3_LARGE_BOLT_1 = 117,
    WILY_3_LARGE_BOLT_2 = 118,
    WILY_3_LARGE_HEALTH_1 = 119,
    WILY_3_1_UP_1 = 120,
    WILY_3_E_TANK_1 = 122,
    WILY_3_W_TANK = 124,
}

mm7_slot = {}
mm7_checked = {}

local function has_code(code)
    return Tracker:ProviderCountForCode(code) > 0
end

local function has_item(item_offset)
    return has_code('i' .. tostring(0x770000 + item_offset))
end

-- Connected slot data takes precedence over manually selected options.
local function is_option_enabled(key)
    local slot_value = mm7_slot[key]
    if slot_value ~= nil then
        return slot_value == true or slot_value == 1
    end
    return has_code('opt_' .. key)
end

local function get_count_setting(key, default)
    local slot_value = mm7_slot[key]
    if slot_value ~= nil then
        return tonumber(slot_value) or default
    end
    local tracker_option = Tracker:FindObjectForCode('opt_' .. key)
    return tracker_option and tracker_option.AcquiredCount or default
end

-- Super Adapter requires all four R.U.S.H plates.
local function has_super_adapter()
    return has_item(ITEM.RUSH_R_PLATE) and has_item(ITEM.RUSH_U_PLATE) and has_item(ITEM.RUSH_S_PLATE) and has_item(ITEM.RUSH_H_PLATE)
end

-- Vertical movement: Rush Coil, Rush Jet, or Super Adapter.
local function has_vertical_movement()
    return has_item(ITEM.RUSH_COIL) or has_item(ITEM.RUSH_JET) or has_super_adapter()
end

local stage_order = {
    'Freeze', 'Cloud', 'Junk', 'Turbo', 'Slash', 'Shade', 'Burst', 'Spring'
}
local stage_access_offsets = {
    Freeze = ITEM.FREEZE_MAN_ACCESS, Cloud = ITEM.CLOUD_MAN_ACCESS, Junk = ITEM.JUNK_MAN_ACCESS, Turbo = ITEM.TURBO_MAN_ACCESS,
    Slash = ITEM.SLASH_MAN_ACCESS, Shade = ITEM.SHADE_MAN_ACCESS, Burst = ITEM.BURST_MAN_ACCESS, Spring = ITEM.SPRING_MAN_ACCESS
}
local stage_defeat_offsets = {
    Freeze = LOCATION.FREEZE_MAN_WEAPON_GET, Cloud = LOCATION.CLOUD_MAN_WEAPON_GET, Junk = LOCATION.JUNK_MAN_WEAPON_GET, Turbo = LOCATION.TURBO_MAN_WEAPON_GET,
    Slash = LOCATION.SLASH_MAN_WEAPON_GET, Shade = LOCATION.SHADE_MAN_WEAPON_GET, Burst = LOCATION.BURST_MAN_WEAPON_GET, Spring = LOCATION.SPRING_MAN_WEAPON_GET,
    Wily1 = LOCATION.GUTS_MAN_G_REWARD, Wily2 = LOCATION.GAMERIZER_REWARD, Wily3 = LOCATION.HANNYANED_2_REWARD
}
local boss_weakness_offsets = {
    Freeze = {ITEM.JUNK_SHIELD, ITEM.SCORCH_WHEEL}, Cloud = {ITEM.DANGER_WRAP}, Junk = {ITEM.THUNDER_BOLT}, Turbo = {ITEM.NOISE_CRUSH},
    Slash = {ITEM.FREEZE_CRACKER, ITEM.SCORCH_WHEEL}, Shade = {ITEM.WILD_COIL}, Burst = {ITEM.FREEZE_CRACKER, ITEM.SCORCH_WHEEL}, Spring = {ITEM.SLASH_CLAW},
    Museum = {ITEM.DANGER_WRAP}, Wily1 = {ITEM.SLASH_CLAW}, Wily2 = {ITEM.WILD_COIL, ITEM.DANGER_WRAP}, Wily3 = {ITEM.SLASH_CLAW, ITEM.NOISE_CRUSH}, Wily4 = {ITEM.WILD_COIL}
}

local function is_stage_completed(stage_name)
    if not stage_defeat_offsets[stage_name] then
        return false
    end
    local id = 0x770100 + stage_defeat_offsets[stage_name]
    local tracker_object = Tracker:FindObjectForCode(LOCATIONS and LOCATIONS[id] or '')
    return mm7_checked[id] == true or (tracker_object ~= nil and tracker_object.AvailableChestCount == 0)
end

local function can_enter_stage(stage_name)
    return not is_option_enabled('robot_master_access_codes') or has_item(stage_access_offsets[stage_name])
end

local function has_boss_weakness(stage_name)
    if not is_option_enabled('logic_boss_weakness') then
        return true
    end
    for _, weapon_offset in ipairs(boss_weakness_offsets[stage_name] or {}) do
        if has_item(weapon_offset) then
            return true
        end
    end
    return false
end

local function can_use_exit_unit(stage_name)
    return (is_option_enabled('exit_unit_in_uncleared_stages') or is_stage_completed(stage_name))
        and (has_item(ITEM.EXIT_UNIT) or (is_option_enabled('paid_exit_unit') and is_option_enabled('paid_exit_unit_in_logic')))
end

local function can_leave_stage(stage_name)
    return can_enter_stage(stage_name) and (has_boss_weakness(stage_name) or can_use_exit_unit(stage_name))
end

local function can_access_shop()
    return has_item(ITEM.HYPER_BOLT) and can_leave_stage('Cloud')
end

local function can_complete_proto_man()
    return has_item(ITEM.PROTO_CLUE_1) and has_item(ITEM.PROTO_CLUE_2) and can_leave_stage('Shade')
end

local function can_clear_boss_rush()
    if not is_option_enabled('boss_rush_checks') or not has_item(ITEM.BOSS_RUSH_ACCESS) then
        return false
    end
    for _, stage_name in ipairs(stage_order) do
        if not has_boss_weakness(stage_name) then
            return false
        end
    end
    return true
end

-- Final-stage requirement type: stages, Robot Masters, weapons, or Proto Man.
local function can_access_final_stage()
    local requirement_type = get_count_setting('wily_4_requirement_type', 0)
    local count = 0
    if requirement_type == 0 then
        for _, stage_name in ipairs({'Wily1', 'Wily2', 'Wily3'}) do
            if is_stage_completed(stage_name) then
                count = count + 1
            end
        end
        if can_clear_boss_rush() then
            count = count + 1
        end
        return count >= get_count_setting('wily_4_wily_stages', 3)
    elseif requirement_type == 1 then
        for _, stage_name in ipairs(stage_order) do
            if is_stage_completed(stage_name) then
                count = count + 1
            end
        end
        return count >= get_count_setting('wily_4_robot_masters', 8)
    elseif requirement_type == 2 then
        for weapon_offset = 0, 7 do
            if has_item(weapon_offset) then
                count = count + 1
            end
        end
        return count >= get_count_setting('wily_4_weapons', 8)
    else
        local id = 0x770100 + LOCATION.PROTO_SHIELD_LOCATION
        local tracker_object = Tracker:FindObjectForCode(LOCATIONS[id] or '')
        return mm7_checked[id] == true
            or (tracker_object ~= nil and tracker_object.AvailableChestCount == 0)
            or can_complete_proto_man()
    end
end

local function can_clear_wily_stage(stage_name)
    if stage_name == 'Wily1' or stage_name == 'Wily3' then
        return has_vertical_movement() and has_boss_weakness(stage_name)
    end
    if stage_name == 'Wily2' then
        return (has_vertical_movement() or (is_option_enabled('strict_seed_logic') and has_item(ITEM.FREEZE_CRACKER))) and has_boss_weakness(stage_name)
    end
    if get_count_setting('wily_4_behavior', 1) == 0 then
        for _, stage in ipairs(stage_order) do
            if not has_boss_weakness(stage) then
                return false
            end
        end
    end
    return has_boss_weakness('Wily4')
end

local function can_leave_wily_stage(stage_name)
    if stage_name == 'Wily4' and is_option_enabled('boss_rush_checks') then
        return has_item(ITEM.BOSS_RUSH_ACCESS)
    end
    if stage_name == 'Wily4' then
        return can_access_final_stage() and (can_clear_wily_stage(stage_name) or can_use_exit_unit(stage_name))
    end
    local code = ({Wily1 = ITEM.WILY_1_ACCESS, Wily2 = ITEM.WILY_2_ACCESS, Wily3 = ITEM.WILY_3_ACCESS})[stage_name]
    return has_item(code) and (can_clear_wily_stage(stage_name) or can_use_exit_unit(stage_name))
end

-- Physical-route exceptions are applied before the seed requirement table.
local function meets_refill_requirement(location_offset)
    if not is_option_enabled('strict_seed_logic') then
        if location_offset == LOCATION.BURST_MAN_1_UP_1 or location_offset == LOCATION.WILY_1_LARGE_WEAPON_ENERGY or location_offset == LOCATION.WILY_3_LARGE_BOLT_1 or location_offset == LOCATION.WILY_3_LARGE_BOLT_2 or location_offset == LOCATION.WILY_3_LARGE_HEALTH_1 then
            return true
        end
        if location_offset >= LOCATION.WILY_3_E_TANK_1 and location_offset <= LOCATION.WILY_3_W_TANK then
            return has_item(ITEM.RUSH_JET) or has_super_adapter()
        end
    end
    local group = MM7_REFILL_REQUIREMENTS[location_offset]
    if group == 'vertical' then
        return has_vertical_movement()
    elseif group == 'thunder' then
        return has_item(ITEM.THUNDER_BOLT)
    elseif group == 'freeze' then
        return has_item(ITEM.FREEZE_CRACKER)
    elseif group == 'jet' then
        return has_item(ITEM.RUSH_JET)
    elseif group == 'jet_super' then
        return has_item(ITEM.RUSH_JET) or has_super_adapter()
    elseif group == 'vertical_freeze' then
        return has_vertical_movement() or has_item(ITEM.FREEZE_CRACKER)
    end
    return true
end

-- Location offsets identify bosses, pickups, and unique upgrades.
function mm7_access(id)
    -- Reading this provider registers the refresh dependency with PopTracker.
    local refresh_dependency = has_code("logic_refresh")
    local location_offset = tonumber(id) - 0x770100
    local stage_name = MM7_CHECK_STAGES[location_offset]

    if location_offset == LOCATION.INTRO_STAGE_CLEARED then
        return true
    end
    if location_offset >= LOCATION.FREEZE_MAN_WEAPON_GET and location_offset <= LOCATION.SPRING_MAN_WEAPON_GET then
        return can_enter_stage(stage_name) and has_boss_weakness(stage_name)
    end
    if location_offset == LOCATION.MASH_DEFEATED then
        local count = 0
        for _, stage in ipairs(stage_order) do
            if is_stage_completed(stage) then
                count = count + 1
            end
        end
        return count >= get_count_setting('robot_museum_robot_masters', 4)
            and (is_option_enabled('skip_robot_museum') or has_boss_weakness('Museum'))
    end
    if location_offset >= LOCATION.GUTS_MAN_G_REWARD and location_offset <= LOCATION.HANNYANED_2_REWARD then
        return has_item(({[LOCATION.GUTS_MAN_G_REWARD] = ITEM.WILY_1_ACCESS, [LOCATION.GAMERIZER_REWARD] = ITEM.WILY_2_ACCESS, [LOCATION.HANNYANED_2_REWARD] = ITEM.WILY_3_ACCESS})[location_offset]) and can_clear_wily_stage(stage_name)
    end
    if location_offset >= LOCATION.BOSS_RUSH_FREEZE_MAN and location_offset <= LOCATION.BOSS_RUSH_BURST_MAN then
        return is_option_enabled('boss_rush_checks') and has_item(ITEM.BOSS_RUSH_ACCESS) and has_boss_weakness(stage_name)
    end

    -- Optional refills: yellow means entry is possible without a safe clear/exit.
    if location_offset >= LOCATION.SPRING_MAN_LARGE_BOLT then
        if not is_option_enabled('pickupsanity') then
            return false
        end
        if location_offset == LOCATION.SPRING_MAN_E_TANK and not is_option_enabled('strict_seed_logic') then
            if not can_leave_stage('Spring') then
                return false
            end
            return has_vertical_movement() and true or AccessibilityLevel.SequenceBreak
        end
        if not is_option_enabled('strict_seed_logic') and (stage_name == 'Wily2' or stage_name == 'Wily3') then
            local code = stage_name == 'Wily2' and ITEM.WILY_2_ACCESS or ITEM.WILY_3_ACCESS
            if not has_item(code) or not meets_refill_requirement(location_offset) then
                return false
            end
            if stage_name == 'Wily2' and location_offset >= LOCATION.WILY_2_LARGE_WEAPON_ENERGY and not has_vertical_movement() then
                return false
            end
            if stage_name == 'Wily3' and location_offset >= LOCATION.WILY_3_1_UP_1 and not has_vertical_movement() then
                return false
            end
            if not can_leave_wily_stage(stage_name) then
                return AccessibilityLevel.SequenceBreak
            end
            return true
        end
        return meets_refill_requirement(location_offset)
            and (stage_name:sub(1, 4) == 'Wily' and can_leave_wily_stage(stage_name)
                or (stage_name:sub(1, 4) ~= 'Wily' and can_leave_stage(stage_name)))
    end

    -- Unique progression checks and upgrades; shop alternatives share AP checks.
    if location_offset == LOCATION.PROTO_MAN_S_CLUE_1_LOCATION then
        return has_vertical_movement() and can_leave_stage('Cloud')
    end
    if location_offset == LOCATION.PROTO_MAN_S_CLUE_2_LOCATION then
        return can_leave_stage('Turbo')
    end
    if location_offset == LOCATION.PROTO_SHIELD_LOCATION then
        return can_complete_proto_man()
    end
    if location_offset == LOCATION.RUSH_R_PLATE_LOCATION or location_offset == LOCATION.HYPER_BOLT_LOCATION then
        return can_leave_stage(stage_name)
    end
    if location_offset == LOCATION.RUSH_U_PLATE_LOCATION or location_offset == LOCATION.RUSH_H_PLATE_LOCATION then
        return has_vertical_movement() and can_leave_stage(stage_name)
    end
    if location_offset == LOCATION.RUSH_S_PLATE_LOCATION then
        return has_item(ITEM.FREEZE_CRACKER) and can_leave_stage(stage_name)
    end
    if location_offset == LOCATION.EXIT_UNIT_LOCATION then
        return has_item(ITEM.RUSH_SEARCH) and can_leave_stage('Freeze')
    end
    if location_offset == LOCATION.HYPER_ROCKET_BUSTER_LOCATION or location_offset == LOCATION.ENERGY_BALANCER_LOCATION then
        return (has_item(ITEM.RUSH_SEARCH) and can_leave_stage(stage_name)) or can_access_shop()
    end
    if location_offset == LOCATION.BEAT_LOCATION then
        return has_item(ITEM.SCORCH_WHEEL) and has_vertical_movement() and can_leave_stage('Slash')
    end
    if location_offset == LOCATION.RUSH_SEARCH_LOCATION then
        return can_leave_stage('Freeze') or can_access_shop()
    end
    if location_offset == LOCATION.RUSH_JET_LOCATION then
        return (has_item(ITEM.THUNDER_BOLT) and can_leave_stage('Junk')) or can_access_shop()
    end
    if location_offset >= LOCATION.CLOUD_MAN_S_MEGA_BOLT_LOCATION and location_offset <= LOCATION.MEGA_HEALTH_CAPSULE_LOCATION then
        return has_item(ITEM.RUSH_SEARCH) and can_leave_stage(stage_name) and (location_offset ~= LOCATION.JUNK_MAN_S_MEGA_BOLT_LOCATION or has_item(ITEM.FREEZE_CRACKER))
    end
    return AccessibilityLevel.Inspect
end

function mm7_pickups_visible(id)
    return seed_has(id) and is_option_enabled('pickupsanity')
end

function mm7_apply_slot(slot)
    mm7_slot = slot or {}
    mm7_checked = {}
    for _, id in ipairs(Archipelago.CheckedLocations or {}) do
        mm7_checked[id] = true
    end

    -- Only synchronize supplied fields; others retain the manual YAML controls.
    for _, key in ipairs({'robot_master_access_codes', 'pickupsanity', 'boss_rush_checks'}) do
        if mm7_slot[key] ~= nil then
            local tracker_object = Tracker:FindObjectForCode('opt_' .. key)
            if tracker_object then
                tracker_object.Active = (mm7_slot[key] == true or mm7_slot[key] == 1)
            end
        end
    end
    for _, key in ipairs({
        'wily_4_requirement_type', 'wily_4_wily_stages', 'wily_4_robot_masters',
        'wily_4_weapons', 'wily_4_behavior', 'robot_museum_robot_masters'
    }) do
        if mm7_slot[key] ~= nil then
            local tracker_object = Tracker:FindObjectForCode('opt_' .. key)
            if tracker_object then
                tracker_object.AcquiredCount = tonumber(mm7_slot[key])
            end
        end
    end
end

function mm7_final_access()
    return can_access_final_stage()
end

function mm7_rematch_visible(id)
    return seed_has(id) and is_option_enabled("boss_rush_checks")
end
