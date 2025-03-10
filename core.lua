local _, ImproveAny = ...
-- TAINTFREE SLASH COMMANDS --
local lastMessage = ""
local cmds = {}
if ChatEdit_ParseText then
	hooksecurefunc(
		"ChatEdit_ParseText",
		function(editBox, send, parseIfNoSpace)
			if send == 0 then
				lastMessage = editBox:GetText()
			end
		end
	)
else
	ImproveAny:MSG("FAILED TO ADD SLASH HANDLE #1")
end

if ChatFrame_DisplayHelpTextSimple then
	hooksecurefunc(
		"ChatFrame_DisplayHelpTextSimple",
		function(frame)
			if lastMessage and lastMessage ~= "" then
				local cmd = string.upper(lastMessage)
				cmd = strsplit(" ", cmd)
				if cmds[cmd] ~= nil then
					local count = 1
					local numMessages = frame:GetNumMessages()
					local function predicateFunction(entry)
						if count == numMessages and entry == HELP_TEXT_SIMPLE then return true end
						count = count + 1
					end

					frame:RemoveMessagesByPredicate(predicateFunction)
					cmds[cmd]()
				end
			end
		end
	)
else
	ImproveAny:MSG("FAILED TO ADD SLASH HANDLE #2")
end

function ImproveAny:InitSlash()
	cmds["/IMPROVE"] = ImproveAny.ToggleSettings
	cmds["/IMPROVEANY"] = ImproveAny.ToggleSettings
	if C_UI then
		cmds["/RL"] = C_UI.Reload
		cmds["/REL"] = C_UI.Reload
	else
		cmds["/RL"] = ReloadUi
		cmds["/REL"] = ReloadUi
	end
end

-- TAINTFREE SLASH COMMANDS --
IAHIDDEN = CreateFrame("FRAME", "IAHIDDEN")
IAHIDDEN:Hide()
local IAMaxZoom = 5
function ImproveAny:GetMaxZoom()
	return IAMaxZoom
end

for i = 2.6, 5.0, 0.1 do
	ConsoleExec("cameraDistanceMaxZoomFactor " .. i)
end

IAMaxZoom = tonumber(GetCVar("cameraDistanceMaxZoomFactor")) or 4
function ImproveAny:UpdateMaxZoom()
	ConsoleExec("cameraDistanceMaxZoomFactor " .. ImproveAny:IAGV("MAXZOOM", ImproveAny:GetMaxZoom()))
end

function ImproveAny:UpdateWorldTextScale()
	ConsoleExec("WorldTextScale " .. ImproveAny:IAGV("WORLDTEXTSCALE", 1.0))
end

function ImproveAny:CheckCVars()
	if ImproveAny:IAGV("MAXZOOM", ImproveAny:GetMaxZoom()) ~= tonumber(GetCVar("cameraDistanceMaxZoomFactor")) then
		ImproveAny:UpdateMaxZoom()
	end

	if ImproveAny:IAGV("WORLDTEXTSCALE", 1.0) ~= tonumber(GetCVar("WorldTextScale")) then
		ImproveAny:UpdateWorldTextScale()
	end

	ImproveAny:Debug("CHECK CVARS", "retry")
	C_Timer.After(5, ImproveAny.CheckCVars)
end

function ImproveAny:AddRightClick()
	if not InCombatLockdown() then
		local bars = {"MainMenuBarArtFrame", "MultiBarBottomLeft", "MultiBarBottomRight", "MultiBarRight", "MultiBarLeft", "PossessBarFrame", "MAActionBar1", "MAActionBar2", "MAActionBar3", "MAActionBar4", "MAActionBar5", "MAActionBar6", "MAActionBar7", "MAActionBar8", "MAActionBar9", "MAActionBar10"}
		for i, v in ipairs(bars) do
			local bar = _G[v]
			if bar ~= nil then
				bar:SetAttribute("unit2", "player")
			end
		end
	else
		ImproveAny:Debug("AdddRightClick")
		C_Timer.After(0.1, ImproveAny.AddRightClick)
	end
end

function ImproveAny:IsOnActionbar(spellID)
	for i = 1, 120 do
		local actionType, id, _ = GetActionInfo(i)
		if actionType == "macro" then
			id = GetMacroSpell(id)
		end

		if id == spellID then return true end
	end

	if GetShapeshiftFormInfo then
		for i = 1, 10 do
			local _, _, _, id = GetShapeshiftFormInfo(i)
			if id == spellID then return true end
		end
	end

	return false
end

function ImproveAny:InitSpellBookFix()
	hooksecurefunc(
		"SpellBookFrame_UpdateSpells",
		function()
			for i = 1, SPELLS_PER_PAGE do
				local sel = _G["SpellButton" .. i]
				local slot, slotType = SpellBook_GetSpellBookSlot(sel)
				if slot and slotType ~= "FUTURESPELL" then
					local texture = GetSpellTexture(slot, SpellBookFrame.bookType)
					local spellName, _, spellID = GetSpellBookItemName(slot, SpellBookFrame.bookType)
					local isPassive = IsPassiveSpell(slot, SpellBookFrame.bookType)
					if isPassive or spellName == nil or texture == 134419 then
						sel:SetChecked(false)
					else
						if spellName and spellID and not ImproveAny:IsOnActionbar(spellID) then
							sel:SetChecked(true)
						else
							sel:SetChecked(false)
						end
					end
				else
					sel:SetChecked(false)
				end
			end
		end
	)
end

local warningEnhanceDressup = false
local warningEnhanceQuestLog = false
local warningEnhanceTrainers = false
function ImproveAny:Event(event, ...)
	if ImproveAny.Setup == nil then
		ImproveAny.Setup = true
		if ImproveAny:IsAddOnLoaded("D4KiR MoveAndImprove") then
			ImproveAny:MSG("DON'T use MoveAndImprove, when you use ImproveAny")
		end

		ImproveAny:InitSlash()
		ImproveAny:InitDB()
		ImproveAny:InitIASettings()
		if ImproveAny:IAGV("fontName", "Default") ~= "Default" and ImproveAny.Fonts then
			ImproveAny:Fonts()
		end

		if ImproveAny:IsEnabled("CASTBAR", false) and ImproveAny.InitCastBar then
			ImproveAny:InitCastBar()
		end

		if ImproveAny:IsEnabled("DURABILITY", false) and ImproveAny.InitDurabilityFrame then
			ImproveAny:InitDurabilityFrame()
		end

		local f = CreateFrame("Frame")
		f:RegisterEvent("MERCHANT_SHOW")
		f:SetScript(
			"OnEvent",
			function(sel)
				if ImproveAny:IsEnabled("AUTOSELLJUNK", true) then
					for bag = 0, 4 do
						for slot = 1, C_Container.GetContainerNumSlots(bag) do
							local itemLink = C_Container.GetContainerItemLink(bag, slot)
							if itemLink then
								local _, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(itemLink)
								if itemRarity == 0 and itemSellPrice > 0 then
									C_Container.UseContainerItem(bag, slot) -- Sell the item
								end
							end
						end
					end
				end

				if ImproveAny:IsEnabled("AUTOREPAIR", true) and CanMerchantRepair() then
					local repairCost, canRepair = GetRepairAllCost()
					if canRepair and repairCost > 0 then
						RepairAllItems()
					end
				end
			end
		)

		if ImproveAny.InitItemLevel then
			ImproveAny:InitItemLevel()
		end

		if ImproveAny.InitMinimap then
			ImproveAny:InitMinimap()
		end

		if ImproveAny.InitMoneyBar then
			ImproveAny:InitMoneyBar()
		end

		if ImproveAny.InitTokenBar then
			ImproveAny:InitTokenBar()
		end

		if ImproveAny.InitIAILVLBar then
			ImproveAny:InitIAILVLBar()
		end

		if ImproveAny.InitSkillBars then
			ImproveAny:InitSkillBars()
		end

		if ImproveAny.InitBags then
			ImproveAny:InitBags()
		end

		if ImproveAny:IsEnabled("WORLDMAP", false) and ImproveAny.InitWorldMapFrame then
			ImproveAny:InitWorldMapFrame()
		end

		if (ImproveAny:IsEnabled("AUTOACCEPTQUESTS", false) or ImproveAny:IsEnabled("AUTOCHECKINQUESTS", false)) and ImproveAny.InitAutoAcceptQuests then
			ImproveAny:InitAutoAcceptQuests()
		end

		if ImproveAny.InitCombatText then
			ImproveAny:InitCombatText()
		end

		if ImproveAny.InitXPBar then
			ImproveAny:InitXPBar()
		end

		if ImproveAny.InitSuperTrackedFrame then
			ImproveAny:InitSuperTrackedFrame()
		end

		if ImproveAny.InitMicroMenu then
			ImproveAny:InitMicroMenu()
		end

		if ImproveAny.InitRaidFrames then
			ImproveAny:InitRaidFrames()
		end

		if ImproveAny.InitPartyFrames then
			ImproveAny:InitPartyFrames()
		end

		if ImproveAny.InitLFGFrame then
			ImproveAny:InitLFGFrame()
		end

		if ImproveAny.UpdateUIParentAttribute then
			ImproveAny:UpdateUIParentAttribute()
		end

		if ImproveAny.UpdateStatusBar then
			ImproveAny:UpdateStatusBar()
		end

		if ImproveAny.InitIAPingFrame then
			ImproveAny:InitIAPingFrame()
		end

		if ImproveAny.InitIACoordsFrame then
			ImproveAny:InitIACoordsFrame()
		end

		if ImproveAny:GetWoWBuild() ~= "RETAIL" then
			ImproveAny:InitSpellBookFix()
		end

		IATAB["VERSION"] = IATAB["VERSION"] or 0
		if IATAB["VERSION"] < 1 then
			IATAB["VERSION"] = 1
			ImproveAny:MSG(ImproveAny:GT("NEW") .. ":", ImproveAny:GT("AUTOSELLJUNK"))
			ImproveAny:MSG(ImproveAny:GT("NEW") .. ":", ImproveAny:GT("AUTOREPAIR"))
		end

		if CharacterFrameExpandButton and ImproveAny:IsEnabled("CHARACTERFRAMEAUTOEXPAND", true) then
			if CharacterFrame then
				CharacterFrame:HookScript(
					"OnShow",
					function()
						CharacterFrameExpandButton:Click()
					end
				)
			end

			if CharacterFrameTab1 then
				CharacterFrameTab1:HookScript(
					"OnClick",
					function()
						CharacterFrameExpandButton:Click()
					end
				)
			end
		end

		if ImproveAny:IsEnabled("RIGHTCLICKSELFCAST", false) then
			ImproveAny:Debug("RIGHTCLICKSELFCAST")
			C_Timer.After(
				2,
				function()
					ImproveAny:AddRightClick()
				end
			)
		end

		function ImproveAny:UpdateMinimapButton()
			if ImproveAny:IsEnabled("SHOWMINIMAPBUTTON", ImproveAny:GetWoWBuild() ~= "RETAIL") then
				ImproveAny:ShowMMBtn("ImproveAny")
			else
				ImproveAny:HideMMBtn("ImproveAny")
			end
		end

		if ExtraActionButton1 and ExtraActionButton1.style and ImproveAny:IsEnabled("HIDEEXTRAACTIONBUTTONARTWORK", false) then
			hooksecurefunc(
				ExtraActionButton1.style,
				"Show",
				function(sel, ...)
					sel:Hide()
				end
			)

			ExtraActionButton1.style:Hide()
		end

		local mmbtn = nil
		ImproveAny:CreateMinimapButton(
			{
				["name"] = "ImproveAny",
				["icon"] = 136033,
				["var"] = mmbtn,
				["dbtab"] = IATAB,
				["vTT"] = {{"|T136033:16:16:0:0|t I|cff3FC7EBmprove|rA|cff3FC7EBny|r", "v|cff3FC7EB" .. ImproveAny:GetVersion()}, {ImproveAny:Trans("LID_LEFTCLICK"), ImproveAny:Trans("LID_OPENSETTINGS")}, {ImproveAny:Trans("LID_RIGHTCLICK"), ImproveAny:Trans("LID_HIDEMINIMAPBUTTON")}},
				["funcL"] = function()
					ImproveAny:ToggleSettings()
				end,
				["funcR"] = function()
					ImproveAny:MSG("Minimap Button is now hidden.")
					ImproveAny:SetEnabled("SHOWMINIMAPBUTTON", false)
					ImproveAny:HideMMBtn("ImproveAny")
				end,
				["dbkey"] = "SHOWMINIMAPBUTTON"
			}
		)

		ImproveAny:UpdateMaxZoom()
		ImproveAny:UpdateWorldTextScale()
		ImproveAny:CheckCVars()
		if ImproveAny:IsEnabled("HIDEPVPBADGE", false) then
			if PlayerFrame and PlayerFrame.PlayerFrameContent and PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual then
				hooksecurefunc(
					PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait,
					"Show",
					function(sel)
						sel:Hide()
					end
				)

				PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait:Hide()
				hooksecurefunc(
					PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge,
					"Show",
					function(sel)
						sel:Hide()
					end
				)

				PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge:Hide()
			end

			if TargetFrame and TargetFrame.TargetFrameContent and TargetFrame.TargetFrameContent.TargetFrameContentContextual then
				hooksecurefunc(
					TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait,
					"Show",
					function(sel)
						sel:Hide()
					end
				)

				TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait:Hide()
				hooksecurefunc(
					TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge,
					"Show",
					function(sel)
						sel:Hide()
					end
				)

				TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge:Hide()
			end

			if FocusFrame and FocusFrame.TargetFrameContent and FocusFrame.TargetFrameContent.TargetFrameContentContextual then
				hooksecurefunc(
					FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait,
					"Show",
					function(sel)
						sel:Hide()
					end
				)

				FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait:Hide()
				hooksecurefunc(
					FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge,
					"Show",
					function(sel)
						sel:Hide()
					end
				)

				FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge:Hide()
			end

			if PlayerPVPIcon then
				hooksecurefunc(
					PlayerPVPIcon,
					"Show",
					function(sel)
						sel:Hide()
					end
				)

				PlayerPVPIcon:Hide()
			end

			if TargetFrameTextureFramePVPIcon then
				hooksecurefunc(
					TargetFrameTextureFramePVPIcon,
					"Show",
					function(sel)
						sel:Hide()
					end
				)

				TargetFrameTextureFramePVPIcon:Hide()
			end

			if FocusFrameTextureFramePVPIcon then
				hooksecurefunc(
					FocusFrameTextureFramePVPIcon,
					"Show",
					function(sel)
						sel:Hide()
					end
				)

				FocusFrameTextureFramePVPIcon:Hide()
			end
		end

		local tts = {GameTooltip, ItemRefTooltip, ItemRefShoppingTooltip1, ItemRefShoppingTooltip2, ShoppingTooltip1, ShoppingTooltip2, EmbeddedItemTooltip,}
		local function OnTooltipSetItem(tt, data)
			if not tContains(tts, tt) then return end
			local spellID = nil
			local itemId = nil
			if tt.GetTooltipData then
				local tooltipData = tt:GetTooltipData()
				if tooltipData and tooltipData.id then
					if tooltipData.type == 0 then
						itemId = tooltipData.id
					elseif tooltipData.type == 1 then
						spellID = tooltipData.id
					end
				end
			else
				if tt.GetSpell then
					_, spellID = tt:GetSpell()
				else
					local _, itemLink = tt:GetItem()
					if itemLink then
						itemId = string.match(itemLink, "item:(%d*)")
					end
				end
			end

			if spellID and ImproveAny:IsEnabled("SETTINGS", false) then
				tt:AddDoubleLine("SpellID" .. ":", "|cFFFFFFFF" .. spellID)
			end

			if itemId then
				local _, _, _, _, _, _, _, itemStackCount, _, _, price, _, _, _, expacID, _, _ = ImproveAny:GetItemInfo(itemId)
				if expacID and ImproveAny:IsEnabled("TOOLTIPEXPANSION", false) then
					local textcolor = "|cFFFF1111"
					if expacID >= GetExpansionLevel() then
						textcolor = "|cFF11FF11"
					end

					if ImproveAny:GetWoWBuild() == "RETAIL" and expacID < GetExpansionLevel() then
						tt:AddDoubleLine(ImproveAny:GT("ADDEDIN"), format(ImproveAny:GT("EXPANSION"), textcolor, _G["EXPANSION_NAME" .. expacID]))
					end
				end

				if price and tt.shownMoneyFrames == nil and price > 0 and GetItemCount and GetCoinTextureString then
					local count = GetItemCount(itemId)
					if ImproveAny:IsEnabled("TOOLTIPSELLPRICE", false) then
						if count and count > 1 and itemStackCount and AUCTION_BROWSE_UNIT_PRICE_SORT then
							tt:AddDoubleLine(AUCTION_BROWSE_UNIT_PRICE_SORT .. "", GetCoinTextureString(price))
							tt:AddDoubleLine(SELL_PRICE .. " (" .. count .. "/" .. itemStackCount .. ")", GetCoinTextureString(price * count))
						else
							tt:AddDoubleLine(SELL_PRICE .. ":", GetCoinTextureString(price))
						end
					end
				end
			end
		end

		if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall then
			TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
			TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, OnTooltipSetItem)
		else
			for _, frame in pairs{GameTooltip, ItemRefTooltip, WhatevahTooltip} do
				if frame then
					frame:HookScript(
						"OnTooltipSetSpell",
						function(tt)
							local _, spellID = tt:GetSpell()
							if spellID and ImproveAny:IsEnabled("SETTINGS", false) then
								tt:AddDoubleLine("SpellID" .. ":", "|cFFFFFFFF" .. spellID)
							end
						end
					)
				end
			end

			for _, frame in pairs{GameTooltip, ItemRefTooltip, WhatevahTooltip} do
				if frame then
					frame:HookScript(
						"OnTooltipSetItem",
						function(tt)
							local _, itemLink = tt:GetItem()
							if itemLink then
								local itemId = tonumber(strmatch(itemLink, "item:(%d*)"))
								if itemId then
									local _, _, _, _, _, _, _, itemStackCount, _, _, price, _, _, _, _, _, _ = ImproveAny:GetItemInfo(itemId)
									if price and tt.shownMoneyFrames == nil and price > 0 and GetItemCount and GetCoinTextureString then
										local count = GetItemCount(itemId)
										if ImproveAny:IsEnabled("TOOLTIPSELLPRICE", false) then
											if count and count > 1 and itemStackCount and AUCTION_BROWSE_UNIT_PRICE_SORT then
												tt:AddDoubleLine(AUCTION_BROWSE_UNIT_PRICE_SORT .. "", GetCoinTextureString(price))
												tt:AddDoubleLine(SELL_PRICE .. " (" .. count .. "/" .. itemStackCount .. ")", GetCoinTextureString(price * count))
											else
												tt:AddDoubleLine(SELL_PRICE .. ":", GetCoinTextureString(price))
											end
										end
									end
								end
							end
						end
					)
				end
			end
		end

		local ids = {}
		ids[138019] = 1 -- Mythic Legion				Added in patch 7.1.5.23360
		ids[158923] = 1 -- Mythic BFA 					Added in patch 8.0.1.26903
		ids[180653] = 1 -- Mythic SL, DF 				Added in patch 9.0.1.36216
		ids[151086] = 1 -- Mythic Invitational Keystone	Added in patch 9.2.0.42698
		ids[186159] = 1 -- Mythic DF? 					Added in patch 10.0.0.44592
		local MythicAuto = CreateFrame("Frame")
		MythicAuto:RegisterEvent("ADDON_LOADED")
		MythicAuto:SetScript(
			"OnEvent",
			function(sel, event2, addon)
				if addon ~= "Blizzard_ChallengesUI" then return end
				if ChallengesKeystoneFrame then
					ChallengesKeystoneFrame:HookScript(
						"OnShow",
						function()
							for bagId = 0, Constants.InventoryConstants.NumBagSlots do
								for slotId = 1, C_Container.GetContainerNumSlots(bagId) do
									local id = C_Container.GetContainerItemID(bagId, slotId)
									if id and ids[id] then return C_Container.UseContainerItem(bagId, slotId) end
								end
							end
						end
					)

					sel:UnregisterEvent(event2)
				end
			end
		)

		if ImproveAny:GetWoWBuild() ~= "RETAIL" and ImproveAny:IsEnabled("WIDEFRAMES", false) then
			if not warningEnhanceDressup and LeaPlusDB and LeaPlusDB["EnhanceDressup"] and LeaPlusDB["EnhanceDressup"] == "On" then
				ImproveAny:MSG("LeatrixPlus \"EnhanceDressup\" is enabled, may break WideFrames")
				warningEnhanceDressup = true
			end

			if not warningEnhanceQuestLog and LeaPlusDB and LeaPlusDB["EnhanceQuestLog"] and LeaPlusDB["EnhanceQuestLog"] == "On" then
				ImproveAny:MSG("LeatrixPlus \"EnhanceQuestLog\" is enabled, may break WideFrames")
				warningEnhanceQuestLog = true
			end

			if not warningEnhanceTrainers and LeaPlusDB and LeaPlusDB["EnhanceTrainers"] and LeaPlusDB["EnhanceTrainers"] == "On" then
				ImproveAny:MSG("LeatrixPlus \"EnhanceTrainers\" is enabled, may break WideFrames")
				warningEnhanceTrainers = true
			end

			if ImproveAny:GetWoWBuild() == "CLASSIC" then
				local tall, numTallQuests = 74, 22
				UIPanelWindows["QuestLogFrame"] = {
					area = "override",
					pushable = 0,
					xoffset = -16,
					yoffset = 12,
					bottomClampOverride = 140 + 12,
					width = 714,
					height = 487,
					whileDead = 1
				}

				QuestLogFrame:SetWidth(714)
				QuestLogFrame:SetHeight(487 + tall)
				QuestLogTitleText:ClearAllPoints()
				QuestLogTitleText:SetPoint("TOP", QuestLogFrame, "TOP", 0, -17)
				QuestLogDetailScrollFrame:ClearAllPoints()
				QuestLogDetailScrollFrame:SetPoint("TOPLEFT", QuestLogListScrollFrame, "TOPRIGHT", 31, 1)
				QuestLogDetailScrollFrame:SetHeight(336 + tall)
				QuestLogListScrollFrame:SetHeight(336 + tall)
				local oldQuestsDisplayed = QUESTS_DISPLAYED
				_G.QUESTS_DISPLAYED = _G.QUESTS_DISPLAYED + numTallQuests
				for i = oldQuestsDisplayed + 1, QUESTS_DISPLAYED do
					local button = CreateFrame("Button", "QuestLogTitle" .. i, QuestLogFrame, "QuestLogTitleButtonTemplate")
					button:SetID(i)
					button:Hide()
					button:ClearAllPoints()
					button:SetPoint("TOPLEFT", _G["QuestLogTitle" .. (i - 1)], "BOTTOMLEFT", 0, 1)
				end

				local regions = {QuestLogFrame:GetRegions()}
				regions[3]:SetSize(1024, 512)
				regions[3]:SetTexture("Interface\\AddOns\\ImproveAny\\media\\wideframe")
				regions[3]:SetTexCoord(0, 1, 0, 1)
				regions[4].Show = regions[4].Hide
				regions[4]:Hide()
				for i = 5, 6 do
					if regions[i] then
						regions[i]:Hide()
					end
				end

				QuestLogFrameAbandonButton:SetSize(110, 21)
				QuestLogFrameAbandonButton:SetText(ABANDON_QUEST_ABBREV)
				QuestLogFrameAbandonButton:ClearAllPoints()
				QuestLogFrameAbandonButton:SetPoint("BOTTOMLEFT", QuestLogFrame, "BOTTOMLEFT", 17, 54)
				QuestFramePushQuestButton:SetSize(100, 21)
				QuestFramePushQuestButton:SetText(SHARE_QUEST_ABBREV)
				QuestFramePushQuestButton:ClearAllPoints()
				QuestFramePushQuestButton:SetPoint("LEFT", QuestLogFrameAbandonButton, "RIGHT", -3, 0)
				local mapButton = CreateFrame("Button", nil, QuestLogFrame, "UIPanelButtonTemplate")
				mapButton:SetText("Map")
				mapButton:ClearAllPoints()
				mapButton:SetPoint("LEFT", QuestFramePushQuestButton, "RIGHT", -3, 0)
				mapButton:SetSize(100, 21)
				mapButton:SetScript("OnClick", ToggleWorldMap)
				if QuestFrameExitButton then
					QuestFrameExitButton:SetSize(80, 22)
					QuestFrameExitButton:SetText(CLOSE)
					QuestFrameExitButton:ClearAllPoints()
					QuestFrameExitButton:SetPoint("BOTTOMRIGHT", QuestLogFrame, "BOTTOMRIGHT", -42, 54)
				end

				QuestLogNoQuestsText:ClearAllPoints()
				QuestLogNoQuestsText:SetPoint("TOP", QuestLogListScrollFrame, 0, -50)
				hooksecurefunc(
					EmptyQuestLogFrame,
					"Show",
					function()
						EmptyQuestLogFrame:ClearAllPoints()
						EmptyQuestLogFrame:SetPoint("BOTTOMLEFT", QuestLogFrame, "BOTTOMLEFT", 20, -76)
						EmptyQuestLogFrame:SetHeight(487)
					end
				)
			end

			if true then
				local tall, numTallProfs = 73, 19
				local function TradeSkillFunc(frame)
					UIPanelWindows["TradeSkillFrame"] = {
						area = "override",
						pushable = 1,
						xoffset = -16,
						yoffset = 12,
						bottomClampOverride = 140 + 12,
						width = 714,
						height = 487,
						whileDead = 1
					}

					_G["TradeSkillFrame"]:SetWidth(714)
					_G["TradeSkillFrame"]:SetHeight(487 + tall)
					_G["TradeSkillFrameTitleText"]:ClearAllPoints()
					_G["TradeSkillFrameTitleText"]:SetPoint("TOP", _G["TradeSkillFrame"], "TOP", 0, -18)
					_G["TradeSkillListScrollFrame"]:ClearAllPoints()
					_G["TradeSkillListScrollFrame"]:SetPoint("TOPLEFT", _G["TradeSkillFrame"], "TOPLEFT", 25, -75)
					_G["TradeSkillListScrollFrame"]:SetSize(295, 336 + tall)
					local oldTradeSkillsDisplayed = TRADE_SKILLS_DISPLAYED
					for i = 1 + 1, TRADE_SKILLS_DISPLAYED do
						_G["TradeSkillSkill" .. i]:ClearAllPoints()
						_G["TradeSkillSkill" .. i]:SetPoint("TOPLEFT", _G["TradeSkillSkill" .. (i - 1)], "BOTTOMLEFT", 0, 1)
					end

					_G.TRADE_SKILLS_DISPLAYED = _G.TRADE_SKILLS_DISPLAYED + numTallProfs
					for i = oldTradeSkillsDisplayed + 1, TRADE_SKILLS_DISPLAYED do
						local button = CreateFrame("Button", "TradeSkillSkill" .. i, TradeSkillFrame, "TradeSkillSkillButtonTemplate")
						button:SetID(i)
						button:Hide()
						button:ClearAllPoints()
						button:SetPoint("TOPLEFT", _G["TradeSkillSkill" .. (i - 1)], "BOTTOMLEFT", 0, 1)
					end

					hooksecurefunc(
						_G["TradeSkillHighlightFrame"],
						"Show",
						function()
							_G["TradeSkillHighlightFrame"]:SetWidth(290)
						end
					)

					_G["TradeSkillDetailScrollFrame"]:ClearAllPoints()
					_G["TradeSkillDetailScrollFrame"]:SetPoint("TOPLEFT", _G["TradeSkillFrame"], "TOPLEFT", 352, -74)
					_G["TradeSkillDetailScrollFrame"]:SetSize(298, 336 + tall)
					_G["TradeSkillDetailScrollFrameTop"]:SetAlpha(0)
					_G["TradeSkillDetailScrollFrameBottom"]:SetAlpha(0)
					local RecipeInset = _G["TradeSkillFrame"]:CreateTexture(nil, "ARTWORK")
					RecipeInset:SetSize(304, 361 + tall)
					RecipeInset:SetPoint("TOPLEFT", _G["TradeSkillFrame"], "TOPLEFT", 16, -72)
					RecipeInset:SetTexture("Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg")
					local DetailsInset = _G["TradeSkillFrame"]:CreateTexture(nil, "ARTWORK")
					DetailsInset:SetSize(302, 339 + tall)
					DetailsInset:SetPoint("TOPLEFT", _G["TradeSkillFrame"], "TOPLEFT", 348, -72)
					DetailsInset:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated")
					_G["TradeSkillExpandTabLeft"]:Hide()
					local regions = {_G["TradeSkillFrame"]:GetRegions()}
					for i, v in pairs(regions) do
						if i > 1 then
							if ImproveAny:GetWoWBuild() == "CLASSIC" then
								if i == 2 then
									regions[i]:SetSize(1024, 512)
									regions[i]:SetTexture("Interface\\AddOns\\ImproveAny\\media\\wideframe")
									regions[i]:SetTexCoord(0, 1, 0, 1)
								elseif i == 3 then
									regions[i].Show = regions[i].Hide
									regions[i]:Hide()
								elseif regions[i] then
									regions[i]:Hide()
								end
							else
								if i == 3 then
									regions[i]:SetSize(1024, 512)
									regions[i]:SetTexture("Interface\\AddOns\\ImproveAny\\media\\wideframe")
									regions[i]:SetTexCoord(0, 1, 0, 1)
								elseif i == 4 then
									regions[i].Show = regions[i].Hide
									regions[i]:Hide()
								elseif regions[i] then
									regions[i]:Hide()
								end
							end
						end
					end

					if TradeSkillRankFrame and TradeSkillLinkButton then
						TradeSkillLinkButton:ClearAllPoints()
						TradeSkillLinkButton:SetPoint("TOP", TradeSkillFrame, "TOP", 0, -15)
					end

					if TradeSkillRankFrame and TradeSkillRankFrameSkillRank then
						TradeSkillRankFrameSkillRank:ClearAllPoints()
						TradeSkillRankFrameSkillRank:SetPoint("CENTER", TradeSkillRankFrame, "CENTER", 0, 0)
					end

					_G["TradeSkillCreateButton"]:ClearAllPoints()
					_G["TradeSkillCreateButton"]:SetPoint("RIGHT", _G["TradeSkillCancelButton"], "LEFT", -1, 0)
					_G["TradeSkillCancelButton"]:SetSize(80, 22)
					_G["TradeSkillCancelButton"]:SetText(CLOSE)
					_G["TradeSkillCancelButton"]:ClearAllPoints()
					_G["TradeSkillCancelButton"]:SetPoint("BOTTOMRIGHT", _G["TradeSkillFrame"], "BOTTOMRIGHT", -42, 54)
					_G["TradeSkillFrameCloseButton"]:ClearAllPoints()
					_G["TradeSkillFrameCloseButton"]:SetPoint("TOPRIGHT", _G["TradeSkillFrame"], "TOPRIGHT", -30, -8)
					if TradeSkillInvSlotDropDown then
						TradeSkillInvSlotDropDown:ClearAllPoints()
						TradeSkillInvSlotDropDown:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 510, -40)
					elseif TradeSkillInvSlotDropdown then
						TradeSkillInvSlotDropdown:ClearAllPoints()
						TradeSkillInvSlotDropdown:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 510, -40)
					end

					if TradeSkillSubClassDropDown then
						TradeSkillSubClassDropDown:ClearAllPoints()
						TradeSkillSubClassDropDown:SetPoint("RIGHT", TradeSkillInvSlotDropDown, "LEFT", 0, 0)
					elseif TradeSkillSubClassDropdown then
						TradeSkillSubClassDropdown:ClearAllPoints()
						TradeSkillSubClassDropdown:SetPoint("RIGHT", TradeSkillInvSlotDropdown, "LEFT", 0, -0)
					end

					if ImproveAny:IsAddOnLoaded("ClassicProfessionFilter") and TradeSkillFrame.SearchBox and TradeSkillFrame.HaveMats and TradeSkillFrame.HaveMats.text and ImproveAny:GetWoWBuild() ~= "RETAIL" and ImproveAny:GetWoWBuild() ~= "CATA" then
						TradeSkillFrame.SearchBox:ClearAllPoints()
						TradeSkillFrame.SearchBox:SetPoint("LEFT", TradeSkillRankFrame, "RIGHT", 20, -10)
						TradeSkillFrame.HaveMats:ClearAllPoints()
						TradeSkillFrame.HaveMats:SetPoint("LEFT", TradeSkillFrame.SearchBox, "RIGHT", 10, 8)
						TradeSkillFrame.HaveMats.text:SetText("Have Materials?")
						TradeSkillFrame.HaveMats:SetHitRectInsets(0, -TradeSkillFrame.HaveMats.text:GetStringWidth() + 4, 0, 0)
						TradeSkillFrame.HaveMats.text:SetJustifyH("LEFT")
						TradeSkillFrame.HaveMats.text:SetWordWrap(false)
						if TradeSkillFrame.HaveMats.text:GetWidth() > 80 then
							TradeSkillFrame.HaveMats.text:SetWidth(80)
							TradeSkillFrame.HaveMats:SetHitRectInsets(0, -80 + 4, 0, 0)
						end

						TradeSkillFrame.SearchMats:ClearAllPoints()
						TradeSkillFrame.SearchMats:SetPoint("BOTTOMLEFT", TradeSkillFrame.HaveMats, "BOTTOMLEFT", 0, -16)
						TradeSkillFrame.SearchMats.text:SetText("Search")
						TradeSkillFrame.SearchMats:SetHitRectInsets(0, -TradeSkillFrame.SearchMats.text:GetStringWidth() + 2, 0, 0)
						TradeSkillFrame.SearchMats.text:SetJustifyH("LEFT")
						TradeSkillFrame.SearchMats.text:SetWordWrap(false)
						if TradeSkillFrame.SearchMats.text:GetWidth() > 80 then
							TradeSkillFrame.SearchMats.text:SetWidth(80)
							TradeSkillFrame.SearchMats:SetHitRectInsets(0, -80 + 4, 0, 0)
						end
					end
				end

				if ImproveAny:IsAddOnLoaded("Blizzard_TradeSkillUI") then
					TradeSkillFunc("TradeSkill")
				else
					local waitFrame = CreateFrame("FRAME")
					waitFrame:RegisterEvent("ADDON_LOADED")
					waitFrame:SetScript(
						"OnEvent",
						function(sel, even, arg1)
							if arg1 == "Blizzard_TradeSkillUI" then
								TradeSkillFunc("TradeSkill")
								waitFrame:UnregisterAllEvents()
							end
						end
					)
				end

				local function CraftFunc()
					UIPanelWindows["CraftFrame"] = {
						area = "override",
						pushable = 1,
						xoffset = -16,
						yoffset = 12,
						bottomClampOverride = 140 + 12,
						width = 714,
						height = 487,
						whileDead = 1
					}

					_G["CraftFrame"]:SetWidth(714)
					_G["CraftFrame"]:SetHeight(487 + tall)
					_G["CraftFrameTitleText"]:ClearAllPoints()
					_G["CraftFrameTitleText"]:SetPoint("TOP", _G["CraftFrame"], "TOP", 0, -18)
					_G["CraftListScrollFrame"]:ClearAllPoints()
					_G["CraftListScrollFrame"]:SetPoint("TOPLEFT", _G["CraftFrame"], "TOPLEFT", 25, -75)
					_G["CraftListScrollFrame"]:SetSize(295, 336 + tall)
					local oldCraftsDisplayed = CRAFTS_DISPLAYED
					_G["Craft1Cost"]:ClearAllPoints()
					_G["Craft1Cost"]:SetPoint("RIGHT", _G["Craft1"], "RIGHT", -30, 0)
					for i = 1 + 1, CRAFTS_DISPLAYED do
						_G["Craft" .. i]:ClearAllPoints()
						_G["Craft" .. i]:SetPoint("TOPLEFT", _G["Craft" .. (i - 1)], "BOTTOMLEFT", 0, 1)
						_G["Craft" .. i .. "Cost"]:ClearAllPoints()
						_G["Craft" .. i .. "Cost"]:SetPoint("RIGHT", _G["Craft" .. i], "RIGHT", -30, 0)
					end

					_G.CRAFTS_DISPLAYED = _G.CRAFTS_DISPLAYED + numTallProfs
					for i = oldCraftsDisplayed + 1, CRAFTS_DISPLAYED do
						local button = CreateFrame("Button", "Craft" .. i, CraftFrame, "CraftButtonTemplate")
						button:SetID(i)
						button:Hide()
						button:ClearAllPoints()
						button:SetPoint("TOPLEFT", _G["Craft" .. (i - 1)], "BOTTOMLEFT", 0, 1)
						_G["Craft" .. i .. "Cost"]:ClearAllPoints()
						_G["Craft" .. i .. "Cost"]:SetPoint("RIGHT", _G["Craft" .. i], "RIGHT", -30, 0)
					end

					CraftFramePointsLabel:ClearAllPoints()
					CraftFramePointsLabel:SetPoint("TOPLEFT", CraftFrame, "TOPLEFT", 100, -50)
					CraftFramePointsText:ClearAllPoints()
					CraftFramePointsText:SetPoint("LEFT", CraftFramePointsLabel, "RIGHT", 3, 0)
					hooksecurefunc(
						"CraftFrame_Update",
						function()
							for i = 1, CRAFTS_DISPLAYED do
								if _G["Craft" .. i] then
									local craftButtonCost = _G["Craft" .. i .. "Cost"]
									if craftButtonCost then
										craftButtonCost:SetPoint("RIGHT", -30, 0)
									end
								end
							end
						end
					)

					hooksecurefunc(
						_G["CraftHighlightFrame"],
						"Show",
						function()
							_G["CraftHighlightFrame"]:SetWidth(290)
						end
					)

					_G["CraftDetailScrollFrame"]:ClearAllPoints()
					_G["CraftDetailScrollFrame"]:SetPoint("TOPLEFT", _G["CraftFrame"], "TOPLEFT", 352, -74)
					_G["CraftDetailScrollFrame"]:SetSize(298, 336 + tall)
					_G["CraftDetailScrollFrameTop"]:SetAlpha(0)
					_G["CraftDetailScrollFrameBottom"]:SetAlpha(0)
					local RecipeInset = _G["CraftFrame"]:CreateTexture(nil, "ARTWORK")
					RecipeInset:SetSize(304, 361 + tall)
					RecipeInset:SetPoint("TOPLEFT", _G["CraftFrame"], "TOPLEFT", 16, -72)
					RecipeInset:SetTexture("Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg")
					local DetailsInset = _G["CraftFrame"]:CreateTexture(nil, "ARTWORK")
					DetailsInset:SetSize(302, 339 + tall)
					DetailsInset:SetPoint("TOPLEFT", _G["CraftFrame"], "TOPLEFT", 348, -72)
					DetailsInset:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated")
					_G["CraftExpandTabLeft"]:Hide()
					local regions = {_G["CraftFrame"]:GetRegions()}
					regions[2]:SetSize(1024, 512)
					regions[2]:SetTexture("Interface\\AddOns\\ImproveAny\\media\\wideframe")
					regions[2]:SetTexCoord(0, 1, 0, 1)
					regions[3].Show = regions[3].Hide
					regions[3]:Hide()
					for i = 4, 10 do
						if regions[i] then
							regions[i]:Hide()
						end
					end

					_G["CraftCreateButton"]:ClearAllPoints()
					_G["CraftCreateButton"]:SetPoint("RIGHT", _G["CraftCancelButton"], "LEFT", -1, 0)
					_G["CraftCancelButton"]:SetSize(80, 22)
					_G["CraftCancelButton"]:SetText(CLOSE)
					_G["CraftCancelButton"]:ClearAllPoints()
					_G["CraftCancelButton"]:SetPoint("BOTTOMRIGHT", _G["CraftFrame"], "BOTTOMRIGHT", -42, 54)
					_G["CraftFrameCloseButton"]:ClearAllPoints()
					_G["CraftFrameCloseButton"]:SetPoint("TOPRIGHT", _G["CraftFrame"], "TOPRIGHT", -30, -8)
					hooksecurefunc(
						CraftCreateButton,
						"SetFrameLevel",
						function()
							CraftCreateButton:ClearAllPoints()
							CraftCreateButton:SetPoint("RIGHT", CraftCancelButton, "LEFT", -1, 0)
						end
					)

					if ImproveAny:IsAddOnLoaded("ClassicProfessionFilter") and CraftFrame.SearchBox and CraftFrame.HaveMats and CraftFrame.HaveMats.text and CraftFrame.SearchMats and CraftFrame.SearchMats.text then
						CraftFrame.SearchBox:ClearAllPoints()
						CraftFrame.SearchBox:SetPoint("LEFT", CraftRankFrame, "RIGHT", 20, -10)
						CraftFrame.HaveMats:ClearAllPoints()
						CraftFrame.HaveMats:SetPoint("LEFT", CraftFrame.SearchBox, "RIGHT", 10, 8)
						CraftFrame.HaveMats.text:SetText("Have Materials?")
						CraftFrame.HaveMats:SetHitRectInsets(0, -CraftFrame.HaveMats.text:GetStringWidth() + 4, 0, 0)
						CraftFrame.HaveMats.text:SetJustifyH("LEFT")
						CraftFrame.HaveMats.text:SetWordWrap(false)
						if CraftFrame.HaveMats.text:GetWidth() > 80 then
							CraftFrame.HaveMats.text:SetWidth(80)
							CraftFrame.HaveMats:SetHitRectInsets(0, -80 + 4, 0, 0)
						end

						CraftFrame.SearchMats:ClearAllPoints()
						CraftFrame.SearchMats:SetPoint("BOTTOMLEFT", CraftFrame.HaveMats, "BOTTOMLEFT", 0, -16)
						CraftFrame.SearchMats.text:SetText("Search")
						CraftFrame.SearchMats:SetHitRectInsets(0, -CraftFrame.SearchMats.text:GetStringWidth() + 2, 0, 0)
						CraftFrame.SearchMats.text:SetJustifyH("LEFT")
						CraftFrame.SearchMats.text:SetWordWrap(false)
						if CraftFrame.SearchMats.text:GetWidth() > 80 then
							CraftFrame.SearchMats.text:SetWidth(80)
							CraftFrame.SearchMats:SetHitRectInsets(0, -80 + 4, 0, 0)
						end
					end
				end

				if ImproveAny:IsAddOnLoaded("Blizzard_CraftUI") then
					CraftFunc()
				else
					local waitFrame = CreateFrame("FRAME")
					waitFrame:RegisterEvent("ADDON_LOADED")
					waitFrame:SetScript(
						"OnEvent",
						function(sel, even, arg1)
							if arg1 == "Blizzard_CraftUI" then
								CraftFunc()
								waitFrame:UnregisterAllEvents()
							end
						end
					)
				end
			end

			if true then
				local sh = 336
				local tall, numTallTrainers = 73, 17
				local function TrainerFunc(frame)
					UIPanelWindows["ClassTrainerFrame"] = {
						area = "override",
						pushable = 1,
						xoffset = -16,
						yoffset = 12,
						bottomClampOverride = 140 + 12,
						width = 714,
						height = 487,
						whileDead = 1
					}

					_G["ClassTrainerFrame"]:SetSize(714, 487 + tall)
					_G["ClassTrainerNameText"]:ClearAllPoints()
					_G["ClassTrainerNameText"]:SetPoint("TOP", _G["ClassTrainerFrame"], "TOP", 0, -18)
					_G["ClassTrainerListScrollFrame"]:ClearAllPoints()
					_G["ClassTrainerListScrollFrame"]:SetPoint("TOPLEFT", _G["ClassTrainerFrame"], "TOPLEFT", 25, -75)
					_G["ClassTrainerListScrollFrame"]:SetSize(295, sh + tall)
					do
						local oldSkillsDisplayed = CLASS_TRAINER_SKILLS_DISPLAYED
						for i = 1 + 1, CLASS_TRAINER_SKILLS_DISPLAYED do
							_G["ClassTrainerSkill" .. i]:ClearAllPoints()
							_G["ClassTrainerSkill" .. i]:SetPoint("TOPLEFT", _G["ClassTrainerSkill" .. (i - 1)], "BOTTOMLEFT", 0, 1)
						end

						_G.CLASS_TRAINER_SKILLS_DISPLAYED = _G.CLASS_TRAINER_SKILLS_DISPLAYED + numTallTrainers
						for i = oldSkillsDisplayed + 1, CLASS_TRAINER_SKILLS_DISPLAYED do
							local button = CreateFrame("Button", "ClassTrainerSkill" .. i, ClassTrainerFrame, "ClassTrainerSkillButtonTemplate")
							button:SetID(i)
							button:Hide()
							button:ClearAllPoints()
							button:SetPoint("TOPLEFT", _G["ClassTrainerSkill" .. (i - 1)], "BOTTOMLEFT", 0, 1)
						end

						hooksecurefunc(
							"ClassTrainer_SetToTradeSkillTrainer",
							function()
								_G.CLASS_TRAINER_SKILLS_DISPLAYED = _G.CLASS_TRAINER_SKILLS_DISPLAYED + numTallTrainers
								ClassTrainerListScrollFrame:SetHeight(sh + tall)
								ClassTrainerDetailScrollFrame:SetHeight(sh + tall)
							end
						)

						hooksecurefunc(
							"ClassTrainer_SetToClassTrainer",
							function()
								_G.CLASS_TRAINER_SKILLS_DISPLAYED = _G.CLASS_TRAINER_SKILLS_DISPLAYED + numTallTrainers - 1
								ClassTrainerListScrollFrame:SetHeight(sh + tall)
								ClassTrainerDetailScrollFrame:SetHeight(sh + tall)
							end
						)
					end

					hooksecurefunc(
						_G["ClassTrainerSkillHighlightFrame"],
						"Show",
						function()
							ClassTrainerSkillHighlightFrame:SetWidth(290)
						end
					)

					_G["ClassTrainerDetailScrollFrame"]:ClearAllPoints()
					_G["ClassTrainerDetailScrollFrame"]:SetPoint("TOPLEFT", _G["ClassTrainerFrame"], "TOPLEFT", 352, -74)
					_G["ClassTrainerDetailScrollFrame"]:SetSize(296, sh + tall)
					_G["ClassTrainerDetailScrollFrameTop"]:SetAlpha(0)
					_G["ClassTrainerDetailScrollFrameBottom"]:SetAlpha(0)
					_G["ClassTrainerExpandTabLeft"]:Hide()
					local regions = {_G["ClassTrainerFrame"]:GetRegions()}
					regions[2]:SetSize(1024, 512)
					regions[2]:SetTexture("Interface\\AddOns\\ImproveAny\\media\\wideframe")
					regions[2]:SetTexCoord(0, 1, 0, 1)
					regions[3].Show = regions[3].Hide
					regions[3]:Hide()
					for i = 4, 9 do
						if regions[i] then
							regions[i]:Hide()
						end
					end

					ClassTrainerHorizontalBarLeft:Hide()
					local RecipeInset = _G["ClassTrainerFrame"]:CreateTexture(nil, "ARTWORK")
					RecipeInset:SetSize(304, 361 + tall)
					RecipeInset:SetPoint("TOPLEFT", _G["ClassTrainerFrame"], "TOPLEFT", 16, -72)
					RecipeInset:SetTexture("Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg")
					local DetailsInset = _G["ClassTrainerFrame"]:CreateTexture(nil, "ARTWORK")
					DetailsInset:SetSize(302, 339 + tall)
					DetailsInset:SetPoint("TOPLEFT", _G["ClassTrainerFrame"], "TOPLEFT", 348, -72)
					DetailsInset:SetTexture("Interface\\ACHIEVEMENTFRAME\\UI-GuildAchievement-Parchment-Horizontal-Desaturated")
					if _G["ClassTrainerTrainButton"] and _G["ClassTrainerCancelButton"] and _G["ClassTrainerFrameCloseButton"] then
						_G["ClassTrainerTrainButton"]:ClearAllPoints()
						_G["ClassTrainerTrainButton"]:SetPoint("RIGHT", _G["ClassTrainerCancelButton"], "LEFT", -1, 0)
						_G["ClassTrainerCancelButton"]:SetSize(80, 22)
						_G["ClassTrainerCancelButton"]:SetText(CLOSE)
						_G["ClassTrainerCancelButton"]:ClearAllPoints()
						_G["ClassTrainerCancelButton"]:SetPoint("BOTTOMRIGHT", _G["ClassTrainerFrame"], "BOTTOMRIGHT", -42, 54)
						_G["ClassTrainerFrameCloseButton"]:ClearAllPoints()
						_G["ClassTrainerFrameCloseButton"]:SetPoint("TOPRIGHT", _G["ClassTrainerFrame"], "TOPRIGHT", -30, -8)
					end

					if ClassTrainerFrameFilterDropDown then
						ClassTrainerFrameFilterDropDown:ClearAllPoints()
						ClassTrainerFrameFilterDropDown:SetPoint("TOPLEFT", ClassTrainerFrame, "TOPLEFT", 501, -40)
					elseif ClassTrainerFrame.FilterDropdown then
						ClassTrainerFrame.FilterDropdown:ClearAllPoints()
						ClassTrainerFrame.FilterDropdown:SetPoint("TOPLEFT", ClassTrainerFrame, "TOPLEFT", 501, -40)
					end

					ClassTrainerMoneyFrame:ClearAllPoints()
					ClassTrainerMoneyFrame:SetPoint("TOPLEFT", ClassTrainerFrame, "TOPLEFT", 143, -49)
					if ClassTrainerGreetingText then
						ClassTrainerGreetingText:Hide()
					end
				end

				if ImproveAny:IsAddOnLoaded("Blizzard_TrainerUI") then
					TrainerFunc()
				else
					local waitFrame = CreateFrame("FRAME")
					waitFrame:RegisterEvent("ADDON_LOADED")
					waitFrame:SetScript(
						"OnEvent",
						function(sel, even, arg1)
							if arg1 == "Blizzard_TrainerUI" then
								TrainerFunc()
								waitFrame:UnregisterAllEvents()
							end
						end
					)
				end
			end
		end

		if ImproveAny:GetWoWBuild() == "CLASSIC" and ImproveAny:IsEnabled("IMPROVETRADESKILLFRAME", true) then
			local function InitTSF()
				if ImproveAny:GetWoWBuild() == "CLASSIC" then
					TradeSkillFrame.hasMaterial = CreateFrame("CheckButton", "HasMaterial", TradeSkillFrame, "UICheckButtonTemplate")
					TradeSkillFrame.hasMaterial:SetSize(20, 20)
					TradeSkillFrame.hasMaterial:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 70, -54)
					TradeSkillFrame.hasMaterial:SetChecked(ImproveAny:IsEnabled("HASMATERIAL", false))
					TradeSkillFrame.hasMaterial:SetScript(
						"OnClick",
						function(sel)
							ImproveAny:SetEnabled("HASMATERIAL", sel:GetChecked())
							TradeSkillFrame_Update()
						end
					)

					TradeSkillFrame.hasMaterial.f = TradeSkillFrame.hasMaterial:CreateFontString(nil, nil, "GameFontNormalSmall")
					TradeSkillFrame.hasMaterial.f:SetPoint("LEFT", TradeSkillFrame.hasMaterial, "RIGHT", 0, 0)
					TradeSkillFrame.hasMaterial.f:SetText(CRAFT_IS_MAKEABLE or "Have Materials")
				end

				TradeSkillFrame.hasSkillUp = CreateFrame("CheckButton", "HasSkillUp", TradeSkillFrame, "UICheckButtonTemplate")
				TradeSkillFrame.hasSkillUp:SetSize(20, 20)
				if ImproveAny:GetWoWBuild() == "CLASSIC" then
					TradeSkillFrame.hasSkillUp:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 210, -54)
				else
					TradeSkillFrame.hasSkillUp:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 210, -15)
				end

				TradeSkillFrame.hasSkillUp:SetChecked(ImproveAny:IsEnabled("HASSKILLUP", false))
				TradeSkillFrame.hasSkillUp:SetScript(
					"OnClick",
					function(sel)
						ImproveAny:SetEnabled("HASSKILLUP", sel:GetChecked())
						TradeSkillFrame_Update()
					end
				)

				TradeSkillFrame.hasSkillUp.f = TradeSkillFrame.hasSkillUp:CreateFontString(nil, nil, "GameFontNormalSmall")
				TradeSkillFrame.hasSkillUp.f:SetPoint("LEFT", TradeSkillFrame.hasSkillUp, "RIGHT", 0, 0)
				TradeSkillFrame.hasSkillUp.f:SetText(TRADESKILL_FILTER_HAS_SKILL_UP or "Has Skill Up")
				hooksecurefunc(
					"TradeSkillFrame_Update",
					function()
						local py = 94
						local numTradeSkills = GetNumTradeSkills()
						local skillOffset = FauxScrollFrame_GetOffset(TradeSkillListScrollFrame)
						local headers = {}
						local headerId = 0
						local skillCount = 0
						for i = 1, TRADE_SKILLS_DISPLAYED do
							local skillIndex = i + skillOffset
							local _, skillType, numAvailable, isHeader = GetTradeSkillInfo(skillIndex)
							if skillIndex <= numTradeSkills then
								if isHeader then
									if i ~= 1 then
										if skillCount == 0 then
											headers[headerId] = false
										else
											headers[headerId] = true
										end

										headerId = headerId + 1
									end

									skillCount = 0
								else
									local color = TradeSkillTypeColor[skillType]
									if not (ImproveAny:IsEnabled("HASSKILLUP", false) and color and color.r == color.g and color.r == color.b) and not (numAvailable <= 0 and ImproveAny:IsEnabled("HASMATERIAL", false)) then
										skillCount = skillCount + 1
									end
								end
							end
						end

						if skillCount == 0 then
							headers[headerId] = false
						else
							headers[headerId] = true
						end

						headerId = 0
						for i = 1, TRADE_SKILLS_DISPLAYED do
							local skillIndex = i + skillOffset
							local _, skillType, numAvailable, isHeader = GetTradeSkillInfo(skillIndex)
							local skillButton = getglobal("TradeSkillSkill" .. i)
							if skillIndex <= numTradeSkills and i < 25 then
								local color = TradeSkillTypeColor[skillType]
								if not isHeader then
									if ImproveAny:IsEnabled("HASSKILLUP", false) and color and color.r == color.g and color.r == color.b then
										skillButton:Hide()
									else
										if numAvailable <= 0 and ImproveAny:IsEnabled("HASMATERIAL", false) then
											skillButton:Hide()
										else
											skillButton:ClearAllPoints()
											skillButton:SetPoint("TOPLEFT", skillButton:GetParent(), "TOPLEFT", 32, -py)
											skillButton:Show()
											py = py + 16
										end
									end
								else
									if headers[headerId] then
										skillButton:ClearAllPoints()
										skillButton:SetPoint("TOPLEFT", skillButton:GetParent(), "TOPLEFT", 32, -py)
										skillButton:Show()
										py = py + 16
									else
										skillButton:Hide()
									end

									headerId = headerId + 1
								end
							else
								skillButton:Hide()
							end
						end
					end
				)
			end

			if ImproveAny:IsAddOnLoaded("Blizzard_TradeSkillUI") then
				InitTSF()
			else
				local waitFrame = CreateFrame("FRAME")
				waitFrame:RegisterEvent("ADDON_LOADED")
				waitFrame:SetScript(
					"OnEvent",
					function(sel, even, arg1)
						if arg1 == "Blizzard_TradeSkillUI" then
							InitTSF()
							waitFrame:UnregisterAllEvents()
						end
					end
				)
			end
		end
	end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", ImproveAny.Event)
f:RegisterEvent("PLAYER_LOGIN")
function ImproveAny:FastLooting()
	if ImproveAny:IsEnabled("FASTLOOTING", false) then
		ts = GetTime()
		if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
			for i = GetNumLootItems(), 1, -1 do
				LootSlot(i)
			end

			ts = GetTime()
		end
	end
end

local escortQuests = {}
local function AddEQ(id)
	escortQuests[id] = true
end

AddEQ(9528) -- A Cry For Help (TBC, Azure island)
AddEQ(2904) -- A Fine Mess (Gnome Dungeon)
AddEQ(4491) -- A Little Help From My Friends (Classic, Ungoro)
AddEQ(24735) -- A Little Help From My Friends (Retail, Ungoro)
AddEQ(11930) -- Across Transborea (Wrath, Tundra)
AddEQ(4261) -- Ancient Spirit (Felwood)
AddEQ(13267) -- The Battle For The Undercity (Wrath, Undercity (Horde))
AddEQ(13377) -- The Battle For The Undercity (Wrath, Undercity (Alliance))
AddEQ(12832) -- Bitter Departure (Wrath, Storm Peaks)
AddEQ(5821) -- Bodyguard for Hire (Desolace)
AddEQ(4244) -- Chasing A-Me 01 (Ungoro)
AddEQ(34779) -- Circle the Wagon (Warlords of Draenor, Shadowmoon Valley (Alliance))
AddEQ(10406) -- Delivering the Message (TBC, Netherstorm)
AddEQ(10922) -- Digging Through Bones (TBC, Terokkar Forest)
AddEQ(12082) -- Dun-da-Dun-tah! (Wrath, Grizzly Hilly)
AddEQ(9759) -- Ending Their World (Bloodmyst Isle)
AddEQ(10451) -- Escape from Coilskar Cistern (Wrath, Shadowmoon Valley)
AddEQ(10284) -- Escape from Durnholde (TBC, Durnholde)
AddEQ(10052) -- Escape from Firewing Point! (Wrath, Terokkar Forest (Horde))
AddEQ(10051) -- Escape from Firewing Point! (Wrath, Terokkar Forest (Alliance))
AddEQ(11085) -- Escape from Skettis (Wrath, Terokkar Forest)
AddEQ(9212) -- Escape from the Catacombs (TBC, Ghostlands)
AddEQ(10425) -- Escape from the Staging Grounds (TBC, Netherstorm)
AddEQ(9752) -- Escape from Umbrafen (TBC, Zangarmarsh)
AddEQ(435) -- Escorting Erland (Silverpine Forest)
AddEQ(3525) -- Extinguishing the Idol (Razorfen Downs)
AddEQ(9729) -- Fhwoor Smash! (Zangarmarsh)
AddEQ(12570) -- Fortunate Misunderstandings (Sholazar Basin)
AddEQ(4904) -- Free at Last (Thousand Needles (Horde))
AddEQ(898) -- Free From the Hold (Barrens (Horde))
AddEQ(6482) -- Freedom to Ruul (Ashenvale (Horde))
AddEQ(1393) -- Galen's Escape (Swamp of Sorrows)
AddEQ(6132) -- Get Me Out of Here! (Desolace)
AddEQ(5943) -- Gizelton Caravan (Desolace)
AddEQ(26050) -- Goggle Boggle (Cata, Arathi Highlands)
AddEQ(4901) -- Guardians of the Altar (Winterspring)
AddEQ(658) -- Hints of a New Plague? (Arathi Highlands (Alliance))
AddEQ(4770) -- Homeward Bound (Thousand Needles (Horde))
AddEQ(13229) -- I'm Not Dead Yet! (Icecrown (Horde))
AddEQ(13221) -- I'm Not Dead Yet! (Icecrown (Alliance))
AddEQ(5944) -- In Dreams (Western Plaguelands)
AddEQ(4322) -- Jail Break! (Blackrock Depths)
AddEQ(26116) -- Kinelory Strikes (Cata, Arathi Highlands (Alliance))
AddEQ(13481) -- Let's Get Out of Here (Icecrown (Horde))
AddEQ(13482) -- Let's Get Out of Here (Icecrown (Alliance))
AddEQ(26549) -- Madness (Cata, Twilight Highlands (Horde))
AddEQ(219) -- Missing In Action (Redridge Mountains (Alliance))
AddEQ(938) -- Mist (Teldrassil (Alliance))
AddEQ(29272) -- Need... Water... Badly... (Cata, Firelands Invasion)
AddEQ(10965) -- No Mere Dream (TBC, Moonglade)
AddEQ(4121) -- Precarious Predicament (Burning Steppes (Horde))
AddEQ(6523) -- Protect Kaya (Stonetalon Mountain (Horde))
AddEQ(5203) -- Rescue From Jaedenar (Felwood)
AddEQ(836) -- Rescue OOX-09/HL! (The Hinterlands)
AddEQ(648) -- Rescue OOX-17/TN! (Tanaris)
AddEQ(2767) -- Rescue OOX-22/FE! (Feralas)
AddEQ(1440) -- Return to Vahlarriel (Desolace)
AddEQ(31091) -- Reunited (Dread Wastes) (Mist of Pandaria, Dread Wastes)
AddEQ(2742) -- Rin'ji is Trapped! (The Hinterlands (Horde))
AddEQ(10310) -- Sabotage the Warp-Gate! (TBC, Netherstorm)
AddEQ(10898) -- Skywing (TBC, Terokkar Forest)
AddEQ(10218) -- Someone Else's Hard Work Pays Off (TBC, Mana-Tombs)
AddEQ(1270) -- Stinky's Escape (Dustwallow Marsh (Horde))
AddEQ(1222) -- Stinky's Escape (Dustwallow Marsh (Alliance))
AddEQ(665) -- Sunken Treasure (Arathi Highlands)
AddEQ(3367) -- Suntara Stones (Searing Gorge)
AddEQ(976) -- Supplies to Auberdine (Ashenvale)
AddEQ(731) -- The Absent Minded Prospector (Darkshore)
AddEQ(155) -- The Defias Brotherhood (Westfall)
AddEQ(863) -- The Escape (Barrens)
AddEQ(6403) -- The Great Masquerade (Stormwind (Alliance))
AddEQ(9375) -- The Road to Falcon Watch (TBC, Hellfire Peninsula)
AddEQ(5321) -- The Sleeper Has Awakened (Ashenvale (Alliance))
AddEQ(9868) -- The Totem of Kar'dash (TBC, (Horde))
AddEQ(9879) -- The Totem of Kar'dash (TBC, Nagrand)
AddEQ(945) -- Therylune's Escape (Darkshore (Alliance))
AddEQ(9446) -- Tomb of the Lightbringer (TBC, Western Plaguelands (Alliance))
AddEQ(1560) -- Tooga's Quest (Tanaris)
AddEQ(30269) -- Unsafe Passage (Mist of Pandaria, Krasarang Wilds)
AddEQ(2845) -- Wandering Shay (Feralas (Alliance))
AddEQ(10337) -- When the Cows Come Home (TBC, Netherstorm)
AddEQ(1144) -- Willix the Importer  (Razorfen Kraul)
AddEQ(9165) -- Writ of Safe Passage (Eastern Plaguelands)
AddEQ(78714) -- TWW SKIP QUEST 1
AddEQ(84365) -- TWW SKIP QUEST 2
local f2 = CreateFrame("Frame")
f2:RegisterEvent("LOOT_READY")
f2:SetScript("OnEvent", ImproveAny.FastLooting)
function ImproveAny:InitAutoAcceptQuests()
	local default = 1
	local function RegisterAutoQuestsEvents()
		local function Autoquests(sel, event, key, down, ...)
			if not IsShiftKeyDown() and not IsControlKeyDown() and not IsAltKeyDown() then
				if event == "GOSSIP_SHOW" then
					local nActive = C_GossipInfo.GetNumActiveQuests()
					local activeQuests = C_GossipInfo.GetActiveQuests()
					local nAvailable = C_GossipInfo.GetNumAvailableQuests()
					local availableQuests = C_GossipInfo.GetAvailableQuests()
					local gossipOptions = C_GossipInfo.GetOptions()
					local autoquestsQuestID
					local autoquestsIsComplete
					local autoquestsRepeatable
					-- if there is only a non-gossip option, then go to it directly
					if nAvailable == 0 and #activeQuests == 0 and #gossipOptions == 1 then
						C_GossipInfo.SelectOptionByIndex(0)
					elseif nAvailable > 0 then
						for i = 1, nAvailable do
							if type(availableQuests) == "table" then
								autoquestsQuestID = availableQuests[i].questID
								autoquestsRepeatable = availableQuests[i].repeatable
								if nAvailable < 2 or autoquestsRepeatable == false then
									C_GossipInfo.SelectAvailableQuest(autoquestsQuestID)
								end
							end
						end
					elseif nActive > 0 then
						local selectedIndex = 2
						if GetQuestLogSelection then
							selectedIndex = GetQuestLogSelection()
						end

						for i = 1, nActive do
							if type(activeQuests) == "table" then
								autoquestsIsComplete = activeQuests[i].isComplete
								autoquestsQuestID = activeQuests[i].questID
								if SelectQuestLogEntry and GetQuestLogIndexByID then
									SelectQuestLogEntry(GetQuestLogIndexByID(autoquestsQuestID))
								end

								if autoquestsIsComplete == true or (GetQuestLogLeaderBoard ~= nil and GetQuestLogLeaderBoard(1) == nil) then
									C_GossipInfo.SelectActiveQuest(autoquestsQuestID)
								end
							end
						end

						if SelectQuestLogEntry and GetQuestLogIndexByID then
							SelectQuestLogEntry(selectedIndex)
						end
					end
				elseif event == "QUEST_GREETING" then
					local npcAvailableQuestCount = GetNumAvailableQuests()
					local npcActiveQuestCount = GetNumActiveQuests()
					if npcAvailableQuestCount > 0 then
						for i = 1, GetNumAvailableQuests() do
							SelectAvailableQuest(i)
						end
					elseif npcActiveQuestCount > 0 then
						for i = 1, GetNumActiveQuests() do
							SelectActiveQuest(i)
						end
					end
				elseif event == "QUEST_DETAIL" and ImproveAny:IsEnabled("AUTOACCEPTQUESTS", false) then
					if escortQuests[GetQuestID()] == nil then
						AcceptQuest()
					else
						ImproveAny:MSG("Is Escort Quest")
					end
				elseif event == "QUEST_ACCEPT_CONFIRM" and ImproveAny:IsEnabled("AUTOACCEPTQUESTS", false) then
					ConfirmAcceptQuest()
				elseif event == "QUEST_PROGRESS" and ImproveAny:IsEnabled("AUTOCHECKINQUESTS", false) then
					CompleteQuest()
				elseif event == "QUEST_COMPLETE" then
					local npcQuestRewardsCount = GetNumQuestChoices()
					if npcQuestRewardsCount > 1 then
						PlaySound(5274, "master")
					else
						GetQuestReward(default)
					end
				end
			end
		end

		local raaf = CreateFrame("Frame")
		raaf:RegisterEvent("MODIFIER_STATE_CHANGED")
		raaf:RegisterEvent("GOSSIP_SHOW")
		raaf:RegisterEvent("QUEST_PROGRESS")
		raaf:RegisterEvent("QUEST_DETAIL")
		raaf:RegisterEvent("QUEST_COMPLETE")
		raaf:RegisterEvent("QUEST_GREETING")
		raaf:RegisterEvent("QUEST_ACCEPT_CONFIRM")
		raaf:SetScript("OnEvent", Autoquests)
	end

	RegisterAutoQuestsEvents()
end
