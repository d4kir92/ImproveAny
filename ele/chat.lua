local _, ImproveAny = ...
local races = {}
local classes = {}
C_Timer.After(
	0.01,
	function()
		if D4:GetWoWBuild() == "CLASSIC" then
			races["Troll2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:256:256:128:192:64:128|t"
			races["NightElf3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:256:256:192:256:128:192|t"
			races["Human2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:256:256:0:64:0:64|t"
			races["Gnome3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:256:256:128:192:128:192|t"
			races["NightElf2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:256:256:192:256:0:64|t"
			races["Gnome2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:256:256:128:192:0:64|t"
			races["Orc2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:256:256:192:256:64:128|t"
			races["Human3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:256:256:0:64:128:192|t"
			races["Orc3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:256:256:192:256:192:256|t"
			races["Tauren3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:256:256:0:64:192:256|t"
			races["Troll3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:256:256:128:192:192:256|t"
			races["Scourge3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:256:256:64:128:192:256|t"
			races["Dwarf3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:256:256:64:128:128:192|t"
			races["Scourge2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:256:256:64:128:64:128|t"
			races["Tauren2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:256:256:0:64:64:128|t"
			races["Dwarf2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:256:256:64:128:0:64|t"
		elseif D4:GetWoWBuild() == "TBC" or D4:GetWoWBuild() == "WRATH" then
			races["Troll2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:128:192:64:128|t"
			races["Scourge2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:64:128:64:128|t"
			races["Tauren3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:0:64:192:256|t"
			races["Troll3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:128:192:192:256|t"
			races["Scourge3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:64:128:192:256|t"
			races["BloodElf3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:256:320:192:256|t"
			races["Draenei3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:256:320:128:192|t"
			races["NightElf3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:192:256:128:192|t"
			races["Gnome3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:128:192:128:192|t"
			races["NightElf2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:192:256:0:64|t"
			races["Gnome2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:128:192:0:64|t"
			races["BloodElf2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:256:320:64:128|t"
			races["Orc3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:192:256:192:256|t"
			races["Human2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:0:64:0:64|t"
			races["Tauren2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:0:64:64:128|t"
			races["Human3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:0:64:128:192|t"
			races["Dwarf3"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:64:128:128:192|t"
			races["Draenei2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:256:320:0:64|t"
			races["Orc2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:192:256:64:128|t"
			races["Dwarf2"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Races:0:0:0:0:512:256:64:128:0:64|t"
		elseif D4:GetWoWBuild() == "RETAIL" then
			races["Human2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:262:327|t"
			races["Human3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:196:261|t"
			races["Orc2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1434:1499:196:261|t"
			races["Orc3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1368:1433:196:261|t"
			races["Dwarf2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1566:1631:130:195|t"
			races["Dwarf3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1500:1565:130:195|t"
			races["NightElf2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1302:1367:196:261|t"
			races["NightElf3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1236:1301:196:261|t"
			races["Scourge2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1962:2027:196:261|t"
			races["Scourge3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1896:1961:196:261|t"
			races["Tauren2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1698:1763:196:261|t"
			races["Tauren3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1632:1697:196:261|t"
			races["Gnome2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1698:1763:130:195|t"
			races["Gnome3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1632:1697:130:195|t"
			races["Troll2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1830:1895:196:261|t"
			races["Troll3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1764:1829:196:261|t"
			races["Goblin2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1830:1895:130:195|t"
			races["Goblin3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1764:1829:130:195|t"
			races["BloodElf2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1105:720:785|t"
			races["BloodElf3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1105:654:719|t"
			races["Draenei2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1434:1499:130:195|t"
			races["Draenei3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1368:1433:130:195|t"
			races["Worgen2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1236:1301:724:789|t"
			races["Worgen3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1236:1301:658:723|t"
			races["Pandaren2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1566:1631:196:261|t"
			races["Pandaren3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1500:1565:196:261|t"
			races["Nightborne2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:922:987|t"
			races["Nightborne3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:856:921|t"
			races["HighmountainTauren2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1962:2027:130:195|t"
			races["HighmountainTauren3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1896:1961:130:195|t"
			races["VoidElf2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1236:1301:460:525|t"
			races["VoidElf3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1236:1301:394:459|t"
			races["LightforgedDraenei2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:526:591|t"
			races["LightforgedDraenei3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:460:525|t"
			races["ZandalariTroll2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1236:1301:856:921|t"
			races["ZandalariTroll3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1236:1301:790:855|t"
			races["KulTiran2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:394:459|t"
			races["KulTiran3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:328:393|t"
			races["DarkIronDwarf2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1105:852:917|t"
			races["DarkIronDwarf3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1105:786:851|t"
			races["Vulpera2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1236:1301:592:657|t"
			races["Vulpera3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1236:1301:526:591|t"
			races["MagharOrc2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:658:723|t"
			races["MagharOrc3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:592:657|t"
			races["Mechagnome2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:790:855|t"
			races["Mechagnome3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:724:789|t"
			races["Dracthyr2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1302:1367:130:195|t"
			races["Dracthyr3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1236:1301:130:195|t"
		end

		classes["WARRIOR"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:0:64:0:64|t"
		classes["MAGE"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:64:128:0:64|t"
		classes["ROGUE"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:128:192:0:64|t"
		classes["DRUID"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:192:256:0:64|t"
		classes["HUNTER"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:0:64:64:128|t"
		classes["SHAMAN"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:64:128:64:128|t"
		classes["PRIEST"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:128:192:64:128|t"
		classes["WARLOCK"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:192:256:64:128|t"
		classes["PALADIN"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:0:64:128:192|t"
		classes["DEATHKNIGHT"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:64:128:128:192|t"
		classes["MONK"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:128:192:128:192|t"
		classes["DEMONHUNTER"] = "|TInterface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes:0:0:0:0:256:256:192:256:128:192|t"
		classes["EVOKER"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:0:129:0:129|t"
		classes["EVOKER"] = "|T4574311|t"
	end
)

function ImproveAny:GetClassIcon(class, size)
	size = size or 0
	if classes and classes[class] then return classes[class] end

	return ""
end

function ImproveAny:GetRaceIcon(race, gender)
	if races then return races[race .. gender] end

	return ""
end

local allowedTyp = {}
allowedTyp["player"] = true
allowedTyp["playerCommunity"] = true
allowedTyp["playerGM"] = true
-- Funktion, um Klassenfarben abzurufen
function ImproveAny:GetClassColor(class)
	local colors = RAID_CLASS_COLORS[class]

	return colors.r, colors.g, colors.b
end

-- Funktion, um den Spielername in der Chatnachricht einzufärben
function ImproveAny:ColorizePlayerNameInMessage(message, guid, engClass)
	local coloredMessage = message:gsub(
		"|Hplayer:(.-)|h%[(.-)%]|h",
		function(link, playerName)
			if engClass then
				local r, g, b = ImproveAny:GetClassColor(engClass)
				local hexColor = ("|cFF%02x%02x%02x"):format(r * 255, g * 255, b * 255)

				return format("|Hplayer:%s|h[%s%s|r]|h", link, hexColor, playerName)
			else
				return format("|Hplayer:%s|h[%s]|h", link, playerName)
			end
		end
	)

	return coloredMessage
end

function ImproveAny:FormatURL(url)
	url = "|cff" .. "3FC7EB" .. "|Hurl:" .. url .. "|h" .. url .. "|h|r"

	return url
end

local rightWasDown = false
local rightWasDownTs = 0
function ImproveAny:ThinkRightClick()
	if IsMouseButtonDown("RightButton") then
		rightWasDown = true
		rightWasDownTs = time()
	end

	if rightWasDownTs < time() - 0.1 then
		rightWasDown = false
	end

	C_Timer.After(0.01, ImproveAny.ThinkRightClick)
end

ImproveAny:ThinkRightClick()
function ImproveAny:SetHyperlink(link)
	local poi = string.find(link, ":", 0, true)
	local typ = string.sub(link, 1, poi - 1)
	if typ == "url" then
		local url = string.sub(link, 5)
		local tab = {}
		tab.url = url
		StaticPopup_Show("CLICK_LINK_URL", "", "", tab)

		return true
	elseif typ == "inv" or typ == "einladen" then
		local name = string.sub(link, poi + 1)
		if rightWasDown then
			if GuildInvite then
				GuildInvite(name)
			end

			return true
		else
			if C_PartyInfo and C_PartyInfo.InviteUnit then
				C_PartyInfo.InviteUnit(name)
			elseif InviteUnit then
				InviteUnit(name)
			end
		end

		return true
	end

	return false
end

local function removeTimestamp(message)
	local result = string.gsub(message, "^[:%d%d]+[%s][AM]*[PM]*[%s]*", "")
	if GetChatTimestampFormat() then
		local timestamp = BetterDate(GetChatTimestampFormat(), time())
		timestamp = string.sub(timestamp, 1, #timestamp - 1)

		return result, "[" .. timestamp .. "]"
	end

	return result
end

function ImproveAny:InitChat()
	local chatTypes = {}
	for i, v in pairs(_G) do
		if string.find(i, "CHAT_MSG_") and not tContains(chatTypes, i) then
			tinsert(chatTypes, i)
		end
	end

	for typ in next, getmetatable(ChatTypeInfo).__index do
		if not tContains(chatTypes, "CHAT_MSG_" .. typ) then
			tinsert(chatTypes, "CHAT_MSG_" .. typ)
		end
	end

	if ImproveAny:IsEnabled("CHAT", false) then
		function ImproveAny:ChatOnlyBig(str, imax)
			if str == nil then return nil end
			local smax = imax or 3
			local res = string.gsub(str, "[^%u-]", "")
			-- shorten
			if #res > smax then
				res = string.sub(res, 1, smax)
			end

			-- 1-3 => upper
			if #str <= smax then
				res = string.upper(res)
			end

			-- no upper?
			if #res <= 0 then
				if #str <= smax then
					res = string.upper(str)
				else
					res = string.gsub(str, "[^%l-]", "")
					res = string.sub(res, 1, smax)
					res = string.upper(res)
				end
			end

			if string.find(res, "-", string.len(res), true) then
				res = string.gsub(str, "[^%u]", "")
			end

			return res
		end

		local PLYCache = {}
		function ImproveAny:GetGUID(name)
			return PLYCache[name]
		end

		function ImproveAny:FixName(name, realm)
			if name and realm == nil or realm == "" then
				local s1 = string.find(name, "-", 0, true)
				if name and s1 then
					realm = string.sub(name, s1 + 1)
					name = string.sub(name, 1, s1 - 1)
				else
					realm = GetRealmName()
				end
			end

			realm = string.gsub(realm, "-", "")
			realm = string.gsub(realm, " ", "")

			return name, realm
		end

		local levelTab = {}
		function ImproveAny:GetLevel(name, realm)
			name, realm = ImproveAny:FixName(name, realm)

			return levelTab[name .. "-" .. realm]
		end

		function ImproveAny:SetLevel(name, realm, level, from)
			name, realm = ImproveAny:FixName(name, realm)
			if name and realm then
				levelTab[name .. "-" .. realm] = level
			end
		end

		ImproveAny:SetLevel(UnitName("player"), nil, UnitLevel("player"))
		function ImproveAny:WhoScan()
			for i = 1, C_FriendList.GetNumWhoResults() do
				local info = C_FriendList.GetWhoInfo(i)
				if info and info.fullName and info.level then
					ImproveAny:SetLevel(info.fullName, nil, info.level, "WhoScan")
				end
			end
		end

		function ImproveAny:FriendScan()
			for i = 1, C_FriendList.GetNumFriends() do
				local info = C_FriendList.GetFriendInfo(i)
				if info and info.fullName and info.level then
					ImproveAny:SetLevel(info.fullName, nil, info.level, "FriendScan")
				end
			end
		end

		function ImproveAny:PartyScan()
			local max = GetNumSubgroupMembers or GetNumPartyMembers
			local success = true
			for i = 1, max() do
				local name, realm = UnitName("party" .. i)
				if name then
					if UnitLevel("party" .. i) == 0 then
						success = false
					else
						ImproveAny:SetLevel(name, realm, UnitLevel("party" .. i), "PartyScan")
					end
				end
			end

			if not success then
				ImproveAny:Debug("chat.lua: not success")
				C_Timer.After(0.1, ImproveAny.PartyScan)
			end
		end

		function ImproveAny:RaidScan()
			local max = GetNumGroupMembers or GetNumRaidMembers
			for i = 1, max() do
				local _, _, _, Level = GetRaidRosterInfo(i)
				local Name, Server = UnitName("raid" .. i)
				if Name then
					ImproveAny:SetLevel(Name, Server, Level, "RaidScan")
				end
			end
		end

		function ImproveAny:GuildScan()
			if IsInGuild() then
				C_GuildInfo.GuildRoster()
				local max = GetNumGuildMembers(true)
				for i = 1, max do
					local Name, _, _, Level = GetGuildRosterInfo(i)
					local name, realm = Name:match("([^%-]+)%-?(.*)")
					if name then
						ImproveAny:SetLevel(name, realm, Level, "GuildScan")
					end
				end
			end
		end

		local delay = 0.6
		local lf = CreateFrame("Frame", "IALevelFrame")
		lf:RegisterEvent("GROUP_ROSTER_UPDATE")
		lf:RegisterEvent("CHAT_MSG_RAID")
		lf:RegisterEvent("CHAT_MSG_GUILD")
		lf:RegisterEvent("CHAT_MSG_OFFICER")
		lf:RegisterEvent("FRIENDLIST_UPDATE")
		lf:RegisterEvent("GUILD_ROSTER_UPDATE")
		lf:RegisterEvent("RAID_ROSTER_UPDATE")
		lf:RegisterEvent("WHO_LIST_UPDATE")
		lf:RegisterEvent("PLAYER_LEVEL_UP")
		lf:RegisterEvent("CHAT_MSG_SYSTEM")
		lf:SetScript(
			"OnEvent",
			function(sel, event, ...)
				if event == "GUILD_ROSTER_UPDATE" or event == "CHAT_MSG_GUILD" or event == "CHAT_MSG_OFFICER" then
					C_Timer.After(delay, ImproveAny.GuildScan)
				elseif event == "PLAYER_LEVEL_UP" then
					C_Timer.After(
						delay,
						function()
							ImproveAny:SetLevel(UnitName("player"), GetRealmName(), UnitLevel("player"))
						end
					)
				elseif event == "WHO_LIST_UPDATE" or event == "CHAT_MSG_SYSTEM" then
					C_Timer.After(delay, ImproveAny.WhoScan)
				elseif event == "FRIENDLIST_UPDATE" then
					C_Timer.After(delay, ImproveAny.FriendScan)
				elseif event == "RAID_ROSTER_UPDATE" or event == "CHAT_MSG_RAID" then
					C_Timer.After(delay, ImproveAny.RaidScan)
				elseif event == "GROUP_ROSTER_UPDATE" then
					C_Timer.After(delay, ImproveAny.PartyScan)
				else
					ImproveAny:MSG("Missing Event: " .. event)
				end
			end
		)

		ImproveAny:WhoScan()
		ImproveAny:FriendScan()
		ImproveAny:PartyScan()
		ImproveAny:RaidScan()
		ImproveAny:GuildScan()
		local function LOCALChatAddPlayerIcons(msg, c)
			local links = {}
			for i = 1, string.len(msg) do
				local _, _, itemString = strfind(msg, "|H(.+)|h", i)
				if not tContains(links, itemString) then
					table.insert(links, itemString)
				end
			end

			for i, itemString in ipairs(links) do
				local typ, id = string.split(":", itemString)
				if allowedTyp[typ] then
					local guid = ImproveAny:GetGUID(id)
					if guid then
						local _, engClass, _, engRace, gender, name, realm = GetPlayerInfoByGUID(guid)
						if ImproveAny:IsEnabled("CHATCLASSCOLORS", false) then
							msg = ImproveAny:ColorizePlayerNameInMessage(msg, guid, engClass)
						end

						if engClass and engRace and gender and races[engRace .. gender] and ImproveAny:GetClassIcon(engClass) then
							if ImproveAny:IsEnabled("CHATCLASSICONS", false) then
								msg = ImproveAny:GetClassIcon(engClass, 0) .. msg
							end

							if ImproveAny:IsEnabled("CHATRACEICONS", false) then
								msg = ImproveAny:GetRaceIcon(engRace, gender) .. msg
							end
						end

						local level = ImproveAny:GetLevel(name, realm)
						if ImproveAny:IsEnabled("CHATLEVELS", false) and level and level > 0 then
							if string.find(msg, name .. "|r%]") then
								msg = string.gsub(msg, name .. "|r%]", level .. ":" .. name .. "|r%]", 1)
							elseif string.find(msg, name .. "%]") then
								msg = string.gsub(msg, name .. "%]", level .. ":" .. name .. "%]", 1)
							else
								local _, e1 = string.find(msg, name)
								if e1 then
									local s2 = string.find(msg, name, e1)
									if s2 then
										msg = msg:sub(1, s2 - 1) .. level .. ":" .. msg:sub(s2)
									end
								end
							end
						end
					end
				end
			end

			return msg
		end

		local function LOCALChatAddItemIcons(msg)
			msg = string.gsub(
				msg,
				"(|H.-|h.-|h)",
				function(itemString)
					local typ, id = string.match(itemString, "|H(.-):(.-)|h")
					if typ == "item" then
						id = string.match(id, "(%d+)")
						local itemName, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(id)
						if itemName and itemTexture then
							if ImproveAny:IsEnabled("CHATITEMICONS", false) then
								return "|T" .. itemTexture .. ":0|t" .. itemString
							else
								return itemString
							end
						else
							return itemString
						end
					else
						return itemString
					end
				end
			)

			return msg
		end

		local hooks = {}
		local function AddMessage(sel, message, ...)
			local chanName = nil
			local timestamp = nil
			message, timestamp = removeTimestamp(message)
			local sear = message:gsub("|", ""):gsub("h%[", ":"):gsub("%]h", ":")
			local _, channel, _, channelName, chanIndex = string.split(":", sear)
			if channel and channel == "channel" and channelName then
				local s1, s2 = channelName:find("%[(.-)%]")
				if s1 and s2 then
					chanName = channelName:sub(s1 + 1, s2 - 1)
				else
					chanName = channelName
				end
			end

			if channel then
				chanName = chanName or _G["CHAT_MSG_" .. channel]
				local chanFormat = _G["CHAT_" .. channel .. "_GET"]
				if chanFormat == nil and channelName then
					chanFormat = _G["CHAT_" .. channelName .. "_GET"]
				end

				if chanFormat == nil and chanIndex then
					chanFormat = _G["CHAT_" .. chanIndex .. "_GET"]
				end

				if chanFormat then
					chanFormat = chanFormat:gsub("%s", "")
					if channelName and channelName == "EMOTE" then
						message = message:gsub(chanFormat, " ", 1)
					else
						message = message:gsub(chanFormat, ":", 1)
					end
				end

				if ImproveAny:IsEnabled("CHATSHORTCHANNELS", false) then
					local leaderChannel = _G["CHAT_MSG_" .. channel .. "_LEADER"]
					if leaderChannel == nil then
						leaderChannel = _G[channel .. "_LEADER"]
					end

					if leaderChannel then
						message = ImproveAny:ReplaceStr(message, leaderChannel, ImproveAny:ChatOnlyBig(leaderChannel))
					end

					if chanName then
						message = ImproveAny:ReplaceStr(message, chanName, ImproveAny:ChatOnlyBig(chanName))
					elseif channelName then
						chanName = _G["CHAT_MSG_" .. channelName]
						if chanName then
							message = "[" .. ImproveAny:ChatOnlyBig(chanName, 1) .. "] " .. message
						end
					end
				end

				message = LOCALChatAddPlayerIcons(message, 1)
			end

			if timestamp then
				message = timestamp .. message
			end

			return hooks[sel](sel, message, ...)
		end

		for index = 1, NUM_CHAT_WINDOWS do
			if index ~= 2 then
				local frame = _G["ChatFrame" .. index]
				if frame then
					hooks[frame] = frame.AddMessage
					frame.AddMessage = AddMessage
				end
			end
		end

		-- Item Icons
		local function LOCALIconsFilter(sel, typ, msg, author, ...)
			local guid = select(10, ...)
			if author and guid then
				PLYCache[author] = guid
			end

			return false, LOCALChatAddItemIcons(msg, 1), author, ...
		end

		for i, typ in pairs(chatTypes) do
			ChatFrame_AddMessageEventFilter(typ, LOCALIconsFilter)
		end

		-- URLs / IPs / Emails
		local patterns = {"[htps:/]*%w+%.%w[%w%.%/%+%-%_%#%?%=]*"}
		function ImproveAny:ConvertMessage(typ, msg, ...)
			for i, p in pairs(patterns) do
				local s1 = string.find(msg, "|")
				local s2 = string.find(msg, p)
				if s1 == nil and s2 ~= nil then
					msg = string.gsub(msg, p, ImproveAny:FormatURL("%1"))
				end
			end

			if string.find(msg, "inv", 0, true) then
				local name = select(1, ...)
				if name then
					msg = string.gsub(msg, "inv", "|cff" .. "FFFF00" .. "|Hinv:" .. name .. "|h" .. "inv" .. "|h|r")
				end
			end

			if string.find(msg, "einladen", 0, true) then
				local name = select(1, ...)
				if name then
					msg = string.gsub(msg, "einladen", "|cff" .. "FFFF00" .. "|Heinladen:" .. name .. "|h" .. "einladen" .. "|h|r")
				end
			end

			return false, msg, ...
		end

		StaticPopupDialogs["CLICK_LINK_URL"] = {
			text = "LINK/EMAIL/IP",
			button1 = "Close",
			OnAccept = function() end,
			timeout = 0,
			whileDead = true,
			hideOnEscape = true,
			preferredIndex = 3,
			OnShow = function(sel, data)
				sel.editBox:SetText(data.url)
				sel.editBox:HighlightText()
			end,
			hasEditBox = true
		}

		if D4:GetWoWBuild() == "RETAIL" then
			hooksecurefunc(
				ItemRefTooltip,
				"SetHyperlink",
				function(sel, link)
					ImproveAny:SetHyperlink(link)
				end
			)
		else
			ItemRefTooltip.OldSetHyperlink = ItemRefTooltip.SetHyperlink
			function ItemRefTooltip:SetHyperlink(link)
				local worked = ImproveAny:SetHyperlink(link)
				if not worked then
					ItemRefTooltip:OldSetHyperlink(link)
				end
			end
		end

		-- SetHyperLink
		for i, typ in pairs(chatTypes) do
			ChatFrame_AddMessageEventFilter(typ, ImproveAny.ConvertMessage)
		end
	end
end