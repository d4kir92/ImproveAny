local _, ImproveAny = ...
-- TAINTFREE SLASH COMMANDS --
local lastMessage = ""
local cmds = {}
local IAMMBTN = nil

hooksecurefunc("ChatEdit_ParseText", function(editBox, send, parseIfNoSpace)
	if send == 0 then
		lastMessage = editBox:GetText()
	end
end)

hooksecurefunc("ChatFrame_DisplayHelpTextSimple", function(frame)
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
end)

function ImproveAny:InitSlash()
	cmds["/IMPROVE"] = ImproveAny.ToggleSettings
	cmds["/IMPROVEANY"] = ImproveAny.ToggleSettings
	cmds["/RL"] = C_UI.Reload
	cmds["/REL"] = C_UI.Reload
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

IAMaxZoom = tonumber(GetCVar("cameraDistanceMaxZoomFactor"))

function ImproveAny:UpdateMaxZoom()
	ConsoleExec("cameraDistanceMaxZoomFactor " .. ImproveAny:GV("MAXZOOM", ImproveAny:GetMaxZoom()))
end

function ImproveAny:UpdateWorldTextScale()
	ConsoleExec("WorldTextScale " .. ImproveAny:GV("WORLDTEXTSCALE", 1.0))
end

function ImproveAny:CheckCVars()
	if ImproveAny:GV("MAXZOOM", ImproveAny:GetMaxZoom()) ~= tonumber(GetCVar("cameraDistanceMaxZoomFactor")) then
		ImproveAny:UpdateMaxZoom()
	end

	if ImproveAny:GV("WORLDTEXTSCALE", 1.0) ~= tonumber(GetCVar("WorldTextScale")) then
		ImproveAny:UpdateWorldTextScale()
	end

	C_Timer.After(3, ImproveAny.CheckCVars)
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
		C_Timer.After(0.1, ImproveAny.AddRightClick)
	end
end

function ImproveAny:Event(event, ...)
	if ImproveAny.Setup == nil then
		ImproveAny.Setup = true

		if IsAddOnLoaded("D4KiR MoveAndImprove") then
			ImproveAny:MSG("DON'T use MoveAndImprove, when you use ImproveAny")
		end

		ImproveAny:InitSlash()
		ImproveAny:InitDB()

		if ImproveAny:GV("fontName", "Default") ~= "Default" and ImproveAny.Fonts then
			ImproveAny:Fonts()
		end

		if ImproveAny:IsEnabled("CASTBAR", false) then
			ImproveAny:InitCastBar()
		end

		if ImproveAny:IsEnabled("DURABILITY", false) then
			ImproveAny:InitDurabilityFrame()
		end

		ImproveAny:InitItemLevel()
		ImproveAny:InitMinimap()
		ImproveAny:InitMoneyBar()
		ImproveAny:InitTokenBar()
		ImproveAny:InitIAILVLBar()
		ImproveAny:InitSkillBars()

		if ImproveAny:IsEnabled("BAGS", false) then
			ImproveAny:InitBags()
		end

		if ImproveAny:IsEnabled("WORLDMAP", false) then
			ImproveAny:InitWorldMapFrame()
		end

		ImproveAny:InitXPBar()
		ImproveAny:InitSuperTrackedFrame()
		ImproveAny:InitMicroMenu()
		ImproveAny:InitIASettings()

		if ImproveAny:IsEnabled("CHAT", false) then
			ImproveAny:InitChat()
		end

		ImproveAny:InitRaidFrames()
		ImproveAny:InitPartyFrames()
		ImproveAny:InitLFGFrame()
		ImproveAny:UpdateUIParentAttribute()
		ImproveAny:UpdateStatusBar()
		ImproveAny:InitIAPingFrame()
		ImproveAny:InitIACoordsFrame()

		if ImproveAny:IsEnabled("RIGHTCLICKSELFCAST", false) then
			C_Timer.After(2, function()
				ImproveAny:AddRightClick()
			end)
		end

		function ImproveAny:UpdateMinimapButton()
			if IAMMBTN then
				if ImproveAny:IsEnabled("SHOWMINIMAPBUTTON", true) then
					IAMMBTN:Show("ImproveAnyMinimapIcon")
				else
					IAMMBTN:Hide("ImproveAnyMinimapIcon")
				end
			end
		end

		function ImproveAny:ToggleMinimapButton()
			ImproveAny:SetEnabled("SHOWMINIMAPBUTTON", not ImproveAny:IsEnabled("SHOWMINIMAPBUTTON", true))

			if IAMMBTN then
				if ImproveAny:IsEnabled("SHOWMINIMAPBUTTON", true) then
					IAMMBTN:Show("ImproveAnyMinimapIcon")
				else
					IAMMBTN:Hide("ImproveAnyMinimapIcon")
				end
			end
		end

		function ImproveAny:HideMinimapButton()
			ImproveAny:SetEnabled("SHOWMINIMAPBUTTON", false)

			if IAMMBTN then
				IAMMBTN:Hide("ImproveAnyMinimapIcon")
			end
		end

		function ImproveAny:ShowMinimapButton()
			ImproveAny:SetEnabled("SHOWMINIMAPBUTTON", true)

			if IAMMBTN then
				IAMMBTN:Show("ImproveAnyMinimapIcon")
			end
		end

		if ExtraActionButton1 and ExtraActionButton1.style and ImproveAny:IsEnabled("HIDEEXTRAACTIONBUTTONARTWORK", false) then
			hooksecurefunc(ExtraActionButton1.style, "Show", function(sel, ...)
				sel:Hide()
			end)

			ExtraActionButton1.style:Hide()
		end

		local ImproveAnyMinimapIcon = LibStub("LibDataBroker-1.1"):NewDataObject("ImproveAnyMinimapIcon", {
			type = "data source",
			text = "ImproveAnyMinimapIcon",
			icon = 136033,
			OnClick = function(sel, btn)
				if btn == "LeftButton" then
					ImproveAny:ToggleSettings()
				elseif btn == "RightButton" then
					ImproveAny:HideMinimapButton()
				end
			end,
			OnTooltipShow = function(tooltip)
				if not tooltip or not tooltip.AddLine then return end
				tooltip:AddLine("ImproveAny")
				tooltip:AddLine(ImproveAny:GT("MMBTNLEFT"))
				tooltip:AddLine(ImproveAny:GT("MMBTNRIGHT"))
			end,
		})

		if ImproveAnyMinimapIcon then
			IAMMBTN = LibStub("LibDBIcon-1.0", true)

			if IAMMBTN then
				IAMMBTN:Register("ImproveAnyMinimapIcon", ImproveAnyMinimapIcon, ImproveAny:GetMinimapTable())
			end
		end

		if IAMMBTN then
			if ImproveAny:IsEnabled("SHOWMINIMAPBUTTON", true) then
				IAMMBTN:Show("ImproveAnyMinimapIcon")
			else
				IAMMBTN:Hide("ImproveAnyMinimapIcon")
			end
		end

		ImproveAny:UpdateMaxZoom()
		ImproveAny:UpdateWorldTextScale()
		ImproveAny:CheckCVars()

		if ImproveAny:IsEnabled("HIDEPVPBADGE", false) then
			if PlayerFrame and PlayerFrame.PlayerFrameContent and PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual then
				hooksecurefunc(PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait, "Show", function(sel)
					sel:Hide()
				end)

				PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigePortrait:Hide()

				hooksecurefunc(PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge, "Show", function(sel)
					sel:Hide()
				end)

				PlayerFrame.PlayerFrameContent.PlayerFrameContentContextual.PrestigeBadge:Hide()
			end

			if TargetFrame and TargetFrame.TargetFrameContent and TargetFrame.TargetFrameContent.TargetFrameContentContextual then
				hooksecurefunc(TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait, "Show", function(sel)
					sel:Hide()
				end)

				TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait:Hide()

				hooksecurefunc(TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge, "Show", function(sel)
					sel:Hide()
				end)

				TargetFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge:Hide()
			end

			if FocusFrame and FocusFrame.TargetFrameContent and FocusFrame.TargetFrameContent.TargetFrameContentContextual then
				hooksecurefunc(FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait, "Show", function(sel)
					sel:Hide()
				end)

				FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigePortrait:Hide()

				hooksecurefunc(FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge, "Show", function(sel)
					sel:Hide()
				end)

				FocusFrame.TargetFrameContent.TargetFrameContentContextual.PrestigeBadge:Hide()
			end

			if PlayerPVPIcon then
				hooksecurefunc(PlayerPVPIcon, "Show", function(sel)
					sel:Hide()
				end)

				PlayerPVPIcon:Hide()
			end

			if TargetFrameTextureFramePVPIcon then
				hooksecurefunc(TargetFrameTextureFramePVPIcon, "Show", function(sel)
					sel:Hide()
				end)

				TargetFrameTextureFramePVPIcon:Hide()
			end

			if FocusFrameTextureFramePVPIcon then
				hooksecurefunc(FocusFrameTextureFramePVPIcon, "Show", function(sel)
					sel:Hide()
				end)

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
				local _, _, _, _, _, _, _, itemStackCount, _, _, price, _, _, _, expacID, _, _ = GetItemInfo(itemId)

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
					frame:HookScript("OnTooltipSetSpell", function(tt)
						local _, spellID = tt:GetSpell()

						if spellID and ImproveAny:IsEnabled("SETTINGS", false) then
							tt:AddDoubleLine("SpellID" .. ":", "|cFFFFFFFF" .. spellID)
						end
					end)
				end
			end

			for _, frame in pairs{GameTooltip, ItemRefTooltip, WhatevahTooltip} do
				if frame then
					frame:HookScript("OnTooltipSetItem", function(tt)
						local _, itemLink = tt:GetItem()

						if itemLink then
							local itemId = tonumber(strmatch(itemLink, "item:(%d*)"))

							if itemId then
								local _, _, _, _, _, _, _, itemStackCount, _, _, price, _, _, _, _, _, _ = GetItemInfo(itemId)

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
					end)
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

		MythicAuto:SetScript("OnEvent", function(sel, event2, addon)
			if addon ~= "Blizzard_ChallengesUI" then return end

			if ChallengesKeystoneFrame then
				ChallengesKeystoneFrame:HookScript("OnShow", function()
					for bagId = 0, Constants.InventoryConstants.NumBagSlots do
						for slotId = 1, C_Container.GetContainerNumSlots(bagId) do
							local id = C_Container.GetContainerItemID(bagId, slotId)
							if id and ids[id] then return C_Container.UseContainerItem(bagId, slotId) end
						end
					end
				end)

				sel:UnregisterEvent(event2)
			end
		end)

		if ImproveAny:GetWoWBuild() ~= "RETAIL" and ShouldKnowUnitHealth() == false then
			function ShouldKnowUnitHealth()
				return true
			end
		end

		if ImproveAny:GetWoWBuild() ~= "RETAIL" then
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

				hooksecurefunc(EmptyQuestLogFrame, "Show", function()
					EmptyQuestLogFrame:ClearAllPoints()
					EmptyQuestLogFrame:SetPoint("BOTTOMLEFT", QuestLogFrame, "BOTTOMLEFT", 20, -76)
					EmptyQuestLogFrame:SetHeight(487)
				end)
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

					hooksecurefunc(_G["TradeSkillHighlightFrame"], "Show", function()
						_G["TradeSkillHighlightFrame"]:SetWidth(290)
					end)

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

					_G["TradeSkillCreateButton"]:ClearAllPoints()
					_G["TradeSkillCreateButton"]:SetPoint("RIGHT", _G["TradeSkillCancelButton"], "LEFT", -1, 0)
					_G["TradeSkillCancelButton"]:SetSize(80, 22)
					_G["TradeSkillCancelButton"]:SetText(CLOSE)
					_G["TradeSkillCancelButton"]:ClearAllPoints()
					_G["TradeSkillCancelButton"]:SetPoint("BOTTOMRIGHT", _G["TradeSkillFrame"], "BOTTOMRIGHT", -42, 54)
					_G["TradeSkillFrameCloseButton"]:ClearAllPoints()
					_G["TradeSkillFrameCloseButton"]:SetPoint("TOPRIGHT", _G["TradeSkillFrame"], "TOPRIGHT", -30, -8)
					TradeSkillInvSlotDropDown:ClearAllPoints()
					TradeSkillInvSlotDropDown:SetPoint("TOPLEFT", TradeSkillFrame, "TOPLEFT", 510, -40)
					TradeSkillSubClassDropDown:ClearAllPoints()
					TradeSkillSubClassDropDown:SetPoint("RIGHT", TradeSkillInvSlotDropDown, "LEFT", 0, 0)

					if IsAddOnLoaded("ClassicProfessionFilter") and TradeSkillFrame.SearchBox and TradeSkillFrame.HaveMats and TradeSkillFrame.HaveMats.text then
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

				if IsAddOnLoaded("Blizzard_TradeSkillUI") then
					TradeSkillFunc("TradeSkill")
				else
					local waitFrame = CreateFrame("FRAME")
					waitFrame:RegisterEvent("ADDON_LOADED")

					waitFrame:SetScript("OnEvent", function(sel, even, arg1)
						if arg1 == "Blizzard_TradeSkillUI" then
							TradeSkillFunc("TradeSkill")
							waitFrame:UnregisterAllEvents()
						end
					end)
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

					hooksecurefunc("CraftFrame_Update", function()
						for i = 1, CRAFTS_DISPLAYED do
							if _G["Craft" .. i] then
								local craftButtonCost = _G["Craft" .. i .. "Cost"]

								if craftButtonCost then
									craftButtonCost:SetPoint("RIGHT", -30, 0)
								end
							end
						end
					end)

					hooksecurefunc(_G["CraftHighlightFrame"], "Show", function()
						_G["CraftHighlightFrame"]:SetWidth(290)
					end)

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

					hooksecurefunc(CraftCreateButton, "SetFrameLevel", function()
						CraftCreateButton:ClearAllPoints()
						CraftCreateButton:SetPoint("RIGHT", CraftCancelButton, "LEFT", -1, 0)
					end)

					if IsAddOnLoaded("ClassicProfessionFilter") and CraftFrame.SearchBox and CraftFrame.HaveMats and CraftFrame.HaveMats.text and CraftFrame.SearchMats and CraftFrame.SearchMats.text then
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

				if IsAddOnLoaded("Blizzard_CraftUI") then
					CraftFunc()
				else
					local waitFrame = CreateFrame("FRAME")
					waitFrame:RegisterEvent("ADDON_LOADED")

					waitFrame:SetScript("OnEvent", function(sel, even, arg1)
						if arg1 == "Blizzard_CraftUI" then
							CraftFunc()
							waitFrame:UnregisterAllEvents()
						end
					end)
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

						hooksecurefunc("ClassTrainer_SetToTradeSkillTrainer", function()
							_G.CLASS_TRAINER_SKILLS_DISPLAYED = _G.CLASS_TRAINER_SKILLS_DISPLAYED + numTallTrainers
							ClassTrainerListScrollFrame:SetHeight(sh + tall)
							ClassTrainerDetailScrollFrame:SetHeight(sh + tall)
						end)

						hooksecurefunc("ClassTrainer_SetToClassTrainer", function()
							_G.CLASS_TRAINER_SKILLS_DISPLAYED = _G.CLASS_TRAINER_SKILLS_DISPLAYED + numTallTrainers - 1
							ClassTrainerListScrollFrame:SetHeight(sh + tall)
							ClassTrainerDetailScrollFrame:SetHeight(sh + tall)
						end)
					end

					hooksecurefunc(_G["ClassTrainerSkillHighlightFrame"], "Show", function()
						ClassTrainerSkillHighlightFrame:SetWidth(290)
					end)

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
					_G["ClassTrainerTrainButton"]:ClearAllPoints()
					_G["ClassTrainerTrainButton"]:SetPoint("RIGHT", _G["ClassTrainerCancelButton"], "LEFT", -1, 0)
					_G["ClassTrainerCancelButton"]:SetSize(80, 22)
					_G["ClassTrainerCancelButton"]:SetText(CLOSE)
					_G["ClassTrainerCancelButton"]:ClearAllPoints()
					_G["ClassTrainerCancelButton"]:SetPoint("BOTTOMRIGHT", _G["ClassTrainerFrame"], "BOTTOMRIGHT", -42, 54)
					_G["ClassTrainerFrameCloseButton"]:ClearAllPoints()
					_G["ClassTrainerFrameCloseButton"]:SetPoint("TOPRIGHT", _G["ClassTrainerFrame"], "TOPRIGHT", -30, -8)
					ClassTrainerFrameFilterDropDown:ClearAllPoints()
					ClassTrainerFrameFilterDropDown:SetPoint("TOPLEFT", ClassTrainerFrame, "TOPLEFT", 501, -40)
					ClassTrainerMoneyFrame:ClearAllPoints()
					ClassTrainerMoneyFrame:SetPoint("TOPLEFT", _G["ClassTrainerFrame"], "TOPLEFT", 143, -49)
					ClassTrainerGreetingText:Hide()
				end

				if IsAddOnLoaded("Blizzard_TrainerUI") then
					TrainerFunc()
				else
					local waitFrame = CreateFrame("FRAME")
					waitFrame:RegisterEvent("ADDON_LOADED")

					waitFrame:SetScript("OnEvent", function(sel, even, arg1)
						if arg1 == "Blizzard_TrainerUI" then
							TrainerFunc()
							waitFrame:UnregisterAllEvents()
						end
					end)
				end
			end
		end
	end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", ImproveAny.Event)
f:RegisterEvent("PLAYER_LOGIN")
f.incombat = false
local ts = 0

function ImproveAny:FastLooting()
	if GetTime() - ts >= 0.24 and ImproveAny:IsEnabled("FASTLOOTING", false) then
		ts = GetTime()

		if GetCVarBool("autoLootDefault") ~= IsModifiedClick("AUTOLOOTTOGGLE") then
			for i = GetNumLootItems(), 1, -1 do
				LootSlot(i)
			end

			ts = GetTime()
		end
	end
end

local f2 = CreateFrame("Frame")
f2:RegisterEvent("LOOT_READY")
f2:SetScript("OnEvent", ImproveAny.FastLooting)