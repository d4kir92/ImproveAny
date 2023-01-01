-- deDE German Deutsch

local AddOnName, ImproveAny = ...

function ImproveAny:Lang_deDE()
	local tab = {
		["MMBTNLEFT"] = "Linksklick => Optionen",
		["MMBTNRIGHT"] = "Rechtsklick => Minimapknopf verstecken",

		["GENERAL"] = "Allgemein",
		["SHOWMINIMAPBUTTON"] = "Minimapknopf anzeigen",
		["UIFONT"] = "Ui Schriftart",
		["WORLDTEXTSCALE"] = "Welttext Skala",
		["MAXZOOM"] = "Maximale Zoomstufe",
		["HIDEPVPBADGE"] = "PVP-Abzeichen-Symbole ausblenden",
		["TOP_OFFSET"] = "Fenster Anker Abstand - Oben",
		["LEFT_OFFSET"] = "Fenster Anker Abstand - Links",
		["PANEl_SPACING_X"] = "Fenster Abstand",
		["BAGSAMESIZE"] = "Alle Taschen gleich groß",
		["BAGSIZE"] = "Taschengröße",
		
		["QUICKGAMEPLAY"] = "Schnelles Gameplay",
		["FASTLOOTING"] = "Schnelles Plündern",

		["COMBAT"] = "Kampf",
		["COMBATTEXTICONS"] = "Kampftext Symbole",

		["CHAT"] = "Chat",
		["SHORTCHANNELS"] = "Kurze Chat-Kanäle",
		["ITEMICONS"] = "Gegenstandssymbole",
		["CLASSICONS"] = "Klassensymbole", ["CLASSICONS"] = "Klassensymbole",
		["RACEICONS"] = "Völker/KörperTyp Symbole",
		["CHATLEVELS"] = "Spieler-Stufen",

		["MINIMAP"] = "Minimap",
		["MINIMAPHIDEBORDER"] = "Rand der Minimap ausblenden",
		["MINIMAPHIDEZOOMBUTTONS"] = "Minimap-Zoom-Schaltflächen ausblenden",
		["MINIMAPSCROLLZOOM"] = "Minimap-Zoom mit Mausrad", ["MINIMAPSCROLLZOOM"] = "Minimap-Zoom mit Mausrad",
		["MINIMAPSHAPESQUARE"] = "Quadratische Minimap",
		["MINIMAPMINIMAPBUTTONSMOVABLE"] = "Minimap-Knöpfe verschiebbar machen",

		["ITEMLEVEL"] = "Element-Ebene",
		["ITEMLEVELNUMBER"] = "ItemLevel-Nummer",
		["ITEMLEVELBORDER"] = "ItemLevel Umrandung",

		["XPBAR"] = "XPBar",
		["XPLEVEL"] = "Charakterstufe",
		["XPNUMBER"] = "XP Nummer",
		["XPPERCENT"] = "XP-Prozent",
		["XPMISSING"] = "Fehlende XP",
		["XPEXHAUSTION"] = "XP-Erschöpfung",
		["XPXPPERHOUR"] = "XP/Stunde",
		["XPHIDEARTWORK"] = "XP-Leiste Kunstwerk ausblenden",

		["REPBAR"] = "Rufleiste",
		["REPNUMBER"] = "Ruf Nummer",
		["REPPERCENT"] = "Ruf Prozent",
		["REPHIDEARTWORK"] = "Rufleiste - Kunstwerk ausblenden",

		["UNITFRAMES"] = "Einheitenfenster (UnitFrames)",
		["RFHIDEBUFFIDSINCOMBAT"] = "BuffIds für RaidFrame verstecken (Im Kampf)",
		["RFHIDEBUFFIDSINNOTCOMBAT"] = "BuffIds für RaidFrame verstecken (Außerhalb vom Kampf)",
		["RAIDFRAMEMOREBUFFS"] = "RaidFrame mit mehr Buffs",
		["BUFFSCALE"] = "Buff-Skalierung (Buff-Scale)",
		["DEBUFFSCALE"] = "Debuff-Skalierung (Debuff-Scale)",
		["OVERWRITERAIDFRAMESIZE"] = "Raidfenster-Größe überschreiben",
		["RAIDFRAMEW"] = "Raidfenster Weite",
		["RAIDFRAMEH"] = "Raidfenster Höhe",

		["EXTRAS"] = "Extras",
		["MONEYBAR"] = "Geldleiste",
		["TOKENBAR"] = "Wertmarkenleiste",
		["IAILVLBAR"] = "Gegenstandsstufeleiste (Itemlevel)",
		["SKILLBARS"] = "Skillbars (Berufe, Waffenfertigkeiten)",
		["CASTBAR"] = "Zauberleiste (Castbar)",
		["DURABILITY"] = "Haltbarkeit (Zeigt ItemLevel, Reparaturkosten)",
		["MICROMENUCOLORED"] = "Mikro Menü eingefärbt",
		["SHOWDURABILITYUNDER"] = "Zeige Haltbarkeit, wenn unter",
		["BAGS"] = "Freiraum für jede Tasche anzeigen",
		["WORLDMAP"] = "Weltkarten-Zoom mit Mausrad",
		["BAGMODE"] = "Taschen Modus",
		["STATUSBARWIDTH"] = "Statusleiste weite (XPleiste, Rufleiste)",
		["UIFONTINDEX"] = "Schriftart",
		["BAGMODEINDEX"] = "Taschen Modus",

		["TOOLTIPSELLPRICE"] = "Tooltip - Verkaufspreis",
		["TOOLTIPEXPANSION"] = "Tooltip - Spiel-Erweiterung",

		["ADDEDIN"] = "Hinzugefügt in:",
		["EXPANSION"] = "%s%s",
	}

	ImproveAny:UpdateLanguageTab( tab )
end
