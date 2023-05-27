local _, ImproveAny = ...
-- TAINTFREE SLASH COMMANDS --
local lastMessage = ""
local cmds = {}

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

		if ImproveAny:IsEnabled("CASTBAR", true) then
			ImproveAny:InitCastBar()
		end

		if ImproveAny:IsEnabled("DURABILITY", true) then
			ImproveAny:InitDurabilityFrame()
		end

		ImproveAny:InitItemLevel()
		ImproveAny:InitMinimap()
		ImproveAny:InitMoneyBar()
		ImproveAny:InitTokenBar()
		ImproveAny:InitIAILVLBar()
		ImproveAny:InitSkillBars()

		if ImproveAny:IsEnabled("BAGS", true) then
			ImproveAny:InitBags()
		end

		if ImproveAny:IsEnabled("WORLDMAP", true) then
			ImproveAny:InitWorldMapFrame()
		end

		ImproveAny:InitXPBar()
		ImproveAny:InitSuperTrackedFrame()
		ImproveAny:InitMicroMenu()
		ImproveAny:InitIASettings()

		if ImproveAny:IsEnabled("CHAT", true) then
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

		-- overload the base function for ItemRefTooltip with a custom routine
		local tts = {GameTooltip, ItemRefTooltip, ItemRefShoppingTooltip1, ItemRefShoppingTooltip2, ShoppingTooltip1, ShoppingTooltip2, EmbeddedItemTooltip,}

		local function OnTooltipSetItem(tt, data)
			if not tContains(tts, tt) then return end
			local spellID = nil
			local itemId = nil

			if tt.GetTooltipData then
				local tooltipData = tt:GetTooltipData()

				-- type -> 0 = item, 1 = spell 
				if tooltipData and tooltipData.id then
					-- item
					if tooltipData.type == 0 then
						itemId = tooltipData.id
					elseif tooltipData.type == 1 then
						-- spell
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

				if expacID and ImproveAny:IsEnabled("TOOLTIPEXPANSION", true) then
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
			--[[ NEW SYSTEM ]]
			TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
			TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, OnTooltipSetItem)
		else
			--[[ OLD SYSTEM ]]
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
	end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", ImproveAny.Event)
f:RegisterEvent("PLAYER_LOGIN")
f.incombat = false
local ts = 0

function ImproveAny:FastLooting()
	if GetTime() - ts >= 0.2 and ImproveAny:IsEnabled("FASTLOOTING", true) then
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