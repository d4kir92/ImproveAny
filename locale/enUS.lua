-- enUS English

LANG_IA = LANG_IA or {}

function IAUpdateLanguageTab( tab )
	for i, v in pairs( tab ) do
		LANG_IA[i] = v
	end
end

function IALang_enUS()
	local tab = {
		["MMBTNLEFT"] = "Left Click => Options",
		["MMBTNRIGHT"] = "Right Click => Hide Minimap Button",

		["GENERAL"] = "General",
		["SHOWMINIMAPBUTTON"] = "Show Minimap Button",
		["WORLDTEXTSCALE"] = "World Text Scale",
		["MAXZOOM"] = "Max Zoom Distance",
		["HIDEPVPBADGE"] = "Hide PVP Badge Icons",

		["QUICKGAMEPLAY"] = "Quick Gameplay",
		["FASTLOOTING"] = "Fast Looting",

		["COMBAT"] = "Combat",
		["COMBATTEXTICONS"] = "CombatText Icons",

		["CHAT"] = "Chat",
		["SHORTCHANNELS"] = "Short Chat Channels",
		["ITEMICONS"] = "Item Icons",
		["CLASSICONS"] = "Class Icons",
		["RACEICONS"] = "Race/BodyType Icons",
		["CHATLEVELS"] = "Player Levels",

		["MINIMAP"] = "Minimap",
		["MINIMAPHIDEBORDER"] = "Minimap Hide Border",
		["MINIMAPHIDEZOOMBUTTONS"] = "Minimap Hide Zoom Buttons",
		["MINIMAPSCROLLZOOM"] = "Minimap Zoom with Mousewheel",
		["MINIMAPSHAPESQUARE"] = "Square Minimap",
		["MINIMAPMINIMAPBUTTONSMOVABLE"] = "Make minimap buttons movable",

		["ITEMLEVEL"] = "ItemLevel",
		["ITEMLEVELNUMBER"] = "ItemLevel Number",
		["ITEMLEVELBORDER"] = "ItemLevel Border",

		["XPBAR"] = "XPBar",
		["XPLEVEL"] = "Character Level",
		["XPNUMBER"] = "XP Number",
		["XPPERCENT"] = "XP Percent",
		["XPMISSING"] = "Missing XP",
		["XPEXHAUSTION"] = "XP Exhaustion",
		["XPXPPERHOUR"] = "XP/Hour",
		["XPHIDEARTWORK"] = "XPBar Hide Artwork",

		["REPBAR"] = "Reputation Bar",
		["REPNUMBER"] = "Reputation Number",
		["REPPERCENT"] = "Reputation Percent",
		["REPHIDEARTWORK"] = "Reputation Bar Hide Artwork",

		["UNITFRAMES"] = "UnitFrames",
		["RFHIDEBUFFIDSINCOMBAT"] = "Hide BuffIds for Raidframe (In Combat)",
		["RFHIDEBUFFIDSINNOTCOMBAT"] = "Hide BuffIds for Raidframe (Outside of Combat)",
		["RAIDFRAMEMOREBUFFS"] = "Raidframe more Buffs",
		["BUFFSCALE"] = "Buff-Scale",
		["DEBUFFSCALE"] = "Debuff-Scale",
		["OVERWRITERAIDFRAMESIZE"] = "Override Raidframe-Size",
		["RAIDFRAMEW"] = "Raidframe Width",
		["RAIDFRAMEH"] = "Raidframe Height",

		["EXTRAS"] = "Extras",
		["MONEYBAR"] = "Money Bar",
		["TOKENBAR"] = "Token Bar",
		["SKILLBARS"] = "Skillbars (Professions, Weaponskills)",
		["CASTBAR"] = "Castbar",
		["DURABILITY"] = "Durability (Shows ItemLevel, Repaircosts)",
		["BAGS"] = "Show Freespace for each Bag",
		["WORLDMAP"] = "WorldMap Zoom with Mousewheel",
	}

	IAUpdateLanguageTab( tab )
end
