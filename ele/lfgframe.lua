
local AddOnName, ImproveAny = ...

local portal = GetCVar( "portal" )



local IMPORTREALMS = {}
if portal == "EU" then
	IMPORTREALMS["EU"] = {}
	IMPORTREALMS["EU"]["enUS"] = {
		"Aerie Peak",
		"Agamaggan",
		"Aggra (Português)",
		"Aggramar",
		"Ahn'Qiraj",
		"Al'Akir",
		"Alonsus",
		"Anachronos",
		"Arathor",
		"Argent Dawn",
		"Aszune",
		"Auchindoun",
		"Azjol-Nerub",
		"Azuremyst",
		"Balnazzar",
		"Blade's Edge",
		"Bladefist",
		"Bloodfeather",
		"Bloodhoof",
		"Bloodscalp",
		"Boulderfist",
		"Bronze Dragonflight",
		"Bronzebeard",
		"Burning Blade",
		"Burning Legion",
		"Burning Steppes",
		"Chamber of Aspects",
		"Chromaggus",
		"Crushridge",
		"Daggerspine",
		"Darkmoon Faire",
		"Darksorrow",
		"Darkspear",
		"Deathwing",
		"Defias Brotherhood",
		"Dentarg",
		"Doomhammer",
		"Draenor",
		"Dragonblight",
		"Dragonmaw",
		"Drak'thul",
		"Dunemaul",
		"Earthen Ring",
		"Emerald Dream",
		"Emeriss",
		"Eonar",
		"Executus",
		"Frostmane",
		"Frostwhisper",
		"Genjuros",
		"Ghostlands",
		"Grim Batol",
		"Hakkar",
		"Haomarush",
		"Hellfire",
		"Hellscream",
		"Jaedenar",
		"Karazhan",
		"Kazzak",
		"Khadgar",
		"Kilrogg",
		"Kor'gall",
		"Kul Tiras",
		"Laughing Skull",
		"Lightbringer",
		"Lightning's Blade",
		"Magtheridon",
		"Mazrigos",
		"Moonglade",
		"Nagrand",
		"Neptulon",
		"Nordrassil",
		"Outland",
		"Quel'Thalas",
		"Ragnaros",
		"Ravencrest",
		"Ravenholdt",
		"Runetotem",
		"Saurfang",
		"Scarshield Legion",
		"Shadowsong",
		"Shattered Halls",
		"Shattered Hand",
		"Silvermoon",
		"Skullcrusher",
		"Spinebreaker",
		"Sporeggar",
		"Steamwheedle Cartel",
		"Stormrage",
		"Stormreaver",
		"Stormscale",
		"Sunstrider",
		"Sylvanas",
		"Talnivarr",
		"Tarren Mill",
		"Terenas",
		"Terokkar",
		"The Maelstrom",
		"The Sha'tar",
		"The Venture Co",
		"Thunderhorn",
		"Trollbane",
		"Turalyon",
		"Twilight's Hammer",
		"Twisting Nether",
		"Vashj",
		"Vek'nilash",
		"Wildhammer",
		"Xavius",
		"Zenedar",
	}
	IMPORTREALMS["EU"]["deDE"] = {
		"Aegwynn",
		"Alexstrasza",
		"Alleria",
		"Aman'thul",
		"Ambossar",
		"Anetheron",
		"Antonidas",
		"Anub'arak",
		"Area 52",
		"Arthas",
		"Arygos",
		"Azshara",
		"Baelgun",
		"Blackhand",
		"Blackmoore",
		"Blackrock",
		"Blutkessel",
		"Dalvengyr",
		"Das Konsortium",
		"Das Syndikat",
		"Der Abyssische Rat",
		"Der Mithrilorden",
		"Der Rat von Dalaran",
		"Destromath",
		"Dethecus",
		"Die Aldor",
		"Die Arguswacht",
		"Die Nachtwache",
		"Die Silberne Hand",
		"Die Todeskrallen",
		"Die ewige Wacht",
		"Dun Morogh",
		"Durotan",
		"Echsenkessel",
		"Eredar",
		"Festung der Stürme",
		"Forscherliga",
		"Frostmourne",
		"Frostwolf",
		"Garrosh",
		"Gilneas",
		"Gorgonnash",
		"Gul'dan",
		"Kargath",
		"Kel'Thuzad",
		"Khaz'goroth",
		"Kil'jaeden",
		"Krag'jin",
		"Kult der Verdammten",
		"Lordaeron",
		"Lothar",
		"Madmortem",
		"Mal'Ganis",
		"Malfurion",
		"Malorne",
		"Malygos",
		"Mannoroth",
		"Mug'thol",
		"Nathrezim",
		"Nazjatar",
		"Nefarian",
		"Nera'thor",
		"Nethersturm",
		"Norgannon",
		"Nozdormu",
		"Onyxia",
		"Perenolde",
		"Proudmoore",
		"Rajaxx",
		"Rexxar",
		"Sen'jin",
		"Shattrath",
		"Taerar",
		"Teldrassil",
		"Terrordar",
		"Theradras",
		"Thrall",
		"Tichondrius",
		"Tirion",
		"Todeswache",
		"Ulduar",
		"Un'Goro",
		"Vek'lor",
		"Wrathbringer",
		"Ysera",
		"Zirkel des Cenarius",
		"Zuluhed",
	}
	IMPORTREALMS["EU"]["frFR"] = {
		"Arak-arahm",
		"Arathi",
		"Archimonde",
		"Chants éternels",
		"Cho'gall",
		"Confrérie du Thorium",
		"Conseil des Ombres",
		"Culte de la Rive noire",
		"Dalaran",
		"Drek'Thar",
		"Eitrigg",
		"Eldre'Thalas",
		"Elune",
		"Garona",
		"Hyjal",
		"Illidan",
		"Kael'thas",
		"Khaz Modan",
		"Kirin Tor",
		"Krasus",
		"La Croisade écarlate",
		"Les Clairvoyants",
		"Les Sentinelles",
		"Marécage de Zangar",
		"Medivh",
		"Naxxramas",
		"Ner'zhul",
		"Rashgarroth",
		"Sargeras",
		"Sinstralis",
		"Suramar",
		"Temple noir",
		"Throk'Feroth",
		"Uldaman",
		"Varimathras",
		"Vol'jin",
		"Ysondre",
	}
	IMPORTREALMS["EU"]["ruRU"] = {
		"Ясеневый лес",		--"Ashenvale",
		"Азурегос",			--"Azuregos",
		"Черный Шрам",		--"Blackscar",
		"Пиратская Бухта",	--"Booty Bay",
		"Борейская тундра",	--"Borean Tundra",
		"Страж Смерти",		--"Deathguard",
		"Ткач Смерти",		--"Deathweaver",
		"Подземье", 		--"Deepholm",
		"Вечная Песня",		--"Eversong",
		"Дракономор",		--"Fordragon",
		"Галакронд",		--"Galakrond",
		"Голдринн",			--"Goldrinn",
		"Гордунни", 		--"Gordunni",
		"Седогрив",			--"Greymane",
		"Гром",				--"Grom",
		"Ревущий фьорд",	--"Howling Fjord",
		"Корольлич",	 	--"Lich King",
		"Разувий",			--"Razuvious",
		"Свежеватель Душ",	--"Soulflayer",
		"Термоштепсель",	--"Thermaplugg",
	}
	IMPORTREALMS["EU"]["esES"] = {
		"C'Thun",
		"Colinas Pardas",
		"Dun Modr",
		"Exodar",
		"Los Errantes",
		"Minahonda",
		"Sanguino",
		"Shen'dralar",
		"Tyrande",
		"Uldum",
		"Zul'jin",
	}
	IMPORTREALMS["EU"]["itIT"] = {
		"Nemesis",
		"Pozzo dell'Eternità",
	}
elseif portal == "US" then
	IMPORTREALMS["US"] = {}
	IMPORTREALMS["US"]["enUS"] = {
		"Aegwynn",
		"Aerie Peak",
		"Agamaggan",
		"Aggramar",
		"Akama",
		"Alexstrasza",
		"Alleria",
		"Altar of Storms",
		"Alterac Mountains",
		"Andorhal",
		"Anetheron",
		"Antonidas",
		"Anub'arak",
		"Anvilmar",
		"Arathor",
		"Archimonde",
		"Area 52",
		"Argent Dawn",
		"Arthas",
		"Arygos",
		"Auchindoun",
		"Azgalor",
		"Azjol-Nerub",
		"Azshara",
		"Azuremyst",
		"Baelgun",
		"Balnazzar",
		"Black Dragonflight",
		"Blackhand",
		"Blackrock",
		"Blackwater Raiders",
		"Blackwing Lair",
		"Blade's Edge",
		"Bladefist",
		"Bleeding Hollow",
		"Blood Furnace",
		"Bloodhoof",
		"Bloodscalp",
		"Bonechewer",
		"Borean Tundra",
		"Boulderfist",
		"Bronzebeard",
		"Burning Blade",
		"Burning Legion",
		"Cairne",
		"Cenarion Circle",
		"Cenarius",
		"Cho'gall",
		"Chromaggus",
		"Coilfang",
		"Crushridge",
		"Daggerspine",
		"Dalaran",
		"Dalvengyr",
		"Dark Iron",
		"Darkspear",
		"Darrowmere",
		"Dawnbringer",
		"Deathwing",
		"Demon Soul",
		"Dentarg",
		"Destromath",
		"Dethecus",
		"Detheroc",
		"Doomhammer",
		"Draenor",
		"Dragonblight",
		"Dragonmaw",
		"Drak'Tharon",
		"Drak'thul",
		"Draka",
		"Drenden",
		"Dunemaul",
		"Durotan",
		"Duskwood",
		"Earthen Ring",
		"Echo Isles",
		"Eitrigg",
		"Eldre'Thalas",
		"Elune",
		"Emerald Dream",
		"Eonar",
		"Eredar",
		"Executus",
		"Exodar",
		"Farstriders",
		"Feathermoon",
		"Fenris",
		"Firetree",
		"Fizzcrank",
		"Frostmane",
		"Frostwolf",
		"Galakrond",
		"Garithos",
		"Garona",
		"Garrosh",
		"Ghostlands",
		"Gilneas",
		"Gnomeregan",
		"Gorefiend",
		"Gorgonnash",
		"Greymane",
		"Grizzly Hills",
		"Gul'dan",
		"Gurubashi",
		"Hakkar",
		"Haomarush",
		"Hellscream",
		"Hydraxis",
		"Hyjal",
		"Icecrown",
		"Illidan",
		"Jaedenar",
		"Kael'thas",
		"Kalecgos",
		"Kargath",
		"Kel'Thuzad",
		"Khadgar",
		"Khaz Modan",
		"Kil'jaeden",
		"Kilrogg",
		"Kirin Tor",
		"Korgath",
		"Korialstrasz",
		"Kul Tiras",
		"Laughing Skull",
		"Lethon",
		"Lightbringer",
		"Lightning's Blade",
		"Lightninghoof",
		"Llane",
		"Lothar",
		"Madoran",
		"Maelstrom",
		"Magtheridon",
		"Maiev",
		"Mal'Ganis",
		"Malfurion",
		"Malorne",
		"Malygos",
		"Mannoroth",
		"Medivh",
		"Misha",
		"Mok'Nathal",
		"Moon Guard",
		"Moonrunner",
		"Mug'thol",
		"Muradin",
		"Nathrezim",
		"Nazgrel",
		"Nazjatar",
		"Ner'zhul",
		"Nesingwary",
		"Nordrassil",
		"Norgannon",
		"Onyxia",
		"Perenolde",
		"Proudmoore",
		"Quel'dorei",
		"Ravencrest",
		"Ravenholdt",
		"Rexxar",
		"Rivendare",
		"Runetotem",
		"Sargeras",
		"Scarlet Crusade",
		"Scilla",
		"Sen'jin",
		"Sentinels",
		"Shadow Council",
		"Shadowmoon",
		"Shadowsong",
		"Shandris",
		"Shattered Halls",
		"Shattered Hand",
		"Shu'halo",
		"Silver Hand",
		"Silvermoon",
		"Sisters of Elune",
		"Skullcrusher",
		"Skywall",
		"Smolderthorn",
		"Spinebreaker",
		"Spirestone",
		"Staghelm",
		"Steamwheedle Cartel",
		"Stonemaul",
		"Stormrage",
		"Stormreaver",
		"Stormscale",
		"Suramar",
		"Tanaris",
		"Terenas",
		"Terokkar",
		"The Forgotten Coast",
		"The Scryers",
		"The Underbog",
		"The Venture Co",
		"Thorium Brotherhood",
		"Thrall",
		"Thunderhorn",
		"Thunderlord",
		"Tichondrius",
		"Tortheldrin",
		"Trollbane",
		"Turalyon",
		"Twisting Nether",
		"Uldaman",
		"Uldum",
		"Undermine",
		"Ursin",
		"Uther",
		"Vashj",
		"Vek'nilash",
		"Velen",
		"Warsong",
		"Whisperwind",
		"Wildhammer",
		"Windrunner",
		"Winterhoof",
		"Wyrmrest Accord",
		"Ysera",
		"Ysondre",
		"Zangarmarsh",
		"Zul'jin",
		"Zuluhed",
	}
	IMPORTREALMS["US"]["oceanic"] = {
		"Aman'Thul",
		"Barthilas",
		"Caelestrasz",
		"Dath'Remar",
		"Dreadmaul",
		"Frostmourne",
		"Gundrak",
		"Jubei'Thos",
		"Khaz'goroth",
		"Nagrand",
		"Saurfang",
		"Thaurissan",
	}
	IMPORTREALMS["US"]["ptBR"] = {
		"Azralon",
		"Gallywix",
		"Goldrinn",
		"Nemesis",
		"Tol Barad",
	}
	IMPORTREALMS["US"]["esMX"] = {
		"Drakkari",
		"Quel'Thalas",
		"Ragnaros",
	}
end

local REALMS = {}
REALMS[portal] = {}
if IMPORTREALMS[portal] then
	for lang, realmTab in pairs( IMPORTREALMS[portal] ) do
		for i, realmName in pairs(  realmTab ) do
			realmName = string.gsub( realmName, "%s+", "" )
			realmName = string.gsub( realmName, "%-", "" )
			if REALMS[portal][realmName] == nil then
				REALMS[portal][realmName] = lang
			else
				print(">>> EXISTS ALREADY", realmName)
			end
		end
	end
end



function ImproveAny:GetRealmLang( name )
	local realmName = name
	if realmName == nil then
		return nil
	end
	local s1, e1 = string.find( realmName, "-" )
	if s1 and e1 then
		realmName = string.sub( realmName, e1 + 1 )
	end
	realmName = string.gsub( realmName, "%s+", "" )
	realmName = string.gsub( realmName, "%-", "" )

	local portal = GetCVar( "portal" )
	if REALMS[portal] == nil then
		return nil
	end

	if REALMS[portal][realmName] then
		return REALMS[portal][realmName]
	else
		ImproveAny:MSG( format( "MISSING REALM [%s], please Send to Developer", realmName ) )
	end

	return nil
end

function ImproveAny:GetFlagString( realmName, text )
	local realmLang = ImproveAny:GetRealmLang( realmName )
	if realmLang and ImproveAny:IsEnabled( "LFGSHOWLANGUAGEFLAG", true ) then
		return "|T".."Interface\\Addons\\ImproveAny\\media\\flags\\" .. realmLang .. ":12:24:0:0|t" .. " " .. text
	else
		return text
	end
end

function ImproveAny:InitLFGFrame()
	if LFGListApplicationViewer_UpdateApplicantMember then
		hooksecurefunc( "LFGListApplicationViewer_UpdateApplicantMember", function( member, id, index )
			local name, class, localizedClass, level, itemLevel, honorLevel, tank, healer, damage, assignedRole, relationship, dungeonScore, pvpItemLevel = C_LFGList.GetApplicantMemberInfo( id, index )
			local stats = C_LFGList.GetApplicantMemberStats( id, index )

			local activeEntryInfo = C_LFGList.GetActiveEntryInfo();
			if ( not activeEntryInfo ) then
				return;
			end

			if name == nil then
				return
			end

			local dName = member.Name:GetText()
			local text = ""

			local bestDungeonScoreForListing = C_LFGList.GetApplicantDungeonScoreForListing( id, index, activeEntryInfo.activityID )
			
			local dungeonRating = bestDungeonScoreForListing.mapScore
			if ImproveAny:IsEnabled( "LFGSHOWDUNGEONSCORE", true ) and dungeonRating and dungeonRating > 0 then 
				local r, g, b, hex = GetClassColor( class )
				local color = C_ChallengeMode.GetDungeonScoreRarityColor( dungeonRating )
				text = "|c" .. color:GenerateHexColor() .. dungeonRating .. "|r " .. text
			end

			local dungeonKey = bestDungeonScoreForListing.bestRunLevel
			if ImproveAny:IsEnabled( "LFGSHOWDUNGEONKEY", true ) and dungeonKey then
				text = dungeonKey .. " " .. text
			end

			if ImproveAny:IsEnabled( "LFGSHOWCLASSICON", true ) then
				text = text .. ImproveAny:GetClassIcon( class )
			end

			text = text .. dName


			
			local server = ""
			local s, e = string.find( name, "-" )
			
			if s then
				server = strsub( name, s + 1 )
			else
				server = GetRealmName()
			end

			local lang = ImproveAny:GetFlagString( server, text )

			if lang then
				member.Name:SetText( lang )
			end
		end )
	end

	if LFGListSearchEntry_Update then
		hooksecurefunc( "LFGListSearchEntry_Update", function( self, ... )
			local sri = C_LFGList.GetSearchResultInfo(self.resultID)
			local name = sri.leaderName
			
			local text = self.Name:GetText()

			if sri.isWarMode then
				text = "[WM] " .. text
			end
			if sri.requiredItemLevel > 0 then
				text = "[ilvl: " .. sri.requiredItemLevel .. "+] " .. text
			end
			if sri.leaderDungeonScoreInfo and sri.leaderDungeonScoreInfo.mapScore then -- only when its for dungeon
				if ImproveAny:IsEnabled( "LFGSHOWOVERALLSCORE", true ) and sri.leaderOverallDungeonScore and sri.leaderOverallDungeonScore > 0 then
					local color = C_ChallengeMode.GetDungeonScoreRarityColor( sri.leaderOverallDungeonScore )
					if color then
						text = "|c" .. color:GenerateHexColor() .. sri.leaderOverallDungeonScore .. "|r " .. text
					end
				end
				if ImproveAny:IsEnabled( "LFGSHOWDUNGEONSCORE", true ) and sri.leaderDungeonScoreInfo and sri.leaderDungeonScoreInfo.mapScore > 0 then
					local color = C_ChallengeMode.GetSpecificDungeonOverallScoreRarityColor( sri.leaderDungeonScoreInfo.mapScore )
					if color then
						text = "|c" .. color:GenerateHexColor() .. sri.leaderDungeonScoreInfo.mapScore .. "|r " .. text
					end
				end
			end

			if text then
				self.Name:SetText( text )
			end

			local lang = ImproveAny:GetFlagString( name, self.ActivityName:GetText() )
			if lang then
				self.ActivityName:SetText( lang )
			end
		end )
	end
end
