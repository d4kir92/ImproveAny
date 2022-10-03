
local AddOnName, ImproveAny = ...

local IAGlowAlpha = 0.75

local IAClassIDs = {2, 3, 4, 6, 8}
local IASubClassIDs15 = {5, 6} -- 15
local LEFTSLOTS = { 2, 3, 4, 5, 6, 10, 16, 20, 18 }
local RIGHTSLOTS = { 7, 8, 9, 11, 12, 13, 14, 15, 17 }
local slotbry = 0
local slotbrx = 3
local IACharSlots = {
	"AmmoSlot", -- 0,
	"HeadSlot", -- 1
	"NeckSlot", -- 2
	"ShoulderSlot", -- 3
	"ShirtSlot", -- 4
	"ChestSlot", -- 5
	"WaistSlot", -- 6
	"LegsSlot", -- 7
	"FeetSlot", -- 8
	"WristSlot", -- 9
	"HandsSlot", -- 10
	"Finger0Slot", -- 11
	"Finger1Slot", -- 12
	"Trinket0Slot", -- 13
	"Trinket1Slot", -- 14
	"BackSlot", -- 15
	"MainHandSlot", -- 16
	"SecondaryHandSlot", -- 17
	"RangedSlot", -- 18
	"TabardSlot", -- 19
	--"Bag0Slot",
	--"Bag1Slot",
	--"Bag2Slot",
	--"Bag3Slot"
}

function IAAddIlvl(SLOT, i)
	if SLOT and SLOT.info == nil then
		local name = ""
		if SLOT.GetName then
			name = SLOT:GetName() .. "."
		end

		SLOT.info = CreateFrame( "FRAME", name .. "info", SLOT )
		SLOT.info:SetSize( SLOT:GetSize() )
		SLOT.info:SetPoint( "CENTER", SLOT, "CENTER", 0, 0 )
		SLOT.info:SetFrameLevel( 50 )
		SLOT.info:EnableMouse( false )

		SLOT.text = SLOT.info:CreateFontString(nil, "OVERLAY")
		SLOT.text:SetFont(STANDARD_TEXT_FONT, 11, "THINOUTLINE")
		SLOT.text:SetShadowOffset(1, -1)

		SLOT.texth = SLOT.info:CreateFontString(nil, "OVERLAY")
		SLOT.texth:SetFont(STANDARD_TEXT_FONT, 9, "THINOUTLINE")
		SLOT.texth:SetShadowOffset(1, -1)

		SLOT.border = SLOT.info:CreateTexture("SLOT.border", "OVERLAY")
		SLOT.border:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
		SLOT.border:SetBlendMode("ADD")
		SLOT.border:SetAlpha(IAGlowAlpha)

		SLOT.text:SetPoint( "TOP", SLOT.info, "TOP", 0, -slotbry )
		SLOT.texth:SetPoint( "BOTTOM", SLOT.info, "BOTTOM", 0, slotbry )

		local NormalTexture = _G[SLOT:GetName() .. "NormalTexture"]
		if NormalTexture then
			local sw, sh = NormalTexture:GetSize()
			SLOT.border:SetWidth(sw)
			SLOT.border:SetHeight(sh)
		end

		SLOT.border:SetPoint("CENTER")

		function SLOT.info:UpdateVisible()
			SLOT.info.vis = SLOT.info.vis or false
			
			if MouseIsOver( SLOT.info ) ~= SLOT.info.vis then
				SLOT.info.vis = MouseIsOver( SLOT.info )

				if SLOT.info.vis then
					SLOT.info:SetAlpha( 0 )
				else
					SLOT.info:SetAlpha( 1 )
				end
			end

			C_Timer.After( 0.04, SLOT.info.UpdateVisible )
		end
		SLOT.info:UpdateVisible()
	end
end

function ImproveAny:InitItemLevel()
	if PaperDollFrame then
		PDThink = CreateFrame("FRAME")

		PaperDollFrame.ilvl = PaperDollFrame:CreateFontString(nil, "ARTWORK")
		PaperDollFrame.ilvl:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
		PaperDollFrame.ilvl:SetPoint("TOPLEFT", CharacterWristSlot, "BOTTOMLEFT", 24, -15)
		PaperDollFrame.ilvl:SetText(ITEM_LEVEL_ABBR .. ": ?")

		for i, slot in pairs(IACharSlots) do
			IAAddIlvl( _G["Character" .. slot], i )
		end

		function PDThink.UpdateItemInfos()
			local count = 0
			local sum = 0
			for i, slot in pairs(IACharSlots) do
				local id = i
				i = i - 1
				local SLOT = _G["Character" .. slot]
				if SLOT and SLOT.text ~= nil and GetInventoryItemLink and SLOT.GetID and SLOT:GetID() then
					local ItemID = GetInventoryItemLink("PLAYER", SLOT:GetID()) or GetInventoryItemID("PLAYER", SLOT:GetID())
					if ItemID ~= nil and GetDetailedItemLevelInfo then
						local t1, t2, rarity, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13 = GetItemInfo(ItemID)
						local ilvl, _, baseilvl = GetDetailedItemLevelInfo(ItemID)
						local color = ITEM_QUALITY_COLORS[rarity]
						local current, maximum = GetInventoryItemDurability(i)
						if current and maximum then
							local per = current / maximum
							if current == maximum then -- 100%
								SLOT.texth:SetTextColor(0,	1,		0,	1)
							elseif per == 0.0 then -- = 0%, black
								SLOT.texth:SetTextColor(0,	0,		0,	1)
							elseif per < 0.1 then -- < 10%, red
								SLOT.texth:SetTextColor(1,	0,		0,	1)
							elseif per < 0.3 then -- < 30%, orange
								SLOT.texth:SetTextColor(1,	0.65,	0,	1)
							elseif per < 1 then -- < 100%, red
								SLOT.texth:SetTextColor(1,	1,		0,	1)
							end
							if current ~= maximum then
								SLOT.texth:SetText( string.format("%0.0f", current / maximum * 100) .. "%" )
							else
								SLOT.texth:SetText( "" )
							end
						else
							SLOT.texth:SetText( "" )
						end
						if ilvl and color then
							if slot == "AmmoSlot" then
								local COUNT = _G["Character" .. slot .. "Count"]
								if COUNT.hooked == nil then
									COUNT.hooked = true
									COUNT:SetFont(STANDARD_TEXT_FONT, 9, "THINOUTLINE")
									SLOT.maxDisplayCount = 999999
									COUNT:SetText( COUNT:GetText() )
								end
							end
							if i ~= 4 and i ~= 19 and i ~= 20 then -- ignore: shirt, tabard, ammo
								count = count + 1
								sum = sum + ilvl
							end
							if ImproveAny:IsEnabled( "ITEMLEVEL", true ) then
								if ImproveAny:IsEnabled( "ITEMLEVELNUMBER", true ) then
									SLOT.text:SetText( color.hex .. ilvl )
								end
								local alpha = IAGlowAlpha
								if color.r == 1 and color.g == 1 and color.b == 1 then
									alpha = alpha - 0.2
								end
								if ImproveAny:IsEnabled( "ITEMLEVELBORDER", true ) then
									SLOT.border:SetVertexColor(color.r, color.g, color.b, alpha)
								else
									SLOT.border:SetVertexColor(1, 1, 1, 0)
								end
								--SLOT.info:Show()
							else
								SLOT.text:SetText("")
								SLOT.texth:SetText("")
								SLOT.border:SetVertexColor(1, 1, 1, 0)
								--SLOT.info:Hide()
							end
						else
							SLOT.text:SetText("")
							SLOT.texth:SetText("")
							SLOT.border:SetVertexColor(1, 1, 1, 0)
							--SLOT.info:Hide()
						end
					else
						SLOT.text:SetText("")
						SLOT.texth:SetText("")
						SLOT.border:SetVertexColor(1, 1, 1, 0)
						--SLOT.info:Hide()
					end
				end
			end
			
			if count > 0 then
				local max = 16 -- when only IAnhand
				if GetInventoryItemID("PLAYER", 17) then
					local t1, t2, rarity, ilvl, t5, t6, t7, t8, t9, t10, t11, t12, t13 = GetItemInfo(GetInventoryItemLink("PLAYER", 17))
					if t1 then -- when 2x 1handed
						max = 17
					end
				end
				if IABUILD == "RETAIL" then
					max = max - 1
				end

				IAILVL = string.format("%0.2f", sum / max)
				if true then
					PaperDollFrame.ilvl:SetText("|cFFFFFF00" .. ITEM_LEVEL_ABBR .. ": |r" .. IAILVL)
				else
					PaperDollFrame.ilvl:SetText("")
				end
			else
				PaperDollFrame.ilvl:SetText("|cFFFFFF00" .. ITEM_LEVEL_ABBR .. ": " .. "|cFFFF0000?")
			end
		end

		function PDThink.Loop()
			PDThink.UpdateItemInfos()
			C_Timer.After(1, PDThink.Loop)
		end
		C_Timer.After(1, PDThink.Loop)

		PDThink:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
		PDThink:SetScript("OnEvent", function(self, event, slotid, ...)
			PDThink.UpdateItemInfos()
		end)

		PaperDollFrame.btn = CreateFrame("CheckButton", "PaperDollFrame" .. "btn", PaperDollFrame, "UICheckButtonTemplate")
		PaperDollFrame.btn:SetSize(20, 20)
		PaperDollFrame.btn:SetPoint("TOPLEFT", CharacterWristSlot, "BOTTOMLEFT", 6, -10)
		PaperDollFrame.btn:SetChecked( ImproveAny:IsEnabled( "ITEMLEVEL", true ) )
		PaperDollFrame.btn:SetScript("OnClick", function(self)
			local newval = self:GetChecked()
			ImproveAny:SetEnabled( "ITEMLEVEL", newval )
			PDThink.UpdateItemInfos()
			if IFThink and IFThink.UpdateItemInfos then
				IFThink.UpdateItemInfos()
			end
			if ContainerFrame_UpdateAll then
				ContainerFrame_UpdateAll()
			end
		end)

		-- Inspect
		function IAWaitForInspectFrame()
			if InspectPaperDollFrame then
				IFThink = CreateFrame("FRAME")

				InspectPaperDollFrame.ilvl = InspectPaperDollFrame:CreateFontString(nil, "ARTWORK")
				InspectPaperDollFrame.ilvl:SetFont(STANDARD_TEXT_FONT, 10, "THINOUTLINE")
				InspectPaperDollFrame.ilvl:SetPoint("TOPLEFT", InspectWristSlot, "BOTTOMLEFT", 24, -15)
				InspectPaperDollFrame.ilvl:SetText(ITEM_LEVEL_ABBR .. ": ?")

				for i, slot in pairs(IACharSlots) do
					IAAddIlvl(_G["Inspect" .. slot], i )
				end

				function IFThink.UpdateItemInfos()
					local count = 0
					local sum = 0
					for i, slot in pairs(IACharSlots) do
						local SLOT = _G["Inspect" .. slot]
						if SLOT and SLOT.text ~= nil and GetInventoryItemLink then
							local ItemID = GetInventoryItemLink("TARGET", SLOT:GetID()) --GetInventoryItemID("PLAYER", SLOT:GetID())
							if ItemID and GetDetailedItemLevelInfo then
								local t1, t2, rarity, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13 = GetItemInfo(ItemID)
								local ilvl, _, baseilvl = GetDetailedItemLevelInfo(ItemID)
								local color = ITEM_QUALITY_COLORS[rarity]

								if ImproveAny:IsEnabled( "ITEMLEVEL", true ) and ilvl and color then
									if i ~= 4 and i ~= 19 and i ~= 20 then -- ignore: shirt, tabard, ammo
										count = count + 1
										sum = sum + ilvl
									end
									if ImproveAny:IsEnabled( "ITEMLEVEL", true ) then
										if ImproveAny:IsEnabled( "ITEMLEVELNUMBER", true ) then
											SLOT.text:SetText(color.hex .. ilvl)
										end
										local alpha = IAGlowAlpha
										if color.r == 1 and color.g == 1 and color.b == 1 then
											alpha = alpha - 0.2
										end
										if ImproveAny:IsEnabled( "ITEMLEVELBORDER", true ) then
											SLOT.border:SetVertexColor(color.r, color.g, color.b, alpha)
										else
											SLOT.border:SetVertexColor(1, 1, 1, 0)
										end
										--SLOT.info:Show()
									else
										SLOT.text:SetText("")
										SLOT.border:SetVertexColor(1, 1, 1, 0)
										--SLOT.info:Hide()
									end
								else
									SLOT.text:SetText("")
									SLOT.border:SetVertexColor(1, 1, 1, 0)
									--SLOT.info:Hide()
								end
							else
								SLOT.text:SetText("")
								SLOT.border:SetVertexColor(1, 1, 1, 0)
								--SLOT.info:Hide()
							end
						end
					end
					if count > 0 then
						local max = 16 -- when only IAnhand
						local ItemID = GetInventoryItemLink("TARGET", 17)
						if GetItemInfo and GetInventoryItemID and ItemID ~= nil then
							local t1, t2, rarity, ilvl, t5, t6, t7, t8, t9, t10, t11, t12, t13 = GetItemInfo(ItemID)
							if t1 then -- when 2x 1handed
								max = 17
							end
						end
						if IABUILD == "RETAIL" then
							max = max - 1
						end
						IAILVLINSPECT = string.format("%0.2f", sum / max)
						if ImproveAny:IsEnabled( "ITEMLEVEL", true ) and ImproveAny:IsEnabled( "ITEMLEVELNUMBER", true ) then
							InspectPaperDollFrame.ilvl:SetText("|cFFFFFF00" .. ITEM_LEVEL_ABBR .. ": |r" .. IAILVLINSPECT)
						else
							InspectPaperDollFrame.ilvl:SetText("")
						end
					else
						InspectPaperDollFrame.ilvl:SetText("|cFFFFFF00" .. ITEM_LEVEL_ABBR .. ": " .. "|cFFFF0000?")
					end
				end
				C_Timer.After(0.5, IFThink.UpdateItemInfos)
		
				IFThink:RegisterEvent("INSPECT_READY")
				IFThink:SetScript("OnEvent", function(self, event, slotid, ...)
					C_Timer.After(0.1, IFThink.UpdateItemInfos)
				end)
			else
				C_Timer.After(0.1, IAWaitForInspectFrame)
			end
		end
		IAWaitForInspectFrame()
		

		
		-- BAGS
		if ContainerFrame_Update then
			hooksecurefunc("ContainerFrame_Update", function(self)
				local id = self:GetID()
				local name = self:GetName()
				local size = self.size

				for i=1, size do
					local bid = size - i + 1
					local SLOT = _G[name .. 'Item' .. bid]
					local slotLink = GetContainerItemLink(id, i)
					IAAddIlvl(SLOT, i)

					if slotLink and GetDetailedItemLevelInfo then
						local t1, t2, rarity, t4, t5, t6, t7, t8, t9, t10, t11, classID, subclassID = GetItemInfo(slotLink)
						local ilvl, _, baseilvl = GetDetailedItemLevelInfo(slotLink)
						local color = ITEM_QUALITY_COLORS[rarity]
						if ilvl and color then
							if ImproveAny:IsEnabled( "ITEMLEVEL", true ) then
								if ImproveAny:IsEnabled( "ITEMLEVELNUMBER", true ) and tContains(IAClassIDs, classID) or (classID == 15 and tContains(IASubClassIDs15, subclassID)) then
									SLOT.text:SetText(color.hex .. ilvl)
								else
									SLOT.text:SetText("")
								end
								local alpha = IAGlowAlpha
								if color.r == 1 and color.g == 1 and color.b == 1 then
									alpha = alpha - 0.2
								end
								if ImproveAny:IsEnabled( "ITEMLEVELBORDER", true ) then
									SLOT.border:SetVertexColor(color.r, color.g, color.b, alpha)
								else
									SLOT.border:SetVertexColor(1, 1, 1, 0)
								end
								--SLOT.info:Show()
							else
								SLOT.text:SetText("")
								SLOT.border:SetVertexColor(1, 1, 1, 0)
								--SLOT.info:Hide()
							end
						else
							SLOT.text:SetText("")
							SLOT.border:SetVertexColor(1, 1, 1, 0)
							--SLOT.info:Hide()
						end
					else
						SLOT.text:SetText("")
						SLOT.border:SetVertexColor(1, 1, 1, 0)
						--SLOT.info:Hide()
					end
				end
			end)
		end
	end

	if IABUILD ~= "RETAIL" then
		-- Bag Searchbar
		BagItemSearchBox = CreateFrame("EditBox", "BagItemSearchBox", ContainerFrame1, "BagSearchBoxTemplate")
		BagItemSearchBox:SetSize(110, 18)
		BagItemSearchBox:SetPoint("TOPLEFT", ContainerFrame1, "TOPLEFT", 50, -30)
		
		-- Bag SortButton
		BagItemAutoSortButton = CreateFrame("Button", "BagItemAutoSortButton", ContainerFrame1)
		BagItemAutoSortButton:SetSize(16, 16)
		BagItemAutoSortButton:SetPoint("TOPLEFT", ContainerFrame1, "TOPLEFT", 164, -30)
		--[[
		BagItemAutoSortButton:SetNormalTexture("bags-button-autosort-up")
		BagItemAutoSortButton:SetPushedTexture("bags-button-autosort-down")
		BagItemAutoSortButton:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square")
		]]
		BagItemAutoSortButton:SetScript("OnClick", function(self, ...)
			PlaySound(SOUNDKIT.UI_BAG_SORTING_01)
			if SortBags then
				SortBags()
			elseif C_Container and C_Container.SortBags then
				C_Container.SortBags()
			end
		end)
		BagItemAutoSortButton:SetScript("OnEnter", function(self, ...)
			GameTooltip:SetOwner(self)
			GameTooltip:SetText(BAG_CLEANUP_BAGS)
			GameTooltip:Show()
		end)
		BagItemAutoSortButton:SetScript("OnLeave", function(self, ...)
			GameTooltip_Hide()
		end)
		
	end
end
