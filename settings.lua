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

local defaults = {}
local dependents = {}
local checkboxes = {}
local function IsKeyEnabled(key)
	return ImproveAny:IsEnabled(key, defaults[key] == true)
end

local function IsRequirementMet(req)
	if type(req) ~= "table" then return IsKeyEnabled(req) end
	for _, key in ipairs(req) do
		if IsKeyEnabled(key) then return true end
	end
	return false
end

local function SetControlEnabled(control, enabled)
	if control.slider then
		control.slider:SetEnabled(enabled)
	else
		control:SetEnabled(enabled)
	end

	local holder = control.holder or control
	holder:SetAlpha(enabled and 1 or 0.5)
end

local function UpdateDependents()
	for _, dep in ipairs(dependents) do
		local enabled = true
		for _, req in ipairs(dep.requires) do
			if not IsRequirementMet(req) then
				enabled = false
				break
			end
		end

		SetControlEnabled(dep.control, enabled)
	end
end

local function Requires(control, ...)
	if control == nil then return end
	local requires = {...}
	control.uiElement.depth = control.uiElement.depth + #requires
	for _, req in ipairs(requires) do
		for _, key in ipairs(type(req) == "table" and req or {req}) do
			if checkboxes[key] then IASettings:AddRequirement(control, checkboxes[key]) end
		end
	end

	tinsert(dependents, {
		["control"] = control,
		["requires"] = requires
	})
	return control
end

local function AddCheckBox(key, val, func)
	if val == nil then val = true end
	defaults[key] = val
	checkboxes[key] = IASettings:AddCheckbox({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = ImproveAny:IsEnabled(key, val),
		["func"] = function(value)
			ImproveAny:SetEnabled(key, value)
			if func then func() end
			UpdateDependents()
			EnableSave()
		end
	})
	return checkboxes[key]
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

local statusBarOrgWidths = {}
local function SetStatusBarWidth(frame, w)
	if frame == nil or frame.SetWidth == nil then return end
	if statusBarOrgWidths[frame] == nil then
		if w == nil then return end
		statusBarOrgWidths[frame] = frame:GetWidth()
	end

	frame:SetWidth(w or statusBarOrgWidths[frame])
end

local function UpdateTrackingContainerWidth(container, w)
	SetStatusBarWidth(container, w)
	local width = container:GetWidth()
	local adjustment = STATUS_BAR_SIZE_ADJUSTMENT or 6
	for _, bar in pairs(container.bars or {}) do
		SetStatusBarWidth(bar, w and (width - adjustment))
		SetStatusBarWidth(bar.StatusBar, w and (width - adjustment))
		if bar.ExhaustionTick and bar:IsShown() then bar.ExhaustionTick:UpdateTickPosition() end
	end

	if container.HorizontalDividersPool and container.GetExpectedSegments then
		local numSegments = container:GetExpectedSegments()
		local i = 0
		for divider in container.HorizontalDividersPool:EnumerateActive() do
			i = i + 1
			divider:ClearAllPoints()
			divider:SetPoint("LEFT", container, "LEFT", width / numSegments * i, 0)
		end
	end
end

local statusBarCombatFrame
function ImproveAny:UpdateStatusBar()
	if StatusTrackingBarManager == nil then return end
	if InCombatLockdown() then
		if statusBarCombatFrame == nil then
			statusBarCombatFrame = CreateFrame("Frame")
			statusBarCombatFrame:SetScript("OnEvent", function(sel)
				sel:UnregisterEvent("PLAYER_REGEN_ENABLED")
				ImproveAny:UpdateStatusBar()
			end)
		end

		statusBarCombatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	local w
	if ImproveAny:IsEnabled("STATUSBARWIDTHENABLED", ImproveAny:IsEnabled("XPBAR", false) or ImproveAny:IsEnabled("REPBAR", false)) then w = ImproveAny:IAGV("STATUSBARWIDTH", 570) end
	SetStatusBarWidth(StatusTrackingBarManager, w)
	if StatusTrackingBarManager.barContainers then
		for _, container in ipairs(StatusTrackingBarManager.barContainers) do
			UpdateTrackingContainerWidth(container, w)
		end
		return
	end

	SetStatusBarWidth(StatusTrackingBarManager.TopBarFrameTexture, w and (w + 5))
	SetStatusBarWidth(StatusTrackingBarManager.BottomBarFrameTexture, w and (w + 5))
	ImproveAny:ForeachChildren(StatusTrackingBarManager, function(child, x)
		SetStatusBarWidth(child, w)
		SetStatusBarWidth(child.OverlayFrame, w)
		SetStatusBarWidth(child.StatusBar, w)
	end, "UpdateStatusBar")
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

local function BuildElementList()
	local isRetail = ImproveAny:GetWoWBuild() == "RETAIL"
	local isClassic = ImproveAny:GetWoWBuild() == "CLASSIC"
	IASettings:SuspendLayout()
	AddCategory("GENERAL")
	AddCheckBox("SHOWMINIMAPBUTTON", not isRetail, Call("UpdateMinimapButton"))
	AddCategory("CONSOLEVARIABLES")
	AddSlider("MAXZOOM", ImproveAny:GetMaxZoom(), Call("UpdateMaxZoom"), 1, ImproveAny:GetMaxZoom(), 0.1, 1)
	AddCheckBox("RIGHTCLICKSELFCAST", false)
	AddCategory("QUICKGAMEPLAY")
	AddCheckBox("AUTOSELLJUNK", true)
	AddCheckBox("AUTOREPAIR", true)
	AddCheckBox("AUTOACCEPTQUESTS", false)
	AddCheckBox("AUTOCHECKINQUESTS", false)
	AddCheckBox("FASTLOOTING", false)
	if CharacterFrameExpandButton then AddCheckBox("CHARACTERFRAMEAUTOEXPAND", true) end
	AddCategory("USERINTERFACE")
	if StatusTrackingBarManager then
		AddCheckBox("STATUSBARWIDTHENABLED", ImproveAny:IsEnabled("XPBAR", false) or ImproveAny:IsEnabled("REPBAR", false), Call("UpdateStatusBar"))
		Requires(AddSlider("STATUSBARWIDTH", 570, Call("UpdateStatusBar"), 100, 1920, 5, 0), "STATUSBARWIDTHENABLED")
	end

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
	if not isRetail then
		AddCategory("FRAMES", 2)
		AddCheckBox("WIDEFRAMES", false)
		if isClassic then AddCheckBox("IMPROVETRADESKILLFRAME", true) end
	end

	if not isRetail or ImproveAny:HasTrackingBars() then
		AddCategory("XPBAR", 2)
		AddCheckBox("XPBAR", false)
		for _, key in ipairs({"XPNUMBERLEVEL", "XPPERCENTLEVEL", "XPNUMBER", "XPPERCENT", "XPNUMBEREXHAUSTION", "XPPERCENTEXHAUSTION", "XPNUMBERMISSING", "XPPERCENTMISSING", "XPNUMBERQUESTCOMPLETE", "XPPERCENTQUESTCOMPLETE", "XPNUMBERKILLSTOLEVELUP", "XPHIDEARTWORK", "XPHIDEUNKNOWNVALUES", "XPBARTEXTSHOWINVERTED"}) do
			Requires(AddCheckBox(key, false), "XPBAR")
		end

		AddCategory("REPBAR", 2)
		AddCheckBox("REPBAR", false)
		for _, key in ipairs({"REPNUMBER", "REPPERCENT", "REPHIDEARTWORK"}) do
			Requires(AddCheckBox(key, false), "REPBAR")
		end
	end

	AddCategory("BAGS", 2)
	if not ImproveAny:IsAddOnLoaded("DragonflightUI", "BAGMODEINDEX") then AddDropdown("BAGMODEINDEX", 1, Call("UpdateBagMode"), IABAGMODES) end
	AddCheckBox("FREESPACEBAGS", false)
	AddCheckBox("BAGSAMESIZE", false)
	Requires(AddSlider("BAGSIZE", 30, function() BAGThink.UpdateItemInfos() end, 20, 80, 1, 0), "BAGSAMESIZE")
	AddCategory("MINIMAP", 2)
	local function AddMinimapCheckBox(key)
		Requires(AddCheckBox(key, false, Call("UpdateMinimapSettings")), "MINIMAP")
	end

	AddCheckBox("MINIMAP", false, Call("UpdateMinimapSettings"))
	if not ImproveAny:IsAddOnLoaded("DragonflightUI", "MINIMAPHIDEBORDER") then AddMinimapCheckBox("MINIMAPHIDEBORDER") end
	AddMinimapCheckBox("MINIMAPHIDEZOOMBUTTONS")
	if not isRetail then AddMinimapCheckBox("MINIMAPSCROLLZOOM") end
	if not ImproveAny:IsAddOnLoaded("DragonflightUI", "MINIMAPSHAPESQUARE") then AddMinimapCheckBox("MINIMAPSHAPESQUARE") end
	AddMinimapCheckBox("MINIMAPMINIMAPBUTTONSMOVABLE")
	AddMinimapCheckBox("COMBINEMMBTNS")
	AddCategory("WORLDMAP", 2)
	AddCheckBox("WORLDMAP", false)
	if not isRetail then Requires(AddCheckBox("WORLDMAPZOOM", false), "WORLDMAP") end
	AddCategory("TOOLTIP", 2)
	AddCheckBox("TOOLTIPSELLPRICE", false)
	if isRetail then AddCheckBox("TOOLTIPEXPANSION", false) end
	AddCategory("WIDGETS", 2)
	AddCheckBox("IAPingFrame", false)
	AddCheckBox("IAILVLBAR", false)
	AddCheckBox("IACoordsFrame", false)
	if ImproveAny:HasSkillLines() then AddCheckBox("SKILLBARS", false) end
	AddCategory("DURABILITYFRAME", 3)
	AddCheckBox("DURABILITY", false)
	Requires(AddSlider("SHOWDURABILITYUNDER", 100, nil, 5, 100, 5, 0), "DURABILITY")
	AddCategory("MONEYBAR", 3)
	AddCheckBox("MONEYBAR", false)
	Requires(AddCheckBox("MONEYBARPERHOUR", false), "MONEYBAR")
	AddCategory("BADGES", 3)
	AddCheckBox("TOKENBAR", false)
	AddCheckBox("TOKENBARRESTORE", true)
	AddCategory("COMBAT", 2)
	AddCheckBox("COMBATTEXTICONS", false)
	AddCheckBox("COMBATTEXTPOSITION", false)
	Requires(AddSlider("COMBATTEXTX", 0, nil, -600, 600, 10, 0), "COMBATTEXTPOSITION")
	Requires(AddSlider("COMBATTEXTY", 0, nil, -250, 250, 10, 0), "COMBATTEXTPOSITION")
	UpdateDependents()
	IASettings:ResumeLayout()
end

function ImproveAny:InitIASettings()
	ImproveAny:SetVersion(136033, "1.0.20")
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

	IASettings.save = ImproveAny:CreateReloadButton("IASettings_save", IASettings.footer)
	IASettings.save:SetSize(136, 24)
	IASettings.save:SetPoint("LEFT", IASettings.footer, "LEFT", 0, 0)
	IASettings.save:SetText(ImproveAny:Trans("LID_SAVEANDCLOSE"))
	IASettings.save:SetScript("PreClick", function() ImproveAny:SetEnabled("SETTINGS", false) end)
	IASettings.save:Disable()
	IASettings.reload = ImproveAny:CreateReloadButton("IASettings_reload", IASettings.footer)
	IASettings.reload:SetSize(136, 24)
	IASettings.reload:SetPoint("LEFT", IASettings.save, "RIGHT", 4, 0)
	IASettings.reload:SetText(ImproveAny:Trans("LID_SAVEANDREOPEN"))
	IASettings.reload:SetScript("PreClick", function() ImproveAny:SetEnabled("SETTINGS", true) end)
	IASettings.showerrors = ImproveAny:CreateReloadButton("IASettings_showerrors", IASettings.footer)
	IASettings.showerrors:SetSize(90, 24)
	IASettings.showerrors:SetPoint("LEFT", IASettings.reload, "RIGHT", 4, 0)
	IASettings.showerrors:SetText("Show Errors")
	IASettings.showerrors:SetScript("PreClick", function() SetCVar("ScriptErrors", 1) end)
	IASettings.DISCORD = CreateFrame("EditBox", "IASettings_DISCORD", IASettings.footer, "InputBoxTemplate")
	IASettings.DISCORD:SetSize(140, 24)
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
