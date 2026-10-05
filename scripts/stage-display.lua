-- Derived portraits keep visual availability separate from received AP codes.
local pairs_by_view={
 ['stageview_7798832']='i7798832',
 ['stageview_7798833']='i7798833',
 ['stageview_7798834']='i7798834',
 ['stageview_7798835']='i7798835',
 ['stageview_7798836']='i7798836',
 ['stageview_7798837']='i7798837',
 ['stageview_7798838']='i7798838',
 ['stageview_7798839']='i7798839'
}
local refreshing=false
local function requires_codes()
 local value=mm7_slot and mm7_slot['robot_master_access_codes']
 if value~=nil then return value==true or value==1 end
 return Tracker:ProviderCountForCode('opt_robot_master_access_codes')>0
end
function mm7_refresh_stage_display(changed_code)
 if refreshing then return end
 refreshing=true
 local locked=requires_codes()
 -- Support manual stage toggles while access codes are required.
 if locked and pairs_by_view[changed_code] then
  local raw=Tracker:FindObjectForCode(pairs_by_view[changed_code])
  local view=Tracker:FindObjectForCode(changed_code)
  if raw and view then raw.Active=view.CurrentStage==1 end
 end
 for viewcode,rawcode in pairs(pairs_by_view) do
  local view=Tracker:FindObjectForCode(viewcode)
  local state=(not locked or Tracker:ProviderCountForCode(rawcode)>0) and 1 or 0
  if view and view.CurrentStage~=state then view.CurrentStage=state end
 end
 refreshing=false
end
if ScriptHost.AddWatchForCode then
 ScriptHost:AddWatchForCode('mm7 stage portraits','*',mm7_refresh_stage_display)
end
mm7_refresh_stage_display()
