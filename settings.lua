local _, ImproveAny = ...

local config = {
	["title"] = format("ImproveAny |T136033:16:16:0:0|t v|cff3FC7EB%s", "0.7.34")
}

local font = "Interface\\AddOns\\ImproveAny\\media\\Prototype.ttf"
local IAOldFonts = {}

local BlizDefaultFonts = {"STANDARD_TEXT_FONT", "UNIT_NAME_FONT", "DAMAGE_TEXT_FONT", "NAMEPLATE_FONT", "NAMEPLATE_SPELLCAST_FONT"}

local BlizFontObjects = {"SystemFont_NamePlateCastBar", "SystemFont_NamePlateFixed", "SystemFont_LargeNamePlateFixed", "SystemFont_World", "SystemFont_World_ThickOutline", "SystemFont_Outline_Small", "SystemFont_Outline", "SystemFont_InverseShadow_Small", "SystemFont_Med2", "SystemFont_Med3", "SystemFont_Shadow_Med3", "SystemFont_Huge1", "SystemFont_Huge1_Outline", "SystemFont_OutlineThick_Huge2", "SystemFont_OutlineThick_Huge4", "SystemFont_OutlineThick_WTF", "NumberFont_GameNormal", "NumberFont_Shadow_Small", "NumberFont_OutlineThick_Mono_Small", "NumberFont_Shadow_Med", "NumberFont_Normal_Med", "NumberFont_Outline_Med", "NumberFont_Outline_Large", "NumberFont_Outline_Huge", "Fancy22Font", "QuestFont_Huge", "QuestFont_Outline_Huge", "QuestFont_Super_Huge", "QuestFont_Super_Huge_Outline", "SplashHeaderFont", "Game11Font", "Game12Font", "Game13Font", "Game13FontShadow", "Game15Font", "Game18Font", "Game20Font", "Game24Font", "Game27Font", "Game30Font", "Game32Font", "Game36Font", "Game48Font", "Game48FontShadow", "Game60Font", "Game72Font", "Game11Font_o1", "Game12Font_o1", "Game13Font_o1", "Game15Font_o1", "QuestFont_Enormous", "DestinyFontLarge", "CoreAbilityFont", "DestinyFontHuge", "QuestFont_Shadow_Small", "MailFont_Large", "SpellFont_Small", "InvoiceFont_Med", "InvoiceFont_Small", "Tooltip_Med", "Tooltip_Small", "AchievementFont_Small", "ReputationDetailFont", "FriendsFont_Normal", "FriendsFont_Small", "FriendsFont_Large", "FriendsFont_UserText", "GameFont_Gigantic", "ChatBubbleFont", "Fancy16Font", "Fancy18Font", "Fancy20Font", "Fancy24Font", "Fancy27Font", "Fancy30Font", "Fancy32Font", "Fancy48Font", "SystemFont_NamePlate", "SystemFont_LargeNamePlate", "GameFontNormal", "SystemFont_Tiny2", "SystemFont_Tiny", "SystemFont_Shadow_Small", "SystemFont_Small", "SystemFont_Small2", "SystemFont_Shadow_Small2", "SystemFont_Shadow_Med1_Outline", "SystemFont_Shadow_Med1", "QuestFont_Large", "SystemFont_Large", "SystemFont_Shadow_Large_Outline", "SystemFont_Shadow_Med2", "SystemFont_Shadow_Large", "SystemFont_Shadow_Large2", "SystemFont_Shadow_Huge1", "SystemFont_Huge2", "SystemFont_Shadow_Huge2", "SystemFont_Shadow_Huge3", "SystemFont_Shadow_Outline_Huge3", "SystemFont_Shadow_Outline_Huge2", "SystemFont_Med1", "SystemFont_WTF2", "SystemFont_Outline_WTF2", "GameTooltipHeader", "System_IME",}

function ImproveAny:SaveOldFonts(ele)
	if IAOldFonts[ele] == nil then
		IAOldFonts[ele] = _G[ele]
	end
end

local IAFONTS = {"Default", "Prototype"}

function ImproveAny:Fonts()
	local index = ImproveAny:GV("UIFONTINDEX", 1)
	local val = IAFONTS[index]
	ImproveAny:SV("fontName", val)

	for i, fontName in pairs(BlizDefaultFonts) do
		ImproveAny:SaveOldFonts(fontName)
	end

	local ForcedFontSize = {10, 14, 20, 64, 64}

	for i, fontName in pairs(BlizFontObjects) do
		local fontObject = _G[fontName]

		if fontObject and fontObject.GetFont then
			local oldFont, oldSize, oldStyle = fontObject:GetFont()

			if IAOldFonts[i] == nil then
				IAOldFonts[i] = oldFont
			end

			oldSize = ForcedFontSize[i] or oldSize

			if ImproveAny:GV("fontName", "Default") == "Default" then
				fontObject:SetFont(IAOldFonts[i], oldSize, oldStyle)
			else
				fontObject:SetFont(font, oldSize, oldStyle)
			end
		end
	end
end

local IABAGMODES = {"RETAIL", "CLASSIC", "ONEBAG"}

function ImproveAny:UpdateBagMode()
	local index = ImproveAny:GV("BAGMODEINDEX", 1)
	local val = IABAGMODES[index]
	ImproveAny:SV("BAGMODE", val)
end

local searchStr = ""
local posy = -4
local cas = {}
local cbs = {}
local ebs = {}
local sls = {}

local function IASetPos(ele, key, x)
	if ele == nil then return false end
	ele:ClearAllPoints()

	if strfind(strlower(key), strlower(searchStr), 1, true) then
		ele:Show()

		if posy < -4 then
			posy = posy - 10
		end

		ele:SetPoint("TOPLEFT", IASettings.SC, "TOPLEFT", x or 6, posy)
		posy = posy - 24
	else
		ele:Hide()
	end

	return true
end

local function AddCategory(key)
	if cas[key] == nil then
		cas[key] = CreateFrame("Frame", key .. "_Category", IASettings.SC)
		local ca = cas[key]
		ca:SetSize(24, 24)
		ca.f = ca:CreateFontString(nil, nil, "GameFontNormal")
		ca.f:SetPoint("LEFT", ca, "LEFT", 0, 0)
		ca.f:SetText(ImproveAny:GT(key))
	end

	IASetPos(cas[key], key)
end

local function AddCheckBox(x, key, val, func)
	if val == nil then
		val = true
	end

	if cbs[key] == nil then
		cbs[key] = CreateFrame("CheckButton", key .. "_CB", IASettings.SC, "UICheckButtonTemplate") --CreateFrame( "CheckButton", "moversettingsmove", mover, "UICheckButtonTemplate" )
		local cb = cbs[key]
		cb:SetSize(24, 24)
		cb:SetChecked(ImproveAny:IsEnabled(key, val))

		cb:SetScript("OnClick", function(self)
			ImproveAny:SetEnabled(key, self:GetChecked())

			if func then
				func()
			end

			if IASettings.save then
				IASettings.save:Enable()
			end
		end)

		cb.f = cb:CreateFontString(nil, nil, "GameFontNormal")
		cb.f:SetPoint("LEFT", cb, "RIGHT", 0, 0)
		cb.f:SetText(ImproveAny:GT(key))
	end

	cbs[key]:ClearAllPoints()

	if strfind(strlower(key), strlower(searchStr), 1, true) or strfind(strlower(ImproveAny:GT(key)), strlower(searchStr), 1, true) then
		cbs[key]:Show()
		cbs[key]:SetPoint("TOPLEFT", IASettings.SC, "TOPLEFT", x, posy)
		posy = posy - 24
	else
		cbs[key]:Hide()
	end
end

local function AddEditBox(x, key, val, func)
	if ebs[key] == nil then
		ebs[key] = CreateFrame("EditBox", "ebs[" .. key .. "]", IASettings.SC, "InputBoxTemplate")
		ebs[key]:SetPoint("TOPLEFT", IASettings.SC, "TOPLEFT", x, posy)
		ebs[key]:SetSize(IASettings:GetWidth() - 40, 24)
		ebs[key]:SetAutoFocus(false)
		ebs[key].text = ImproveAny:GV(key, val)
		ebs[key]:SetText(ImproveAny:GV(key, val))

		ebs[key]:SetScript("OnTextChanged", function(self, ...)
			if self.text ~= ebs[key]:GetText() then
				ImproveAny:SV(key, ebs[key]:GetText())

				if func then
					func()
				end
			end
		end)

		ebs[key].f = ebs[key]:CreateFontString(nil, nil, "GameFontNormal")
		ebs[key].f:SetPoint("LEFT", ebs[key], "LEFT", 0, 16)
		ebs[key].f:SetText(ImproveAny:GT(key))
	end

	IASetPos(ebs[key], key, x + 8)
end

local function AddSlider(x, key, val, func, vmin, vmax, steps)
	if sls[key] == nil then
		sls[key] = CreateFrame("Slider", "sls[" .. key .. "]", IASettings.SC, "OptionsSliderTemplate")
		sls[key]:SetWidth(IASettings.SC:GetWidth() - 30 - x)
		sls[key]:SetPoint("TOPLEFT", IASettings.SC, "TOPLEFT", x + 5, posy)

		if type(vmin) == "number" then
			sls[key].Low:SetText(vmin)
			sls[key].High:SetText(vmax)
			sls[key]:SetMinMaxValues(vmin, vmax)
			sls[key].Text:SetText(ImproveAny:GT(key) .. ": " .. ImproveAny:GV(key, val))
		else
			sls[key].Low:SetText("")
			sls[key].High:SetText("")
			sls[key]:SetMinMaxValues(1, #vmin)
			sls[key].Text:SetText(ImproveAny:GT(key) .. ": " .. vmin[ImproveAny:GV(key, val)])
		end

		sls[key]:SetObeyStepOnDrag(true)

		if steps then
			sls[key]:SetValueStep(steps)
		end

		sls[key]:SetValue(ImproveAny:GV(key, val))

		sls[key]:SetScript("OnValueChanged", function(self, valu)
			--val = val - val % steps
			if steps then
				valu = tonumber(string.format("%" .. steps .. "f", valu))
			end

			if valu and valu ~= ImproveAny:GV(key) then
				if type(vmin) == "number" then
					ImproveAny:SV(key, valu)
					sls[key].Text:SetText(ImproveAny:GT(key) .. ": " .. valu)
				else
					ImproveAny:SV(key, valu)
					sls[key].Text:SetText(ImproveAny:GT(key) .. ": " .. vmin[valu])
				end

				if func then
					func()
				end

				if IASettings.save then
					IASettings.save:Enable()
				end
			end
		end)

		posy = posy - 10
	end

	IASetPos(sls[key], key, x)
end

function ImproveAny:UpdateILVLIcons()
	PDThink.UpdateItemInfos()

	if IFThink and IFThink.UpdateItemInfos then
		IFThink.UpdateItemInfos()
	end

	if IAUpdateBags then
		IAUpdateBagsIlvl()
	end
end

function ImproveAny:UpdateRaidFrameSize()
	for i = 1, 40 do
		local frame = _G["CompactRaidFrame" .. i]

		if frame then
			local options = DefaultCompactMiniFrameSetUpOptions

			if ImproveAny:IsEnabled("OVERWRITERAIDFRAMESIZE", false) and ImproveAny:GV("RAIDFRAMEW", options.width) and ImproveAny:GV("RAIDFRAMEH", options.height) then
				frame:SetSize(ImproveAny:GV("RAIDFRAMEW", options.width), ImproveAny:GV("RAIDFRAMEH", options.height))
			end

			if true then
				local index = 1
				local frameNum = 1
				local filter = nil

				while frameNum <= 10 do
					if frame.displayedUnit then
						local buffName = UnitBuff(frame.displayedUnit, index, filter)

						if buffName then
							local buffFrame = _G[frame:GetName() .. "Buff" .. i]

							if buffFrame then
								buffFrame:SetScale(ImproveAny:GV("BUFFSCALE", 0.8))
							end

							frameNum = frameNum + 1
						else
							break
						end
					else
						break
					end

					index = index + 1
				end
			end

			if true then
				local index = 1
				local frameNum = 1
				local filter = nil

				while frameNum <= 10 do
					if frame.displayedUnit then
						local debuffName = UnitDebuff(frame.displayedUnit, index, filter)

						if debuffName then
							local debuffFrame = _G[frame:GetName() .. "Debuff" .. i]

							if debuffFrame then
								debuffFrame:SetScale(ImproveAny:GV("DEBUFFSCALE", 1))
							end

							frameNum = frameNum + 1
						else
							break
						end
					else
						break
					end

					index = index + 1
				end
			end
		end
	end
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
		local topOffset = ImproveAny:GV("TOP_OFFSET", 116)
		self:SetAttribute("TOP_OFFSET", -topOffset)
	elseif key == "LEFT_OFFSET" then
		local leftOffset = ImproveAny:GV("LEFT_OFFSET", 16)
		self:SetAttribute("LEFT_OFFSET", leftOffset)
	elseif key == "PANEl_SPACING_X" then
		local panelSpacingX = ImproveAny:GV("PANEl_SPACING_X", 32)
		self:SetAttribute("PANEl_SPACING_X", panelSpacingX)
	end

	iasetattribute = false
end)

function ImproveAny:UpdateUIParentAttribute()
	if not InCombatLockdown() then
		local topOffset = ImproveAny:GV("TOP_OFFSET", 116)
		local leftOffset = ImproveAny:GV("LEFT_OFFSET", 16)
		local panelSpacingX = ImproveAny:GV("PANEl_SPACING_X", 32)
		UIParent:SetAttribute("TOP_OFFSET", -topOffset)
		UIParent:SetAttribute("LEFT_OFFSET", leftOffset)
		UIParent:SetAttribute("PANEl_SPACING_X", panelSpacingX)
	end
end

function ImproveAny:UpdateStatusBar()
	local w = ImproveAny:GV("STATUSBARWIDTH", 565)

	if StatusTrackingBarManager then
		StatusTrackingBarManager:SetWidth(w)

		if StatusTrackingBarManager.TopBarFrameTexture then
			StatusTrackingBarManager.TopBarFrameTexture:SetWidth(w + 5)
		end

		if StatusTrackingBarManager.BottomBarFrameTexture then
			StatusTrackingBarManager.BottomBarFrameTexture:SetWidth(w + 5)
		end

		for i, v in pairs({StatusTrackingBarManager:GetChildren()}) do
			v:SetWidth(w)

			if v.OverlayFrame then
				v.OverlayFrame:SetWidth(w)
			end

			if v.StatusBar then
				v.StatusBar:SetWidth(w)
			end
		end
	end

	if MainStatusTrackingBarContainer then
		MainStatusTrackingBarContainer:SetWidth(w)

		for i, v in pairs({MainStatusTrackingBarContainer:GetChildren()}) do
			v:SetWidth(w - 5)

			for id, va in pairs({v:GetChildren()}) do
				va:SetWidth(w - 5)
			end
		end
	end

	if SecondaryStatusTrackingBarContainer then
		SecondaryStatusTrackingBarContainer:SetWidth(w)

		for i, v in pairs({SecondaryStatusTrackingBarContainer:GetChildren()}) do
			v:SetWidth(w - 5)

			for id, va in pairs({v:GetChildren()}) do
				va:SetWidth(w - 5)
			end
		end
	end
end

function ImproveAny:ToggleSettings()
	ImproveAny:SetEnabled("SETTINGS", not ImproveAny:IsEnabled("SETTINGS", false))

	if ImproveAny:IsEnabled("SETTINGS", false) then
		IASettings:Show()
		IASettings:UpdateShowErrors()
	else
		IASettings:Hide()
		IASettings:UpdateShowErrors()
	end
end

function ImproveAny:InitIASettings()
	IASettings = CreateFrame("Frame", "IASettings", UIParent, "BasicFrameTemplate")
	IASettings:SetSize(550, 500)
	IASettings:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	IASettings:SetFrameStrata("HIGH")
	IASettings:SetFrameLevel(999)
	IASettings:SetClampedToScreen(true)
	IASettings:SetMovable(true)
	IASettings:EnableMouse(true)
	IASettings:RegisterForDrag("LeftButton")
	IASettings:SetScript("OnDragStart", IASettings.StartMoving)

	IASettings:SetScript("OnDragStop", function()
		IASettings:StopMovingOrSizing()
		local p1, _, p3, p4, p5 = IASettings:GetPoint()
		ImproveAny:SetElePoint("IASettings", p1, _, p3, p4, p5)
	end)

	if ImproveAny:IsEnabled("SETTINGS", false) then
		IASettings:Show()
	else
		IASettings:Hide()
	end

	IASettings.TitleText:SetText(config.title)

	IASettings.CloseButton:SetScript("OnClick", function()
		ImproveAny:ToggleSettings()
	end)

	function IAUpdateElementList()
		posy = -8
		AddCategory("GENERAL")
		AddCheckBox(4, "SHOWMINIMAPBUTTON", true, ImproveAny.UpdateMinimapButton)
		AddSlider(4, "UIFONTINDEX", 1, ImproveAny.Fonts, IAFONTS, nil, 1)
		AddSlider(4, "WORLDTEXTSCALE", 1.0, ImproveAny.UpdateWorldTextScale, 0.1, 2.0, 0.1)
		AddSlider(4, "MAXZOOM", ImproveAny:GetMaxZoom(), ImproveAny.UpdateMaxZoom, 1, ImproveAny:GetMaxZoom(), 0.1)
		AddCheckBox(4, "HIDEPVPBADGE", false)
		AddSlider(4, "TOP_OFFSET", 116, ImproveAny.UpdateUIParentAttribute, 0.0, 600.0, 1)
		AddSlider(4, "LEFT_OFFSET", 16, ImproveAny.UpdateUIParentAttribute, 16.0, 400.0, 1)
		AddSlider(4, "PANEl_SPACING_X", 32, ImproveAny.UpdateUIParentAttribute, 10.0, 300.0, 1)

		if StatusTrackingBarManager then
			AddSlider(4, "STATUSBARWIDTH", 565, ImproveAny.UpdateStatusBar, 100.0, 1920.0, 5)
		end

		AddCheckBox(4, "BAGSAMESIZE", false)
		AddSlider(24, "BAGSIZE", 30, BAGThink.UpdateItemInfos, 20.0, 80.0, 1)
		AddSlider(24, "BAGMODEINDEX", 1, ImproveAny.UpdateBagMode, IABAGMODES, nil, 1)
		AddCategory("QUICKGAMEPLAY")
		AddCheckBox(4, "FASTLOOTING", false)
		AddCheckBox(4, "COORDSP", false)
		AddCheckBox(4, "COORDSC", false)
		AddSlider(24, "COORDSFONTSIZE", 8, ImproveAny.UpdateCoordsFontSize, 6, 20, 1)
		AddCheckBox(4, "IACoordsFrame", false)
		AddCategory("COMBAT")
		AddCheckBox(4, "COMBATTEXTICONS", false)
		AddCheckBox(4, "COMBATTEXTPOSITION", false)
		AddSlider(4, "COMBATTEXTX", 0, nil, -600, 600, 10)
		AddSlider(4, "COMBATTEXTY", 0, nil, -250, 250, 10)
		AddCategory("CHAT")
		AddCheckBox(4, "CHAT", false)
		AddCheckBox(24, "CHATSHORTCHANNELS", false)
		AddCheckBox(24, "CHATITEMICONS", false)
		AddCheckBox(24, "CHATCLASSICONS", false)
		AddCheckBox(24, "CHATRACEICONS", false)
		AddCheckBox(24, "CHATLEVELS", false)
		AddCheckBox(24, "CHATCLASSCOLORS", false)
		AddCategory("MINIMAP")
		AddCheckBox(4, "MINIMAP", false, ImproveAny.UpdateMinimapSettings)
		AddCheckBox(24, "MINIMAPHIDEBORDER", false, ImproveAny.UpdateMinimapSettings)

		if ImproveAny:GetWoWBuild() ~= "RETAIL" then
			AddCheckBox(24, "MINIMAPHIDEZOOMBUTTONS", false, ImproveAny.UpdateMinimapSettings)
		end

		AddCheckBox(24, "MINIMAPSCROLLZOOM", false, ImproveAny.UpdateMinimapSettings)
		AddCheckBox(24, "MINIMAPSHAPESQUARE", false, ImproveAny.UpdateMinimapSettings)
		AddCheckBox(4, "MINIMAPMINIMAPBUTTONSMOVABLE", false, ImproveAny.UpdateMinimapSettings)
		AddCategory("ITEMLEVEL")
		AddCheckBox(4, "ITEMLEVELNUMBER", false, ImproveAny.UpdateILVLIcons)
		AddCheckBox(4, "ITEMLEVELBORDER", false, ImproveAny.UpdateILVLIcons)

		if ImproveAny:GetWoWBuild() ~= "RETAIL" then
			AddCategory("XPBAR")
			AddCheckBox(4, "XPBAR", false)
			AddCheckBox(24, "XPNUMBERLEVEL", false)
			AddCheckBox(24, "XPPERCENTLEVEL", false)
			AddCheckBox(24, "XPNUMBER", false)
			AddCheckBox(24, "XPPERCENT", false)
			AddCheckBox(24, "XPNUMBEREXHAUSTION", false)
			AddCheckBox(24, "XPPERCENTEXHAUSTION", false)
			AddCheckBox(24, "XPNUMBERMISSING", false)
			AddCheckBox(24, "XPPERCENTMISSING", false)
			AddCheckBox(24, "XPNUMBERQUESTCOMPLETE", false)
			AddCheckBox(24, "XPPERCENTQUESTCOMPLETE", false)
			AddCheckBox(24, "XPNUMBERKILLSTOLEVELUP", false)
			AddCheckBox(24, "XPHIDEARTWORK", false)
			AddCheckBox(24, "XPHIDEUNKNOWNVALUES", false)
			AddCheckBox(24, "XPBARTEXTSHOWINVERTED", false)
			AddCategory("REPBAR")
			AddCheckBox(4, "REPBAR", false)
			AddCheckBox(24, "REPNUMBER", false)
			AddCheckBox(24, "REPPERCENT", false)
			AddCheckBox(24, "REPHIDEARTWORK", false)
		end

		if ImproveAny:GetWoWBuild() ~= "RETAIL" then
			AddCategory("UNITFRAMES")
			AddEditBox(4, "RFHIDEBUFFIDSINCOMBAT", "", ImproveAny.ShowMsgForBuffs)
			AddEditBox(4, "RFHIDEBUFFIDSINNOTCOMBAT", "", ImproveAny.ShowMsgForBuffs)
			AddCheckBox(4, "RAIDFRAMEMOREBUFFS", false)
			AddSlider(24, "BUFFSCALE", 0.8, ImproveAny.UpdateRaidFrameSize, 0.4, 1.6, 0.1)
			AddSlider(24, "DEBUFFSCALE", 1.0, ImproveAny.UpdateRaidFrameSize, 0.4, 1.6, 0.1)
			local options = DefaultCompactMiniFrameSetUpOptions
			AddCheckBox(4, "OVERWRITERAIDFRAMESIZE", false)
			AddSlider(24, "RAIDFRAMEW", options.width, ImproveAny.UpdateRaidFrameSize, 20, 300, 10)
			AddSlider(24, "RAIDFRAMEH", options.height, ImproveAny.UpdateRaidFrameSize, 20, 300, 10)
		end

		AddCategory("EXTRAS")
		AddCheckBox(4, "MONEYBAR", false)
		AddCheckBox(4, "TOKENBAR", false)
		AddCheckBox(4, "IAILVLBAR", false)
		AddCheckBox(4, "SKILLBARS", false)
		AddCheckBox(4, "CASTBAR", false)
		AddCheckBox(4, "DURABILITY", false)
		AddCheckBox(4, "RIGHTCLICKSELFCAST", false)
		AddSlider(24, "SHOWDURABILITYUNDER", 100, nil, 5, 100, 5)
		AddCheckBox(4, "BAGS", false)
		AddCheckBox(4, "WORLDMAP", false)
		AddCheckBox(4, "TOOLTIPSELLPRICE", false)
		AddCheckBox(4, "TOOLTIPEXPANSION", false)
		AddCheckBox(4, "LFGSHOWLANGUAGEFLAG", false)
		AddCheckBox(4, "LFGSHOWCLASSICON", false)
		AddCheckBox(4, "LFGSHOWOVERALLSCORE", false)
		AddCheckBox(4, "LFGSHOWDUNGEONSCORE", false)
		AddCheckBox(4, "LFGSHOWDUNGEONKEY", false)

		if ExtraActionButton1 and ExtraActionButton1.style then
			AddCheckBox(4, "HIDEEXTRAACTIONBUTTONARTWORK", false)
		end

		AddCheckBox(4, "IAPingFrame", false)
	end

	IASettings.Search = CreateFrame("EditBox", "IASettings_Search", IASettings, "InputBoxTemplate")
	IASettings.Search:SetPoint("TOPLEFT", IASettings, "TOPLEFT", 12, -26)
	IASettings.Search:SetSize(IASettings:GetWidth() - 22 - 100, 24)
	IASettings.Search:SetAutoFocus(false)

	IASettings.Search:SetScript("OnTextChanged", function(sel, ...)
		searchStr = IASettings.Search:GetText()
		IAUpdateElementList()
	end)

	IASettings.SF = CreateFrame("ScrollFrame", "IASettings_SF", IASettings, "UIPanelScrollFrameTemplate")
	IASettings.SF:SetPoint("TOPLEFT", IASettings, 8, -30 - 24)
	IASettings.SF:SetPoint("BOTTOMRIGHT", IASettings, -32, 24 + 8)
	IASettings.SC = CreateFrame("Frame", "IASettings_SC", IASettings.SF)
	IASettings.SC:SetSize(IASettings.SF:GetSize())
	IASettings.SC:SetPoint("TOPLEFT", IASettings.SF, "TOPLEFT", 0, 0)
	IASettings.SF:SetScrollChild(IASettings.SC)
	IASettings.SF.bg = IASettings.SF:CreateTexture("IASettings.SF.bg", "ARTWORK")
	IASettings.SF.bg:SetAllPoints(IASettings.SF)
	IASettings.SF.bg:SetColorTexture(0.03, 0.03, 0.03, 0.5)
	IASettings.save = CreateFrame("BUTTON", "IASettings" .. ".save", IASettings, "UIPanelButtonTemplate")
	IASettings.save:SetSize(120, 24)
	IASettings.save:SetPoint("TOPLEFT", IASettings, "TOPLEFT", 4, -IASettings:GetHeight() + 24 + 4)
	IASettings.save:SetText(SAVE)

	IASettings.save:SetScript("OnClick", function()
		C_UI.Reload()
	end)

	IASettings.save:Disable()
	IASettings.reload = CreateFrame("BUTTON", "IASettings" .. ".reload", IASettings, "UIPanelButtonTemplate")
	IASettings.reload:SetSize(120, 24)
	IASettings.reload:SetPoint("TOPLEFT", IASettings, "TOPLEFT", 4 + 120 + 4, -IASettings:GetHeight() + 24 + 4)
	IASettings.reload:SetText(RELOADUI)

	IASettings.reload:SetScript("OnClick", function()
		C_UI.Reload()
	end)

	IASettings.showerrors = CreateFrame("BUTTON", "IASettings" .. ".showerrors", IASettings, "UIPanelButtonTemplate")
	IASettings.showerrors:SetSize(120, 24)
	IASettings.showerrors:SetPoint("TOPLEFT", IASettings, "TOPLEFT", 4 + 120 + 4 + 120 + 4, -IASettings:GetHeight() + 24 + 4)
	IASettings.showerrors:SetText("Show Errors")

	IASettings.showerrors:SetScript("OnClick", function()
		if GetCVar("ScriptErrors") == "0" then
			SetCVar("ScriptErrors", 1)
			C_UI.Reload()
		end

		IASettings:UpdateShowErrors()
	end)

	function IASettings:UpdateShowErrors()
		if GetCVar("ScriptErrors") == "0" then
			IASettings.showerrors:Show()
		else
			IASettings.showerrors:Hide()
		end
	end

	IASettings:UpdateShowErrors()
	IASettings.DISCORD = CreateFrame("EditBox", "IASettings" .. ".DISCORD", IASettings, "InputBoxTemplate")
	IASettings.DISCORD:SetText("discord.gg/AWcDfvcYCN")
	IASettings.DISCORD:SetSize(160, 24)
	IASettings.DISCORD:SetPoint("TOPLEFT", IASettings, "TOPLEFT", IASettings:GetWidth() - 160 - 8, -IASettings:GetHeight() + 24 + 4)
	IASettings.DISCORD:SetAutoFocus(false)
	local dbp1, _, dbp3, dbp4, dbp5 = ImproveAny:GetElePoint("IASettings")

	if dbp1 and dbp3 then
		IASettings:ClearAllPoints()
		IASettings:SetPoint(dbp1, UIParent, dbp3, dbp4, dbp5)
	end
end