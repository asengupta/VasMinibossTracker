VasMiniBossTracker = {}
 
-- This isn't strictly necessary, but we'll use this string later when registering events.
-- Better to define it in a single place rather than retyping the same string.

VasMiniBossTracker.name = "VasMiniBossTracker"
VasMiniBossTracker.isDebug = false
VasMiniBossTracker.healthMap = { ["Test"]= { ["name"]="Test", ["health"]=100 }, ["Saint Llothis"]= 100, ["Saint Felms"]= 100 }

-- Next we create a function that will initialize our addon
function VasMiniBossTracker:Initialize()
	 self.inCombat = IsUnitInCombat("player")
	VasMiniBossTrackerIndicator:SetHidden(false)
	 EVENT_MANAGER:RegisterForEvent(self.name, EVENT_PLAYER_COMBAT_STATE, self.OnPlayerCombatState)
  -- ...but we don't have anything to initialize yet. We'll come back to this.
end
 
-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function VasMiniBossTracker.OnAddOnLoaded(event, addonName)
  -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
  if addonName == VasMiniBossTracker.name then
    VasMiniBossTracker:Initialize()
  end
end
 
function VasMiniBossTracker.OnPlayerCombatState(event, inCombat)
  -- The ~= operator is "not equal to" in Lua.
  if inCombat ~= VasMiniBossTracker.inCombat then
    -- The player's state has changed. Update the stored state...
    VasMiniBossTracker.inCombat = inCombat
 
    -- ...and then announce the change.
    if inCombat then
      d("Entering combat.")
    else
      d("Exiting combat.")
    end
 
  end
end

function logDebug(message)
	if VasMiniBossTracker.isDebug then
		d(message)
	end
end

function VasMiniBossTracker.OnTargetChanged(event, unitTag)
	local current1, max1, effective1 = GetUnitPower("reticleover", -2)
	local unitName = GetUnitName("reticleover")
	if (unitName == nil or unitName == '') then
		return
	end
	logDebug("Now targeting: "..unitName)

	if unitName == "Saint Llothis the Pious" then
		VasMiniBossTracker.healthMap["Saint Llothis"] = current1/max1*100.0
	elseif unitName == "Saint Felms the Bold" then
		VasMiniBossTracker.healthMap["Saint Felms"] = current1/max1*100.0
	elseif string.match(unitName, VasMiniBossTracker.healthMap["Test"]["name"]) then
		VasMiniBossTracker.healthMap["Test"]["health"] = current1/max1*100.0
	else
		logDebug("Ignoring")
	end

	VasMiniBossTrackerIndicatorFelmsLabel:SetText("Felms: "..math.floor(VasMiniBossTracker.healthMap["Saint Felms"]).."%")
	VasMiniBossTrackerIndicatorLlothisLabel:SetText("Llothis: "..math.floor(VasMiniBossTracker.healthMap["Saint Llothis"]).."%")
	VasMiniBossTrackerIndicatorTestLabel:SetText(VasMiniBossTracker.healthMap["Test"]["name"]..": "..math.floor(VasMiniBossTracker.healthMap["Test"]["health"]).."%")
	logDebug("L: "..math.floor(VasMiniBossTracker.healthMap["Saint Llothis"]).." F: "..math.floor(VasMiniBossTracker.healthMap["Saint Felms"]).." T: "..VasMiniBossTracker.healthMap["Test"]["health"])
	logDebug("Target is:")
	logDebug(unitName)
	logDebug(current1/max1*100.0)
end

-- Finally, we'll register our event handler function to be called when the proper event occurs.

EVENT_MANAGER:RegisterForEvent(VasMiniBossTracker.name, EVENT_ADD_ON_LOADED, VasMiniBossTracker.OnAddOnLoaded)
EVENT_MANAGER:RegisterForEvent(VasMiniBossTracker.name,  EVENT_RETICLE_TARGET_CHANGED, VasMiniBossTracker.OnTargetChanged)
EVENT_MANAGER:RegisterForEvent(VasMiniBossTracker.name,  EVENT_POWER_UPDATE, VasMiniBossTracker.OnTargetChanged)
-- EVENT_MANAGER:RegisterForEvent(VasMiniBossTracker.name,  EVENT_TARGET_CHANGED, VasMiniBossTracker.OnTargetChanged)
EVENT_MANAGER:RegisterForEvent(VasMiniBossTracker.name, EVENT_PLAYER_COMBAT_STATE, VasMiniBossTracker.OnPlayerCombatState)
SLASH_COMMANDS["/track"] = function(unitName)
	d("Adding '"..unitName.."'' to persistent tracker")
	VasMiniBossTracker.healthMap["Test"]["name"] = unitName
	VasMiniBossTracker.OnTargetChanged(1, "")
end

SLASH_COMMANDS["/vasdebug"] = function(isDebug)
	if isDebug == "on" or isDebug == "true" then
		VasMiniBossTracker.isDebug = true
		d("Debug = TRUE")
	else
		VasMiniBossTracker.isDebug = false
		d("Debug = FALSE")
	end
end
