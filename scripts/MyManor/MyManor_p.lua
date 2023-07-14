local core = require("openmw.core")
local function onQuestUpdate(id,index)
if id == "jsmk_mm" then
    core.sendGlobalEvent("MManor_journalUpdated",index)
end
end
return {
	interfaceName  = "MyManor",
	interface      = {
		version = 1,

	},
	engineHandlers = {
		onQuestUpdate = onQuestUpdate
	}
}
