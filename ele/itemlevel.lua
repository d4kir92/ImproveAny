local _, ImproveAny = ...
local IAGlowAlpha = 0.75
local IAClassIDs = {2, 3, 4, 6, 8}
-- 15
local IASubClassIDs15 = {5, 6}
local slotbry = 0
local IACharSlots = {"AmmoSlot", "HeadSlot", "NeckSlot", "ShoulderSlot", "ShirtSlot", "ChestSlot", "WaistSlot", "LegsSlot", "FeetSlot", "WristSlot", "HandsSlot", "Finger0Slot", "Finger1Slot", "Trinket0Slot", "Trinket1Slot", "BackSlot", "MainHandSlot", "SecondaryHandSlot", "RangedSlot", "TabardSlot",}
function ImproveAny:AddIlvl(SLOT, i)
	if SLOT and SLOT.iainfo == nil then
		local name = ""
		if SLOT.GetName then
			name = SLOT:GetName() .. "."
		end

		SLOT.iainfo = CreateFrame("FRAME", name .. ".iainfo", SLOT)
		SLOT.iainfo:SetSize(SLOT:GetSize())
		SLOT.iainfo:SetPoint("CENTER", SLOT, "CENTER", 0, 0)
		SLOT.iainfo:SetFrameLevel(50)
		SLOT.iainfo:EnableMouse(false)
		SLOT.iatext = SLOT.iainfo:CreateFontString(nil, "OVERLAY")
		SLOT.iatext:SetFont(STANDARD_TEXT_FONT, 11, "THINOUTLINE")
		SLOT.iatext:SetShadowOffset(1, -1)
		SLOT.iatexth = SLOT.iainfo:CreateFontString(nil, "OVERLAY")
		SLOT.iatexth:SetFont(STANDARD_TEXT_FONT, 9, "THINOUTLINE")
		SLOT.iatexth:SetShadowOffset(1, -1)
		SLOT.iaborder = SLOT.iainfo:CreateTexture("SLOT.iaborder", "OVERLAY")
		SLOT.iaborder:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
		SLOT.iaborder:SetBlendMode("ADD")
		SLOT.iaborder:SetAlpha(1)
		SLOT.iatext:SetPoint("TOP", SLOT.iainfo, "TOP", 0, -slotbry)
		SLOT.iatexth:SetPoint("BOTTOM", SLOT.iainfo, "BOTTOM", 0, slotbry)
		local NormalTexture = _G[SLOT:GetName() .. "NormalTexture"]
		if NormalTexture then
			local sw, sh = NormalTexture:GetSize()
			SLOT.iaborder:SetWidth(sw)
			SLOT.iaborder:SetHeight(sh)
		end

		SLOT.iaborder:SetPoint("CENTER")
	end
end

local PDThink = CreateFrame("FRAME")
function ImproveAny:PDUpdateItemInfos()
	if ImproveAny:IsEnabled("ITEMLEVELSYSTEM", false) then
		local count = 0
		local sum = 0
		for i, slot in pairs(IACharSlots) do
			i = i - 1
			local SLOT = _G["Character" .. slot]
			if SLOT and SLOT.iatext ~= nil and GetInventoryItemLink and SLOT.GetID and SLOT:GetID() then
				local ItemID = GetInventoryItemLink("PLAYER", SLOT:GetID()) or GetInventoryItemID("PLAYER", SLOT:GetID())
				if ItemID ~= nil and GetDetailedItemLevelInfo then
					local _, _, rarity = GetItemInfo(ItemID)
					local ilvl, _, _ = GetDetailedItemLevelInfo(ItemID)
					local color = ITEM_QUALITY_COLORS[rarity]
					local current, maximum = GetInventoryItemDurability(i)
					if current and maximum then
						local per = current / maximum
						-- 100%
						if current == maximum then
							SLOT.iatexth:SetTextColor(0, 1, 0, 1)
						elseif per == 0.0 then
							-- = 0%, black
							SLOT.iatexth:SetTextColor(0, 0, 0, 1)
						elseif per < 0.1 then
							-- < 10%, red
							SLOT.iatexth:SetTextColor(1, 0, 0, 1)
						elseif per < 0.3 then
							-- < 30%, orange
							SLOT.iatexth:SetTextColor(1, 0.65, 0, 1)
						elseif per < 1 then
							-- < 100%, red
							SLOT.iatexth:SetTextColor(1, 1, 0, 1)
						end

						if current ~= maximum then
							SLOT.iatexth:SetText(string.format("%0.0f", current / maximum * 100) .. "%")
						else
							SLOT.iatexth:SetText("")
						end
					else
						SLOT.iatexth:SetText("")
					end

					if ilvl and color then
						if slot == "AmmoSlot" then
							local COUNT = _G["Character" .. slot .. "Count"]
							if COUNT.hooked == nil then
								COUNT.hooked = true
								COUNT:SetFont(STANDARD_TEXT_FONT, 9, "THINOUTLINE")
								SLOT.maxDisplayCount = 999999
								COUNT:SetText(COUNT:GetText())
							end
						end

						-- ignore: shirt, tabard, ammo
						if i ~= 4 and i ~= 19 and i ~= 20 and ilvl and ilvl > 1 then
							count = count + 1
							sum = sum + ilvl
						end

						if ImproveAny:IsEnabled("ITEMLEVEL", false) then
							if ImproveAny:IsEnabled("ITEMLEVELNUMBER", false) and ilvl and ilvl > 1 then
								SLOT.iatext:SetText(color.hex .. ilvl)
							end

							local alpha = IAGlowAlpha
							if color.r == 1 and color.g == 1 and color.b == 1 then
								alpha = alpha - 0.2
							end

							if rarity and rarity > 1 and ImproveAny:IsEnabled("ITEMLEVELBORDER", false) then
								SLOT.iaborder:SetVertexColor(color.r, color.g, color.b, alpha)
							else
								SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
							end
						else
							SLOT.iatext:SetText("")
							SLOT.iatexth:SetText("")
							SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
						end
					else
						SLOT.iatext:SetText("")
						SLOT.iatexth:SetText("")
						SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
					end
				else
					SLOT.iatext:SetText("")
					SLOT.iatexth:SetText("")
					SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
				end
			end
		end

		if count > 0 then
			local max = 16 -- when only IAnhand
			if GetInventoryItemID("PLAYER", 17) then
				local t1 = GetItemInfo(GetInventoryItemLink("PLAYER", 17))
				-- when 2x 1handed
				if t1 then
					max = 17
				end
			end

			if D4:GetWoWBuild() == "RETAIL" then
				max = max - 1
			end

			IAILVL = string.format("%0.2f", sum / max)
			if PaperDollFrame.ilvl then
				if true then
					PaperDollFrame.ilvl:SetText("|cFFFFFF00" .. ITEM_LEVEL_ABBR .. ": |r" .. IAILVL)
				else
					PaperDollFrame.ilvl:SetText("")
				end
			end
		elseif PaperDollFrame.ilvl then
			PaperDollFrame.ilvl:SetText("|cFFFFFF00" .. ITEM_LEVEL_ABBR .. ": " .. "|cFFFF0000?")
		end
	end
end

function ImproveAny:InitItemLevel()
	if ImproveAny:IsEnabled("ITEMLEVELSYSTEM", false) and PaperDollFrame then
		PaperDollFrame.ilvl = PaperDollFrame:CreateFontString(nil, "ARTWORK")
		PaperDollFrame.ilvl:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
		PaperDollFrame.ilvl:SetPoint("TOPLEFT", CharacterWristSlot, "BOTTOMLEFT", 24, -15)
		PaperDollFrame.ilvl:SetText(ITEM_LEVEL_ABBR .. ": ?")
		for i, slot in pairs(IACharSlots) do
			ImproveAny:AddIlvl(_G["Character" .. slot], i)
		end

		function PDThink.Loop()
			ImproveAny:PDUpdateItemInfos()
			ImproveAny:Debug("PDThink.lua: Loop", "think")
			C_Timer.After(1, PDThink.Loop)
		end

		C_Timer.After(1, PDThink.Loop)
		PDThink:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
		PDThink:SetScript(
			"OnEvent",
			function(sel, event, slotid, ...)
				ImproveAny:PDUpdateItemInfos()
			end
		)

		PaperDollFrame.btn = CreateFrame("CheckButton", "PaperDollFrame" .. "btn", PaperDollFrame, "UICheckButtonTemplate")
		PaperDollFrame.btn:SetSize(20, 20)
		PaperDollFrame.btn:SetPoint("TOPLEFT", CharacterWristSlot, "BOTTOMLEFT", 6, -10)
		PaperDollFrame.btn:SetChecked(ImproveAny:IsEnabled("ITEMLEVEL", false))
		PaperDollFrame.btn:SetScript(
			"OnClick",
			function(sel)
				local newval = sel:GetChecked()
				ImproveAny:SetEnabled("ITEMLEVEL", newval)
				ImproveAny:PDUpdateItemInfos()
				if ImproveAny.IFUpdateItemInfos then
					ImproveAny:IFUpdateItemInfos()
				end

				if ImproveAny.UpdateBagsIlvl then
					ImproveAny:UpdateBagsIlvl()
				end
			end
		)

		-- Inspect
		function ImproveAny:WaitForInspectFrame()
			if InspectPaperDollFrame then
				IFThink = CreateFrame("FRAME")
				InspectPaperDollFrame.ilvl = InspectPaperDollFrame:CreateFontString(nil, "ARTWORK")
				InspectPaperDollFrame.ilvl:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
				InspectPaperDollFrame.ilvl:SetPoint("TOPLEFT", InspectWristSlot, "BOTTOMLEFT", 24, -15)
				InspectPaperDollFrame.ilvl:SetText(ITEM_LEVEL_ABBR .. ": ?")
				for i, slot in pairs(IACharSlots) do
					ImproveAny:AddIlvl(_G["Inspect" .. slot], i)
				end

				function ImproveAny:IFUpdateItemInfos()
					local count = 0
					local sum = 0
					for i, slot in pairs(IACharSlots) do
						local SLOT = _G["Inspect" .. slot]
						if SLOT and SLOT.iatext ~= nil and GetInventoryItemLink then
							local ItemID = GetInventoryItemLink("TARGET", SLOT:GetID()) --GetInventoryItemID("PLAYER", SLOT:GetID())
							if ItemID and GetDetailedItemLevelInfo then
								local _, _, rarity = GetItemInfo(ItemID)
								local ilvl, _, _ = GetDetailedItemLevelInfo(ItemID)
								local color = ITEM_QUALITY_COLORS[rarity]
								if ImproveAny:IsEnabled("ITEMLEVEL", false) and ilvl and color then
									-- ignore: shirt, tabard, ammo
									if i ~= 4 and i ~= 19 and i ~= 20 and ilvl and ilvl > 1 then
										count = count + 1
										sum = sum + ilvl
									end

									if ImproveAny:IsEnabled("ITEMLEVEL", false) then
										if ImproveAny:IsEnabled("ITEMLEVELNUMBER", false) and ilvl and ilvl > 1 then
											SLOT.iatext:SetText(color.hex .. ilvl)
										end

										local alpha = IAGlowAlpha
										if color.r == 1 and color.g == 1 and color.b == 1 then
											alpha = alpha - 0.2
										end

										if rarity and rarity > 1 and ImproveAny:IsEnabled("ITEMLEVELBORDER", false) then
											SLOT.iaborder:SetVertexColor(color.r, color.g, color.b, alpha)
										else
											SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
										end
									else
										SLOT.iatext:SetText("")
										SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
									end
								else
									SLOT.iatext:SetText("")
									SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
								end
							else
								SLOT.iatext:SetText("")
								SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
							end
						end
					end

					if count > 0 then
						local max = 16 -- when only IAnhand
						local ItemID = GetInventoryItemLink("TARGET", 17)
						if GetItemInfo and GetInventoryItemID and ItemID ~= nil then
							local t1 = GetItemInfo(ItemID)
							-- when 2x 1handed
							if t1 then
								max = 17
							end
						end

						if D4:GetWoWBuild() == "RETAIL" then
							max = max - 1
						end

						IAILVLINSPECT = string.format("%0.2f", sum / max)
						if ImproveAny:IsEnabled("ITEMLEVEL", false) and ImproveAny:IsEnabled("ITEMLEVELNUMBER", false) and InspectPaperDollFrame.ilvl then
							InspectPaperDollFrame.ilvl:SetText("|cFFFFFF00" .. ITEM_LEVEL_ABBR .. ": |r" .. IAILVLINSPECT)
						else
							InspectPaperDollFrame.ilvl:SetText("")
						end
					elseif InspectPaperDollFrame.ilvl then
						InspectPaperDollFrame.ilvl:SetText("|cFFFFFF00" .. ITEM_LEVEL_ABBR .. ": " .. "|cFFFF0000?")
					end
				end

				ImproveAny:Debug("itemlevel.lua: IFUpdateItemInfos")
				C_Timer.After(0.5, ImproveAny.IFUpdateItemInfos)
				IFThink:RegisterEvent("INSPECT_READY")
				IFThink:SetScript(
					"OnEvent",
					function(sel, event, slotid, ...)
						ImproveAny:Debug("itemlevel.lua: IFUpdateItemInfos")
						C_Timer.After(0.1, ImproveAny.IFUpdateItemInfos)
					end
				)
			else
				ImproveAny:Debug("itemlevel.lua: WaitForInspectFrame", "retry")
				C_Timer.After(0.3, ImproveAny.WaitForInspectFrame)
			end
		end

		ImproveAny:WaitForInspectFrame()
		function ImproveAny:GetContainerNumSlots(bagID)
			local cur = 0
			if C_Container and C_Container.GetContainerNumSlots then
				cur = C_Container.GetContainerNumSlots(bagID)
			else
				cur = GetContainerNumSlots(bagID)
			end

			local max = cur
			if bagID == 0 and not IsAccountSecured() then
				max = cur + 4
			end

			return max, cur
		end

		function ImproveAny:GetContainerItemLink(bagID, slotID)
			if C_Container and C_Container.GetContainerItemLink then return C_Container.GetContainerItemLink(bagID, slotID) end

			return GetContainerItemLink(bagID, slotID)
		end

		-- BAGS
		function ImproveAny:UpdateBag(bag, id)
			local name = bag:GetName()
			local bagID = bag:GetID()
			if GetCVarBool("combinedBags") then
				bagID = id
			end

			local size = ImproveAny:GetContainerNumSlots(bagID)
			for i = 1, size do
				local SLOT = _G[name .. "Item" .. i]
				if GetCVarBool("combinedBags") then
					SLOT = _G[name .. "Item" .. i]
				end

				if SLOT then
					local slotID = size - i + 1
					local slotLink = ImproveAny:GetContainerItemLink(bagID, slotID)
					ImproveAny:AddIlvl(SLOT, slotID)
					if slotLink and GetDetailedItemLevelInfo then
						local _, _, rarity, _, _, _, _, _, _, _, _, classID, subclassID = GetItemInfo(slotLink)
						local ilvl, _, _ = GetDetailedItemLevelInfo(slotLink)
						local color = ITEM_QUALITY_COLORS[rarity]
						if ilvl and color then
							if ImproveAny:IsEnabled("ITEMLEVEL", false) then
								if ImproveAny:IsEnabled("ITEMLEVELNUMBER", false) and tContains(IAClassIDs, classID) or (classID == 15 and tContains(IASubClassIDs15, subclassID)) and ilvl and ilvl > 1 then
									SLOT.iatext:SetText(color.hex .. ilvl)
								else
									SLOT.iatext:SetText("")
								end

								local alpha = IAGlowAlpha
								if color.r == 1 and color.g == 1 and color.b == 1 then
									alpha = alpha - 0.2
								end

								if rarity and rarity > 1 and ImproveAny:IsEnabled("ITEMLEVELBORDER", false) then
									SLOT.iaborder:SetVertexColor(color.r, color.g, color.b, alpha)
								else
									SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
								end
							else
								SLOT.iatext:SetText("")
								SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
							end
						else
							SLOT.iatext:SetText("")
							SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
						end
					else
						SLOT.iatext:SetText("")
						SLOT.iaborder:SetVertexColor(1, 1, 1, 0)
					end
				end
			end
		end

		function ImproveAny:UpdateBagsIlvl()
			local tab = {}
			for i = 1, 20 do
				tinsert(tab, _G["ContainerFrame" .. i])
			end

			if ContainerFrameCombinedBags and ContainerFrameCombinedBags.iasetup == nil then
				ContainerFrameCombinedBags.iasetup = true
				ContainerFrameCombinedBags:HookScript(
					"OnShow",
					function(sel)
						ImproveAny:UpdateBagsIlvl()
					end
				)
			end

			for x, bag in pairs(tab) do
				if bag.iasetup == nil then
					bag.iasetup = true
					bag:HookScript(
						"OnShow",
						function(sel)
							ImproveAny:UpdateBag(bag, x - 1)
						end
					)
				end

				ImproveAny:UpdateBag(bag, x - 1)
			end
		end

		local frame = CreateFrame("FRAME")
		frame:RegisterEvent("BAG_OPEN")
		frame:RegisterEvent("BAG_CLOSED")
		frame:RegisterEvent("QUEST_ACCEPTED")
		frame:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
		frame:RegisterEvent("BAG_UPDATE")
		frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
		frame:RegisterEvent("ITEM_LOCK_CHANGED")
		frame:RegisterEvent("BAG_UPDATE_COOLDOWN")
		frame:RegisterEvent("DISPLAY_SIZE_CHANGED")
		frame:RegisterEvent("INVENTORY_SEARCH_UPDATE")
		frame:RegisterEvent("BAG_NEW_ITEMS_UPDATED")
		frame:RegisterEvent("BAG_SLOT_FLAGS_UPDATED")
		frame:SetScript(
			"OnEvent",
			function(sel, event)
				ImproveAny:UpdateBagsIlvl()
			end
		)

		ImproveAny:UpdateBagsIlvl()
	end

	if D4:GetWoWBuild() ~= "RETAIL" and BagItemSearchBox == nil and BagItemAutoSortButton == nil then
		-- Bag Searchbar
		if not D4:IsOldWow() then
			BagItemSearchBox = CreateFrame("EditBox", "BagItemSearchBox", ContainerFrame1, "BagSearchBoxTemplate")
			BagItemSearchBox:SetSize(110, 18)
			BagItemSearchBox:SetPoint("TOPLEFT", ContainerFrame1, "TOPLEFT", 50, -30)
		end

		-- Bag SortButton
		BagItemAutoSortButton = CreateFrame("Button", "BagItemAutoSortButton", ContainerFrame1)
		BagItemAutoSortButton:SetSize(16, 16)
		BagItemAutoSortButton:SetPoint("TOPLEFT", ContainerFrame1, "TOPLEFT", 164, -30)
		--[[
		BagItemAutoSortButton:SetNormalTexture("bags-button-autosort-up")
		BagItemAutoSortButton:SetPushedTexture("bags-button-autosort-down")
		BagItemAutoSortButton:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
		]]
		BagItemAutoSortButton:SetScript(
			"OnClick",
			function(sel, ...)
				PlaySound(SOUNDKIT.UI_BAG_SORTING_01)
				if SortBags then
					SortBags()
				elseif C_Container and C_Container.SortBags then
					C_Container.SortBags()
				end
			end
		)

		BagItemAutoSortButton:SetScript(
			"OnEnter",
			function(sel, ...)
				if sel then
					GameTooltip:SetOwner(sel)
					GameTooltip:SetText(BAG_CLEANUP_BAGS)
					GameTooltip:Show()
				end
			end
		)

		BagItemAutoSortButton:SetScript(
			"OnLeave",
			function(sel, ...)
				GameTooltip_Hide()
			end
		)
	end
end