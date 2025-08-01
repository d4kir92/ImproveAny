-- deDE German Deutsch
local _, ImproveAny = ...
function ImproveAny:Lang_deDE()
	local tab = {
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
		["COMBATTEXTICONS"] = "Kampftext",
		["COMBATTEXTPOSITION"] = "Kampftext Position",
		["COMBATTEXTX"] = "Kampftext Position X",
		["COMBATTEXTY"] = "Kampftext Position Y",
		["CHAT"] = "Chat",
		["CHATSHORTCHANNELS"] = "Kurze Chat-Kanäle",
		["CHATITEMICONS"] = "Gegenstandssymbole",
		["CHATCLASSICONS"] = "Klassensymbole",
		["CHATRACEICONS"] = "Völker/KörperTyp Symbole",
		["CHATLEVELS"] = "Spieler-Stufen",
		["CHATCLASSCOLORS"] = "Klassenfarben",
		["MINIMAP"] = "Minimap",
		["MINIMAPHIDEBORDER"] = "Rand der Minimap ausblenden",
		["MINIMAPHIDEZOOMBUTTONS"] = "Minimap-Zoom-Schaltflächen ausblenden",
		["MINIMAPSCROLLZOOM"] = "Minimap-Zoom mit Mausrad",
		["MINIMAPSCROLLZOOM"] = "Minimap-Zoom mit Mausrad",
		["MINIMAPSHAPESQUARE"] = "Quadratische Minimap",
		["MINIMAPMINIMAPBUTTONSMOVABLE"] = "Minimap-Knöpfe verschiebbar machen",
		["ITEMLEVEL"] = "ItemLevel",
		["ITEMLEVELNUMBER"] = "ItemLevel-Nummer",
		["ITEMLEVELBORDER"] = "ItemLevel Umrandung",
		["XPBAR"] = "XPBar",
		["XPNUMBERLEVEL"] = "Charakterstufe Nummer",
		["XPPERCENTLEVEL"] = "Charakterstufe Prozent",
		["XPNUMBER"] = "XP Nummer",
		["XPPERCENT"] = "XP Prozent",
		["XPNUMBERQUESTCOMPLETE"] = "Fertige-Quests-XP Nummer",
		["XPPERCENTQUESTCOMPLETE"] = "Fertige-Quests-XP Prozent",
		["XPNUMBERKILLSTOLEVELUP"] = "Tötungen zum Aufstieg (Level Up) Nummer",
		["XPPERCENTKILLSTOLEVELUP"] = "Tötungen zum Aufstieg (Level Up) Prozent",
		["XPNUMBERMISSING"] = "Fehlende XP Nummer",
		["XPPERCENTMISSING"] = "Fehlende XP Prozent",
		["XPNUMBEREXHAUSTION"] = "XP-Erschöpfung Nummer",
		["XPPERCENTEXHAUSTION"] = "XP-Erschöpfung Prozent",
		["XPHIDEUNKNOWNVALUES"] = "Verstecke unbekannte XP Zahlen",
		["XPHIDEARTWORK"] = "XP-Leiste Kunstwerk ausblenden",
		["XPBARTEXTSHOWINVERTED"] = "Ein-/Ausblenden des XPBar-Textes invertieren",
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
		["MONEYBARPERHOUR"] = "Geldleiste pro Stunde",
		["TOKENBAR"] = "Wertmarkenleiste",
		["IAILVLBAR"] = "Gegenstandsstufeleiste (Itemlevel)",
		["SKILLBARS"] = "Skillbars (Berufe, Waffenfertigkeiten)",
		["CASTBAR"] = "Zauberleiste (Castbar)",
		["DURABILITY"] = "Haltbarkeit (Zeigt ItemLevel, Reparaturkosten)",
		["MICROMENUCOLORED"] = "Mikro Menü eingefärbt",
		["SHOWDURABILITYUNDER"] = "Zeige Haltbarkeit, wenn unter",
		["FREESPACEBAGS"] = "Freiraum für jede Tasche anzeigen",
		["WORLDMAP"] = "Weltkarte",
		["WORLDMAPZOOM"] = "Weltkarten-Zoom mit Mausrad (mit erhöhtem Zoom)",
		["BAGMODE"] = "Taschen Modus",
		["STATUSBARWIDTH"] = "Statusleiste weite (XPleiste, Rufleiste)",
		["UIFONTINDEX"] = "Schriftart",
		["BAGMODEINDEX"] = "Taschen Modus",
		["TOOLTIPSELLPRICE"] = "Tooltip - Verkaufspreis",
		["TOOLTIPEXPANSION"] = "Tooltip - Spiel-Erweiterung",
		["ADDEDIN"] = "Hinzugefügt in:",
		["EXPANSION"] = "%s%s",
		["LFGSHOWLANGUAGEFLAG"] = "LFG - Sprachflaggen anzeigen",
		["LFGSHOWCLASSICON"] = "LFG - Klassensymbole anzeigen",
		["LFGSHOWOVERALLSCORE"] = "LFG - Gesamtwertung anzeigen",
		["LFGSHOWDUNGEONSCORE"] = "LFG - Dungeonwertung anzeigen",
		["LFGSHOWDUNGEONKEY"] = "LFG - Dungeonstein anzeigen",
		["HIDEEXTRAACTIONBUTTONARTWORK"] = "Extra-Aktionknopf Kunst ausblenden",
		["IAPingFrame"] = "Ping Leiste",
		["WORLDMAPCOORDSP"] = "Koordinaten (Spieler) (Weltkarte)",
		["WORLDMAPCOORDSC"] = "Koordinaten (Zeiger) (Weltkarte)",
		["COORDSFONTSIZE"] = "Koordinatenschriftgröße",
		["IACoordsFrame"] = "Koordinatenfenster",
		["RIGHTCLICKSELFCAST"] = "Rechtsklick für Selbstzauber",
		["BLOCKWORDS"] = "Blockwörter",
		["FRAMES"] = "Fenster",
		["WIDEFRAMES"] = "Weite Fenster",
		["ITEMLEVELSYSTEM"] = "ItemLevel System",
		["ITEMLEVELSYSTEMSIDEWAYS"] = "ItemLevel System (Seitlich anzeigen)",
		["AUTOACCEPTQUESTS"] = "Automatisch Quests annehmen",
		["AUTOCHECKINQUESTS"] = "Automatisch Quests abgeben",
		["COMBINEMMBTNS"] = "Minimap Knöpfe zusammenfassen",
		["IMPROVEBAGS"] = "Taschen verbessern (Suche/Sortieren)",
		["IMPROVETRADESKILLFRAME"] = "Berufsfenster verbessern (Material vorhanden, Suche)",
		["CHARACTERFRAMEAUTOEXPAND"] = "Charakterfenster automatisch erweitern",
		["FRAMEANCHOR"] = "Fenster Anker",
		["SHOWVAULTMMBTN"] = "Große Schatzkammer an der Minimap anzeigen",
		["AUTOSELLJUNK"] = "Automatisch Müll verkaufen",
		["AUTOREPAIR"] = "Automatisch reparieren",
		["NEW"] = "NEU",
	}

	ImproveAny:UpdateLanguageTab(tab)
end
