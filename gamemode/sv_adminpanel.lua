
util.AddNetworkString("mu_adminpanel_details")

net.Receive("mu_adminpanel_details", function (length, ply)
	if !ply:IsAdmin() then return end
	if !GAMEMODE.AdminPanelAllowed:GetBool() then return end
	local sendData = {}
	local tab = {}
	local lootTab = {}
	tab.players = {}
	tab.weightMul = GAMEMODE.MurdererWeight:GetFloat()

	local total = 0
	for k, ply in pairs(team.GetPlayers(2)) do
		total = total + (ply.MurdererChance or 1) ^ tab.weightMul
	end

	for k, ply in pairs(team.GetPlayers(2)) do
		local t = {}
		t.player = ply:EntIndex() // cant send players via JSON
		t.murderer = ply:GetMurderer()
		t.murdererChance = ((ply.MurdererChance or 1) ^ tab.weightMul) / total
		t.murdererWeight = ply.MurdererChance or 1
		tab.players[ply:EntIndex()] = t
	end

	lootTab = LootItems

	sendData.playerData = tab
	sendData.lootData = lootTab

	local json = util.TableToJSON(sendData)
	net.Start("mu_adminpanel_details")
	net.WriteString(json)
	net.Send(ply)
end)