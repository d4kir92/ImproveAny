local _, ImproveAny = ...
local allowedTyp = {}
allowedTyp["player"] = true
allowedTyp["playerCommunity"] = true
allowedTyp["playerGM"] = true

-- Funktion, um Klassenfarben abzurufen
local function GetClassColor(class)
	local colors = RAID_CLASS_COLORS[class]

	return colors.r, colors.g, colors.b
end

-- Funktion, um den Spielername in der Chatnachricht einzufärben
local function ColorizePlayerNameInMessage(message, guid, engClass)
	local coloredMessage = message:gsub("|Hplayer:(.-)|h%[(.-)%]|h", function(link, playerName)
		if engClass then
			local r, g, b = GetClassColor(engClass)
			local hexColor = ("|cFF%02x%02x%02x"):format(r * 255, g * 255, b * 255)

			return format("|Hplayer:%s|h[%s%s|r]|h", link, hexColor, playerName)
		else
			return format("|Hplayer:%s|h[%s]|h", link, playerName)
		end
	end)

	return coloredMessage
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

	if ImproveAny:IsEnabled("CHAT", true) then
		function IAChatOnlyBig(str, imax)
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

		local races = {}
		local classes = {}

		C_Timer.After(0.01, function()
			if ImproveAny:GetWoWBuild() == "CLASSIC" then
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
			elseif ImproveAny:GetWoWBuild() == "TBC" or ImproveAny:GetWoWBuild() == "WRATH" then
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
			elseif ImproveAny:GetWoWBuild() == "RETAIL" then
				races["Human2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1632:1697:130:195|t"
				races["Human2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1566:1631:130:195|t"
				races["Orc2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:724:789|t"
				races["Orc3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:658:723|t"
				races["Dwarf2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1105:918:983|t"
				races["Dwarf3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1105:852:917|t"
				races["NightElf2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:592:657|t"
				races["NightElf3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:526:591|t"
				races["Scourge2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1500:1565:196:261|t"
				races["Scourge3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1434:1499:196:261|t"
				races["Tauren2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1236:1301:196:261|t"
				races["Tauren3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:922:987|t"
				races["Gnome2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1236:1301:130:195|t"
				races["Gnome3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:130:195|t"
				races["Troll2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1368:1433:196:261|t"
				races["Troll3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1302:1367:196:261|t"
				races["Goblin2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1368:1433:130:195|t"
				races["Goblin3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1302:1367:130:195|t"
				races["BloodElf2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:910:975:910:975|t"
				races["BloodElf3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:780:845:910:975|t"
				races["Draenei2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1105:786:851|t"
				races["Draenei3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1105:720:785|t"
				races["Worgen2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1236:1301:262:327|t"
				races["Worgen3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1962:2027:196:261|t"
				races["Pandaren2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:856:921|t"
				races["Pandaren3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:790:855|t"
				races["Nightborne2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:460:525|t"
				races["Nightborne3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:394:459|t"
				races["HighmountainTauren2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1500:1565:130:195|t"
				races["HighmountainTauren3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1434:1499:130:195|t"
				races["VoidElf2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1764:1829:196:261|t"
				races["VoidElf3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1698:1763:196:261|t"
				races["LightforgedDraenei2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1896:1961:130:195|t"
				races["LightforgedDraenei3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1830:1895:130:195|t"
				races["ZandalariTroll2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1236:1301:394:459|t"
				races["ZandalariTroll3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1236:1301:328:393|t"
				races["KulTiran2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1764:1829:130:195|t"
				races["KulTiran3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1698:1763:130:195|t"
				races["DarkIronDwarf2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1105:390:455|t"
				races["DarkIronDwarf3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1950:2015:0:65|t"
				races["Vulpera2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1896:1961:196:261|t"
				races["Vulpera3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1830:1895:196:261|t"
				races["MagharOrc2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:196:261|t"
				races["MagharOrc3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1962:2027:130:195|t"
				races["Mechagnome2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:328:393|t"
				races["Mechagnome3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1170:1235:262:327|t"
				races["Dracthyr2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1105:654:719|t"
				races["Dracthyr3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1105:588:653|t"
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
		end)

		function ImproveAny:GetClassIcon(class)
			return classes[class]
		end

		local PLYCache = {}

		local function IAGetGUID(name)
			return PLYCache[name]
		end

		function IAFixName(name, realm)
			if name and realm == nil or realm == "" then
				local s1 = string.find(name, "-", 0, true)

				if name and s1 then
					realm = string.sub(name, s1 + 1)
					name = string.sub(name, 1, s1 - 1)
				else
					realm = GetRealmName()
				end

				realm = string.gsub(realm, "-", "", 1)
				realm = string.gsub(realm, " ", "", 1)
			end

			return name, realm
		end

		local levelTab = {}

		function IAGetLevel(name, realm)
			name, realm = IAFixName(name, realm)

			return levelTab[name .. "-" .. realm]
		end

		function IASetLevel(name, realm, level, from)
			name, realm = IAFixName(name, realm)

			if name and realm then
				levelTab[name .. "-" .. realm] = level
			end
		end

		IASetLevel(UnitName("player"), nil, UnitLevel("player"))

		function IAWhoScan()
			for i = 1, C_FriendList.GetNumWhoResults() do
				local info = C_FriendList.GetWhoInfo(i)

				if info and info.fullName and info.level then
					IASetLevel(info.fullName, nil, info.level, "IAWhoScan")
				end
			end
		end

		function IAFriendScan()
			for i = 1, C_FriendList.GetNumFriends() do
				local info = C_FriendList.GetFriendInfo(i)

				if info and info.fullName and info.level then
					IASetLevel(info.fullName, nil, info.level, "IAFriendScan")
				end
			end
		end

		function IAPartyScan()
			local max = GetNumSubgroupMembers or GetNumPartyMembers
			local success = true

			for i = 1, max() do
				local name, realm = UnitName("party" .. i)

				if name then
					if UnitLevel("party" .. i) == 0 then
						success = false
					else
						IASetLevel(name, realm, UnitLevel("party" .. i), "IAPartyScan")
					end
				end
			end

			if not success then
				C_Timer.After(0.1, IAPartyScan)
			end
		end

		function IARaidScan()
			local max = GetNumGroupMembers or GetNumRaidMembers

			for i = 1, max() do
				local _, _, _, Level = GetRaidRosterInfo(i)
				local Name, Server = UnitName("raid" .. i)

				if Name then
					IASetLevel(Name, Server, Level, "IARaidScan")
				end
			end
		end

		function IAGuildScan()
			if IsInGuild() then
				C_GuildInfo.GuildRoster()

				for i = 1, GetNumGuildMembers(true) do
					local Name, _, _, Level = GetGuildRosterInfo(i)
					local name, realm = Name:match("([^%-]+)%-?(.*)")

					if name then
						IASetLevel(name, realm, Level, "IAGuildScan")
					end
				end
			end
		end

		local delay = 0.5
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

		lf:SetScript("OnEvent", function(sel, event, ...)
			if event == "GUILD_ROSTER_UPDATE" or event == "CHAT_MSG_GUILD" or event == "CHAT_MSG_OFFICER" then
				C_Timer.After(delay, IAGuildScan)
			elseif event == "PLAYER_LEVEL_UP" then
				IASetLevel(UnitName("player"), GetRealmName(), UnitLevel("player"))
			elseif event == "WHO_LIST_UPDATE" or event == "CHAT_MSG_SYSTEM" then
				C_Timer.After(delay, IAWhoScan)
			elseif event == "FRIENDLIST_UPDATE" then
				C_Timer.After(delay, IAFriendScan)
			elseif event == "RAID_ROSTER_UPDATE" or event == "CHAT_MSG_RAID" then
				C_Timer.After(delay, IARaidScan)
			elseif event == "GROUP_ROSTER_UPDATE" then
				C_Timer.After(delay, IAPartyScan)
			else
				ImproveAny:MSG("Missing Event: " .. event)
			end
		end)

		IAWhoScan()
		IAFriendScan()
		IAPartyScan()
		IARaidScan()
		IAGuildScan()

		local function IAChatAddPlayerIcons(msg, c)
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
					local guid = IAGetGUID(id)

					if guid then
						local _, engClass, _, engRace, gender, name, realm = GetPlayerInfoByGUID(guid)

						if ImproveAny:IsEnabled("CHATCLASSCOLORS", true) then
							msg = ColorizePlayerNameInMessage(msg, guid, engClass)
						end

						if engClass and engRace and gender and races[engRace .. gender] and ImproveAny:GetClassIcon(engClass) then
							if ImproveAny:IsEnabled("CHATCLASSICONS", true) then
								msg = ImproveAny:GetClassIcon(engClass) .. msg
							end

							if ImproveAny:IsEnabled("CHATRACEICONS", false) then
								msg = races[engRace .. gender] .. msg
							end
						end

						local level = IAGetLevel(name, realm)

						if ImproveAny:IsEnabled("CHATLEVELS", true) and level and level > 0 then
							if string.find(msg, name .. "|r%]") then
								msg = string.gsub(msg, name .. "|r%]", level .. ":" .. name .. "|r%]", 1)
							else
								msg = string.gsub(msg, name .. "%]", level .. ":" .. name .. "%]", 1)
							end
						end
					end
				end
			end

			return msg
		end

		local function IAChatAddItemIcons(msg)
			msg = string.gsub(msg, "(|H.-|h.-|h)", function(itemString)
				local typ, id = string.match(itemString, "|H(.-):(.-)|h")

				if typ == "item" then
					id = string.match(id, "(%d+)")
					local itemName, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(id)

					if itemName and itemTexture then
						if ImproveAny:IsEnabled("CHATITEMICONS", true) then
							return "|T" .. itemTexture .. ":0|t" .. msg
						else
							return msg
						end
					else
						return itemString
					end
				else
					return itemString
				end
			end)

			return msg
		end

		local hooks = {}

		local function AddMessage(sel, message, ...)
			local chanName = nil
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

				if ImproveAny:IsEnabled("CHATSHORTCHANNELS", true) then
					local leaderChannel = _G["CHAT_MSG_" .. channel .. "_LEADER"]

					if leaderChannel == nil then
						leaderChannel = _G[channel .. "_LEADER"]
					end

					if leaderChannel then
						message = ImproveAny:ReplaceStr(message, leaderChannel, IAChatOnlyBig(leaderChannel))
					end

					if chanName then
						message = ImproveAny:ReplaceStr(message, chanName, IAChatOnlyBig(chanName))
					elseif channelName then
						chanName = _G["CHAT_MSG_" .. channelName]

						if chanName then
							message = "[" .. IAChatOnlyBig(chanName, 1) .. "] " .. message
						end
					end
				end

				message = IAChatAddPlayerIcons(message, 1)
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
		function IAIconsFilter(sel, event, msg, author, ...)
			local guid = select(10, ...)

			if author and guid then
				PLYCache[author] = guid
			end

			return false, IAChatAddItemIcons(msg, 1), author, ...
		end

		for i, typ in pairs(chatTypes) do
			ChatFrame_AddMessageEventFilter(typ, IAIconsFilter)
		end

		-- URLs / IPs / Emails
		local patterns = {"[htps:/]*%w+%.%w[%w%.%/%+%-%_%#%?%=]*"}

		function ImproveAny:FormatURL(url)
			url = "|cff" .. "3FC7EB" .. "|Hurl:" .. url .. "|h" .. url .. "|h|r"

			return url
		end

		function IAConvertMessage(sel, event, msg, ...)
			for i, p in pairs(patterns) do
				local s1 = string.find(msg, "|")
				local s2 = string.find(msg, p)

				if s1 == nil and s2 ~= nil then
					msg = string.gsub(msg, p, ImproveAny:FormatURL("%1"))
				end
			end

			if string.find(msg, "ginv", 0, true) then
				local name = select(1, ...)

				if name then
					msg = string.gsub(msg, "ginv", "|cff" .. "AAFFAA" .. "|Hginv:" .. name .. "|h" .. "ginv" .. "|h|r")
				end
			elseif string.find(msg, "inv", 0, true) then
				local name = select(1, ...)

				if name then
					msg = string.gsub(msg, "inv", "|cff" .. "FFFF00" .. "|Hinv:" .. name .. "|h" .. "inv" .. "|h|r")
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

		-- SetHyperLink
		function ImproveAny:SetHyperlink(link)
			local poi = string.find(link, ":", 0, true)
			local typ = string.sub(link, 1, poi - 1)

			if typ == "url" then
				local url = string.sub(link, 5)
				local tab = {}
				tab.url = url
				StaticPopup_Show("CLICK_LINK_URL", "", "", tab)

				return true
			elseif typ == "ginv" then
				local name = string.sub(link, poi + 1)
				GuildInvite(name)

				return true
			elseif typ == "inv" then
				local name = string.sub(link, poi + 1)

				if C_PartyInfo then
					C_PartyInfo.InviteUnit(name)
				else
					InviteUnit(name)
				end

				return true
			end

			return false
		end

		if ImproveAny:GetWoWBuild() == "RETAIL" then
			hooksecurefunc(ItemRefTooltip, "SetHyperlink", function(sel, link, ...)
				ImproveAny:SetHyperlink(link)
			end)
		else
			ItemRefTooltip.OldSetHyperlink = ItemRefTooltip.SetHyperlink

			function ItemRefTooltip:SetHyperlink(link, ...)
				local worked = ImproveAny:SetHyperlink(link)

				if not worked then
					ItemRefTooltip:OldSetHyperlink(link, ...)
				end
			end
		end

		-- SetHyperLink
		for i, typ in pairs(chatTypes) do
			ChatFrame_AddMessageEventFilter(typ, IAConvertMessage)
		end
	end
end