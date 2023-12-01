-- enUS English
local _, ImproveAny = ...
function ImproveAny:UpdateLanguageTab(tab)
	local lang = ImproveAny:GetLangTab()
	for i, v in pairs(tab) do
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
		["COMBATTEXTPOSITION"] = "CombatText Position",
		["COMBATTEXTX"] = "CombatText Position X",
		["COMBATTEXTY"] = "CombatText Position Y",
		["CHAT"] = "Chat",
		["CHATSHORTCHANNELS"] = "Short Chat Channels",
		["CHATITEMICONS"] = "Item Icons",
		["CHATCLASSICONS"] = "Class Icons",
		["CHATRACEICONS"] = "Race/BodyType Icons",
		["CHATLEVELS"] = "Player Levels",
		["CHATCLASSCOLORS"] = "Class Colors",
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
		["XPNUMBERLEVEL"] = "Character Level Number",
		["XPPERCENTLEVEL"] = "Character Level Percent",
		["XPNUMBER"] = "XP Number",
		["XPPERCENT"] = "XP Percent",
		["XPNUMBERQUESTCOMPLETE"] = "Quest-Completed-XP Number",
		["XPPERCENTQUESTCOMPLETE"] = "Quest-Completed-XP Percent",
		["XPNUMBERKILLSTOLEVELUP"] = "Kills To Level Up Number",
		["XPPERCENTKILLSTOLEVELUP"] = "Kills To Level Up Percent",
		["XPNUMBERMISSING"] = "Missing XP Number",
		["XPPERCENTMISSING"] = "Missing XP Percent",
		["XPNUMBEREXHAUSTION"] = "XP Exhaustion Number",
		["XPPERCENTEXHAUSTION"] = "XP Exhaustion Percent",
		["XPHIDEUNKNOWNVALUES"] = "Hide unknown XP values",
		["XPHIDEARTWORK"] = "XPBar Hide Artwork",
		["XPBARTEXTSHOWINVERTED"] = "Invert show/hide XPBar text",
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
		["MONEYBARPERHOUR"] = "Money Bar per Hour",
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
		["RIGHTCLICKSELFCAST"] = "Right click to selfcast",
		["BLOCKWORDS"] = "Blockwords",
		["FRAMES"] = "Windows (Frames)",
		["WIDEFRAMES"] = "Wide Windows (Wide Frames)",
		["ITEMLEVELSYSTEM"] = "Item Level System",
		["AUTOACCEPTQUESTS"] = "Auto Accept Quests",
		["AUTOCHECKINQUESTS"] = "Autom Submit Quests",
		["COMBINEMMBTNS"] = "Combine Minimap Buttons",
	}

	ImproveAny:UpdateLanguageTab(tab)
end