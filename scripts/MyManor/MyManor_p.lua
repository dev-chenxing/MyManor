local core = require("openmw.core")
local types = require("openmw.types")
local I = require("openmw.interfaces")
if types.Player.quests == nil then
    I.Settings.registerPage {
        key = 'SettingsMyManor',
        l10n = '',
        name = 'MyManor',
        description = 'This version of OpenMW has no lua quest support. Update to the latest 0.49 or development release/build.',
    }
    error("This version of OpenMW has no lua quest support. Update to the latest 0.49 or development release/build.")
else
end
local function onQuestUpdate(id,index)
if id == "jsmk_mm" then
    core.sendGlobalEvent("MManor_journalUpdated",index)
end
end
return {
	engineHandlers = {
		onQuestUpdate = onQuestUpdate
	}
}
