local _, ImproveAny = ...
local font = "Interface\\AddOns\\ImproveAny\\media\\Prototype.ttf"
local IAOldFonts = {}
local BlizDefaultFonts = {"STANDARD_TEXT_FONT", "UNIT_NAME_FONT", "DAMAGE_TEXT_FONT", "NAMEPLATE_FONT", "NAMEPLATE_SPELLCAST_FONT"}
local BlizFontObjects = {"SystemFont_NamePlateCastBar", "SystemFont_NamePlateFixed", "SystemFont_LargeNamePlateFixed", "SystemFont_World", "SystemFont_World_ThickOutline", "SystemFont_Outline_Small", "SystemFont_Outline", "SystemFont_InverseShadow_Small", "SystemFont_Med2", "SystemFont_Med3", "SystemFont_Shadow_Med3", "SystemFont_Huge1", "SystemFont_Huge1_Outline", "SystemFont_OutlineThick_Huge2", "SystemFont_OutlineThick_Huge4", "SystemFont_OutlineThick_WTF", "NumberFont_GameNormal", "NumberFont_Shadow_Small", "NumberFont_OutlineThick_Mono_Small", "NumberFont_Shadow_Med", "NumberFont_Normal_Med", "NumberFont_Outline_Med", "NumberFont_Outline_Large", "NumberFont_Outline_Huge", "Fancy22Font", "QuestFont_Huge", "QuestFont_Outline_Huge", "QuestFont_Super_Huge", "QuestFont_Super_Huge_Outline", "SplashHeaderFont", "Game11Font", "Game12Font", "Game13Font", "Game13FontShadow", "Game15Font", "Game18Font", "Game20Font", "Game24Font", "Game27Font", "Game30Font", "Game32Font", "Game36Font", "Game48Font", "Game48FontShadow", "Game60Font", "Game72Font", "Game11Font_o1", "Game12Font_o1", "Game13Font_o1", "Game15Font_o1", "QuestFont_Enormous", "DestinyFontLarge", "CoreAbilityFont", "DestinyFontHuge", "QuestFont_Shadow_Small", "MailFont_Large", "SpellFont_Small", "InvoiceFont_Med", "InvoiceFont_Small", "Tooltip_Med", "Tooltip_Small", "AchievementFont_Small", "ReputationDetailFont", "FriendsFont_Normal", "FriendsFont_Small", "FriendsFont_Large", "FriendsFont_UserText", "GameFont_Gigantic", "ChatBubbleFont", "Fancy16Font", "Fancy18Font", "Fancy20Font", "Fancy24Font", "Fancy27Font", "Fancy30Font", "Fancy32Font", "Fancy48Font", "SystemFont_NamePlate", "SystemFont_LargeNamePlate", "GameFontNormal", "SystemFont_Tiny2", "SystemFont_Tiny", "SystemFont_Shadow_Small", "SystemFont_Small", "SystemFont_Small2", "SystemFont_Shadow_Small2", "SystemFont_Shadow_Med1_Outline", "SystemFont_Shadow_Med1", "QuestFont_Large", "SystemFont_Large", "SystemFont_Shadow_Large_Outline", "SystemFont_Shadow_Med2", "SystemFont_Shadow_Large", "SystemFont_Shadow_Large2", "SystemFont_Shadow_Huge1", "SystemFont_Huge2", "SystemFont_Shadow_Huge2", "SystemFont_Shadow_Huge3", "SystemFont_Shadow_Outline_Huge3", "SystemFont_Shadow_Outline_Huge2", "SystemFont_Med1", "SystemFont_WTF2", "SystemFont_Outline_WTF2", "GameTooltipHeader", "System_IME", "CombatTextFont", "DamageNumberFont", "WorldFont",}
local IAFONTS = {"Default", "Prototype"}
function ImproveAny:Fonts()
	local index = ImproveAny:IAGV("UIFONTINDEX", 1)
	local val = IAFONTS[index]
	ImproveAny:IASV("fontName", val)
	local useDefault = ImproveAny:IAGV("fontName", "Default") == "Default"
	for i, fontName in ipairs(BlizDefaultFonts) do
		if IAOldFonts[fontName] == nil then IAOldFonts[fontName] = _G[fontName] end
		if useDefault then
			_G[fontName] = IAOldFonts[fontName]
		else
			_G[fontName] = font
		end
	end

	local ForcedFontSize = {
		["SystemFont_NamePlateCastBar"] = 10,
		["SystemFont_NamePlateFixed"] = 14,
		["SystemFont_LargeNamePlateFixed"] = 20,
		["SystemFont_World"] = 64,
		["SystemFont_World_ThickOutline"] = 64
	}

	for i, fontName in ipairs(BlizFontObjects) do
		local fontObject = _G[fontName]
		if fontObject and fontObject.GetFont then
			local oldFont, oldSize, oldStyle = fontObject:GetFont()
			if IAOldFonts[i] == nil then IAOldFonts[i] = oldFont end
			oldSize = ForcedFontSize[fontName] or oldSize
			if useDefault then
				fontObject:SetFont(IAOldFonts[i], oldSize, oldStyle)
			else
				fontObject:SetFont(font, oldSize, oldStyle)
			end
		end
	end

	if ImproveAny.UpdateNameplateFonts then ImproveAny:UpdateNameplateFonts() end
end

local fontFrame = CreateFrame("Frame", "IAFonts")
ImproveAny:RegisterEvent(fontFrame, "ADDON_LOADED")
ImproveAny:RegisterEvent(fontFrame, "PLAYER_ENTERING_WORLD")
ImproveAny:OnEvent(fontFrame, function(sel, event, arg1)
	if event == "ADDON_LOADED" and arg1 ~= "ImproveAny" then return end
	if ImproveAny:IAGV("fontName", "Default") ~= "Default" then ImproveAny:Fonts() end
end, "Fonts")

local IABAGMODES = {"RETAIL", "CLASSIC", "ONEBAG", "DISABLED"}
function ImproveAny:UpdateBagMode()
	local index = ImproveAny:IAGV("BAGMODEINDEX", 1)
	local val = IABAGMODES[index]
	ImproveAny:IASV("BAGMODE", val)
end

function ImproveAny:GetBagMode()
	if ImproveAny:IsAddOnLoaded("DragonflightUI", "BagMode") then return "DISABLED" end
	return ImproveAny:IAGV("BAGMODE", "RETAIL")
end

local UI = ImproveAny.UI
local function EnableSave()
	if IASettings and IASettings.save then IASettings.save:Enable() end
end

local function GetCollapsed(key)
	IATAB = IATAB or {}
	IATAB["COLLAPSED"] = IATAB["COLLAPSED"] or {}
	return IATAB["COLLAPSED"][key]
end

local function SetCollapsed(key, collapsed)
	IATAB = IATAB or {}
	IATAB["COLLAPSED"] = IATAB["COLLAPSED"] or {}
	IATAB["COLLAPSED"][key] = collapsed
end

local function Call(name)
	return function() if ImproveAny[name] then ImproveAny[name](ImproveAny) end end
end

local function AddCategory(key, level)
	return IASettings:AddCategory({
		["label"] = "LID_" .. key,
		["key"] = key,
		["search"] = key,
		["level"] = level
	})
end

local function AddCheckBox(key, val, func)
	if val == nil then val = true end
	return IASettings:AddCheckbox({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = ImproveAny:IsEnabled(key, val),
		["func"] = function(value)
			ImproveAny:SetEnabled(key, value)
			if func then func() end
			EnableSave()
		end
	})
end

local function AddSlider(key, val, func, vmin, vmax, step, decimals, extra)
	local search = key
	if extra then search = key .. " " .. extra end
	return IASettings:AddSlider({
		["label"] = "LID_" .. key,
		["search"] = search,
		["value"] = ImproveAny:IAGV(key, val),
		["min"] = vmin,
		["max"] = vmax,
		["step"] = step,
		["decimals"] = decimals,
		["func"] = function(value)
			if value == ImproveAny:IAGV(key) then return end
			ImproveAny:IASV(key, value)
			if func then func() end
			EnableSave()
		end
	})
end

local function AddDropdown(key, val, func, tab)
	local cur = ImproveAny:IAGV(key, val)
	return IASettings:AddDropdown({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = cur,
		["choices"] = UI:ChoicesFromMap(tab, cur),
		["func"] = function(value)
			if value == ImproveAny:IAGV(key) then return end
			ImproveAny:IASV(key, value)
			if func then func() end
			EnableSave()
		end
	})
end

local function AddEditBox(key, val, func)
	return IASettings:AddEditbox({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = ImproveAny:IAGV(key, val),
		["func"] = function(value, box)
			ImproveAny:IASV(key, value)
			if func then func(box) end
		end
	})
end

function ImproveAny:UpdateILVLIcons()
	ImproveAny:PDUpdateItemInfos()
	if ImproveAny.IFUpdateItemInfos then ImproveAny:IFUpdateItemInfos() end
	if ImproveAny.UpdateBagsIlvl then ImproveAny:UpdateBagsIlvl() end
end

local keys = {}
keys["TOP_OFFSET"] = true
keys["LEFT_OFFSET"] = true
keys["PANEl_SPACING_X"] = true
local iasetattribute = false
hooksecurefunc(UIParent, "SetAttribute", function(self, key, value)
	if keys[key] == nil then return end
	if iasetattribute then return end
	iasetattribute = true
	if key == "TOP_OFFSET" then
		local topOffset = ImproveAny:IAGV("TOP_OFFSET", 116)
		self:SetAttribute("TOP_OFFSET", -topOffset)
	elseif key == "LEFT_OFFSET" then
		local leftOffset = ImproveAny:IAGV("LEFT_OFFSET", 16)
		self:SetAttribute("LEFT_OFFSET", leftOffset)
	elseif key == "PANEl_SPACING_X" then
		local panelSpacingX = ImproveAny:IAGV("PANEl_SPACING_X", 32)
		self:SetAttribute("PANEl_SPACING_X", panelSpacingX)
	end

	iasetattribute = false
end)

function ImproveAny:UpdateUIParentAttribute()
	if not InCombatLockdown() then
		local topOffset = ImproveAny:IAGV("TOP_OFFSET", 116)
		local leftOffset = ImproveAny:IAGV("LEFT_OFFSET", 16)
		local panelSpacingX = ImproveAny:IAGV("PANEl_SPACING_X", 32)
		UIParent:SetAttribute("TOP_OFFSET", -topOffset)
		UIParent:SetAttribute("LEFT_OFFSET", leftOffset)
		UIParent:SetAttribute("PANEl_SPACING_X", panelSpacingX)
	end
end

function ImproveAny:UpdateStatusBar()
	if ImproveAny:IsEnabled("XPBAR", false) or ImproveAny:IsEnabled("REPBAR", false) then
		local w = ImproveAny:IAGV("STATUSBARWIDTH", 570)
		if StatusTrackingBarManager then
			StatusTrackingBarManager:SetWidth(w)
			if StatusTrackingBarManager.TopBarFrameTexture then StatusTrackingBarManager.TopBarFrameTexture:SetWidth(w + 5) end
			if StatusTrackingBarManager.BottomBarFrameTexture then StatusTrackingBarManager.BottomBarFrameTexture:SetWidth(w + 5) end
			ImproveAny:ForeachChildren(StatusTrackingBarManager, function(child, x)
				child:SetWidth(w)
				if child.OverlayFrame then child.OverlayFrame:SetWidth(w) end
				if child.StatusBar then child.StatusBar:SetWidth(w) end
			end, "UpdateStatusBar")
		end

		if MainStatusTrackingBarContainer then
			MainStatusTrackingBarContainer:SetWidth(w)
			ImproveAny:ForeachChildren(MainStatusTrackingBarContainer, function(child, x)
				child:SetWidth(w - 5)
				ImproveAny:ForeachChildren(child, function(va, id) if id ~= 3 then va:SetWidth(w - 5) end end, "MainStatusTrackingBarContainer 2")
			end, "MainStatusTrackingBarContainer 1")
		end

		if SecondaryStatusTrackingBarContainer then
			SecondaryStatusTrackingBarContainer:SetWidth(w)
			ImproveAny:ForeachChildren(SecondaryStatusTrackingBarContainer, function(child, x)
				child:SetWidth(w - 5)
				ImproveAny:ForeachChildren(child, function(va, id) if id ~= 3 then va:SetWidth(w - 5) end end, "SecondaryStatusTrackingBarContainer 2")
			end, "SecondaryStatusTrackingBarContainer 1")
		end
	end
end

function ImproveAny:ToggleSettings()
	ImproveAny:SetEnabled("SETTINGS", not ImproveAny:IsEnabled("SETTINGS", false))
	if ImproveAny:IsEnabled("SETTINGS", false) then
		IASettings:Show()
		ImproveAny:UpdateShowErrors()
	else
		IASettings:Hide()
		ImproveAny:UpdateShowErrors()
	end
end

local function IAReload()
	if C_UI then
		C_UI.Reload()
	else
		ReloadUi()
	end
end

local function BuildElementList()
	local isRetail = ImproveAny:GetWoWBuild() == "RETAIL"
	local isClassic = ImproveAny:GetWoWBuild() == "CLASSIC"
	local hasLFGList = C_LFGList ~= nil and C_LFGList.GetApplicantMemberInfo ~= nil
	local hasMythicScore = hasLFGList and C_LFGList.GetApplicantDungeonScoreForListing ~= nil and C_ChallengeMode ~= nil and C_ChallengeMode.GetDungeonScoreRarityColor ~= nil
	IASettings:SuspendLayout()
	AddCategory("GENERAL")
	AddCheckBox("SHOWMINIMAPBUTTON", not isRetail, Call("UpdateMinimapButton"))
	AddCategory("CONSOLEVARIABLES")
	AddSlider("MAXZOOM", ImproveAny:GetMaxZoom(), Call("UpdateMaxZoom"), 1, ImproveAny:GetMaxZoom(), 0.1, 1)
	AddCategory("QUICKGAMEPLAY")
	AddCheckBox("AUTOSELLJUNK", true)
	AddCheckBox("AUTOREPAIR", true)
	AddCheckBox("AUTOACCEPTQUESTS", false)
	AddCheckBox("AUTOCHECKINQUESTS", false)
	AddCheckBox("FASTLOOTING", false)
	if CharacterFrameExpandButton then AddCheckBox("CHARACTERFRAMEAUTOEXPAND", true) end
	AddCategory("CHAT")
	AddEditBox("BLOCKWORDS", "", function(eb)
		eb.lastchange = GetTime()
		ImproveAny:Debug("settings, lastchange")
		ImproveAny:After(1, function()
			if eb.lastchange < GetTime() - 0.9 then
				ImproveAny:IASV("BLOCKWORDS", eb:GetText())
				if eb:GetText() ~= "" then
					ImproveAny:MSG("|cFF00FF00" .. "BLOCKWORDS changed to: |r")
					for i, v in pairs({string.split(",", ImproveAny:IAGV("BLOCKWORDS"))}) do
						if strlen(v) < 3 then
							ImproveAny:MSG(" • |cFFFF0000" .. v .. " [TO SHORT!]")
						else
							ImproveAny:MSG(" • |cFF00FF00" .. v)
						end
					end
				else
					ImproveAny:MSG("|cFFFF0000" .. "BLOCKWORDS are disabled")
				end
			end
		end, "lastchange")
	end)

	if not isRetail then
		AddCategory("FRAMES")
		AddCheckBox("WIDEFRAMES", false)
		if isClassic then AddCheckBox("IMPROVETRADESKILLFRAME", true) end
	end

	if not isRetail then
		AddCategory("XPBAR")
		AddCheckBox("XPBAR", false)
		AddCheckBox("XPNUMBERLEVEL", false)
		AddCheckBox("XPPERCENTLEVEL", false)
		AddCheckBox("XPNUMBER", false)
		AddCheckBox("XPPERCENT", false)
		AddCheckBox("XPNUMBEREXHAUSTION", false)
		AddCheckBox("XPPERCENTEXHAUSTION", false)
		AddCheckBox("XPNUMBERMISSING", false)
		AddCheckBox("XPPERCENTMISSING", false)
		AddCheckBox("XPNUMBERQUESTCOMPLETE", false)
		AddCheckBox("XPPERCENTQUESTCOMPLETE", false)
		AddCheckBox("XPNUMBERKILLSTOLEVELUP", false)
		AddCheckBox("XPHIDEARTWORK", false)
		AddCheckBox("XPHIDEUNKNOWNVALUES", false)
		AddCheckBox("XPBARTEXTSHOWINVERTED", false)
		AddCategory("REPBAR")
		AddCheckBox("REPBAR", false)
		AddCheckBox("REPNUMBER", false)
		AddCheckBox("REPPERCENT", false)
		AddCheckBox("REPHIDEARTWORK", false)
	end

	AddCategory("USERINTERFACE")
	if StatusTrackingBarManager then AddSlider("STATUSBARWIDTH", 570, Call("UpdateStatusBar"), 100, 1920, 5, 0) end
	AddCheckBox("CASTBAR", false)
	if ExtraActionButton1 and ExtraActionButton1.style then AddCheckBox("HIDEEXTRAACTIONBUTTONARTWORK", false) end
	AddCategory("OVERALLUI", 2)
	AddDropdown("UIFONTINDEX", 1, Call("Fonts"), IAFONTS)
	AddSlider("WORLDTEXTSCALE", 1.0, Call("UpdateWorldTextScale"), 0.1, 2.0, 0.1, 1)
	AddCheckBox("HIDEPVPBADGE", false)
	AddCategory("FRAMEANCHOR", 3)
	AddSlider("TOP_OFFSET", 116, Call("UpdateUIParentAttribute"), 0, 1000, 5, 0, "FRAMEANCHOR")
	AddSlider("LEFT_OFFSET", 16, Call("UpdateUIParentAttribute"), 16, 1000, 5, 0, "FRAMEANCHOR")
	AddSlider("PANEl_SPACING_X", 32, Call("UpdateUIParentAttribute"), 10, 300, 1, 0, "FRAMEANCHOR")
	AddCategory("BAGS", 2)
	AddCheckBox("FREESPACEBAGS", false)
	AddCheckBox("BAGSAMESIZE", false)
	AddSlider("BAGSIZE", 30, function() BAGThink.UpdateItemInfos() end, 20, 80, 1, 0)
	if not ImproveAny:IsAddOnLoaded("DragonflightUI", "BAGMODEINDEX") then AddDropdown("BAGMODEINDEX", 1, Call("UpdateBagMode"), IABAGMODES) end
	AddCategory("MINIMAP", 2)
	AddCheckBox("MINIMAP", false, Call("UpdateMinimapSettings"))
	if not ImproveAny:IsAddOnLoaded("DragonflightUI", "MINIMAPHIDEBORDER") then AddCheckBox("MINIMAPHIDEBORDER", false, Call("UpdateMinimapSettings")) end
	AddCheckBox("MINIMAPHIDEZOOMBUTTONS", false, Call("UpdateMinimapSettings"))
	if not isRetail then AddCheckBox("MINIMAPSCROLLZOOM", false, Call("UpdateMinimapSettings")) end
	if not ImproveAny:IsAddOnLoaded("DragonflightUI", "MINIMAPSHAPESQUARE") then AddCheckBox("MINIMAPSHAPESQUARE", false, Call("UpdateMinimapSettings")) end
	AddCheckBox("MINIMAPMINIMAPBUTTONSMOVABLE", false, Call("UpdateMinimapSettings"))
	AddCheckBox("COMBINEMMBTNS", false, Call("UpdateMinimapSettings"))
	AddCategory("WORLDMAP", 2)
	AddCheckBox("WORLDMAP", false)
	if not isRetail then AddCheckBox("WORLDMAPZOOM", false) end
	AddCheckBox("WORLDMAPCOORDSP", false)
	AddCheckBox("WORLDMAPCOORDSC", false)
	AddSlider("COORDSFONTSIZE", 8, Call("UpdateCoordsFontSize"), 6, 20, 1, 0)
	AddCategory("TOOLTIP", 2)
	AddCheckBox("TOOLTIPSELLPRICE", false)
	if isRetail then AddCheckBox("TOOLTIPEXPANSION", false) end
	if hasLFGList then
		AddCategory("LOOKINGFORGROUP", 2)
		AddCheckBox("LFGSHOWLANGUAGEFLAG", false)
		AddCheckBox("LFGSHOWCLASSICON", false)
		if hasMythicScore then
			AddCheckBox("LFGSHOWOVERALLSCORE", false)
			AddCheckBox("LFGSHOWDUNGEONSCORE", false)
			AddCheckBox("LFGSHOWDUNGEONKEY", false)
		end
	end

	AddCategory("WIDGETS", 2)
	AddCheckBox("IAPingFrame", false)
	AddCheckBox("IAILVLBAR", false)
	AddCheckBox("IACoordsFrame", false)
	AddCategory("DURABILITYFRAME", 3)
	AddCheckBox("DURABILITY", false)
	AddSlider("SHOWDURABILITYUNDER", 100, nil, 5, 100, 5, 0)
	AddCategory("MONEYBAR", 3)
	AddCheckBox("MONEYBAR", false)
	AddCheckBox("MONEYBARPERHOUR", false)
	AddCategory("BADGES", 3)
	AddCheckBox("TOKENBAR", false)
	AddCheckBox("TOKENBARRESTORE", true)
	AddCategory("COMBAT", 2)
	AddCheckBox("COMBATTEXTICONS", false)
	AddCheckBox("COMBATTEXTPOSITION", false)
	AddSlider("COMBATTEXTX", 0, nil, -600, 600, 10, 0)
	AddSlider("COMBATTEXTY", 0, nil, -250, 250, 10, 0)
	AddCategory("EXTRAS")
	if not isRetail then AddCheckBox("SKILLBARS", false) end
	AddCheckBox("RIGHTCLICKSELFCAST", false)
	IASettings:ResumeLayout()
end

function ImproveAny:InitIASettings()
	ImproveAny:SetVersion(136033, "1.0.1")
	local p1, _, p3, p4, p5 = ImproveAny:GetElePoint("IASettings")
	local pTab = {"CENTER", UIParent, "CENTER", 0, 0}
	if p1 and p3 then pTab = {p1, UIParent, p3, p4, p5} end
	IASettings = ImproveAny:CreateUIWindow({
		["name"] = "IASettings",
		["title"] = format("|T136033:16:16:0:0|t ImproveAny v%s", ImproveAny:GetVersion()),
		["pTab"] = pTab,
		["width"] = ImproveAny:IAGV("SETTINGSWIDTH", 550),
		["height"] = ImproveAny:IAGV("SETTINGSHEIGHT", 500),
		["minWidth"] = 550,
		["minHeight"] = 300,
		["onResize"] = function(width, height)
			ImproveAny:IASV("SETTINGSWIDTH", width)
			ImproveAny:IASV("SETTINGSHEIGHT", height)
		end,
		["onMove"] = function(mp1, mp3, mp4, mp5) ImproveAny:SetElePoint("IASettings", mp1, nil, mp3, mp4, mp5) end,
		["getCollapsed"] = function(key) return GetCollapsed(key) end,
		["setCollapsed"] = function(key, collapsed) SetCollapsed(key, collapsed) end,
		["onClose"] = function() ImproveAny:ToggleSettings() end
	})

	IASettings:SetFrameLevel(999)
	IASettings.Search = IASettings:AddSearch()
	IASettings:AddFooter({
		["height"] = 24
	})

	IASettings.save = ImproveAny:CreateButton("IASettings_save", IASettings.footer)
	IASettings.save:SetSize(112, 24)
	IASettings.save:SetPoint("LEFT", IASettings.footer, "LEFT", 0, 0)
	IASettings.save:SetText(SAVE)
	IASettings.save:SetScript("OnClick", IAReload)
	IASettings.save:Disable()
	IASettings.reload = ImproveAny:CreateButton("IASettings_reload", IASettings.footer)
	IASettings.reload:SetSize(112, 24)
	IASettings.reload:SetPoint("LEFT", IASettings.save, "RIGHT", 4, 0)
	IASettings.reload:SetText(RELOADUI)
	IASettings.reload:SetScript("OnClick", IAReload)
	IASettings.showerrors = ImproveAny:CreateButton("IASettings_showerrors", IASettings.footer)
	IASettings.showerrors:SetSize(112, 24)
	IASettings.showerrors:SetPoint("LEFT", IASettings.reload, "RIGHT", 4, 0)
	IASettings.showerrors:SetText("Show Errors")
	IASettings.showerrors:SetScript("OnClick", function()
		if GetCVar("ScriptErrors") == "0" then
			SetCVar("ScriptErrors", 1)
			IAReload()
		end

		ImproveAny:UpdateShowErrors()
	end)

	IASettings.DISCORD = CreateFrame("EditBox", "IASettings_DISCORD", IASettings.footer, "InputBoxTemplate")
	IASettings.DISCORD:SetSize(160, 24)
	IASettings.DISCORD:SetPoint("RIGHT", IASettings.footer, "RIGHT", 0, 0)
	IASettings.DISCORD:SetAutoFocus(false)
	IASettings.DISCORD:SetText("discord.gg/AWcDfvcYCN")
	function ImproveAny:UpdateShowErrors()
		if GetCVar("ScriptErrors") == "0" then
			IASettings.showerrors:Show()
		else
			IASettings.showerrors:Hide()
		end
	end

	ImproveAny:UpdateShowErrors()
	BuildElementList()
	if ImproveAny:IsEnabled("SETTINGS", false) then
		IASettings:Show()
	else
		IASettings:Hide()
	end
end

function ImproveAny:CheckBlockedWords()
	if IATAB and ImproveAny:IAGV("BLOCKWORDS") and ImproveAny:IAGV("BLOCKWORDS") ~= "" and ImproveAny:IAGV("BLOCKWORDS") ~= " " then
		for i, v in pairs({string.split(",", ImproveAny:IAGV("BLOCKWORDS"))}) do
			if strlen(v) < 3 then ImproveAny:MSG("|cFFFF0000" .. "Blockword \"" .. v .. "\" is to short!") end
		end
	end
end

ImproveAny:After(2, ImproveAny.CheckBlockedWords, "CheckBlockedWords")
function ImproveAny:RemoveBadWords(self, msg, author, ...)
	msg = strlower(msg)
	if ImproveAny:IAGV("BLOCKWORDS") and ImproveAny:IAGV("BLOCKWORDS") ~= "" and ImproveAny:IAGV("BLOCKWORDS") ~= " " then
		for i, v in pairs({string.split(",", ImproveAny:IAGV("BLOCKWORDS"))}) do
			if v ~= "" and msg:find(strlower(v)) then return true end
		end
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", ImproveAny.RemoveBadWords)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", ImproveAny.RemoveBadWords)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", ImproveAny.RemoveBadWords)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", ImproveAny.RemoveBadWords)
