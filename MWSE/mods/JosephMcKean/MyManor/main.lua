local MyManor = {}

---@param cell tes3cell
function MyManor.replaceDoorLocks(cell)
	local key_hlaalo_manor = "key_hlaalo_manor"
	local jsmk_mm_mi_key = tes3.getObject("jsmk_mm_mi_key")
	if not jsmk_mm_mi_key then return end ---@cast jsmk_mm_mi_key tes3misc
	for doorRef in cell:iterateReferences(tes3.objectType.door) do
		local lockNode = doorRef.lockNode
		if lockNode then if lockNode.key and lockNode.key.id == key_hlaalo_manor then lockNode.key = jsmk_mm_mi_key end end
	end
	tes3.player.data.MyManor.doorLocksReplaced = true
end

function MyManor.deleteRalenHlaalo()
	local hlaalo = tes3.getReference("ralen hlaalo")
	if hlaalo then
		hlaalo:disable()
		hlaalo:delete()
	end
	local nirith = tes3.getReference("uryne nirith")
	if nirith then
		nirith:disable()
		nirith:delete()
	end
end

---@param cell tes3cell
function MyManor.transferOwnership(cell)
	for ref in cell:iterateReferences() do if tes3.getOwner({ reference = ref }) then tes3.setOwner({ reference = ref, remove = true }) end end
	tes3.player.data.MyManor.ownershipTransferred = true
end

---@param cell tes3cell
function MyManor.moveOldFurniture(cell, offset)
	---@param object tes3object
	local function isBlacklisted(object)
		if object.objectType == tes3.objectType.light then return false end -- dark_64 is a location marker for some reason
		if object.isLocationMarker then return true end -- DoorMarker
		if object.objectType == tes3.objectType.door then return true end -- in_h_trapdoor_01
		local id = object.id:lower()
		if id:match("^in_hlaalu") then return true end -- in_hlaalu_hall_end
		if id:match("^t_de_sethla") then return true end -- t_de_sethla_x_win_01
		if id:match("^ex_hlaalu") then return true end -- ex_hlaalu_win_01
		if id:match("^ab_in_hla") then return true end -- ab_in_hlaroomfloor
		return false
	end
	for ref in cell:iterateReferences() do
		if not isBlacklisted(ref.baseObject) then
			ref.position = ref.position + tes3vector3.new(offset, 0, 0)
		end
	end
	tes3.player.data.MyManor.oldFurnitureMoved = true
end

---@param e cellChangedEventData
local function cellChanged(e)
	local journalIndex = tes3.getJournalIndex({ id = "jsmk_mm" })
	if journalIndex < 20 then return end
	local cellName = e.cell.editorName
	if cellName == "Balmora (-3, -2)" and not tes3.player.data.MyManor.doorLocksReplaced then
		MyManor.replaceDoorLocks(e.cell)
		MyManor.deleteRalenHlaalo()
	end
	if cellName == "Balmora, Hlaalo Manor" and not tes3.player.data.MyManor.ownershipTransferred then MyManor.transferOwnership(e.cell) end
	if journalIndex < 30 then return end
	if cellName == "Balmora, Hlaalo Manor" and not tes3.player.data.MyManor.oldFurnitureMoved then MyManor.moveOldFurniture(e.cell, 1536) end
end

event.register("initialized", function()
	event.register("loaded", function() tes3.player.data.MyManor = tes3.player.data.MyManor or { doorLocksReplaced = false, ownershipTransferred = false, oldFurnitureMoved = false } end)
	event.register("cellChanged", cellChanged)
	event.register("UIEXP:sandboxConsole", function(e) e.sandbox.MyManor = MyManor end)
end)

return MyManor
