
local AddOnName, ImproveAny = ...

function IAChatOnlyBig( str )
	local res = string.gsub(str, "[^%u-]", "" )

	if #res > 3 then -- shorten
		res = string.sub( res, 1, 3 )
	end
	if #str <= 3 then -- 1-3 => upper
		res = string.upper( res )
	end

	if #res <= 0 then -- no upper?
		if #str <= 3 then
			res = string.upper( str )
		else
			res = string.gsub(str, "[^%l-]", "" )
			res = string.sub( res, 1, 1 )
			res = string.upper( res )
			--res = IAChatOnlyBig( res )
		end
	end

	if string.find( res, "-", string.len( res ), true ) then
		res = string.gsub(str, "[^%u]", "" )
	end

	return res
end

local races = {}

local classes = {}

C_Timer.After( 0.01, function()
	if IABUILD == "CLASSIC" then
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
	elseif IABUILD == "TBC" or IABUILD == "WRATH" then
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
	elseif IABUILD == "RETAIL" then
		races["DarkIronDwarf2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:390:456:910:976|t"
		races["KulTiran2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1894:1960:0:66|t"
		races["Mechagnome3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1106:328:394|t"
		races["Vulpera2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1106:1172:724:790|t"
		races["Scourge3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1106:1172:394:460|t"
		races["VoidElf3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1106:1172:526:592|t"
		races["Worgen2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1106:1172:856:922|t"
		races["DarkIronDwarf3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:260:326:910:976|t"
		races["NightElf3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1106:592:658|t"
		races["Gnome3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1300:1366:0:66|t"
		races["Dwarf2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:910:976:910:976|t"
		races["Gnome2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1366:1432:0:66|t"
		races["Orc3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1106:724:790|t"
		races["ZandalariTroll2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1172:1238:130:196|t"
		races["Tauren2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1106:1172:196:262|t"
		races["MagharOrc2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1106:262:328|t"
		races["Troll2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1106:1172:328:394|t"
		races["Scourge2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1106:1172:460:526|t"
		races["MagharOrc3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1106:196:262|t"
		races["Tauren3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1106:1172:130:196|t"
		races["Goblin2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1498:1564:0:66|t"
		races["BloodElf3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:0:66:910:976|t"
		races["BloodElf2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:130:196:910:976|t"
		races["Human3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1696:1762:0:66|t"
		races["Human2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1762:1828:0:66|t"
		races["LightforgedDraenei2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1106:130:196|t"
		races["LightforgedDraenei3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1960:2026:0:66|t"
		races["HighmountainTauren2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1630:1696:0:66|t"
		races["Nightborne2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1106:526:592|t"
		races["Pandaren3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1106:856:922|t"
		races["Draenei3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:520:586:910:976|t"
		races["VoidElf2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1106:1172:592:658|t"
		races["Nightborne3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1106:460:526|t"
		races["Worgen3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1106:1172:790:856|t"
		races["NightElf2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1106:658:724|t"
		races["Goblin3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1432:1498:0:66|t"
		races["Orc2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1106:790:856|t"
		races["Mechagnome2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1106:394:460|t"
		races["Troll3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1106:1172:262:328|t"
		races["ZandalariTroll3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1106:1172:922:988|t"
		races["Vulpera3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1106:1172:658:724|t"
		races["KulTiran3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1828:1894:0:66|t"
		races["Dwarf3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:780:846:910:976|t"
		races["Draenei2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:650:716:910:976|t"
		races["HighmountainTauren3"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1564:1630:0:66|t"
		races["Pandaren2"] = "|TInterface\\Glues\\CharacterCreate\\CharacterCreateIcons:0:0:0:0:2048:1024:1040:1106:922:988|t"
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
end)

local PLYCache = {}
local function IAGetGUID( name )
	return PLYCache[name]
end

function IAResetMsg( msg )
	msg = string.gsub(msg, "(|Z)", "|X", 1)
	msg = string.gsub(msg, "(|z)", "|x", 1)
	return msg
end

local levelTab = {}
function IAGetLevel( name, realm )
	if realm == nil or realm == "" then
		realm = GetRealmName()
	end
	return levelTab[name .. "-" .. realm]
end

function IASetLevel( name, realm, level )
	if realm == nil or realm == "" then
		realm = GetRealmName()
	end
	if name and realm then
		levelTab[name .. "-" .. realm] = level
	end
end
IASetLevel( UnitName( "player" ), nil, UnitLevel( "player" ) )

function IAWhoScan()
	local Name, Class, Level, Server, _
	for i = 1, C_FriendList.GetNumWhoResults() do
		local info = C_FriendList.GetWhoInfo( i )
		IASetLevel( info.fullName, nil, info.level )
	end
end

function IAFriendScan()
	local Name, Class, Level
	for i = 1, C_FriendList.GetNumFriends() do
		Name, Level, Class = C_FriendList.GetFriendInfo( i )
		IASetLevel( Name, nil, Level )
	end
end

function IAPartyScan()
	local max = GetNumSubgroupMembers or GetNumPartyMembers
	for i = 1, max() do
		local name, realm = UnitName( "party" .. i )
		IASetLevel( name, realm, UnitLevel( "party" .. i ) )
	end
end

function IARaidScan()
	local max = GetNumGroupMembers or GetNumRaidMembers
	for i = 1, max() do
		local _, _, _, Level = GetRaidRosterInfo( i )
		Name, Server = UnitName( "raid" .. i )
		IASetLevel( Name, Server, Level )
	end
end

function IAGuildScan()
	if IsInGuild() then
		C_GuildInfo.GuildRoster()

		for i = 1, GetNumGuildMembers( true ) do
			local Name, _, _, Level = GetGuildRosterInfo(i)
			local name, realm = Name:match("([^%-]+)%-?(.*)")
			IASetLevel( name, realm, Level )
		end
	end
end

local lf = CreateFrame( "Frame", "IALevelFrame" )
lf:RegisterEvent( "GROUP_ROSTER_UPDATE" )
lf:RegisterEvent( "CHAT_MSG_RAID" )
lf:RegisterEvent( "CHAT_MSG_GUILD" )
lf:RegisterEvent( "CHAT_MSG_OFFICER" )
lf:RegisterEvent( "FRIENDLIST_UPDATE" )
lf:RegisterEvent( "GUILD_ROSTER_UPDATE" )
lf:RegisterEvent( "RAID_ROSTER_UPDATE" )
lf:RegisterEvent( "WHO_LIST_UPDATE" )
lf:RegisterEvent( "PLAYER_LEVEL_UP" )
lf:RegisterEvent( "CHAT_MSG_SYSTEM" )
lf:RegisterEvent( "PLAYER_LOGIN" )
lf:SetScript( "OnEvent", function( self, event, ... )
	if event == "GUILD_ROSTER_UPDATE" or event == "CHAT_MSG_GUILD" or event == "CHAT_MSG_OFFICER" then
		IAGuildScan()
	elseif event == "PLAYER_LEVEL_UP" then
		levelTab[UnitName( "player" ) .. "-" .. GetRealmName()] = UnitLevel( "player" )
	elseif event == "WHO_LIST_UPDATE" or event == "CHAT_MSG_SYSTEM" then
		IAWhoScan()
	elseif event == "FRIENDLIST_UPDATE" then
		IAFriendScan()
	elseif event == "RAID_ROSTER_UPDATE" or event == "CHAT_MSG_RAID" then
		IARaidScan()
	elseif event == "GROUP_ROSTER_UPDATE" then
		IAPartyScan()
	elseif event == "PLAYER_LOGIN" then
		IAWhoScan()
		IAFriendScan()
		IAPartyScan()
		IARaidScan()
		IAGuildScan()
	else
		ImproveAny:MSG( "Missing Event: " .. event )
	end
end )

function IAChatAddItemIcons( msg, c )
	if c >= 40 then
		return msg
	end
	msg = string.gsub(msg, "(|H)", "|Z", 1)
	msg = string.gsub(msg, "(|h)", "|y", 1)
	msg = string.gsub(msg, "(|h)", "|z", 1)

	local itemString = select(3, strfind(msg, "|Z(.+)|z"))

	if itemString then
		local type = select( 1, string.split( ":", itemString ) )
		local id = select( 2, string.split( ":", itemString ) )

		if type == "item" then
			itemTexture = GetItemIcon(id)
			if itemTexture then
				if true then
					msg = string.gsub(msg, "(|Z)", "|T" .. itemTexture .. ":0|t" .. "|X", 1)
					msg = string.gsub(msg, "(|z)", "|x", 1)

					return IAChatAddItemIcons( msg, c + 1 )
				else
					msg = IAResetMsg( msg )
				end
			else
				msg = IAResetMsg( msg )
			end
		elseif type == "player" or type == "playerCommunity" or type == "playerGM" then
			local guid = IAGetGUID( id )
			if guid then
				local _, engClass, _, engRace, gender, name, realm = GetPlayerInfoByGUID( guid )
				if engClass and engRace and gender and races[engRace .. gender] and classes[engClass] then
					local res = ""
					if true then
						res = res .. races[engRace .. gender]
					end
					if true then
						res = res .. classes[engClass]
					end
					local r, g, b, hex = 0, 0, 0, "FFFFFFFF"
					if GetClassColor then
						r, g, b, hex = GetClassColor(engClass)
					end

					local level = IAGetLevel( name, realm )
					if level then
						msg = string.gsub( msg, name, level .. ":" .. name )
					end

					msg = string.gsub( msg, "%[", "" )
					msg = string.gsub( msg, "%]", "" )

					msg = string.gsub( msg, "(|Z)", res .. "[|c" .. hex .. "|X", 1 )
					msg = string.gsub( msg, "(|z)", "|r]|x", 1 )

					return IAChatAddItemIcons( msg, c + 1 )
				else
					msg = IAResetMsg( msg )
				end
			else
				-- NPC TALK
				msg = IAResetMsg( msg )
			end
		elseif type == "ccpCustomLink" then
			msg = IAResetMsg( msg )
		elseif type == "BNplayer" or type == "BNplayerCommunity" then
			msg = IAResetMsg( msg )
		else
			--IAMSG( "SEND TO DEV => UNKNOWN CHAT TYPE: " .. tostring( type ) )
			msg = IAResetMsg( msg )
		end
	end

	msg = string.gsub(msg, "(|X)", "|H")
	msg = string.gsub(msg, "(|y)", "|h")
	msg = string.gsub(msg, "(|x)", "|h")

	return msg
end



-- Item Icons
function IAIconsFilter( self, event, msg, author, ... )
	local guid = select( 10, ... )
	if author and guid then
		PLYCache[author] = guid
	end
	return false, IAChatAddItemIcons( msg, 1 ), author, ...
end

for type in next, getmetatable(ChatTypeInfo).__index do
	ChatFrame_AddMessageEventFilter("CHAT_MSG_" .. type, IAIconsFilter)
end



-- Class/Race Icons
local function IAAddLinks(str)
	return IAChatAddItemIcons( str, 1 )
end

local function IAHookFunc( key )
	local org = _G[key]
	_G[key] = function( ... )
		return IAAddLinks( org( ... ) ) 
	end
end
IAHookFunc("GetBNPlayerCommunityLink") 
IAHookFunc("GetBNPlayerLink") 
IAHookFunc("GetGMLink") 
IAHookFunc("GetPlayerCommunityLink") 
IAHookFunc("GetPlayerLink") 



-- Change
local oldstrs = {}
function IAUpdateChatChannels()
	local c = 1
	for i, v in pairs(_G) do
		if type(v) == "string" and string.find(i, "CHAT_", 1, true) and string.find(i, "_GET", 1, true) then
			c = c + 1
			local lang = string.sub( i, 6 )
			lang = string.sub( lang, 1, string.len( lang ) - 4 )
			if _G[lang] then
				if oldstrs[i] == nil then
					oldstrs[i] = _G[i]
				end

				if true then
					if lang == "CHANNEL" then
						_G[i] = "%s: "
					else
						_G[i] = "[" .. IAChatOnlyBig( _G[lang] ) .. "] %s: "
					end
				elseif oldstrs[i] then
					_G[i] = oldstrs[i]
				end
			end
		end
	end
end

function ChatFrame_ResolvePrefixedChannelName( communityChannel )
	local prefix, communityChannel = communityChannel:match("(%d+. )(.*)")
	if true then
		return IAChatOnlyBig( communityChannel )
	else
		return prefix..ChatFrame_ResolveChannelName(communityChannel)
	end
end












-- URLs / IPs / Emails
local patterns = {
	"[htps:/]*%w+%.%w[%w%.%/%+%-%_%#%?%=]*"
}

function ImproveAny:FormatURL( url )
    url = "|cff".."3FC7EB".."|Hurl:"..url.."|h"..url.."|h|r"
    return url
end

function IAConvertMessage( self, event, msg, ... )
	for i, p in pairs( patterns ) do
		if string.find( msg, p ) then
			msg = string.gsub( msg, p, ImproveAny:FormatURL( "%1" ) )
		end
	end

    if string.find( msg, "ginv", 0, true ) then
		local name = select(1, ...)
		if name then
			msg = string.gsub( msg, "ginv", "|cff".."AAFFAA".."|Hginv:" .. name .. "|h" .. "ginv" .. "|h|r" )
		end
	elseif string.find( msg, "inv", 0, true ) then
		local name = select(1, ...)
		if name then
			msg = string.gsub( msg, "inv", "|cff".."FFFF00".."|Hinv:" .. name .. "|h" .. "inv" .. "|h|r" )
		end
	end

    return false, msg, ...
end

StaticPopupDialogs["CLICK_LINK_URL"] = {
    text = "LINK/EMAIL/IP",
    button1 = "Close",
    OnAccept = function()

    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3, 
    OnShow = 
        function ( self, data )
            self.editBox:SetText( data.url )
            self.editBox:HighlightText()
        end,
    hasEditBox = true
}

local OrgSetHyperlink = ItemRefTooltip.SetHyperlink
function ItemRefTooltip:SetHyperlink( link )
	local poi = string.find( link, ":", 0, true )
	local typ =  string.sub( link, 1, poi - 1 )
	if typ == "url" then
		local url = string.sub( link, 5 )
		local tab = {}
		tab.url = url
		StaticPopup_Show( "CLICK_LINK_URL", "", "", tab )
	elseif typ == "ginv" then
		local name = string.sub( link, poi + 1 )
		GuildInvite( name )
	elseif typ == "inv" then
		local name = string.sub( link, poi + 1 )
		InviteUnit( name )
	else
		OrgSetHyperlink( self, link )
	end
end

local chatTypes = {}
for i, v in pairs( _G ) do
	if string.find( i, "CHAT_MSG_" ) then
		tinsert( chatTypes, i )
	end
end

for i, type in pairs( chatTypes ) do
    ChatFrame_AddMessageEventFilter( type, IAConvertMessage )
end
