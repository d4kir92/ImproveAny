
local AddOnName, ImproveAny = ...

local IACHARSLOTS = {
	CharacterHeadSlot,
	CharacterNeckSlot,
	CharacterShoulderSlot,
	CharacterBackSlot,
	CharacterChestSlot,
	CharacterWristSlot,

	CharacterHandsSlot,
	CharacterWaistSlot,
	CharacterLegsSlot,
	CharacterFeetSlot,
	CharacterFinger0Slot,
	CharacterFinger1Slot,
	CharacterTrinket0Slot,
	CharacterTrinket1Slot,

	CharacterMainHandSlot,
	CharacterSecondaryHandSlot,

	CharacterRangedSlot -- Classic
}

function ImproveAny:InitDurabilityFrame()
	C_Timer.After( 1, function()
		DurabilityFrame.text = DurabilityFrame:CreateFontString(nil)
		DurabilityFrame.text:SetFont(STANDARD_TEXT_FONT, 10, "")
		DurabilityFrame.text:SetPoint("TOP", DurabilityFrame, "TOP", 0, 10)
		DurabilityFrame.text:SetText("101%")

		DurabilityFrame.text2 = DurabilityFrame:CreateFontString(nil)
		DurabilityFrame.text2:SetFont(STANDARD_TEXT_FONT, 10, "")
		DurabilityFrame.text2:SetPoint("BOTTOM", DurabilityFrame, "BOTTOM", 0, -10)
		DurabilityFrame.text2:SetText("")
		DurabilityFrame.text2:SetTextColor(1.0, 1.0, 0.1)

		DurabilityFrame.text3 = DurabilityFrame:CreateFontString(nil)
		DurabilityFrame.text3:SetFont(STANDARD_TEXT_FONT, 10, "")
		DurabilityFrame.text3:SetPoint("BOTTOM", DurabilityFrame, "BOTTOM", 0, -22)
		DurabilityFrame.text3:SetText("")
		DurabilityFrame.text3:SetTextColor(1.0, 1.0, 0.1)

		DurabilityFrame.text4 = DurabilityFrame:CreateFontString(nil)
		DurabilityFrame.text4:SetFont(STANDARD_TEXT_FONT, 10, "")
		DurabilityFrame.text4:SetPoint("TOP", DurabilityFrame, "TOP", 0, 22)
		DurabilityFrame.text4:SetText("")
		DurabilityFrame.text4:SetTextColor(1.0, 1.0, 0.1)

		function DurabilityFrame.Think()
			local ccur = 0
			local cmax = 0

			for i = 0, 20 do
				local curr, maxi = GetInventoryItemDurability(i)
				if curr ~= nil and maxi ~= nil then
					ccur = ccur + curr
					cmax = cmax + maxi
				end
			end
			local perc = 0
			if cmax > 0 then
				perc = IAMathR(ccur / cmax * 100, 1)

				if DurabilityFrame.text ~= nil then
					DurabilityFrame.text:SetText(perc .. "%")

					if perc > 50 then
						DurabilityFrame.text:SetTextColor(0.1, 1.0, 0.1)
					elseif perc > 30 then
						DurabilityFrame.text:SetTextColor(1.0, 1.0, 0.1)
					else
						DurabilityFrame.text:SetTextColor(1.0, 0.1, 0.1)
					end
				end
			end

			if perc <= IAGV( "HIDEDURATIONBELOW", 30 ) then
				DurabilityFrame:Show()
			else
				DurabilityFrame:Hide()
			end

			if DurabilityFrame.text2 and DurabilityFrame.text3 then
				local overall, equipped = IAILVL, IAILVL
				if GetAverageItemLevel then
					overall, equipped = GetAverageItemLevel()
					overall = string.format("%.2f", overall)
					equipped = string.format("%.2f", equipped)
				end
				if overall and equipped then
					if tonumber(overall) == tonumber(equipped) then
						DurabilityFrame.text2:SetText(overall .. " " .. ITEM_LEVEL_ABBR)
						DurabilityFrame.text3:SetText("")
					else
						DurabilityFrame.text2:SetText(overall .. " " .. ITEM_LEVEL_ABBR)
						DurabilityFrame.text3:SetText(equipped .. " " .. ITEM_LEVEL_ABBR)
					end
				else
					DurabilityFrame.text2:SetText("")
					DurabilityFrame.text3:SetText("")
				end
			elseif DurabilityFrame.text2 and DurabilityFrame.text3 then
				DurabilityFrame.text2:SetText("")
				DurabilityFrame.text3:SetText("")
			end

			if DurabilityFrame.text4 then
				local costs = 0
				for i, v in pairs(IACHARSLOTS) do
					local id = v:GetID()

					if v.tt == nil then
						v.tt = CreateFrame( "GameTooltip", "TEST" .. i, DurabilityFrame )
						v.tt:ClearLines()
					end
					if v.tt and v.tt.SetInventoryItem then
						local cost = select(3, v.tt:SetInventoryItem("player", id))
						costs = costs + cost
					end
				end

				if costs > 0 then
					DurabilityFrame.text4:SetText(GetCoinTextureString(costs))
				else
					DurabilityFrame.text4:SetText("")
				end
			elseif DurabilityFrame.text4 then
				DurabilityFrame.text4:SetText("")
			end

			C_Timer.After( 1.0, DurabilityFrame.Think )
		end
		DurabilityFrame.Think()

		if DurabilityFrame.SetAlerts ~= nil then
			hooksecurefunc( DurabilityFrame, "SetAlerts", function()
				DurabilityFrame:Show()
				for index, value in ipairs( INVENTORY_ALERT_STATUS_SLOTS ) do
					if ( not value.showSeparate ) or value.slot == "Weapon" then
						getglobal("Durability" .. value.slot):Show()
					end
				end
			end )
			DurabilityFrame:SetAlerts()
		elseif DurabilityFrame_SetAlerts ~= nil then
			local oldalerts = DurabilityFrame_SetAlerts
			function DurabilityFrame_SetAlerts()
				if oldalerts ~= nil then
					oldalerts()
				end
				DurabilityFrame:Show()
				for index, value in ipairs( INVENTORY_ALERT_STATUS_SLOTS ) do
					if ( not value.showSeparate ) or value.slot == "Weapon" then
						getglobal("Durability" .. value.slot):Show()
					end
				end
			end
			DurabilityFrame_SetAlerts()
		end
	end )
end
