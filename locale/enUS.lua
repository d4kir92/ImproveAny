-- enUS English

local AddOnName, ImproveAny = ...

function ImproveAny:UpdateLanguageTab( tab )
	local lang = ImproveAny:GetLangTab()
	for i, v in pairs( tab ) do
		lang[i] = v
	end
end

function ImproveAny:Lang_enUS()
	local tab = {
		["MMBTNLEFT"] = "Left Click => Options",
		["MMBTNRIGHT"] = "Right Click => Hide Minimap Button",

		["GENERAL"] = "General",
		["SHOWMINIMAPBUTTON"] = "Show Minimap Button",
		["UIFONT"] = "Ui Font",
		["WORLDTEXTSCALE"] = "World Text Scale",
		["MAXZOOM"] = "Max Zoom Distance",
		["HIDEPVPBADGE"] = "Hide PVP Badge Icons",
		["TOP_OFFSET"] = "Frame Anchor Spacing - Top",
		["LEFT_OFFSET"] = "Frame Anchor Spacing - Left",
		["PANEl_SPACING_X"] = "Frame Spacing",
		["BAGSAMESIZE"] = "All Bags Same Size",
		["BAGSIZE"] = "Bag size",
		
		["QUICKGAMEPLAY"] = "Quick Gameplay",
		["FASTLOOTING"] = "Fast Looting",

		["COMBAT"] = "Combat",
		["COMBATTEXTICONS"] = "CombatText Icons",
		["COMBATTEXTX"] = "CombatText Position X",
		["COMBATTEXTY"] = "CombatText Position Y",

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
		["IAILVLBAR"] = "Itemlevel Bar",
		["SKILLBARS"] = "Skillbars (Professions, Weaponskills)",
		["CASTBAR"] = "Castbar",
		["DURABILITY"] = "Durability (Shows ItemLevel, Repaircosts)",
		["MICROMENUCOLORED"] = "Micro Menu Colored",
		["SHOWDURABILITYUNDER"] = "Show Durability, when under:",
		["BAGS"] = "Show Freespace for each Bag",
		["WORLDMAP"] = "WorldMap Zoom with Mousewheel",
		["BAGMODE"] = "Bag Mode",
		["STATUSBARWIDTH"] = "Status Bar Width (XPbar, Reputationbar)",
		["UIFONTINDEX"] = "Font",
		["BAGMODEINDEX"] = "Bag mode",

		["TOOLTIPSELLPRICE"] = "Tooltip - Sellprice",
		["TOOLTIPEXPANSION"] = "Tooltip - Game-Expansion",

		["ADDEDIN"] = "Added in:",
		["EXPANSION"] = "%s%s",

		["LFGSHOWLANGUAGEFLAG"] = "LFG - Show Language Flag",
		["LFGSHOWCLASSICON"] = "LFG - Show Class Icon",
		["LFGSHOWOVERALLSCORE"] = "LFG - Show Overall Score",
		["LFGSHOWDUNGEONSCORE"] = "LFG - Show Dungeon Score",
		["LFGSHOWDUNGEONKEY"] = "LFG - Show Dungeon Key",

		["HIDEEXTRAACTIONBUTTONARTWORK"] = "Hide Extra Action Button Artwork",

		["IAPingFrame"] = "Ping Bar",

		["COORDSP"] = "Coords (Player) (WorldMap)",
		["COORDSC"] = "Coords (Cursor) (WorldMap)",
		["COORDSFONTSIZE"] = "Coords Fontsize",
		["IACoordsFrame"] = "Coords Frame",
	}

	ImproveAny:UpdateLanguageTab( tab )
end
