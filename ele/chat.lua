local _, ImproveAny = ...
local genderNames = {"", "Male", "Female"}
local classes = {}
function ImproveAny:GetClassIcon(class, size)
	size = size or 0
	if classes and classes[class] then return classes[class] end

	return ""
end

function ImproveAny:GetRaceAtlas(race, gender)
	return ("raceicon-%s-%s"):format(race, gender)
end

function ImproveAny:GetRaceIcon(race, gender)
	return "|A:" .. ImproveAny:GetRaceAtlas(race, genderNames[gender], false) .. ":0:0:0:0|a"
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

						if engClass and engRace and gender then
							if ImproveAny:IsEnabled("CHATCLASSICONS", false) and ImproveAny:GetClassIcon(engClass) then
								msg = ImproveAny:GetClassIcon(engClass, 0) .. msg
							end

							if ImproveAny:IsEnabled("CHATRACEICONS", false) and ImproveAny:GetRaceIcon(engRace, gender) then
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
						local itemName, _, _, _, _, _, _, _, _, itemTexture = ImproveAny:GetItemInfo(id)
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

		if ImproveAny:GetWoWBuild() == "RETAIL" then
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
