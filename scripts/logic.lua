-- MM7 v0.6: rules ported from the supplied APWorld rules.py.
mm7_slot = {}; mm7_checked = {}
local function have(code) return Tracker:ProviderCountForCode(code) > 0 end
local function item(n) return have('i' .. tostring(0x770000+n)) end
local function option(key)
 local v=mm7_slot[key]
 if v ~= nil then return v == true or v == 1 end
 return have('opt_'..key)
end
local function count_setting(key,default)
 local v=mm7_slot[key];if v~=nil then return tonumber(v) or default end
 local o=Tracker:FindObjectForCode('opt_'..key)
 return o and o.AcquiredCount or default
end
local function super() return item(11) and item(12) and item(13) and item(14) end
local function vertical() return item(8) or item(10) or super() end
local stage_order={'Freeze','Cloud','Junk','Turbo','Slash','Shade','Burst','Spring'}
local access={Freeze=48,Cloud=49,Junk=50,Turbo=51,Slash=52,Shade=53,Burst=54,Spring=55}
local defeat={Freeze=8,Cloud=9,Junk=10,Turbo=11,Slash=12,Shade=13,Burst=14,Spring=15,Wily1=50,Wily2=51,Wily3=52}
local weaknesses={Freeze={3,7},Cloud={1},Junk={2},Turbo={6},Slash={0,7},Shade={5},Burst={0,7},Spring={4},Museum={1},Wily1={4},Wily2={5,1},Wily3={4,6},Wily4={5}}
local function done(s)
 if not defeat[s] then return false end
 local id=0x770100+defeat[s]
 local obj=Tracker:FindObjectForCode(LOCATIONS and LOCATIONS[id] or '')
 return mm7_checked[id]==true or (obj~=nil and obj.AvailableChestCount==0)
end
local function stage_access(s) return not option('robot_master_access_codes') or item(access[s]) end
local function weakness(s)
 if not option('logic_boss_weakness') then return true end
 for _,n in ipairs(weaknesses[s] or {}) do if item(n) then return true end end
 return false
end
local function exit(s)
 return (option('exit_unit_in_uncleared_stages') or done(s)) and (item(17) or (option('paid_exit_unit') and option('paid_exit_unit_in_logic')))
end
local function leave(s) return stage_access(s) and (weakness(s) or exit(s)) end
local function shop() return item(16) and leave('Cloud') end
local function proto() return item(21) and item(22) and leave('Shade') end
local function rush_clear()
 if not option('boss_rush_checks') or not item(56) then return false end
 for _,s in ipairs(stage_order) do if not weakness(s) then return false end end
 return true
end
local function final_access()
 local t=count_setting('wily_4_requirement_type',0);local n=0
 if t==0 then
  for _,s in ipairs({'Wily1','Wily2','Wily3'}) do if done(s) then n=n+1 end end
  if rush_clear() then n=n+1 end
  return n>=count_setting('wily_4_wily_stages',3)
 elseif t==1 then
  for _,s in ipairs(stage_order) do if done(s) then n=n+1 end end
  return n>=count_setting('wily_4_robot_masters',8)
 elseif t==2 then
  for k=0,7 do if item(k) then n=n+1 end end
  return n>=count_setting('wily_4_weapons',8)
 else
  local id=7799062;local obj=Tracker:FindObjectForCode(LOCATIONS[id] or '')
  return mm7_checked[id]==true or (obj~=nil and obj.AvailableChestCount==0) or proto()
 end
end
local function wily_clear(s)
 if s=='Wily1' or s=='Wily3' then return vertical() and weakness(s) end
 if s=='Wily2' then return (vertical() or (option('strict_seed_logic') and item(0))) and weakness(s) end
 if count_setting('wily_4_behavior',1)==0 then
  for _,stage in ipairs(stage_order) do if not weakness(stage) then return false end end
 end
 return weakness('Wily4')
end
local function wily_leave(s)
 if s=='Wily4' and option('boss_rush_checks') then return item(56) end
 if s=='Wily4' then return final_access() and (wily_clear(s) or exit(s)) end
 local code=({Wily1=45,Wily2=46,Wily3=47})[s]
 return item(code) and (wily_clear(s) or exit(s))
end
local function refill_req(o)
 if not option('strict_seed_logic') then
  if o==0x5a or o==0x66 or o==0x75 or o==0x76 or o==0x77 then return true end
  if o>=0x7a and o<=0x7c then return item(10) or super() end
 end
 local group=MM7_REFILL_REQUIREMENTS[o]
 if group=='vertical' then return vertical()
 elseif group=='thunder' then return item(2)
 elseif group=='freeze' then return item(0)
 elseif group=='jet' then return item(10)
 elseif group=='jet_super' then return item(10) or super()
 elseif group=='vertical_freeze' then return vertical() or item(0) end
 return true
end
function mm7_access(id)
 local refresh=have("logic_refresh")
 local o=tonumber(id)-0x770100;local s=MM7_CHECK_STAGES[o]
 if o==0x29 then return true end
 if o>=8 and o<=15 then return stage_access(s) and weakness(s) end
 if o==0x10 then
  local n=0;for _,stage in ipairs(stage_order) do if done(stage) then n=n+1 end end
  return n>=count_setting('robot_museum_robot_masters',4) and (option('skip_robot_museum') or weakness('Museum'))
 end
 if o>=0x32 and o<=0x34 then
  return item(({[0x32]=45,[0x33]=46,[0x34]=47})[o]) and wily_clear(s)
 end
 if o>=0x35 and o<=0x3c then return option('boss_rush_checks') and item(56) and weakness(s) end
 if o>=0x40 then
  if not option('pickupsanity') then return false end
  if o==0x45 and not option('strict_seed_logic') then
   if not leave('Spring') then return false end
   return vertical() and true or AccessibilityLevel.SequenceBreak
  end
  if not option('strict_seed_logic') and (s=='Wily2' or s=='Wily3') then
   local code=s=='Wily2' and 46 or 47
   if not item(code) or not refill_req(o) then return false end
   if s=='Wily2' and o>=0x73 and not vertical() then return false end
   if s=='Wily3' and o>=0x78 and not vertical() then return false end
   if not wily_leave(s) then return AccessibilityLevel.SequenceBreak end
   return true
  end
  return refill_req(o) and (s:sub(1,4)=='Wily' and wily_leave(s) or (s:sub(1,4)~='Wily' and leave(s)))
 end
 if o==0x14 then return vertical() and leave('Cloud') end
 if o==0x15 then return leave('Turbo') end
 if o==0x16 then return proto() end
 if o==0x20 or o==0x24 then return leave(s) end
 if o==0x21 or o==0x23 then return vertical() and leave(s) end
 if o==0x22 then return item(0) and leave(s) end
 if o==0x25 then return item(9) and leave('Freeze') end
 if o==0x26 or o==0x27 then return (item(9) and leave(s)) or shop() end
 if o==0x28 then return item(7) and vertical() and leave('Slash') end
 if o==0x2a then return leave('Freeze') or shop() end
 if o==0x2b then return (item(2) and leave('Junk')) or shop() end
 if o>=0x2c and o<=0x31 then return item(9) and leave(s) and (o~=0x30 or item(0)) end
 return AccessibilityLevel.Inspect
end
function mm7_pickups_visible(id)
 return seed_has(id) and option('pickupsanity')
end
function mm7_apply_slot(slot)
 mm7_slot=slot or {};mm7_checked={}
 for _,id in ipairs(Archipelago.CheckedLocations or {}) do mm7_checked[id]=true end
 -- Only synchronize fields actually supplied by the APWorld. Others retain YAML controls.
 for _,key in ipairs({'robot_master_access_codes','pickupsanity','boss_rush_checks'}) do
  if mm7_slot[key]~=nil then
   local obj=Tracker:FindObjectForCode('opt_'..key)
   if obj then obj.Active=(mm7_slot[key]==true or mm7_slot[key]==1) end
  end
 end
 for _,key in ipairs({'wily_4_requirement_type','wily_4_wily_stages','wily_4_robot_masters','wily_4_weapons','wily_4_behavior','robot_museum_robot_masters'}) do
  if mm7_slot[key]~=nil then local obj=Tracker:FindObjectForCode('opt_'..key);if obj then obj.AcquiredCount=tonumber(mm7_slot[key]) end end
 end
end

function mm7_final_access() return final_access() end

function mm7_rematch_visible(id) return seed_has(id) and option("boss_rush_checks") end
