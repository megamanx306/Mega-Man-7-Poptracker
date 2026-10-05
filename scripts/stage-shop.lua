-- Live data uses SNES bus addresses through PopTracker's HiROM mapping.
local refreshing=false
local prices={}
local broadcast_split=nil
local observed_stage=nil
local followed_stage=nil
function mm7_follow_current_stage(force)
 if observed_stage==nil or Tracker:ProviderCountForCode('follow_stage')==0 then return end
 local title=MM7_STAGE_TITLES[tostring(observed_stage)]
 if title and (force or followed_stage~=observed_stage) then
  if title:find('Man$') then Tracker:UiHint('ActivateTab','Robot Masters')
  elseif title:find("Wily's Castle Level",1,true) then Tracker:UiHint('ActivateTab',"Wily's Castle") end
  Tracker:UiHint('ActivateTab',title)
  followed_stage=observed_stage
 end
end
function mm7_refresh_shop()
 if refreshing then return end
 refreshing=true
 local hyper=Tracker:ProviderCountForCode('i7798800')>0
 local bolts=Tracker:ProviderCountForCode('bolts')
 for key,offer in pairs(MM7_SHOP_OFFERS) do
  local obj=Tracker:FindObjectForCode('shop_'..key)
  if obj then
   local unlocked=not offer.hyper or hyper
   local price=hyper and offer.discount or offer.normal
   local affordable=unlocked and price~=nil and bolts>=price
   local stage=affordable and 1 or 0
   if obj.CurrentStage~=stage then obj.CurrentStage=stage end
   local badge=unlocked and tostring(price) or 'HB'
   if prices[key]~=badge then obj:SetOverlay(badge);prices[key]=badge end
  end
 end
 local final=Tracker:FindObjectForCode('wily_final')
 if final then
  local value=mm7_final_access()
  local split=Tracker:ProviderCountForCode("opt_boss_rush_checks")>0
  local state=(split and 2 or 0)+(value and 1 or 0)
  if final.CurrentStage~=state then final.CurrentStage=state end
  if broadcast_split~=split then
   Tracker:AddLayouts(split and "layouts/broadcast-split.json" or "layouts/broadcast-combined.json")
   broadcast_split=split
  end
 end
 refreshing=false
end
local function changed(code)
 mm7_refresh_shop()
 if code=='follow_stage' then mm7_follow_current_stage(true) end
end
if ScriptHost.AddWatchForCode then ScriptHost:AddWatchForCode('MM7 shop and final access','*',changed) end
local function stage_memory(mem)
 -- Suppress menu, cutscene and loading-state values.
 if mem:ReadUInt8(0x7E0BD7)==7 and mem:ReadUInt8(0x7E0BC6)==0 then
  local stage=mem:ReadUInt8(0x7E0B73)
  if MM7_STAGE_TITLES[tostring(stage)] then observed_stage=stage;mm7_follow_current_stage(false) end
 end
 return true
end
local function bolt_memory(mem)
 local bolts=mem:ReadUInt16(0x7E0BA6)
 -- Currency is binary little-endian in the supplied ROM, capped to its UI range.
 local obj=Tracker:FindObjectForCode('bolts')
 if obj and bolts>=0 and bolts<=999 and obj.AcquiredCount~=bolts then obj.AcquiredCount=bolts end
 mm7_refresh_shop()
 return true
end
-- HiROM bus address = 0xC00000 + the APWorld's file offset.
-- Verify the MM7AP authentication prefix before trusting ROM configuration.
local function rom_config_memory(mem)
 local prefix='MM7AP'
 for i=1,#prefix do if mem:ReadUInt8(0xD8FEC0+i-1)~=prefix:byte(i) then return true end end
 local fields={wily_4_requirement_type={10,0,3},wily_4_wily_stages={11,0,4},wily_4_robot_masters={12,0,8},wily_4_weapons={13,0,8},wily_4_behavior={21,0,1}}
 local values={}
 for key,field in pairs(fields) do
  local v=mem:ReadUInt8(0xD8FEA0+field[1])
  if v<field[2] or v>field[3] then return true end
  values[key]=v
 end
 for key,v in pairs(values) do
  mm7_slot[key]=v
  local obj=Tracker:FindObjectForCode('opt_'..key)
  if obj and obj.AcquiredCount~=v then obj.AcquiredCount=v end
 end
 mm7_refresh_shop()
 return true
end
if ScriptHost.AddMemoryWatch then
 ScriptHost:AddMemoryWatch('MM7 final-stage ROM settings',0xD8FEA0,0x40,rom_config_memory,1000)
 ScriptHost:AddMemoryWatch('MM7 current stage',0x7E0B73,0x65,stage_memory,250)
 ScriptHost:AddMemoryWatch('MM7 current bolts',0x7E0BA6,2,bolt_memory,250)
end
mm7_refresh_shop()
