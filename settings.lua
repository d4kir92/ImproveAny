local _, ImproveAny = ...
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
	local index = ImproveAny:IAGV("UIFONTINDEX", 1)
	local val = IAFONTS[index]
	ImproveAny:IASV("fontName", val)
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
			if ImproveAny:IAGV("fontName", "Default") == "Default" then
				fontObject:SetFont(IAOldFonts[i], oldSize, oldStyle)
			else
				fontObject:SetFont(font, oldSize, oldStyle)
			end
		end
	end
end

local IABAGMODES = {"RETAIL", "CLASSIC", "ONEBAG", "DISABLED"}
function ImproveAny:UpdateBagMode()
	local index = ImproveAny:IAGV("BAGMODEINDEX", 1)
	local val = IABAGMODES[index]
	ImproveAny:IASV("BAGMODE", val)
end

local searchStr = ""
local posy = -4
local cas = {}
local cbs = {}
local ebs = {}
local sls = {}
function ImproveAny:SetPos(ele, key, x, extra)
	if ele == nil then return false end
	ele:ClearAllPoints()
	if strfind(strlower(key), strlower(searchStr), 1, true) or strfind(strlower(ImproveAny:GT(key)), strlower(searchStr), 1, true) or (extra and (strfind(strlower(extra), strlower(searchStr), 1, true) or strfind(strlower(ImproveAny:GT(extra)), strlower(searchStr), 1, true))) then
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

	ImproveAny:SetPos(cas[key], key)
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
		cb:SetScript(
			"OnClick",
			function(sel)
				ImproveAny:SetEnabled(key, sel:GetChecked())
				if func then
					func()
				end

				if IASettings.save then
					IASettings.save:Enable()
				end
			end
		)

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
		ebs[key].text = ImproveAny:IAGV(key, val)
		ebs[key]:SetText(ImproveAny:IAGV(key, val))
		ebs[key]:SetScript(
			"OnTextChanged",
			function(self, ...)
				if self.text ~= ebs[key]:GetText() then
					ImproveAny:IASV(key, ebs[key]:GetText())
					if func then
						func(self, ...)
					end
				end
			end
		)

		ebs[key].f = ebs[key]:CreateFontString(nil, nil, "GameFontNormal")
		ebs[key].f:SetPoint("LEFT", ebs[key], "LEFT", 0, 16)
		ebs[key].f:SetText(ImproveAny:GT(key))
	end

	ImproveAny:SetPos(ebs[key], key, x + 8)
end

local function AddSlider(x, key, val, func, vmin, vmax, steps, extra)
	if sls[key] == nil then
		sls[key] = CreateFrame("Slider", "sls[" .. key .. "]", IASettings.SC, "UISliderTemplate")
		sls[key]:SetSize(IASettings.SC:GetWidth() - 30 - x, 16)
		sls[key]:SetPoint("TOPLEFT", IASettings.SC, "TOPLEFT", x + 5, posy)
		if sls[key].Low == nil then
			sls[key].Low = sls[key]:CreateFontString(nil, nil, "GameFontNormal")
			sls[key].Low:SetPoint("BOTTOMLEFT", sls[key], "BOTTOMLEFT", 0, -12)
			sls[key].Low:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
			sls[key].Low:SetTextColor(1, 1, 1)
		end

		if sls[key].High == nil then
			sls[key].High = sls[key]:CreateFontString(nil, nil, "GameFontNormal")
			sls[key].High:SetPoint("BOTTOMRIGHT", sls[key], "BOTTOMRIGHT", 0, -12)
			sls[key].High:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
			sls[key].High:SetTextColor(1, 1, 1)
		end

		if sls[key].Text == nil then
			sls[key].Text = sls[key]:CreateFontString(nil, nil, "GameFontNormal")
			sls[key].Text:SetPoint("TOP", sls[key], "TOP", 0, 16)
			sls[key].Text:SetFont(STANDARD_TEXT_FONT, 12, "THINOUTLINE")
			sls[key].Text:SetTextColor(1, 1, 1)
		end

		if type(vmin) == "number" then
			sls[key].Low:SetText(vmin)
			sls[key].High:SetText(vmax)
			sls[key]:SetMinMaxValues(vmin, vmax)
			sls[key].Text:SetText(ImproveAny:GT(key) .. ": " .. ImproveAny:IAGV(key, val))
		else
			sls[key].Low:SetText("")
			sls[key].High:SetText("")
			sls[key]:SetMinMaxValues(1, #vmin)
			sls[key].Text:SetText(ImproveAny:GT(key) .. ": " .. vmin[ImproveAny:IAGV(key, val)])
		end

		sls[key]:SetObeyStepOnDrag(true)
		if steps then
			sls[key]:SetValueStep(steps)
		end

		sls[key]:SetValue(ImproveAny:IAGV(key, val))
		sls[key]:SetScript(
			"OnValueChanged",
			function(self, valu)
				--val = val - val % steps
				if steps then
					valu = tonumber(string.format("%" .. steps .. "f", valu))
				end

				if valu and valu ~= ImproveAny:IAGV(key) then
					if type(vmin) == "number" then
						ImproveAny:IASV(key, valu)
						sls[key].Text:SetText(ImproveAny:GT(key) .. ": " .. valu)
					else
						ImproveAny:IASV(key, valu)
						sls[key].Text:SetText(ImproveAny:GT(key) .. ": " .. vmin[valu])
					end

					if func then
						func()
					end

					if IASettings.save then
						IASettings.save:Enable()
					end
				end
			end
		)

		posy = posy - 10
	end

	ImproveAny:SetPos(sls[key], key, x, extra)
end

function ImproveAny:UpdateILVLIcons()
	ImproveAny:PDUpdateItemInfos()
	if ImproveAny.IFUpdateItemInfos then
		ImproveAny:IFUpdateItemInfos()
	end

	if ImproveAny.UpdateBagsIlvl then
		ImproveAny:UpdateBagsIlvl()
	end
end

function ImproveAny:UpdateRaidFrameSize()
	for i = 1, 40 do
		local frame = _G["CompactRaidFrame" .. i]
		if frame then
			local options = DefaultCompactMiniFrameSetUpOptions
			if ImproveAny:IsEnabled("OVERWRITERAIDFRAMESIZE", false) and ImproveAny:IAGV("RAIDFRAMEW", options.width) and ImproveAny:IAGV("RAIDFRAMEH", options.height) then
				frame:SetSize(ImproveAny:IAGV("RAIDFRAMEW", options.width), ImproveAny:IAGV("RAIDFRAMEH", options.height))
			end

			if true then
				local index = 1
				local frameNum = 1
				local filter = nil
				while frameNum <= 10 do
					if frame.displayedUnit then
						local buffName = ImproveAny:UnitAura(frame.displayedUnit, index, filter)
						if buffName then
							local buffFrame = _G[ImproveAny:GetName(frame) .. "Buff" .. i]
							if buffFrame then
								buffFrame:SetScale(ImproveAny:IAGV("BUFFSCALE", 0.8))
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
						local debuffName = ImproveAny:UnitAura(frame.displayedUnit, index, filter)
						if debuffName then
							local debuffFrame = _G[ImproveAny:GetName(frame) .. "Debuff" .. i]
							if debuffFrame then
								debuffFrame:SetScale(ImproveAny:IAGV("DEBUFFSCALE", 1))
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
hooksecurefunc(
	UIParent,
	"SetAttribute",
	function(self, key, value)
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
	end
)

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
	local w = ImproveAny:IAGV("STATUSBARWIDTH", 570)
	if StatusTrackingBarManager then
		StatusTrackingBarManager:SetWidth(w)
		if StatusTrackingBarManager.TopBarFrameTexture then
			StatusTrackingBarManager.TopBarFrameTexture:SetWidth(w + 5)
		end

		if StatusTrackingBarManager.BottomBarFrameTexture then
			StatusTrackingBarManager.BottomBarFrameTexture:SetWidth(w + 5)
		end

		ImproveAny:ForeachChildren(
			StatusTrackingBarManager,
			function(child, x)
				child:SetWidth(w)
				if child.OverlayFrame then
					child.OverlayFrame:SetWidth(w)
				end

				if child.StatusBar then
					child.StatusBar:SetWidth(w)
				end
			end, "UpdateStatusBar"
		)
	end

	if MainStatusTrackingBarContainer then
		MainStatusTrackingBarContainer:SetWidth(w)
		ImproveAny:ForeachChildren(
			MainStatusTrackingBarContainer,
			function(child, x)
				child:SetWidth(w - 5)
				ImproveAny:ForeachChildren(
					child,
					function(va, id)
						if id ~= 3 then
							va:SetWidth(w - 5)
						end
					end, "MainStatusTrackingBarContainer 2"
				)
			end, "MainStatusTrackingBarContainer 1"
		)
	end

	if SecondaryStatusTrackingBarContainer then
		SecondaryStatusTrackingBarContainer:SetWidth(w)
		ImproveAny:ForeachChildren(
			SecondaryStatusTrackingBarContainer,
			function(child, x)
				child:SetWidth(w - 5)
				ImproveAny:ForeachChildren(
					child,
					function(va, id)
						if id ~= 3 then
							va:SetWidth(w - 5)
						end
					end, "SecondaryStatusTrackingBarContainer 2"
				)
			end, "SecondaryStatusTrackingBarContainer 1"
		)
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

function ImproveAny:InitIASettings()
	if not ImproveAny:IsOldWow() then
		IASettings = CreateFrame("Frame", "IASettings", UIParent, "BasicFrameTemplate")
	else
		IASettings = CreateFrame("Frame", "IASettings", UIParent)
		IASettings.TitleText = IASettings:CreateFontString(nil, nil, "GameFontNormal")
		IASettings.TitleText:SetPoint("TOP", IASettings, "TOP", 0, 0)
		IASettings.CloseButton = CreateFrame("Button", "IASettings.CloseButton", IASettings, "UIPanelButtonTemplate")
		IASettings.CloseButton:SetPoint("TOPRIGHT", IASettings, "TOPRIGHT", 0, 0)
		IASettings.CloseButton:SetSize(25, 25)
		IASettings.CloseButton:SetText("X")
		IASettings.bg = IASettings:CreateTexture("IASettings.bg", "ARTWORK")
		IASettings.bg:SetAllPoints(IASettings)
		if IASettings.bg.SetColorTexture then
			IASettings.bg:SetColorTexture(0.03, 0.03, 0.03, 0.5)
		else
			IASettings.bg:SetTexture(0.03, 0.03, 0.03, 0.5)
		end
	end

	IASettings:SetSize(550, 500)
	IASettings:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	IASettings:SetFrameStrata("HIGH")
	IASettings:SetFrameLevel(999)
	IASettings:SetClampedToScreen(true)
	IASettings:SetMovable(true)
	IASettings:EnableMouse(true)
	IASettings:RegisterForDrag("LeftButton")
	IASettings:SetScript("OnDragStart", IASettings.StartMoving)
	IASettings:SetScript(
		"OnDragStop",
		function()
			IASettings:StopMovingOrSizing()
			local p1, _, p3, p4, p5 = IASettings:GetPoint()
			ImproveAny:SetElePoint("IASettings", p1, _, p3, p4, p5)
		end
	)

	if ImproveAny:IsEnabled("SETTINGS", false) then
		IASettings:Show()
	else
		IASettings:Hide()
	end

	ImproveAny:SetVersion(136033, "0.9.148")
	IASettings.TitleText:SetText(format("|T136033:16:16:0:0|t I|cff3FC7EBmprove|rA|cff3FC7EBny|r v|cff3FC7EB%s", ImproveAny:GetVersion()))
	IASettings.CloseButton:SetScript(
		"OnClick",
		function()
			ImproveAny:ToggleSettings()
		end
	)

	function ImproveAny:UpdateElementList(sel)
		posy = -8
		AddCategory("GENERAL")
		AddCheckBox(4, "SHOWMINIMAPBUTTON", ImproveAny:GetWoWBuild() ~= "RETAIL", ImproveAny.UpdateMinimapButton)
		--AddSlider(x, key, val, func, vmin, vmax, steps)
		AddSlider(10, "UIFONTINDEX", 1, ImproveAny.Fonts, IAFONTS, nil, 1)
		AddSlider(10, "WORLDTEXTSCALE", 1.0, ImproveAny.UpdateWorldTextScale, 0.1, 2.0, 0.1)
		AddSlider(10, "MAXZOOM", ImproveAny:GetMaxZoom(), ImproveAny.UpdateMaxZoom, 1, ImproveAny:GetMaxZoom(), 0.1)
		AddCheckBox(4, "HIDEPVPBADGE", false)
		if StatusTrackingBarManager then
			AddSlider(10, "STATUSBARWIDTH", 570, ImproveAny.UpdateStatusBar, 100.0, 1920.0, 5)
		end

		AddCheckBox(4, "FREESPACEBAGS", false)
		AddCheckBox(4, "BAGSAMESIZE", false)
		AddSlider(24, "BAGSIZE", 30, BAGThink.UpdateItemInfos, 20.0, 80.0, 1)
		AddSlider(24, "BAGMODEINDEX", 1, ImproveAny.UpdateBagMode, IABAGMODES, nil, 1)
		AddCategory("QUICKGAMEPLAY")
		AddCheckBox(4, "AUTOSELLJUNK", true)
		AddCheckBox(4, "AUTOREPAIR", true)
		AddCheckBox(4, "AUTOACCEPTQUESTS", false)
		AddCheckBox(4, "AUTOCHECKINQUESTS", false)
		AddCheckBox(4, "FASTLOOTING", false)
		AddCheckBox(4, "IMPROVEBAGS", true)
		if CharacterFrameExpandButton then
			AddCheckBox(4, "CHARACTERFRAMEAUTOEXPAND", true)
		end

		AddSlider(24, "COORDSFONTSIZE", 8, ImproveAny.UpdateCoordsFontSize, 6, 20, 1)
		AddCheckBox(4, "IACoordsFrame", false)
		AddCategory("COMBAT")
		AddCheckBox(4, "COMBATTEXTICONS", false)
		AddCheckBox(4, "COMBATTEXTPOSITION", false)
		AddSlider(10, "COMBATTEXTX", 0, nil, -600, 600, 10)
		AddSlider(10, "COMBATTEXTY", 0, nil, -250, 250, 10)
		AddEditBox(
			24,
			"BLOCKWORDS",
			"",
			function(eb, ...)
				eb.lastchange = GetTime()
				ImproveAny:Debug("settings, lastchange")
				C_Timer.After(
					1,
					function()
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
					end
				)
			end
		)

		AddCategory("MINIMAP")
		AddCheckBox(4, "MINIMAP", false, ImproveAny.UpdateMinimapSettings)
		AddCheckBox(24, "MINIMAPHIDEBORDER", false, ImproveAny.UpdateMinimapSettings)
		AddCheckBox(24, "MINIMAPHIDEZOOMBUTTONS", false, ImproveAny.UpdateMinimapSettings)
		if ImproveAny:GetWoWBuild() ~= "RETAIL" then
			AddCheckBox(24, "MINIMAPSCROLLZOOM", false, ImproveAny.UpdateMinimapSettings)
		end

		AddCheckBox(24, "MINIMAPSHAPESQUARE", false, ImproveAny.UpdateMinimapSettings)
		AddCheckBox(24, "COMBINEMMBTNS", false, ImproveAny.UpdateMinimapSettings)
		AddCheckBox(24, "MINIMAPMINIMAPBUTTONSMOVABLE", false, ImproveAny.UpdateMinimapSettings)
		if ImproveAny:GetWoWBuild() == "RETAIL" then
			AddCheckBox(24, "SHOWVAULTMMBTN", true, ImproveAny.UpdateMinimapSettings)
		end

		AddCategory("ITEMLEVEL")
		AddCheckBox(4, "ITEMLEVELSYSTEM")
		AddCheckBox(24, "ITEMLEVELNUMBER", false, ImproveAny.UpdateILVLIcons)
		AddCheckBox(24, "ITEMLEVELBORDER", false, ImproveAny.UpdateILVLIcons)
		AddCategory("FRAMES")
		AddCheckBox(4, "WIDEFRAMES", false)
		AddCheckBox(4, "IMPROVETRADESKILLFRAME", true)
		AddCategory("FRAMEANCHOR")
		AddSlider(10, "TOP_OFFSET", 116, ImproveAny.UpdateUIParentAttribute, 0.0, 1000.0, 5, "FRAMEANCHOR")
		AddSlider(10, "LEFT_OFFSET", 16, ImproveAny.UpdateUIParentAttribute, 16.0, 1000.0, 5, "FRAMEANCHOR")
		AddSlider(10, "PANEl_SPACING_X", 32, ImproveAny.UpdateUIParentAttribute, 10.0, 300.0, 1, "FRAMEANCHOR")
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
		AddCheckBox(24, "MONEYBARPERHOUR", false)
		AddCheckBox(4, "TOKENBAR", false)
		AddCheckBox(4, "IAILVLBAR", false)
		AddCheckBox(4, "SKILLBARS", false)
		AddCheckBox(4, "CASTBAR", false)
		AddCheckBox(4, "DURABILITY", false)
		AddCheckBox(4, "RIGHTCLICKSELFCAST", false)
		AddSlider(24, "SHOWDURABILITYUNDER", 100, nil, 5, 100, 5)
		AddCheckBox(4, "WORLDMAP", false)
		if ImproveAny:GetWoWBuild() ~= "RETAIL" then
			AddCheckBox(24, "WORLDMAPZOOM", false)
		end

		AddCheckBox(24, "WORLDMAPCOORDSP", false)
		AddCheckBox(24, "WORLDMAPCOORDSC", false)
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
	IASettings.Search:SetScript(
		"OnTextChanged",
		function(sel, ...)
			searchStr = IASettings.Search:GetText()
			ImproveAny:UpdateElementList()
		end
	)

	IASettings.SF = CreateFrame("ScrollFrame", "IASettings_SF", IASettings, "UIPanelScrollFrameTemplate")
	IASettings.SF:SetPoint("TOPLEFT", IASettings, 8, -30 - 24)
	IASettings.SF:SetPoint("BOTTOMRIGHT", IASettings, -32, 24 + 8)
	IASettings.SC = CreateFrame("Frame", "IASettings_SC", IASettings.SF)
	IASettings.SC:SetSize(IASettings.SF:GetSize())
	IASettings.SC:SetPoint("TOPLEFT", IASettings.SF, "TOPLEFT", 0, 0)
	IASettings.SF:SetScrollChild(IASettings.SC)
	IASettings.SF.bg = IASettings.SF:CreateTexture("IASettings.SF.bg", "ARTWORK")
	IASettings.SF.bg:SetAllPoints(IASettings.SF)
	if IASettings.SF.bg.SetColorTexture then
		IASettings.SF.bg:SetColorTexture(0.03, 0.03, 0.03, 0.5)
	else
		IASettings.SF.bg:SetTexture(0.03, 0.03, 0.03, 0.5)
	end

	IASettings.save = CreateFrame("BUTTON", "IASettings" .. ".save", IASettings, "UIPanelButtonTemplate")
	IASettings.save:SetSize(120, 24)
	IASettings.save:SetPoint("TOPLEFT", IASettings, "TOPLEFT", 4, -IASettings:GetHeight() + 24 + 4)
	IASettings.save:SetText(SAVE)
	IASettings.save:SetScript(
		"OnClick",
		function()
			if C_UI then
				C_UI.Reload()
			else
				ReloadUi()
			end
		end
	)

	IASettings.save:Disable()
	IASettings.reload = CreateFrame("BUTTON", "IASettings" .. ".reload", IASettings, "UIPanelButtonTemplate")
	IASettings.reload:SetSize(120, 24)
	IASettings.reload:SetPoint("TOPLEFT", IASettings, "TOPLEFT", 4 + 120 + 4, -IASettings:GetHeight() + 24 + 4)
	IASettings.reload:SetText(RELOADUI)
	IASettings.reload:SetScript(
		"OnClick",
		function()
			if C_UI then
				C_UI.Reload()
			else
				ReloadUi()
			end
		end
	)

	IASettings.showerrors = CreateFrame("BUTTON", "IASettings" .. ".showerrors", IASettings, "UIPanelButtonTemplate")
	IASettings.showerrors:SetSize(120, 24)
	IASettings.showerrors:SetPoint("TOPLEFT", IASettings, "TOPLEFT", 4 + 120 + 4 + 120 + 4, -IASettings:GetHeight() + 24 + 4)
	IASettings.showerrors:SetText("Show Errors")
	IASettings.showerrors:SetScript(
		"OnClick",
		function()
			if GetCVar("ScriptErrors") == "0" then
				SetCVar("ScriptErrors", 1)
				if C_UI then
					C_UI.Reload()
				else
					ReloadUi()
				end
			end

			ImproveAny:UpdateShowErrors()
		end
	)

	function ImproveAny:UpdateShowErrors()
		if GetCVar("ScriptErrors") == "0" then
			IASettings.showerrors:Show()
		else
			IASettings.showerrors:Hide()
		end
	end

	ImproveAny:UpdateShowErrors()
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

function ImproveAny:CheckBlockedWords()
	if IATAB and ImproveAny:IAGV("BLOCKWORDS") and ImproveAny:IAGV("BLOCKWORDS") ~= "" and ImproveAny:IAGV("BLOCKWORDS") ~= " " then
		for i, v in pairs({string.split(",", ImproveAny:IAGV("BLOCKWORDS"))}) do
			if strlen(v) < 3 then
				ImproveAny:MSG("|cFFFF0000" .. "Blockword \"" .. v .. "\" is to short!")
			end
		end
	end
end

C_Timer.After(2, ImproveAny.CheckBlockedWords)
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
